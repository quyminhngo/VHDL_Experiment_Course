library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity fibonacy is
  generic (
    N_MAX    : unsigned(5 downto 0) := to_unsigned(47, 6);
    REG_SIZE : integer              := 32;
    IN_WIDTH : integer              := 6
  );
  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    start  : in  std_logic;
    ready  : out std_logic;
    n      : in  std_logic_vector(IN_WIDTH - 1 downto 0); -- 6 Bit
    fn     : out std_logic_vector(REG_SIZE - 1 downto 0)  -- 32 bit output
  );
end entity;

architecture multi_segment_style_fibonacy of fibonacy is
  type fib_state is (idel, op);
  -- Register
  signal FSM_state_reg, FSM_state_next            : fib_state;
  signal fib_reg, fib_next, f_n_1_reg, f_n_1_next : unsigned(REG_SIZE - 1 downto 0);
  signal f_n_2_reg, f_n_2_next                    : unsigned(REG_SIZE - 1 downto 0);
  signal i_reg, i_next                            : unsigned(IN_WIDTH - 1 downto 0);
begin
  -- DataPath Register
  DP_REGISTER_PROC: process (clk, resetn)
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

  DP_FUNC: process (FSM_state_reg, f_n_1_reg, f_n_2_reg, i_next, fib_reg, i_reg, start, n, fib_next)
  begin
    fib_next <= fib_reg;
    f_n_1_next <= f_n_1_reg;
    f_n_2_next <= f_n_2_reg;
    i_next <= i_reg;

    case FSM_state_reg is

      when idel =>
        if start = '1' and unsigned(n) <= N_MAX then -- the maximum input is 47, if n > 47 the result will be 0.
          fib_next <= (others => '0');
          f_n_1_next <= to_unsigned(1, REG_SIZE);
          f_n_2_next <= (others => '0');
          i_next <= unsigned(n);
        else
          i_next <= (others => '0');
          fib_next <= (others => '0');
        end if;
        if i_next = 1 then
          fib_next <= to_unsigned(1, REG_SIZE);
        end if;
        if i_next = 0 then
          fib_next <= (others => '0');
        end if;
      when op => i_next <= i_reg - 1;
                 fib_next <= f_n_1_reg + f_n_2_reg;
                 f_n_1_next <= fib_next;
                 f_n_2_next <= f_n_1_reg;
      when others =>
    end case;
  end process; -- DP_FUNC
  fn <= std_logic_vector(fib_reg);
  -- Control Path Register

  CP_REGISTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      FSM_state_reg <= idel;
    elsif rising_edge(clk) then
      FSM_state_reg <= FSM_state_next;
    end if;
  end process;

  CP_NEXT_STATE: process (FSM_state_reg, start, i_next,n)
  begin
    case (FSM_state_reg) is
      when idel =>
        if start = '1' and unsigned(n) <= N_MAX then
          if i_next = 0 or i_next = 1 then
            FSM_state_next <= idel;
          else
            FSM_state_next <= op;
          end if;
        else
          FSM_state_next <= idel;
        end if;
      when op =>
        if (i_next = 1) then
          FSM_state_next <= idel;
        else
          FSM_state_next <= op;
        end if;
    end case;
  end process;

  ready <= '1' when FSM_state_reg = idel else
           '0';

end architecture;
