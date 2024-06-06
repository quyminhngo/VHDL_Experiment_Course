library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Mod_99_BCD_Counter is

  port (
    clk: in std_logic;
    resetn: in std_logic;
    enable: in std_logic;
    tens: out std_logic_vector(3 downto 0);
    unit: out std_logic_vector(3 downto 0)  
  );
end entity;

architecture RTL_Mod_99_BCD_Counter of Mod_99_BCD_Counter is
    signal tens_state_reg, tens_state_next: unsigned(3 downto 0);
    signal units_state_reg, units_state_next: unsigned(3 downto 0);
    
begin
    REGISTER_PROC : process(clk, resetn)
    begin
        if resetn = '0' then
          units_state_reg <= (others => '0');
          tens_state_reg <= (others => '0');
        elsif rising_edge(clk) then
          units_state_reg <= units_state_next;
          tens_state_reg <= tens_state_next;
        end if;
    end process;

    -- OUTPUT
    tens <= std_logic_vector(tens_state_reg);
    unit <= std_logic_vector(units_state_reg);
    -- NEXT STATE LOGIC
units_state_next <= units_state_reg + 1 when enable = '1' and units_state_reg < 9 else
                    (others => '0') when enable = '1' else
                    units_state_reg ;
 tens_state_next <= tens_state_reg when enable = '0' or units_state_reg < 9 else
                tens_state_reg + 1 when enable = '1' and tens_state_reg < 9 else
                (others => '0');




end architecture;
