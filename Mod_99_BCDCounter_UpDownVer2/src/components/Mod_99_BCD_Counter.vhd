library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Mod_99_BCD_Counter is

  port (
    clk: in std_logic;
    resetn: in std_logic;
    up_enable: in std_logic;
    down_enable: in std_logic;
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

    UNITS_PROC : process(up_enable,down_enable,units_state_reg)
    begin
      units_state_next <= units_state_reg;
      if up_enable = '1' and down_enable = '0' then
        units_state_next <= units_state_reg + 1;
        if  units_state_reg >= "1001" then
          units_state_next <= (others => '0');
        end if;
      elsif down_enable = '1' and up_enable = '0' then
        units_state_next <= units_state_reg - 1;
        if units_state_reg = 0 then
          units_state_next <= "1001";  
        end if; 
      end if;
    end process;

    TENS_PROC : process(units_state_reg,tens_state_reg,up_enable,down_enable)
    begin
      tens_state_next <= tens_state_reg;
      if up_enable = '1' and down_enable = '0' and units_state_reg = 9 then
        tens_state_next <= tens_state_reg + 1;
        if tens_state_reg = "1001" then
          tens_state_next <= "0000"; 
        end if;
      elsif up_enable = '0' and down_enable = '1' and units_state_reg = 0 then
        tens_state_next <= tens_state_reg - 1;
        if tens_state_reg = "0000" then
          tens_state_next <= "1001";
        end if;
      end if;

    end process;
                    
                
 

end architecture;
