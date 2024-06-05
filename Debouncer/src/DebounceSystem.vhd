library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DebounceSystem is
  port (
    input: in std_logic;
    output: out std_logic
  );
end entity;

architecture rtl of DebounceSystem is
    signal resetn: std_logic;
    signal clk : std_logic;
begin
    resetn <= '1';
    osc_100hz_inst: entity work.OSC_100Hz
    port map (
      clkout => clk,
      resetn => resetn
    );
    buttondetect_inst: entity work.Debouncer
    port map (
      clk    => clk,
      resetn => resetn,
      input  => input,
      output => output
    );
end architecture;
