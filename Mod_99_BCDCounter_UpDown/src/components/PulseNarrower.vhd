library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity PulseNarrower is
  port (

    clk: in std_logic;
    resetn: in std_logic;
    input_pulse: in std_logic;
    output_narrow: out std_logic
  );
end entity;

architecture RTL_PulseNarrower of PulseNarrower is
    signal state_narrow: std_logic;
begin
    REGISTER_PROC : process(clk,resetn)
    begin
        if resetn = '0' then
          state_narrow <= '0';
        elsif rising_edge(clk) then
        state_narrow <= input_pulse;
        end if;
    end process;

     
    output_narrow <= (not state_narrow) and input_pulse;

end architecture;
