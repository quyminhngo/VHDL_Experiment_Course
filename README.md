# Experimient RTL HARDWARE DESIGN USING VHDL
## CHAPTER 4 - SEQUENTIAL CIRCUIT DESIGN
  
> ![Sequential Circuit Design Model](Ex401/img/SCDModel.png)
  <br>
> ![Timing](Ex401/img/timing.png)
  <br>
> <em> Reference by "RTL Hardware Design Using VHDL" by PONG P. CHU - Cleveland State University </em>



- <b>Exercise 401:</b>  Design A 1-Hz divider circuit from 100Hz:<br>
  - Firstly, in gowin device's primitive lib, we only use gowin_osc clock generator (originally 250MHz --> 2,5MHz) and 5 gowin_clkdiv5 and 1 gowin_clkdiv8 to generate a 100Hz-signal. As the result, the system depends on Gowin FPGA. <br>
  - Secondly, the Sequential Circuit Design Model-Based system diagram is showed below: <br>
  ![The System Diagram](Ex401/img/Ex401Dia.png) <br>

  
  - Finally, the demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw

