-------------------------------------------------------------------------------
--
-- Title       : LED_Decoder_4_Bit
-- Design      : Counter
-- Author      : QUY MINH NGO
-- Company     : HUST
--
-------------------------------------------------------------------------------
--
-- File        : q:\Digital_IC_Design\ActiveHDLWS\SequentialCircuitDesing\Counter\src\LED_Decoder_4_bit.vhd
-- Generated   : Fri May 17 22:26:55 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{ENTITY {LED_Decoder_4_Bit} ARCHITECTURE {LED_Decoder_Arch}}

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY LED_Decoder_3_Bit IS
	 PORT(
		 inp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 outp : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	     );
END LED_Decoder_3_Bit;

--}} End of automatically maintained section

ARCHITECTURE LED_Decoder_Arch OF LED_Decoder_3_Bit IS
BEGIN

	-- enter your statements here --
	with inp select 
	outp <= "1111110" when "000",	-- 0
			"0000110" when "001", 	-- 1
			"1011011" when "010",	-- 2
			"1001111" when "011",	-- 3
			"0100111" when "100",	-- 4
			"1101101" when "101",	-- 5
			"1111101" when "110",	-- 6
			"1000110" when others;	-- 7
			
END LED_Decoder_Arch;
