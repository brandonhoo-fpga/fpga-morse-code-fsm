# fpga-morse-code-fsm
Hardware Morse decoder in Verilog on a Lattice iCE40. Multi-state FSM classifies key durations into dots, dashes, and letter/word boundaries. Dual-layer output: live UART echo plus a 64-byte sentence buffer.
