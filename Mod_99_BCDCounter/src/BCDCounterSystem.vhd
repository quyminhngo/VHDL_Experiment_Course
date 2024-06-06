library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BCDCounterSystem is
  port (
    button: in std_logic;
    resetn: in std_logic;
    tens_led: out std_logic_vector(6 downto 0);
    units_led: out std_logic_vector(6 downto 0)
  );
end entity;

architecture RTL_BCDCounterSystem of BCDCounterSystem is
    signal tens,unit: std_logic_vector(3 downto 0);
    signal input_pulse, input_narrow: std_logic;
	signal clk: std_logic;
begin

    osc_100hz_inst: entity work.OSC_100Hz
    port map (
      clkout => clk,
      resetn => resetn
    );

    debouncer_inst: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => button,
      output => input_pulse
    );

    pulsenarrower_inst: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => input_pulse,
      output_narrow => input_narrow
    );

    mod_99_bcd_counter_inst: entity work.Mod_99_BCD_Counter
    port map (
      clk    => clk,
      resetn => resetn,
      enable => input_narrow,
      tens   => tens,
      unit   => unit
    );

    led_decoder_4_bit_inst: entity work.LED_Decoder_4_Bit
    port map (
      inp  => tens,
      outp => tens_led
    );
    led_decoder_4_bit_inst_2: entity work.LED_Decoder_4_Bit
    port map (
      inp  => unit,
      outp => units_led
    );


end architecture;
