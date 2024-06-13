library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity HourTimerSystem is
  port (
    resetn     : in  std_logic;

    sys_ena_n  : in  std_logic;
    sel        : in  std_logic;
    up         : in  std_logic;
    down       : in  std_logic;

    led        : out std_logic_vector(7 downto 0);
    led_number : out std_logic_vector(7 downto 0)
  );
end entity;

architecture RTL_HourTimerSystem of HourTimerSystem is
  signal tens_minute  : std_logic_vector(3 downto 0);
  signal units_minute : std_logic_vector(3 downto 0);
  signal tens_second  : std_logic_vector(3 downto 0);
  signal units_second : std_logic_vector(3 downto 0);

  signal clk            : std_logic;
  signal enable         : std_logic;
  signal minute, second : std_logic_vector(5 downto 0);

  signal sel_narrow  : std_logic;
  signal up_narrow   : std_logic;
  signal down_narrow : std_logic;
  signal sseg_dot    : std_logic_vector(7 downto 0);

  signal dot_counter_reg, dot_counter_next : unsigned(1 downto 0);

begin

  -- dot_counter
  DOTCOUNTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      dot_counter_reg <= (others => '0');
    elsif rising_edge(clk) then
      dot_counter_reg <= dot_counter_next;
    end if;
  end process;

  dot_counter_next <= dot_counter_reg + 1 when sel_narrow = '1' else
                      dot_counter_reg;
  -- end of dot counter
  osc_100hz_inst: entity work.OSC_100Hz
    port map (
      clkout => clk,
      resetn => '1'
    );
  enable_1hz_inst: entity work.Enable_1Hz
    port map (
      clk    => clk,
      clkout => enable,
      resetn => resetn
    );

  hourtimer_inst: entity work.HourTimer
    port map (
      clk    => clk,
      resetn => resetn,
      enable => enable,
      minute => minute,
      second => second,
      pause  => sys_ena_n,
      up     => up_narrow,
      down   => down_narrow,
      sel    => std_logic_vector(dot_counter_reg)
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
  binbcdconverter_inst_second: entity work.BinBCDConverter
    generic map (
      N => 6
    )
    port map (
      bin_number => second,
      BCD_tens   => tens_second,
      BCD_units  => units_second
    );
  pulsenarrower_inst_sel: entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => sel,
      output_narrow => sel_narrow
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

  controlsevensegmentled_inst: entity work.ControlSevenSegmentLed
    port map (
      clk         => clk,
      sseg_in_0   => units_second,
      sseg_in_1   => tens_second,
      sseg_in_2   => units_minute,
      sseg_in_3   => tens_minute,
      sseg_in_4   => (others => '0'),
      sseg_in_5   => (others => '0'),
      sseg_in_6   => (others => '0'),
      sseg_in_7   => (others => '0'),

      sseg_enable => "00001111",
      sseg_dot    => sseg_dot,
      clk_enable  => '1', -- Work in 500Hz
      sseg_number => led_number,
      sseg_out    => led
    );

  -- XU LY DOT
  sseg_dot <= "00000001" when dot_counter_reg = "00" and sys_ena_n = '1' else
              "00000010" when dot_counter_reg = "01" and sys_ena_n = '1' else
              "00000100" when dot_counter_reg = "10" and sys_ena_n = '1' else
              "00001000" when dot_counter_reg = "11" and sys_ena_n = '1' else
              "00000000";

  BLINK_PROC: process (dot_counter_reg, sys_ena_n)
  begin

  end process;

end architecture;
