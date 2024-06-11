library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity HourTimerSystem is
  port (
    resetn: in std_logic;

    sys_ena: in std_logic;
    sel: std_logic;
    up: std_logic;
    down: std_logic;

    
    led: out std_logic_vector(7 downto 0);
    led_number: out std_logic_vector(3 downto 0)
  );
end entity;

architecture RTL_HourTimerSystem of HourTimerSystem is
    signal tens_minute: std_logic_vector(3 downto 0);
    signal units_minute:  std_logic_vector(3 downto 0);
    signal tens_second: std_logic_vector(3 downto 0);
    signal units_second: std_logic_vector(3 downto 0);

    signal clk: std_logic;
    signal enable: std_logic;
    signal minute,second: std_logic_vector(5 downto 0);

    signal number_temp: std_logic_vector(3 downto 0);

    signal counter_reg,counter_next: unsigned(1 downto 0);

    signal dot_counter_reg,dot_counter_next: unsigned(1 downto 0);

    signal dot : std_logic;
    signal sel_narrow: std_logic;
    signal up_narrow: std_logic;
    signal down_narrow: std_logic;

begin
    -- 7-SEGMENT LED
    REG_PROC : process(clk,resetn)
    begin
        if(resetn = '0') then
          dot_counter_reg <= (others => '0');
          counter_reg <= (others => '0');
        elsif rising_edge(clk) then
            counter_reg <= counter_next;
            dot_counter_reg <= dot_counter_next;
        end if;
    end process;
    counter_next <= counter_reg + 1;

  dot_counter_next <= dot_counter_reg + 1 when sel_narrow = '1' and sys_ena = '1' else
                      dot_counter_reg;
  
    -- dot_counter

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
      pause => sys_ena,
      up => up_narrow ,
      down => down_narrow,
      sel => std_logic_vector(dot_counter_reg)
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
    pulsenarrower_inst_down : entity work.PulseNarrower
    port map (
      clk           => clk,
      resetn        => resetn,
      input_pulse   => down,
      output_narrow => down_narrow
    );
    led_decoder_4_bit_inst: entity work.LED_Decoder_4_Bit
    port map (
      dot => dot,
      inp  => number_temp,
      outp => led
    ); 

PROC : process(counter_reg,dot_counter_reg,units_second,tens_second,units_minute,tens_minute)
begin
  dot <= '0';
  if counter_reg = "00" then
    led_number <= "1110";
    number_temp <= units_second;
    if(dot_counter_reg = "00") then
      dot <= '1';
    end if;
  elsif counter_reg = "01" then
    led_number <= "1101";
    number_temp <= tens_second;
    if(dot_counter_reg = "01") then
      dot <= '1';
    end if;
  elsif counter_reg = "10" then
    led_number <= "1011";
    number_temp <= units_minute;
    if(dot_counter_reg = "10") then
      dot <= '1';
    end if;
  else
    led_number <= "0111";
    number_temp <= tens_minute;
    if(dot_counter_reg = "11") then
      dot <= '1';
    end if;
  end if;
end process;







end architecture;
