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
		 dot: in std_logic;
		 inp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 outp : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	     );
END LED_Decoder_4_Bit;

--}} End of automatically maintained section

ARCHITECTURE LED_Decoder_Arch OF LED_Decoder_4_Bit IS
BEGIN

	-- enter your statements here --
	with inp select 
	outp <= dot&"1111110" when "0000",	-- 0
			dot&"0000110" when "0001", 	-- 1
			dot&"1011011" when "0010",	-- 2
			dot&"1001111" when "0011",	-- 3
			dot&"0100111" when "0100",	-- 4
			dot&"1101101" when "0101",	-- 5
			dot&"1111101"when "0110",	-- 6
			dot&"1000110" when "0111", 	-- 7
			dot&"1111111" when "1000",  -- 8
			dot&"1101111" when "1001",	-- 9
			dot&"1110111" when "1010",	-- A
			dot&"0111101" when "1011",	-- B
			dot&"1111000" when "1100",	-- C
			dot&"0011111" when "1101",	-- D
			dot&"1111001" when "1110",  -- E
			dot&"1110001" when others;	-- 16
			
END LED_Decoder_Arch;
