library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock_system is

  port (
    mode       : in  std_logic;
    resetn     : in  std_logic;
    up         : in  std_logic;
    down       : in  std_logic;
    led        : out std_logic_vector(7 downto 0);
    led_number : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl_clock_system of clock_system is
  signal minute, hour, second                                                        : std_logic_vector(5 downto 0);
  signal up_narrow, down_narrow, mode_narrow, mode_deb                               : std_logic;
  signal clk                                                                         : std_logic;
  signal enable_1hz                                                                  : std_logic;
  signal tens_hour, units_hour, tens_minute, units_minute, tens_second, units_second : std_logic_vector(3 downto 0);
  signal control_mode_reg, control_mode_next                                         : unsigned(2 downto 0);
  signal sseg_dot                                                                    : std_logic_vector(7 downto 0);
begin
  osc_500hz_inst: entity work.OSC_500Hz
    port map (
      clkout => clk,
      resetn => resetn
    );
  enable_1hz_inst: entity work.Enable_1Hz
    port map (
      clk    => clk,
      clkout => enable_1hz,
      resetn => resetn
    );
  debouncer_inst: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => mode,
      output => mode_deb
    );
  pulsenarrower_inst_mode: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => mode_deb,
      output_narrow => mode_narrow
    );
  pulsenarrower_inst_up: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => up,
      output_narrow => up_narrow
    );
  pulsenarrower_inst_down: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => down,
      output_narrow => down_narrow
    );

  clock_inst: entity work.clock
    port map (
      clk    => clk,
      resetn => resetn,
      hour   => hour,
      minute => minute,
      second => second,
      enable => '1',
      mode   => std_logic_vector(control_mode_reg),
      up     => not up_narrow,
      down   => not down_narrow
    );

  binbcdconverter_inst_hour: entity work.BinBCDConverter
    generic map (
      N => 6
    )
    port map (
      bin_number => hour,
      BCD_tens   => tens_hour,
      BCD_units  => units_hour
    );

  binbcdconverter_inst_min: entity work.BinBCDConverter
    generic map (
      N => 6
    )
    port map (
      bin_number => minute,
      BCD_tens   => tens_minute,
      BCD_units  => units_minute
    );

  binbcdconverter_inst_sec: entity work.BinBCDConverter
    generic map (
      N => 6
    )
    port map (
      bin_number => second,
      BCD_tens   => tens_second,
      BCD_units  => units_second
    );

  controlsevensegmentled_inst: entity work.ControlSevenSegmentLed
    port map (
      clk         => clk,
      sseg_in_0   => units_second,
      sseg_in_1   => tens_second,
      sseg_in_2   => units_minute,
      sseg_in_3   => tens_minute,
      sseg_in_4   => units_hour,
      sseg_in_5   => tens_hour,
      sseg_in_6   => (others => '0'),
      sseg_in_7   => (others => '0'),
      sseg_enable => "00111111",
      sseg_dot    => sseg_dot,
      clk_enable  => '1',
      sseg_number => led_number,
      sseg_out    => led
    );

  -- Ssegment dot decoder
  with control_mode_reg select
    sseg_dot <= "00000001" when "001",
                "00000010" when "010",
                "00000100" when "011",
                "00001000" when "100",
                "00010000" when "101",
                "00100000" when "110",
                "00000000" when others;

  -- Controller
  -- Controller Register

  REG_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      control_mode_reg <= (others => '0');
    elsif rising_edge(clk) then
      control_mode_reg <= control_mode_next;
    end if;
  end process;
  --Controller Ouput logic
  -- Controller Next State Logic
  control_mode_next <= control_mode_reg + 1 when mode_narrow = '1' else
                         (others => '0')    when control_mode_reg = "111" else
                       control_mode_reg;

end architecture;
