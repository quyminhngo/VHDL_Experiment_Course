library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity OSC_100Hz is
  port (
    clkout : out std_logic;
    resetn : in  std_logic
  );
end entity;

architecture RTL_OSC_100Hz of OSC_100Hz is
  component gowin_clkdiv8 is
    port (
      clkout : out std_logic;
      hclkin : in  std_logic;
      resetn : in  std_logic
    );
  end component;

  component gowin_clkdiv5 is
    port (
      clkout : out std_logic;
      hclkin : in  std_logic;
      resetn : in  std_logic
    );
  end component;

  --Gowin osc source 250Mhz/100 = 2.500.000 Hz
  component gowin_osc is
    port (
      oscout : out std_logic
    );
  end component;

  signal div51, div52, div53, div54, div55, div56 : std_logic;

begin

  osc_source: gowin_osc
    port map (
      oscout => div51
    );
  oscdiv5_1: gowin_clkdiv5
    port map (
      hclkin => div51,
      clkout => div52,
      resetn => resetn
    );

  oscdiv5_2: gowin_clkdiv5
    port map (
      hclkin => div52,
      clkout => div53,
      resetn => resetn
    );

  oscdiv5_3: gowin_clkdiv5
    port map (
      hclkin => div53,
      clkout => div54,
      resetn => resetn
    );

  oscdiv5_4: gowin_clkdiv5
    port map (
      hclkin => div54,
      clkout => div55,
      resetn => resetn
    );

  oscdiv8: gowin_clkdiv8
    port map (
      clkout => clkout,
      hclkin => div55,
      resetn => resetn
    );

end architecture;
