library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity fibonacy is
  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    start  : in  std_logic;
    ready  : out std_logic;
    n      : in  std_logic_vector(5 downto 0); -- 6 Bit
    fn     : out std_logic_vector(42 downto 0) -- 43 bit output
  );
end entity;

architecture multi_segment_style_fibonacy of fibonacy is
  type fib_state is (idel, op);
  -- Register
  signal FSM_state_reg, FSM_state_next            : fib_state;
  signal fib_reg, fib_next, f_n_1_reg, f_n_1_next : unsigned(20 downto 0);
  signal f_n_2_reg, f_n_2_next                    : unsigned(20 downto 0);
  signal i_reg, i_next                            : unsigned(2 downto 0);
begin
  -- DataPath Register
  DP_REGISTER_PROC: process (clk)
  begin
    if resetn = '0' then
      fib_reg <= (others => '0');
      f_n_1_reg <= (others => '0');
      f_n_2_reg <= (others => '0');
      i_reg <= (others => '0');
    elsif rising_edge(clk) then
      fib_reg <= fib_next;
      f_n_1_reg <= f_n_1_next;
      f_n_2_reg <= f_n_2_next;
      i_reg <= i_next;
    end if;
  end process;

  -- Control Path Register

  CP_REGISTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      FSM_state_reg <= idel;
    elsif rising_edge(clk) then
      FSM_state_reg <= FSM_state_next;
    end if;
  end process;

  CP_NEXT_STATE: process (FSM_state_reg, start, i_next)
  begin
    case (FSM_state_reg) is
      when idel =>
        if start = '1' and i_next /= 0 and i_next /= 1 then
          FSM_state_next <= op;
        else
          FSM_state_next <= idel;
        end if;
      when op =>
        if (i_next) when others => end case; end process; end architecture;