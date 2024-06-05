library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ButtonDetect is
  generic (
    timeDelay: time := 20 ms
  );
  port (
    clk: in std_logic;
    resetn: in std_logic;
    input: in std_logic;
    output: in std_logic
  );
end entity;

architecture RTL_ButtonDetect of ButtonDetect is
    type FSMState is (zero,pre_one,one,pre_zero);
    signal currState,nextState: FSMState;
begin
    REGISTER_PROC : process(sensitivity_list)
    begin
        if resetn = '0' then
            currState <= zero;
        elsif clk'event and clk = '1' then
            currState <= nextState;   
        end if;
    end process;
    -- Moore Output
output <= '0' when currState = zero else
    '1' when currState = one;
    -- Next State Logic
    NEXTSTATE_PROC : process(currState,input)
    begin
        
        FSMCase: case currState 
            when zero =>
                if cond then
                  
                end if;
                
        
            when others =>
                null;
        
        end ;
    end process;

end architecture;
