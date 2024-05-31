--Copyright (C)2014-2023 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.9 Beta-4 Education
--Part Number: GW1NR-LV9QN88PC6/I5
--Device: GW1NR-9
--Device Version: C
--Created Time: Sat Jun 01 03:08:36 2024

library IEEE;
use IEEE.std_logic_1164.all;

entity Gowin_CLKDIV5 is
    port (
        clkout: out std_logic;
        hclkin: in std_logic;
        resetn: in std_logic
    );
end Gowin_CLKDIV5;

architecture Behavioral of Gowin_CLKDIV5 is

    signal gw_gnd: std_logic;

    --component declaration
    component CLKDIV
        generic (
            GSREN: in string := "false";
            DIV_MODE : STRING := "2"
        );
        port (
            CLKOUT: out std_logic;
            HCLKIN: in std_logic;
            RESETN: in std_logic;
            CALIB: in std_logic
        );
    end component;

begin
    gw_gnd <= '0';

    clkdiv_inst: CLKDIV
        generic map (
            GSREN => "false",
            DIV_MODE => "5"
        )
        port map (
            CLKOUT => clkout,
            HCLKIN => hclkin,
            RESETN => resetn,
            CALIB => gw_gnd
        );

end Behavioral; --Gowin_CLKDIV5
