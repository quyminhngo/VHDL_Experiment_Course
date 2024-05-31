# Experimient VHDL Course
## Chapter 4 - Sequential Ciruit Design
- Exercise 401: Design A 1-Hz divider circuit from 100Hz:
  -- Firstly, in gowin device's primitive lib, we only use gowin_osc clock generator (originally 250MHz --> 2,5MHz) and 5 gowin_clkdiv5 and 1 gowin_clkdiv8 to generate a 100Hz-signal. As the result, the system depends on Gowin FPGA.
  -- Secondly, the system diagram is showed below:
  ![The System Diagram](Ex401/img/Ex401Dia)
