library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity fibonacy_system is
  generic (
    N_MAX    : unsigned(5 downto 0) := to_unsigned(47, 6);
    REG_SIZE : integer              := 32;
    IN_WIDTH : integer              := 6;
    SSEG     : integer              := 10 -- 7-segment requirement
  );
  port (
    start      : in  std_logic;
    ready      : out std_logic;
    n          : in  std_logic_vector(IN_WIDTH downto 0);
    led        : in  std_logic_vector(7 downto 0);
    led_number : in  std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of fibonacy_system is
  signal clk : std_logic;
begin
end architecture;
