# FPGA Morse Code Decoder & UART Transmitter

A hardware-level embedded system that decodes manual Morse code inputs in real-time, translates them into standard ASCII characters, and transmits the complete sentences to a PC via UART communication. 

**Note:** This was my very first independent FPGA project. It serves as a foundational exploration of Finite State Machines (FSM), real-time user input measurement, shift-register decoding, and serial communication.

## 🔄 Background & Architecture Redesign
This project is a hardware-level reimagining of a final open-ended assignment from a previous microcontroller lab class. 

For that original assignment, my team and I built a Morse Code interface based on distinct "click" and "hold" durations. While we successfully implemented the prototype using C++ and Assembly, the architecture was inherently limited. The software overhead, interrupt handling, and loop execution times made it incredibly difficult to accurately measure the precise timing of the user's manual inputs, leading to buggy decoding. 

When looking for my first independent FPGA project, I rebuilt this system entirely in hardware using a Verilog Finite State Machine (FSM). By utilizing the 25MHz clock of the FPGA, the input measurement became 100% deterministic—completely eliminating the lag of the original microcontroller version and allowing for flawless real-time decoding.

## ⚙️ How It Works (System Architecture)

The system relies on a central FSM interacting with utility modules (Debouncers, UART TX) to process user inputs. 

### 1. Real-Time Input Measurement
* **Switch 1 (Morse Input):** The user taps or holds this button to input Morse code.
* The FSM uses an internal counter to measure the exact hold duration. Based on predefined parameters (`ONE_SECOND_COUNT = 12,500,000` cycles, representing a 0.5-second threshold at 25MHz), it classifies the input as a **Dot**, **Dash**, **Letter Space**, or **Word Space**.
* **Live LED Feedback:** As the user holds down Switch 1, onboard LEDs dynamically illuminate to indicate which threshold has been crossed, providing real-time visual feedback to the user.

### 2. Shift-Register Decoding
* As Dots (`0`) and Dashes (`1`) are registered, they are shifted into a 5-bit `letter_buffer`.
* Once a "Letter Space" duration is detected, the buffer is routed through a custom lookup table (`Letter_Convert`) to decode the unique binary sequence into its corresponding ASCII hex value.

### 3. Memory & UART Transmission
* Decoded ASCII characters are sequentially stored into a block of `sentence_memory` (RAM).
* **Switch 2 (Transmit):** Triggers a secondary transmission state machine. It loops through the `sentence_memory` and sequentially pushes every stored byte to a custom `UART_TX` module, transmitting the complete decoded sentence to a connected PC terminal.
* **Switch 3 (Backspace):** Shifts the `letter_buffer` backwards, allowing the user to delete their last inputted dot/dash, transmitting an ASCII backspace (`0x08`) via UART.

## 🛠️ Tools & Hardware
* **Language:** Verilog
* **Target:** Lattice iCE40 (Nandland Go Board)
* **Synthesis:** Yosys, NextPNR, and IceStorm (Open-source CLI flow)

## 🚀 Lessons Learned
As my first independent project into FPGA development, this project fundamentally shifted how I approach system design. It taught me how to manage concurrent hardware logic, handle custom memory buffers, and interface with standard communication protocols (RS-232/UART). Most importantly, it proved that strict timing problems are often best solved by removing the software execution layer entirely and letting pure hardware logic do the work.
