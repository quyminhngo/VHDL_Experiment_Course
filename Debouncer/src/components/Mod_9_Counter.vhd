library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Mod_9_Counter is
  port (
    clk: in std_logic;
    output: out std_logic_vector(3 downto 0);
    resetn: in std_logic;
    enable: in std_logic
  );
end entity;

architecture RTL_Mod_9_Counter of Mod_9_Counter is
    signal state_reg, state_next: unsigned(3 downto 0);
begin
    REGISTER_PROC : process(clk,resetn)
    begin
        if resetn = '0' then
          state_reg <= (others => '0');
        elsif rising_edge(clk) then
          state_reg <= state_next;
        end if;
    end process;

    output <= std_logic_vector(state_reg);

  state_next <= state_reg + 1 when state_reg < 9  and enable = '1' else 
                state_reg     when enable = '0'                    else
                (others => '0') ;
end architecture;
