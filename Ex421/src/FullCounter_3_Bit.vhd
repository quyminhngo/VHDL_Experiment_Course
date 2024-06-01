library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity FullCounter_3_Bit is 
  port (
    resetn: in std_logic;
    pause: in std_logic;
    led : out std_logic_vector(6 downto 0)  
  );
end entity;

architecture RTL_FullCounter_3_Bit of FullCounter_3_Bit is
    component LED_Decoder_3_Bit IS
    PORT(
        inp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    end component;

    component  Devider_1Hz is
    port
    (
    clk    : in std_logic;
    clkout : out std_logic;
    resetn : in std_logic
    );
    end component;
    component OSC_100Hz is
        port
        (
          clkout : out std_logic;
          resetn : in std_logic
        );
    end component;
    component Counter_3_Bit is
        port (
          clk: in std_logic;
          enable: in std_logic;
          resetn: in std_logic;
          pause: in std_logic;
          outp: out std_logic_vector(2 downto 0)
        );
    end component;

    signal outptemp: std_logic_vector(2 downto 0);
    signal clk: std_logic;
    signal entemp: std_logic;
begin
    led_decoder_3_bit_inst: LED_Decoder_3_Bit
    port map (
      inp  => outptemp,
      outp => led
    );

    osc_100hz_inst: OSC_100Hz
    port map (
      clkout => clk,
      resetn => resetn
    );

    counter_3_bit_inst: Counter_3_Bit
    port map (
      clk    => clk,
      enable => entemp,
      resetn => resetn,
      outp   => outptemp,
      pause => pause
    );

    devider_1hz_inst: Devider_1Hz
    port map (
      clk    => clk,
      clkout => entemp,
      resetn => resetn
    );
    

end architecture;
