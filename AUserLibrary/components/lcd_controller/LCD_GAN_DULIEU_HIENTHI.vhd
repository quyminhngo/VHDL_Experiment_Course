library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity LCD_GAN_DULIEU_HIENTHI is
  port (
    LCD_HANG_1 : out STD_LOGIC_VECTOR(127 downto 0);
    LCD_HANG_2 : out STD_LOGIC_VECTOR(127 downto 0));
end entity;

architecture Behavioral of LCD_GAN_DULIEU_HIENTHI is
begin
  -- HANG 1 
  LCD_HANG_1(7 downto 0)     <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);
  LCD_HANG_1(15 downto 8)    <= CONV_STD_LOGIC_VECTOR(character'pos('N'), 8);
  LCD_HANG_1(23 downto 16)   <= CONV_STD_LOGIC_VECTOR(character'pos('G'), 8);
  LCD_HANG_1(31 downto 24)   <= CONV_STD_LOGIC_VECTOR(character'pos('O'), 8);
  LCD_HANG_1(39 downto 32)   <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);
  LCD_HANG_1(47 downto 40)   <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);
  LCD_HANG_1(55 downto 48)   <= CONV_STD_LOGIC_VECTOR(character'pos('M'), 8);
  LCD_HANG_1(63 downto 56)   <= CONV_STD_LOGIC_VECTOR(character'pos('I'), 8);
  LCD_HANG_1(71 downto 64)   <= CONV_STD_LOGIC_VECTOR(character'pos('N'), 8);
  LCD_HANG_1(79 downto 72)   <= CONV_STD_LOGIC_VECTOR(character'pos('H'), 8);
  LCD_HANG_1(87 downto 80)   <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);
  LCD_HANG_1(95 downto 88)   <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);
  LCD_HANG_1(103 downto 96)  <= CONV_STD_LOGIC_VECTOR(character'pos('Q'), 8);
  LCD_HANG_1(111 downto 104) <= CONV_STD_LOGIC_VECTOR(character'pos('U'), 8);
  LCD_HANG_1(119 downto 112) <= CONV_STD_LOGIC_VECTOR(character'pos('Y'), 8);
  LCD_HANG_1(127 downto 120) <= CONV_STD_LOGIC_VECTOR(character'pos('*'), 8);

  -- HANG 2 
  LCD_HANG_2(7 downto 0)   <= CONV_STD_LOGIC_VECTOR(character'pos('n'), 8);
  LCD_HANG_2(15 downto 8)  <= CONV_STD_LOGIC_VECTOR(character'pos('g'), 8);
  LCD_HANG_2(23 downto 16) <= CONV_STD_LOGIC_VECTOR(character'pos('o'), 8);
  LCD_HANG_2(31 downto 24) <= CONV_STD_LOGIC_VECTOR(character'pos('m'), 8);
  LCD_HANG_2(39 downto 32) <= CONV_STD_LOGIC_VECTOR(character'pos('i'), 8);
  LCD_HANG_2(47 downto 40) <= CONV_STD_LOGIC_VECTOR(character'pos('n'), 8);
  LCD_HANG_2(55 downto 48) <= CONV_STD_LOGIC_VECTOR(character'pos('h'), 8);
  LCD_HANG_2(63 downto 56) <= CONV_STD_LOGIC_VECTOR(character'pos('q'), 8);
  LCD_HANG_2(71 downto 64) <= CONV_STD_LOGIC_VECTOR(character'pos('u'), 8);
  LCD_HANG_2(79 downto 72) <= CONV_STD_LOGIC_VECTOR(character'pos('y'), 8);
  LCD_HANG_2(87 downto 80) <= CONV_STD_LOGIC_VECTOR(character'pos('.'), 8);
  LCD_HANG_2(95 downto 88) <= CONV_STD_LOGIC_VECTOR(character'pos('n'), 8);

  LCD_HANG_2(103 downto 96)  <= CONV_STD_LOGIC_VECTOR(character'pos('m'), 8);
  LCD_HANG_2(111 downto 104) <= CONV_STD_LOGIC_VECTOR(character'pos('q'), 8);
  LCD_HANG_2(119 downto 112) <= CONV_STD_LOGIC_VECTOR(character'pos('@'), 8);
  LCD_HANG_2(127 downto 120) <= CONV_STD_LOGIC_VECTOR(character'pos('g'), 8);
end architecture;
