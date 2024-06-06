library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity CounterSystemButton is
  port (
    button: in std_logic;
    led: out std_logic_vector(6 downto 0);
    resetn: in std_logic
  );
end entity;

architecture RTL_CounterSystem of CounterSystemButton is
    signal clk:std_logic;
    signal output: std_logic_vector(3 downto 0);
    signal input,input_narow: std_logic;

begin
    
    osc_100hz_inst: entity work.OSC_100Hz
    port map (
      clkout => clk,
      resetn => resetn
    );
    mod_9_counter_inst: entity work.Mod_9_Counter
    port map (
      clk    => clk,
      output => output,
      resetn => resetn,
      enable => input_narow
    );
    
    led_decoder_4_bit_inst: entity work.LED_Decoder_4_Bit
    port map (
      inp  => output,
      outp => led
    );
    
    buttondetect_inst: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => button,
      output => input
    );

    pulsenarrower_inst: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => input,
      output_narrow => input_narow
    );
end architecture;
