library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Counter_3_Bit is
  port (
    clk: in std_logic;
    enable: in std_logic;
    pause : in std_logic;
    resetn: in std_logic;
    outp: out std_logic_vector(2 downto 0)
  );
end entity;

architecture RTL_Counter_3_Bit of Counter_3_Bit is
    signal currState, nextState : unsigned(2 downto 0);
    --signal status: std_logic_vector(3 downto 0);
    signal currStatus, nextStatus : std_logic;
begin
    STATUS_PROC : process(clk,resetn)
    begin
        if resetn = '0' then
          currStatus <= '0';
        elsif clk'event and clk = '1' then
          currStatus <= nextStatus;
        end if;
    end process;

    nextStatus <= '1' when currState = "111" else
                  '0' when currState = "000" else
            		currStatus;




    REGISTER_PROC : process(clk,resetn)
    begin
		
        if resetn = '0' then
            currState <= (others => '0');  
        elsif clk'event and clk = '1'  then
            currState <= nextState;
		
        end if;
    end process;
    --OUTPUT
    outp <= std_logic_vector(currState) ;
    --NEXT STATE LOGIC
	nextState <= currState + 1 when enable = '1'  and currStatus = '0'  else
    currState - 1 when enable = '1' and currStatus = '1' else
                 currState;
    

    



end architecture;
