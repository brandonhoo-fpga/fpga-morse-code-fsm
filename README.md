# fpga-moorse-code-fsm
A hardware-level Morse Code generator written in Verilog, utilizing a Finite State Machine (FSM) for precise signal timing.

**Note:** This was my very first FPGA project. It serves as a foundational exploration of hardware design, state machines, and clock division.

## 🔄 Background & Architecture Redesign
This project was born out of frustration with a previous software implementation. 

Originally, I built this Morse Code generator on a standard microcontroller using a mix of C++ and Assembly. However, I continuously ran into functional bugs and timing inconsistencies. The software overhead, interrupt handling, and loop execution times made it incredibly difficult to achieve perfectly crisp, consistent timing for the Morse dots and dashes. 

I realized that Morse code generation isn't a processing problem; it's a **strict timing and state problem**. 

I abandoned the software approach and rebuilt the system entirely in hardware using an FPGA. By utilizing a Verilog Finite State Machine (FSM), the timing became 100% deterministic, completely eliminating the lag and inconsistency of the microcontroller version.
