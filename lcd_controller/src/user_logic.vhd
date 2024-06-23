library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  -- Send 123456789ABCDEF to lcd

entity main_system is
  port (
    clk           : in  std_logic;
    reset_n       : in  std_logic;
    ready         : in  std_logic;
    start         : out std_logic;
    data          : out std_logic_vector(7 downto 0);
    rs            : out std_logic;
    rw            : out std_logic;
    line_0_buffer : in  std_logic_vector(127 downto 0);
    line_1_buffer : in  std_logic_vector(127 downto 0)

  );
end entity;

architecture rtl of main_system is
  type LINE_DATA is array (0 to 15) of std_logic_vector(7 downto 0);
  signal display_line_0, display_line_1 : LINE_DATA;

  constant line_0_addr : std_logic_vector(7 downto 0) := x"80";
  constant line_1_addr : std_logic_vector(7 downto 0) := x"C0";
  signal count_reg, count_next : unsigned(5 downto 0);

begin

  ASSIGN_PROC: process (line_0_buffer, line_1_buffer)
  begin
    for I in 0 to 15 loop
      display_line_0(i) <= line_0_buffer(8 * i + 7 downto 8 * i);
      display_line_1(i) <= line_1_buffer(8 * i + 7 downto 8 * i);
    end loop;
  end process;

  REGISTER_PROC: process (clk, reset_n)
  begin
    if reset_n = '0' then
      count_reg <= (others => '0');
    elsif rising_edge(clk) then
      count_reg <= count_next;
    end if;
  end process;

  TRANSMIT_PROC: process (clk, ready, reset_n)

  begin
    if reset_n = '0' then
      start <= '0';
    elsif rising_edge(clk) then
      if ready = '1' and count_reg <= 35 then
        count_next <= count_reg + 1;
        start <= '1';
        -- Line 0 address is transmitted
        if count_reg = 0 then
          data <= line_0_addr;
          rs <= '0';
          rw <= '0';
        elsif count_reg <= 16 then

          data <= display_line_0(to_integer(count_reg) - 1);
          rs <= '1';
          rw <= '0';
        elsif count_reg = 17 then
          data <= line_1_addr;
          rs <= '0';
          rw <= '0';
        else
          data <= display_line_1(to_integer(count_reg) - 18);
          rs <= '1';
          rw <= '0';
        end if;
      else

        start <= '0';
      end if;
    end if;

  end process;

end architecture;
