library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock is
  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    hour   : out std_logic_vector(5 downto 0);
    minute : out std_logic_vector(5 downto 0);
    second : out std_logic_vector(5 downto 0);

    enable : in  std_logic; -- clk
    mode   : in  std_logic_vector(2 downto 0);
    up     : in  std_logic;
    down   : in  std_logic

  );
end entity;

architecture rtl_clock of clock is
  signal hour_reg, hour_next     : signed(6 downto 0);
  signal minute_reg, minute_next : signed(6 downto 0);
  signal second_reg, second_next : signed(6 downto 0);

  -- signal state_reg, state_next : unsigned(2 downto 0);
begin
  --Register
  REGISTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      hour_reg <= (others => '0');
      minute_reg <= (others => '0');
      second_reg <= (others => '0');
    elsif rising_edge(clk) then
      hour_reg <= hour_next;
      minute_reg <= minute_next;
      second_reg <= second_next;
    end if;
  end process;
  -- Output logic
  hour   <= std_logic_vector(hour_reg(5 downto 0));
  minute <= std_logic_vector(minute_reg(5 downto 0));
  second <= std_logic_vector(second_reg(5 downto 0));
  -- Next State

  PROC: process (enable, mode, up, down, hour_reg, minute_reg, second_reg)
    variable second_next_var : signed(6 downto 0);
    variable minute_next_var : signed(6 downto 0);
    variable hour_next_var   : signed(6 downto 0);
  begin
    hour_next_var := hour_reg;
    minute_next_var := minute_reg;
    second_next_var := second_reg;
    case (mode) is
      when "001" =>
        if up = '1' and down = '0' then
          second_next_var := second_reg + 1;
        elsif up = '0' and down = '1' then
          second_next_var := second_reg - 1;
        end if;
      when "010" =>
        if up = '1' and down = '0' then
          second_next_var := second_reg + 10;
        elsif up = '0' and down = '1' then
          second_next_var := second_reg - 10;
        end if;
      when "011" =>
        if up = '1' and down = '0' then
          minute_next_var := minute_reg + 1;
        elsif up = '0' and down = '1' then
          minute_next_var := minute_reg - 1;
        end if;
      when "100" =>
        if up = '1' and down = '0' then
          minute_next_var := minute_reg + 10;
        elsif up = '0' and down = '1' then
          minute_next_var := minute_reg - 10;
        end if;
      when "101" =>
        if up = '1' and down = '0' then
          hour_next_var := hour_reg + 1;
        elsif up = '0' and down = '1' then
          hour_next_var := hour_reg - 1;
        end if;
      when "110" =>
        if up = '1' and down = '0' then
          hour_next_var := hour_reg + 10;
        elsif up = '0' and down = '1' then
          hour_next_var := hour_reg - 10;
        end if;
      when others =>
        if enable = '1' then
          second_next_var := second_reg + 1;
        end if;
    end case;

    if second_next_var < 0 then
      second_next_var := "0111011";
      minute_next_var := minute_next_var - 1;
    end if;
    if minute_next_var < 0 then
      minute_next_var := "0111011";
      hour_next_var := hour_next_var - 1;
    end if;
    if hour_next_var < 0 then
      hour_next_var := "0011000";
    end if;

    if second_next_var >= 60 then
      second_next_var := (others => '0');
      minute_next_var := minute_next_var + 1;
    end if;
    if minute_next_var >= 60 then
      minute_next_var := (others => '0');
      second_next_var := (others => '0');
      hour_next_var := hour_next_var + 1;
    end if;
    if hour_next_var >= 24 then
      hour_next_var := (others => '0');
      minute_next_var := (others => '0');
      second_next_var := (others => '0');
    end if;

    hour_next <= hour_next_var;
    minute_next <= minute_next_var;
    second_next <= second_next_var;

  end process;

end architecture;
