library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BCD_counter is
  port (
    clk          : in  std_logic; -- 1Hz
    enable       : in  std_logic;
    reset_n      : in  std_logic;
    bcd_hundreds : out std_logic_vector(3 downto 0);
    bcd_tens     : out std_logic_vector(3 downto 0);
    bcd_units    : out std_logic_vector(3 downto 0)
  );
end entity;

architecture RTL_bcd_counter of BCD_counter is
  signal bcd_hundreds_reg, bcd_hundreds_next : unsigned(3 downto 0);
  signal bcd_tens_reg, bcd_tens_next         : unsigned(3 downto 0);
  signal bcd_units_reg, bcd_units_next       : unsigned(3 downto 0);
begin
  REGISTER_PROC: process (clk, reset_n)
  begin
    if reset_n = '0' then
      bcd_hundreds_reg <= (others => '0');
      bcd_tens_reg <= (others => '0');
      bcd_units_reg <= (others => '0');
    elsif rising_edge(clk) then
      bcd_hundreds_reg <= bcd_hundreds_next;
      bcd_tens_reg <= bcd_tens_next;
      bcd_units_reg <= bcd_units_next;
    end if;
  end process;
  bcd_hundreds <= std_logic_vector(bcd_hundreds_reg);
  bcd_tens     <= std_logic_vector(bcd_tens_reg);
  bcd_units    <= std_logic_vector(bcd_units_reg);

  COMB_PROC_PROC: process (bcd_hundreds_reg, bcd_tens_reg, bcd_units_reg, enable)
  begin
    bcd_hundreds_next <= bcd_hundreds_reg;
    bcd_units_next <= bcd_units_reg;
    bcd_tens_next <= bcd_tens_reg;
    if enable = '1' then
      if bcd_units_reg < 9 then
        bcd_units_next <= bcd_units_reg + 1;
      else
        bcd_units_next <= (others => '0');
        if bcd_tens_reg < 9 then
          bcd_tens_next <= bcd_tens_reg + 1;
        else
          bcd_tens_next <= (others => '0');
          if bcd_hundreds_reg < 9 then
            bcd_hundreds_next <= bcd_hundreds_reg + 1;
          else
            bcd_hundreds_next <= (others => '0');
          end if;

        end if;

      end if;
    end if;
  end process;
end architecture;
