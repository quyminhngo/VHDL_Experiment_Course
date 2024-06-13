library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity led_decoder is
  port (
    inp  : in  STD_LOGIC_VECTOR(3 downto 0);
    outp : out STD_LOGIC_VECTOR(7 downto 0);
    dot  : in  std_logic;
    en   : in  std_logic
  );
end entity;

architecture led_decoder_arch of led_decoder is
begin
  -- enter your statements here --
  LED_DECODER_PROC: process (inp, en, dot)
  begin
    if en = '0' then
      outp <= "00000000";
    else
      case (inp) is
        when x"1" => outp <= dot & "0000110"; --1
        when x"0" => outp <= dot & "1111110"; --0
        when x"2" => outp <= dot & "1011011"; --2
        when x"3" => outp <= dot & "1001111"; -- 3
        when x"4" => outp <= dot & "0100111"; --4
        when x"5" => outp <= dot & "1101101"; --5
        when x"6" => outp <= dot & "1111101"; --6
        when x"7" => outp <= dot & "1000110"; --7
        when x"8" => outp <= dot & "1111111"; --8
        when x"9" => outp <= dot & "1101111"; --9
        when x"a" => outp <= dot & "1110111"; --10
        when x"b" => outp <= dot & "0111101"; --11
        when x"c" => outp <= dot & "1111000"; --12
        when x"d" => outp <= dot & "0011111"; --13
        when x"e" => outp <= dot & "1111001"; --14
        when others => outp <= dot & "1110001"; --15
      end case;
    end if;
  end process;
end architecture;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ControlSevenSegmentLed is

  port (
    clk         : in  std_logic;
    sseg_in_0   : in  std_logic_vector(3 downto 0);
    sseg_in_1   : in  std_logic_vector(3 downto 0);
    sseg_in_2   : in  std_logic_vector(3 downto 0);
    sseg_in_3   : in  std_logic_vector(3 downto 0);
    sseg_in_4   : in  std_logic_vector(3 downto 0);
    sseg_in_5   : in  std_logic_vector(3 downto 0);
    sseg_in_6   : in  std_logic_vector(3 downto 0);
    sseg_in_7   : in  std_logic_vector(3 downto 0);
    sseg_enable : in  std_logic_vector(7 downto 0);
    sseg_dot    : in  std_logic_vector(7 downto 0);
    clk_enable  : in  std_logic;

    sseg_number : out std_logic_vector(7 downto 0);
    sseg_out    : out std_logic_vector(7 downto 0)

  );
end entity;

architecture rtl of ControlSevenSegmentLed is
  signal sseg_counter_reg, sseg_counter_next : unsigned(2 downto 0);

  signal led_decoder_in : std_logic_vector(3 downto 0);
  signal dot, led_en    : std_logic;

begin
  led_decoder_inst: entity work.led_decoder
    port map (
      inp  => led_decoder_in,
      outp => sseg_out,
      dot  => dot,
      en   => led_en
    );

  SSEG_PROC: process (clk)
  begin
    if (rising_edge(clk)) then
      sseg_counter_reg <= sseg_counter_next;
    end if;
  end process;
  sseg_counter_next <= sseg_counter_reg + 1 when clk_enable = '1' else
                       sseg_counter_reg;

  SCAN_PROC: process (sseg_counter_reg, sseg_enable, sseg_dot, sseg_in_0, sseg_in_1, sseg_in_2, sseg_in_3, sseg_in_4, sseg_in_5, sseg_in_6, sseg_in_7)
  begin
    if sseg_counter_reg = "000" then
      led_decoder_in <= sseg_in_0;
      sseg_number <= "11111110";
      dot <= sseg_dot(0);
      led_en <= sseg_enable(0);

    elsif sseg_counter_reg = "001" then
      led_decoder_in <= sseg_in_1;
      sseg_number <= "11111101";
      dot <= sseg_dot(1);
      led_en <= sseg_enable(1);

    elsif sseg_counter_reg = "010" then
      led_decoder_in <= sseg_in_2;
      sseg_number <= "11111011";
      led_en <= sseg_enable(2);
      dot <= sseg_dot(2);
    elsif sseg_counter_reg = "011" then
      led_decoder_in <= sseg_in_3;
      led_en <= sseg_enable(3);
      sseg_number <= "11110111";
      dot <= sseg_dot(3);
    elsif sseg_counter_reg = "100" then
      led_decoder_in <= sseg_in_4;
      sseg_number <= "11101111";
      led_en <= sseg_enable(4);
      dot <= sseg_dot(4);
    elsif sseg_counter_reg = "101" then
      led_decoder_in <= sseg_in_5;
      sseg_number <= "11011111";
      led_en <= sseg_enable(5);
      dot <= sseg_dot(5);

    elsif sseg_counter_reg = "110" then
      led_decoder_in <= sseg_in_6;
      sseg_number <= "10111111";
      led_en <= sseg_enable(6);
      dot <= sseg_dot(6);

    else
      led_decoder_in <= sseg_in_7;
      sseg_number <= "01111111";
      led_en <= sseg_enable(7);
      dot <= sseg_dot(7);

    end if;
  end process;

end architecture;
