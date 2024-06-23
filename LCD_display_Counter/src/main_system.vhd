library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity main_system is

  port (
    reset_n_lcd : in  std_logic;
    reset_n     : in  std_logic;
    lcd_e       : out std_logic;
    lcd_rs      : out std_logic;
    lcd_rw      : out std_logic;
    lcd_data    : out std_logic_vector(7 downto 0)

  );
end entity;

architecture RTL_main_system of main_system is
  signal clk                               : std_logic;
  signal enable_1hz                        : std_logic;
  signal bcd_hundreds, bcd_tens, bcd_units : std_logic_vector(3 downto 0);
  signal lcd_line_0                        : std_logic_vector(127 downto 0);
  signal lcd_line_1                        : std_logic_vector(127 downto 0);
  signal data                              : std_logic_vector(7 downto 0);
  signal rs, rw                            : std_logic;
  signal ready, start                      : std_logic;

begin

  gowin_osc_inst: entity work.Gowin_OSC
    port map (
      oscout => clk
    );
  enable_1hz_inst: entity work.Enable_1Hz
    port map (
      clk    => clk,
      clkout => enable_1hz,
      resetn => reset_n_lcd
    );
  bcd_counter_inst: entity work.BCD_counter
    port map (
      clk          => clk,
      enable       => enable_1hz,
      reset_n      => reset_n,
      bcd_hundreds => bcd_hundreds,
      bcd_tens     => bcd_tens,
      bcd_units    => bcd_units
    );
  lcd_gan_dulieu_hienthi_inst: entity work.LCD_GAN_DULIEU_HIENTHI
    port map (
      BCD_hundreds => bcd_hundreds,
      BCD_tens     => bcd_tens,
      BCD_units    => bcd_units,
      LCD_HANG_1   => lcd_line_0,
      LCD_HANG_2   => lcd_line_1
    );
  user_logic_system_inst: entity work.user_logic_system
    port map (
      clk           => clk,
      reset_n       => reset_n_lcd,
      ready         => ready,
      start         => start,
      data          => data,
      rs            => rs,
      rw            => rw,
      line_0_buffer => lcd_line_0,
      line_1_buffer => lcd_line_1
    );
  lcd_controller_inst: entity work.lcd_controller
    generic map (
      freq => 25
    )
    port map (
      clk      => clk,
      reset_n  => reset_n_lcd,
      start    => start,
      data     => data,
      rs       => rs,
      rw       => rw,
      lcd_rs   => lcd_rs,
      lcd_rw   => lcd_rw,
      lcd_e    => lcd_e,
      lcd_data => lcd_data,
      ready    => ready
    );
end architecture;
