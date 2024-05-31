library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EnableSignal_1Hz is
  port
  (
    clkout : out std_logic;
    resetn : in std_logic
  );
end entity;

architecture RTL_401 of EnableSignal_1Hz is
  component Devider_1Hz is
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
  signal clktemp : std_logic;
begin
  Divider_1Hz : Devider_1Hz
  port map
  (
    clkout => clkout,
    resetn => resetn,
    clk    => clktemp
  );

  osc_100hz_inst : OSC_100Hz
  port
  map (
  clkout => clktemp,
  resetn => resetn
  );
end architecture;