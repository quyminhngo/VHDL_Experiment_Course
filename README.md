# Experimient RTL HARDWARE DESIGN USING VHDL
## CHAPTER 4 - SEQUENTIAL CIRCUIT DESIGN
  
> ![Sequential Circuit Design Model](Ex401/img/SCDModel.png)
> ![Timing](Ex401/img/timing.png)
> <em> Reference by "RTL Hardware Design Using VHDL" by PONG P. CHU - Cleveland State University </em>






- <b>EXERCISE 401:</b>  Design a 1-Hz divider circuit from 100Hz:<br>
  - Firstly, in gowin device's primitive lib, we only use gowin_osc clock generator (originally 250MHz --> 2,5MHz) and 5 gowin_clkdiv5 and 1 gowin_clkdiv8 to generate a 100Hz-signal. As the result, the system depends on Gowin FPGA. <br>
  - Secondly, the Sequential Circuit Design Model-Based system diagram is showed below: <br>
  >![The System Diagram](Ex401/img/Ex401Dia.png) <br>

  
  - Finally, the demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw
- <b>EXERCISE 421:</b> Design a 3-bit counter that count from 000 to 111 and turn around 111 to 000 automatically. It use system clk 100Hz and use a user clock divider 1 Hz as enable port of Register.
  >![The System Diagram](Ex421/img/CounterDia.png) <br>
  > <b>Note that </b>: The 3-bit counter have to have a "status" register to store current state status. Once current state is "111", the status register will be '1' (counting down)... and it decrease by 1, it is "110" but the status register is not enable and it also store '1'. Example, when current state = "010" and status register = '0' (counting up) so the next state = "011"... until the current state is "111", the status is store '1'... and so on. <br>
  > <b>The demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw



