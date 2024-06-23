library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity lcd_system is
  port (
    reset_n  : in  std_logic;
    lcd_e    : out std_logic;
    lcd_rs   : out std_logic;
    lcd_rw   : out std_logic;
    lcd_data : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl_lcd_system of lcd_system is
  signal clk                          : std_logic;
  signal ready, start, rs, rw         : std_logic;
  signal line_0_buffer, line_1_buffer : std_logic_vector(127 downto 0);
  signal data                         : std_logic_vector(7 downto 0);
begin
  gowin_osc_inst: entity work.Gowin_OSC -- 25MHz
  port map (
    oscout => clk
  );
  lcd_gan_dulieu_hienthi_inst: entity work.LCD_GAN_DULIEU_HIENTHI
    port map (
      LCD_HANG_1 => line_0_buffer,
      LCD_HANG_2 => line_1_buffer
    );

  lcd_controller: entity work.lcd_controller
    generic map (
      freq => 25
    )
    port map (
      clk      => clk,
      reset_n  => reset_n,
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

  main_system_inst: entity work.main_system
    port map (
      clk           => clk,
      reset_n       => reset_n,
      ready         => ready,
      start         => start,
      data          => data,
      rs            => rs,
      rw            => rw,
      line_0_buffer => line_0_buffer,
      line_1_buffer => line_1_buffer
    );
end architecture;
