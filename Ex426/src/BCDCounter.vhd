library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BCDCounter is
  port (
    clk: in std_logic;
    resetn: in std_logic;
    pause : in std_logic;
    decHundreds: out std_logic_vector(3 downto 0);
    decTens: out std_logic_vector(3 downto 0);
    decUnits: out std_logic_vector(3 downto 0)
  );
end entity;

architecture RTL_BCDCounter of BCDCounter is
    signal curr100: unsigned(3 downto 0);
    signal next100: unsigned(3 downto 0);
    signal next10,curr10,next1,curr1: unsigned(3 downto 0);

begin
    REGISTER_PROC : process(clk,resetn)
    begin
        if resetn = '0' then
          curr1 <= (others => '0');
          curr10 <= (others => '0');
          curr100 <= (others => '0');
        elsif clk'event and clk = '1'  then
          curr1 <= next1;
          curr10 <= next10;
          curr100 <= next100;
        end if;
    end process;
    -- NEXT STATE LOGIC
    next1 <= curr1 +1 when curr1 < 10 else
    curr1 when pause = '1' else
        (others => '0');

    next10 <= curr10 + 1 when curr1 = 9 and curr10 < 9 else
    curr10 when curr1 < 9 or pause = '1' else
        (others => '0');

    next100 <= curr100 + 1 when curr10 = 9 and curr1 = 9 and curr100 < 9 else
               curr100 when (curr10 < 9 and curr1 < 9) or pause = '1' else
        (others => '0');
    
    -- OUTPUT LOGIC BLOCK
    decHundreds <= std_logic_vector(curr100);
    decTens <= std_logic_vector(curr10);
    decUnits <= std_logic_vector(curr1);





end architecture;
