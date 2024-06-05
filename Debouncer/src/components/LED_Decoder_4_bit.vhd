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

ENTITY LED_Decoder_4_Bit IS
	 PORT(
		 inp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 outp : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	     );
END LED_Decoder_4_Bit;

--}} End of automatically maintained section

ARCHITECTURE LED_Decoder_Arch OF LED_Decoder_4_Bit IS
BEGIN

	-- enter your statements here --
	with inp select 
	outp <= "1111110" when "0000",	-- 0
			"0000110" when "0001", 	-- 1
			"1011011" when "0010",	-- 2
			"1001111" when "0011",	-- 3
			"0100111" when "0100",	-- 4
			"1101101" when "0101",	-- 5
			"1111101" when "0110",	-- 6
			"1000110" when "0111", 	-- 7
			"1111111" when "1000",  -- 8
			"1101111" when "1001",	-- 9
			"1110111" when "1010",	-- A
			"0111101" when "1011",	-- B
			"1111000" when "1100",	-- C
			"0011111" when "1101",	-- D
			"1111001" when "1110",  -- E
			"1110001" when others;	-- 16
			
END LED_Decoder_Arch;
