--Copyright (C)2014-2023 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.9 Beta-4 Education
--Part Number: GW1NR-LV9QN88PC6/I5
--Device: GW1NR-9
--Device Version: C
--Created Time: Tue Jun 18 02:49:50 2024

library IEEE;
  use IEEE.std_logic_1164.all;

entity Gowin_OSC is
  port (
    oscout : out std_logic
  );
end entity;

architecture Behavioral of Gowin_OSC is

  --component declaration
  component OSC
    generic (
      FREQ_DIV : in integer := 100;
      DEVICE   : in string  := "GW1N-4"
    );
    port (
      OSCOUT : out std_logic
    );
  end component;

begin
  osc_inst: OSC
    generic map (
      FREQ_DIV => 10,
      DEVICE   => "GW1NR-9C"
    )
    port map (
      OSCOUT => oscout
    );

end architecture; --Gowin_OSC
