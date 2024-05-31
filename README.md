# Experimient VHDL Course
## Chapter 4 - Sequential Ciruit Design
- Exercise 401: Design A 1-Hz divider circuit from 100Hz:<br>
  - Firstly, in gowin device's primitive lib, we only use gowin_osc clock generator (originally 250MHz --> 2,5MHz) and 5 gowin_clkdiv5 and 1 gowin_clkdiv8 to generate a 100Hz-signal. As the result, the system depends on Gowin FPGA. <br>
  - Secondly, the system diagram is showed below: <br>
  ![The System Diagram](Ex401/img/Ex401Dia.png) <br>
  - Additional, we design Devider_1Hz circuit based on the Sequential Circuit Design Model: <br>
    ![Sequential Circuit Design Model](Ex401/img/SCDModel.png)
  - The timing analysis: <br>
  ![Timing](Ex401/img/timing.png)
  - The two last pictures is reference by "RTL Hardware Design Using VHDL" by PONG P. CHU - Cleveland State University
  - Demonstration: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw

