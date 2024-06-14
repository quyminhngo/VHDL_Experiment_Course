library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BinBCDConverter is
  generic (
    constant N : integer := 6 -- 2^6 = 64
  );
  port (
    bin_number : in  std_logic_vector(N - 1 downto 0);
    BCD_tens   : out std_logic_vector(3 downto 0);
    BCD_units  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture RTL_BinBCDConverter of BinBCDConverter is

begin
  -- enter your statements here --
  process (bin_number)
    variable number : std_logic_vector(13 downto 0);
    variable i      : integer range 0 to 5;
    --variable BCD_1,BCD_2: std_logic_vector(3 downto 0);
  begin
    number := "00000000" & bin_number;
    i := 0;
    while i < 5 loop
      i := i + 1;
      number := number(12 downto 0) & number(13);

      if (number(13 downto 10) >= "0101") then
        number(13 downto 10) := std_logic_vector(unsigned(number(13 downto 10)) + 3);
      end if;
      if (number(9 downto 6) >= "0101") then
        number(9 downto 6) := std_logic_vector(unsigned(number(9 downto 6)) + 3);
      end if;
    end loop;
    number := number(12 downto 0) & '0';

    BCD_tens <= number(13 downto 10);
    BCD_units <= number(9 downto 6);

  end process;

end architecture;




