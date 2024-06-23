library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity user_logic_system is
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

architecture RTL_logic_user_system of user_logic_system is
  type FSM_MACHINE is (IDEL);
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

  COMB_PROC_PROC: process(display_line_0, display_line_1, count_reg, ready, count_next)
  begin
    count_next <= count_reg;
    start <= '0';
    data <= (others => '0');
    rs <= '0';
    rw <= '0';
    if ready = '1' and count_reg <= 34 then
      count_next <= count_reg + 1;
      start <= '1';
      if count_next = 0 then
        rs <= '0';
        rw <= '0';
        data <= line_0_addr;
      elsif count_next <= 16 then
        rs <= '1';
        rw <= '0';
        data <= display_line_0(to_integer(count_reg) - 1);
      elsif count_next = 17 then
        rs <= '0';
        rw <= '0';
        data <= line_1_addr;
      elsif count_next <= 34 then
        rs <= '1';
        rw <= '0';
        data <= display_line_1(to_integer(count_reg) - 17);
      else
        rs <= '0';
        rw <= '0';
        data <= "00000010";
      end if;
    end if;

  end process;

end architecture;
