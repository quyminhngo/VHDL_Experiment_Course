# Experiment RTL HARDWARE DESIGN USING VHDL
<em> Reference by "RTL Hardware Design Using VHDL" by PONG P. CHU - Cleveland State University </em>

# Chapter 1 - Introduction to Digital System Design

# Chapter 2 - Overview of Hardware Description Language

# Chapter 3 - Basic Language Constructs of VHDL

# Chapter 4 - Concurrent Signal Assignment Statement

# Chapter 5 - Sequential Statement of VHDL

# Chapter 6 - Synthesis of VHDL Code

# Chapter 7 - Combinational Circuit Design: Practice

# Chapter 8 - Sequential Circuit Design: Principle


> <img src = "Ex401/img/SCDModel.png">
<div style="text-align: center;">
Sequential Circuit Design Model
</div>
</img>
<br>

><img src = "Ex401/img/timing.png">
<div style="text-align: center;">
Timing Diagram
</div>
</img>
<br>





# Chapter 9 - Sequential Circuit Design: Practice
  

## CLOCK DIVIDER
- <b>EXERCISE 401:</b>  Design a 1-Hz divider circuit from 100Hz:<br>
  - Firstly, in gowin device's primitive lib, we only use gowin_osc clock generator (originally 250MHz --> 2,5MHz) and 5 gowin_clkdiv5 and 1 gowin_clkdiv8 to generate a 100Hz-signal. As the result, the system depends on Gowin FPGA. <br>
  - Secondly, the Sequential Circuit Design Model-Based system diagram is showed below: <br>
  >![The System Diagram](Ex401/img/Ex401Dia.png) <br>

  
  - Finally, the demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw
## BINARY COUNTERS
- <b>EXERCISE 421:</b> Design a 3-bit counter that count from 000 to 111 and turn around 111 to 000 automatically. It use system clk 100Hz and use a user clock divider 1 Hz as enable port of Register.
  >![The System Diagram](Ex421/img/CounterDia.png) <br>
  > <b>Note that </b>: The 3-bit counter have to have a "status" register to store current state status. Once current state is "111", the status register will be '1' (counting down)... and it decrease by 1, it is "110" but the status register is not enable and it also store '1'. Example, when current state = "010" and status register = '0' (counting up) so the next state = "011"... until the current state is "111", the status is store '1'... and so on. <br>
  > <b>The demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw

# Chapter 10 - Finite State Machine: Principle and Practice

> <img src = "img/FSM_Diagram.png">
<div style="text-align: center;">
  Block Diagram of an FSM
</div>
</img>
<br>

> Timing Analysis is discussed at Section 10.3 at page 321-326 of the textbook

## BUTTON DEBOUNCING CIRCUIT
- Goals: When we push a button or switch a toggle switch, it probably has some glitches as the picture. The goal of this problem is to generate the glitch-free output in the all triggering edges of input signal.

> <img src = "img/Switch_Debounce.jpg">
</img>
<br>

- The timing goal 

- The State Diagram

- The Algorithms State Machine (ASM) chart

- The Button debouncing circuit diagram

- Demonstration link: https://www.youtube.com/channel/UCi_n5XIAMVjPtJlm0RjNEPw











