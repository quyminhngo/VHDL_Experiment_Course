library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity lcd_controller is
  generic (
    constant freq : integer := 25
  );
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    start    : in  std_logic;

    data     : in  std_logic_vector(7 downto 0);
    rs       : in  std_logic;
    rw       : in  std_logic;

    lcd_rs   : out std_logic;
    lcd_rw   : out std_logic;
    lcd_e    : out std_logic;
    lcd_data : out std_logic_vector(7 downto 0);

    ready    : out std_logic
  );
end entity;

architecture RTL_LCD_controller of lcd_controller is
  type LCD_FSMD_STATE is (LCD_POWER_UP, LCD_INIT, LCD_READY, LCD_DELAY_300NS, LCD_DELAY_40NS, LCD_DELAY_50US);
  type LCD_INSTRUCTION_SET is array (0 to 5) of std_logic_vector(9 downto 0);
  constant LCD_INSTRUCTION_SET_CONST : LCD_INSTRUCTION_SET := (
    0 => "0000000000",
    1 => "0000111100", --FUNCTION SET 
    2 => "0000001100", -- X"0C" --CONTROL DISPLAY 
    3 => "0000000001", --CLEAR 
    4 => "0000000010", --RETURN HOME 
    5 => "0000000110" --ENTRY MODE SET 

  );

  signal LCD_state_next, LCD_state_reg             : LCD_FSMD_STATE;
  signal clk_count_reg, clk_count_next             : integer;
  signal lcd_instruction_reg, lcd_instruction_next : std_logic_vector(9 downto 0);
  signal ptr_reg, ptr_next                         : INTEGER range 0 to 15 := 0;

begin
  lcd_data <= lcd_instruction_reg(7 downto 0);
  lcd_rs   <= lcd_instruction_reg(9);
  lcd_rw   <= lcd_instruction_reg(8);

  -- CONTROL UNIT

  FSM_REGISTER_PROC: process (clk, reset_n)
  begin
    if reset_n = '0' then
      LCD_state_reg <= LCD_POWER_UP;
    elsif rising_edge(clk) then
      LCD_state_reg <= LCD_state_next;
    end if;
  end process;

  -- Moore Output
  ready <= '1' when LCD_state_reg = LCD_READY else
           '0';

  FSM_NEXT_STATE_PROC: process (LCD_state_reg, ptr_reg, start, clk_count_reg, clk_count_next, lcd_instruction_next)
  begin
    lcd_e <= '0';
    case (LCD_state_reg) is
      when LCD_POWER_UP =>
        if clk_count_reg <= 50000 * freq then
          LCD_state_next <= LCD_POWER_UP;
        else
          LCD_state_next <= LCD_INIT;
        end if;

      when LCD_INIT =>
        LCD_state_next <= LCD_INIT;
        if clk_count_reg = 3000 * freq then
          if ptr_reg = 5 then
            LCD_state_next <= LCD_READY;
          end if;
        elsif clk_count_reg <= 30 then
          LCD_E <= '1';
        end if;

      when LCD_READY =>
        if start = '0' then
          LCD_state_next <= LCD_READY;
        else
          if lcd_instruction_next(8) = '1' then
            LCD_state_next <= LCD_READY;
          else
            LCD_state_next <= LCD_DELAY_300NS;
          end if;
        end if;
      when LCD_DELAY_300NS =>
        lcd_e <= '1';
        if clk_count_reg <= 8 then
          LCD_state_next <= LCD_DELAY_300NS;
        else
          LCD_state_next <= LCD_DELAY_40NS;
        end if;
      when LCD_DELAY_40NS =>
        LCD_state_next <= LCD_DELAY_50US;
      when LCD_DELAY_50US =>
        if clk_count_reg <= 50 * freq then
          LCD_state_next <= LCD_DELAY_50US;
        else
          LCD_state_next <= LCD_READY;
        end if;
    end case;
  end process;
  -- DATAPATH

  DataPath_PROC: process (LCD_state_reg, ptr_reg, clk_count_reg, lcd_instruction_reg, start, rs, rw, data, clk_count_next)
  begin
    clk_count_next <= clk_count_reg;
    lcd_instruction_next <= lcd_instruction_reg;
    ptr_next <= ptr_reg;
    case (LCD_state_reg) is
      when LCD_POWER_UP => -- Delay 50ms
        if clk_count_reg <= 50000 * freq then
          clk_count_next <= clk_count_reg + 1;
        else
          clk_count_next <= 0;
        end if;

      when LCD_INIT =>
        clk_count_next <= clk_count_reg + 1;
        if clk_count_reg = 3000 * freq then
          clk_count_next <= 0;
          if ptr_reg < 5 then
            ptr_next <= ptr_reg + 1;
          end if;
        else
          lcd_instruction_next <= LCD_INSTRUCTION_SET_CONST(ptr_reg);
        end if;

      when LCD_READY => clk_count_next <= 0;
                        if start = '1' then
                          lcd_instruction_next <= rs & rw & data;
                        else
                          lcd_instruction_next <= (others => '0');
                        end if;
      when LCD_DELAY_300NS => if clk_count_reg <= 8 then
                                clk_count_next <= clk_count_reg + 1;
                              else
                                clk_count_next <= 0;
                              end if;
      when LCD_DELAY_40NS => clk_count_next <= 0;
      when LCD_DELAY_50US => if clk_count_reg <= 50 * freq then
                               clk_count_next <= clk_count_reg + 1;
                             else
                               clk_count_next <= 0;
                             end if;

      when others =>
    end case;
  end process;

  datapathRegister_PROC: process (clk, reset_n)
  begin
    if reset_n = '0' then
      ptr_reg <= 0;
      clk_count_reg <= 0;
      lcd_instruction_reg <= LCD_INSTRUCTION_SET_CONST(0); -- NOP INST
    elsif rising_edge(clk) then
      ptr_reg <= ptr_next;
      clk_count_reg <= clk_count_next;
      lcd_instruction_reg <= lcd_instruction_next;
    end if;
  end process;
end architecture;
