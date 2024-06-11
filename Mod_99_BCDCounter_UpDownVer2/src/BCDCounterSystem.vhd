library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BCDCounterSystem is
  port (
    button_up: in std_logic;
    button_down: in std_logic;
    resetn: in std_logic;
    led: out std_logic_vector(6 downto 0);
    led_number: out std_logic_vector(3 downto 0)
    
  );
end entity;

architecture RTL_BCDCounterSystem of BCDCounterSystem is
    signal tens,unit: std_logic_vector(3 downto 0);
    signal clk_up_enable, clk_down_enable: std_logic;
    signal debounced_up, debounced_down: std_logic; 
    signal debounced_up_temp, debounced_down_temp: std_logic; 
    signal select_output: std_logic_vector(3 downto 0);
   

	signal clk: std_logic;
begin

    osc_100hz_inst: entity work.OSC_100Hz
    port map (
      clkout => clk,
      resetn => resetn
    );

    debouncer_inst_up: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => button_up,
      output => debounced_up_temp
    );

    debouncer_inst_down: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => button_down,
      output => debounced_down_temp
    );

debounced_up <= '0' when debounced_down_temp = '1' and debounced_up_temp = '1' else
  debounced_up_temp;
debounced_down <= '0' when debounced_down_temp = '1' and debounced_up_temp = '1' else
  debounced_down_temp;

    enable_1hz_inst_up: entity work.Enable_1Hz
    port map (
      clk    => clk,
      clkout => clk_up_enable,
      resetn => debounced_up
    );

    enable_1hz_inst_down: entity work.Enable_1Hz
    port map (
      clk    => clk,
      clkout => clk_down_enable,
      resetn => debounced_down
    );

    mod_99_bcd_counter_inst: entity work.Mod_99_BCD_Counter
    port map (
      clk    => clk,
      resetn => resetn,
      up_enable => clk_up_enable,
      down_enable => clk_down_enable,
      tens   => tens,
      unit   => unit
    );
    

    led_decoder_4_bit_inst: entity work.LED_Decoder_4_Bit
    port map (
      inp  => select_output,
      outp => led
    );



  SEVENSEGMENTDISPLAY_PROC : process(clk,tens,unit)
  begin
    if clk = '1' then
      select_output <= tens;
      led_number <= "1101";
    else 
      select_output <= unit;
      led_number <= "1110";
    end if;
  end process;





end architecture;
