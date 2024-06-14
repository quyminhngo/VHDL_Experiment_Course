library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Multiplier is

  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    a      : in  std_logic_vector(7 downto 0);
    b      : in  std_logic_vector(7 downto 0);
    r      : out std_logic_vector(15 downto 0);
    ready  : out std_logic;
    start  : in  std_logic
  );
end entity;

architecture rtl of Multiplier is
  type state is (idel, ab0, load, op);
  signal state_reg, state_next : state;
  signal a_reg, a_next         : unsigned(7 downto 0);
  signal n_reg, n_next         : unsigned(7 downto 0);
  signal r_reg, r_next         : unsigned(15 downto 0);
  signal r_next_count          : std_logic_vector(7 downto 0);

  signal sub_out   : unsigned(7 downto 0);
  signal adder_out : unsigned(15 downto 0);
begin
  -- Register
  REGISTER_PROC: process (clk, resetn)
  begin
    if resetn = '0' then
      state_reg <= idel;
      a_reg <= (others => '0');
      n_reg <= (others => '0');
      r_reg <= (others => '0');
    elsif rising_edge(clk) then
      state_reg <= state_next;
      a_reg <= a_next;
      n_reg <= n_next;
      r_reg <= r_next;
    end if;
  end process;
  -- Control Unit: Next State Circuit

  NextState_PROC: process (state_reg, start, n_next, a, b)
  begin
    case (state_reg) is

      when idel =>
        if start = '1' then
          if (a = "00000000" or b = "00000000") then
            state_next <= ab0;
          else
            state_next <= load;
          end if;
        else
          state_next <= idel;
        end if;
      when ab0 =>
        state_next <= idel;
      when load =>
        state_next <= idel;
      when op =>
        if n_next = "00000000" then
          state_next <= idel;
        else
          state_next <= op;
        end if;

    end case;
  end process;

  -- Control Unit: Moore output
  ready <= '1' when state_reg = idel else
           '0';
  -- Datapath Routing network

  PROC: process (state_reg, a_reg, n_reg, r_reg, a, b, adder_out, sub_out)
  begin
    case (state_reg) is

      when idel =>
        a_next <= a_reg;
        n_next <= n_reg;
        r_next <= r_reg;
      when ab0 =>
        r_next <= (others => '0');
        a_next <= unsigned(a);
        n_next <= unsigned(b);
      when load =>
        r_next <= (others => '0');
        a_next <= unsigned(a);
        n_next <= unsigned(b);
      when op =>
        a_next <= a_reg;
        r_next <= adder_out;
        n_next <= sub_out;
    end case;
  end process;
  -- Datapath Funtional Units
  adder_out <= "00000000" & a_reg + r_reg;
  sub_out   <= n_reg - 1;
  -- Datapath status
  -- Datapath output
  r <= std_logic_vector(r_reg);
end architecture;
