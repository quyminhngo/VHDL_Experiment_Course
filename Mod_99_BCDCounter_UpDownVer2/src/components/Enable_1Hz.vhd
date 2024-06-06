library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Enable_1Hz is
  port
  (
    clk    : in std_logic;
    clkout : out std_logic;
    resetn : in std_logic
  );
end entity Enable_1Hz;

architecture RTL_Devider_1Hz of Enable_1Hz is
  constant mod_N : integer := 50;

  component OSC_100Hz is
    port
    (
      clkout : out std_logic;
      resetn : in std_logic
    );
  end component;

  signal next_state, curr_state : signed(7 downto 0) := (others => '0');

begin
  --REGISTER
  REGISTER_PROC : process (clk, resetn)
  begin
    if resetn = '0' then
      curr_state <= (others => '0');
    elsif clk'event and clk = '1' then
      curr_state <= next_state;
    end if;
  end process;
  -- Next State Logic Block

  next_state <= curr_state + 1 when curr_state < mod_N else
    (others => '0');

  -- Output logic State
  clkout <= '1' when curr_state = mod_N/2 else
    '0';
end architecture;