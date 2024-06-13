library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity HourTimer is

  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    enable : in  std_logic;

    pause  : in  std_logic;
    up     : in  std_logic;
    down   : in  std_logic;
    sel    : in  std_logic_vector(1 downto 0);

    minute : out std_logic_vector(5 downto 0);
    second : out std_logic_vector(5 downto 0)
  );
end entity;

architecture RTL_HourTimer of HourTimer is
  signal second_reg, second_next, minute_reg, minute_next : unsigned(5 downto 0);
begin
  REGISTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      second_reg <= (others => '0');
      minute_reg <= (others => '0');
    elsif rising_edge(clk) then
      second_reg <= second_next;
      minute_reg <= minute_next;
    end if;
  end process;

  -- OUTPUT
  minute <= std_logic_vector(minute_reg);
  second <= std_logic_vector(second_reg);
  -- NEXT STATE

  PROC: process (second_reg, minute_reg, enable, pause, sel, up, down)
    variable minu, seco : unsigned(5 downto 0);
  begin
    minu := minute_reg;
    seco := second_reg;
    second_next <= second_reg;
    minute_next <= minute_reg;
    if (enable = '1' and pause = '0') then
      if (second_reg < 59) then
        second_next <= second_reg + 1;
      else
        second_next <= (others => '0');
        if minute_reg < 59 then
          minute_next <= minute_reg + 1;
        else
          minute_next <= (others => '0');
        end if;
      end if;
    elsif pause = '1' then
      if up = '0' and down = '1' then
        if sel = "00" then
          seco := second_reg + 1;
        elsif sel = "01" then
          seco := second_reg + 10;
        elsif sel = "10" then
          minu := minute_reg + 1;
        else
          minu := minute_reg + 10;
        end if;
      elsif up = '1' and down = '0' then
        if sel = "00" then
          seco := second_reg - 1;
        elsif sel = "01" then
          seco := second_reg - 10;
        elsif sel = "10" then
          minu := minute_reg - 1;
        else
          minu := minute_reg - 10;
        end if;
      end if;
      if seco <= 59 then
        second_next <= seco;
      else
        second_next <= (others => '0');
      end if;
      if (minu <= 59) then
        minute_next <= minu;
      else
        minute_next <= (others => '0');
      end if;

    end if;

  end process;

end architecture;
