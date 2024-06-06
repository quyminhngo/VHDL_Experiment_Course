library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Debouncer is
  port (
    clk: in std_logic;      -- clk ; 50Hz
    resetn: in std_logic;
    input: in std_logic;
    output: out std_logic
  );
end entity;

architecture RTL_ButtonDetect of Debouncer is
    type FSMState is (zero,pre_one,one,pre_zero);
    signal state_reg,state_next: FSMState;

    signal timer_reg, timer_next : unsigned(1 downto 0);
    signal timer_en: std_logic;
    
begin
    TIMER_PROC : process(clk,resetn,timer_en,timer_reg)
    begin
        if resetn = '0' then
            timer_reg <= "00";
        elsif clk'event and clk = '1' then
            timer_reg <= timer_next;
        end if;
    end process;


    timer_next <= timer_reg + 1  when timer_en = '1' else
    "00" ;
   
    REGISTER_PROC : process(clk,resetn)
    begin
        if resetn = '0' then
            state_reg <= zero;
        elsif clk'event and clk = '1' then
            state_reg <= state_next;   
        end if;
    end process;
    -- Moore Output
    output <= '1' when state_reg = one or state_reg = pre_zero else
			  '0' ;
              
    -- Next State Logic

    NEXTSTATELOGIC_PROC : process(state_reg,input,timer_reg)
    begin
        case state_reg is
            when zero =>
                timer_en <= '0';
                if input = '0' then
                  state_next <= zero;
                else
                    state_next <= pre_one;
                end if;
            when pre_one =>
                timer_en <= '1';
                if(timer_reg = 3) then
                    timer_en <= '0';
                    if input = '0'then
                        state_next <= zero;
                    else
                        state_next <= one;
                    end if;
                else
                    state_next <= pre_one;
                end if;
            when one =>
                timer_en <= '0';
                if input = '1' then
                  state_next <= one;
                else
                  state_next <= pre_zero;
                end if;
            when pre_zero =>
                timer_en <= '1';
                if timer_reg = 3  then
                  timer_en <= '0';
                  if input = '1' then
                    state_next <= one;
                  else
                    state_next <= zero;
                  end if;
                else
                    state_next <= pre_zero;
                end if;
            when others =>
                timer_en <= '0';
                state_next <= zero;
        end case;
    end process;

    

end architecture;
