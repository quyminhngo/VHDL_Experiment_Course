library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BCDCounterSystem is
  port (
    button     : in  std_logic;
    resetn     : in  std_logic;
    led        : out std_logic_vector(7 downto 0);
    led_number : out std_logic_vector(7 downto 0)
  );
end entity;

architecture RTL_BCDCounterSystem of BCDCounterSystem is
  signal tens, unit                : std_logic_vector(3 downto 0);
  signal input_pulse, input_narrow : std_logic;
  signal clk                       : std_logic;
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

  mod_99_bcd_counter: entity work.Mod_99_BCD_Counter
    port map (
      clk    => clk,
      resetn => resetn,
      enable => input_narrow,
      tens   => tens,
      unit   => unit
    );

  controlsevensegmentled_inst: entity work.ControlSevenSegmentLed
    port map (
      clk         => clk,
      sseg_in_0   => unit,
      sseg_in_1   => (others => '0'),
      sseg_in_2   => (others => '0'),
      sseg_in_3   => tens,
      sseg_in_4   => (others => '0'),
      sseg_in_5   => (others => '0'),
      sseg_in_6   => (others => '0'),
      sseg_in_7   => (others => '0'),

      sseg_enable => "00001001",
      sseg_dot    => "00000110",
      clk_enable  => '1',
      sseg_number => led_number,
      sseg_out    => led
    );

end architecture;
