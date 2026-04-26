# FPGA Morse Code Decoder & UART Transmitter
A hardware-level embedded system that decodes manual Morse code inputs in real-time, translates them into standard ASCII characters, and transmits the complete sentences to a PC via UART communication.
 
**Note:** This was my very first independent FPGA project. It covers Finite State Machines (FSM), real-time user input measurement, shift-register decoding, and serial communication.
 
## 🎥 Hardware Demonstration
https://github.com/user-attachments/assets/25b3a4b6-9bd3-4f26-8a23-6d955d27c8ae
 
This demonstration showcases the dual-layer data path and real-time FSM timing thresholds. The test sequence includes:
1. **Letters `S` & `O`:** Demonstrates basic dot/dash timing calibration and the live terminal echo.
2. **Word `FPGA`:** Verifies continuous letter decoding, spacing, and memory accumulation.
3. **Sentence `HI TEST`:** Demonstrates the >2s "Word Space" threshold and proves the FSM can successfully buffer and transmit multiple words.
4. **Error Correction (`BACK`):** During the letter `K`, an intentional error is made (`-..` instead of `-.-`). The sequence highlights the hardware backspace switch shifting the buffer backwards, deleting the incorrect dot, and replacing it with a dash to lock in the right character.
## 🔄 Background & Architecture Redesign
This project rebuilds, in hardware, a final open-ended assignment from a previous microcontroller lab class.
 
For that original assignment, my team and I built a Morse Code interface based on distinct "click" and "hold" durations. While we successfully implemented the prototype using C++ and Assembly, the architecture was inherently limited. The software overhead, interrupt handling, and loop execution times made it incredibly difficult to accurately measure the precise timing of the user's manual inputs, leading to buggy decoding.
 
When looking for my first independent FPGA project, I rebuilt this system entirely in hardware using a Verilog Finite State Machine (FSM). By utilizing the 25MHz clock of the FPGA, the input measurement became **100% deterministic**, completely eliminating the lag of the original microcontroller version. Every clock cycle is exactly $40\text{ns}$, allowing for consistent real-time decoding.
 
## ⚙️ How It Works (System Architecture)
The system relies on a central FSM interacting with utility modules (Debouncers, UART TX) through a dual-layer data path.
 
### 1. Real-Time Input Measurement
* **Switch 1 (Morse Input):** The user taps or holds this button to input Morse code.
* **Deterministic Timing:** The FSM uses an internal counter to measure exact hold durations. Based on the 25MHz clock, it classifies inputs into four windows: **Dot** (Immediate), **Dash** (0.5s / 12,500,000 cycles), **Letter Space** (1.0s / 25,000,000 cycles), and **Word Space** (2.0s / 50,000,000 cycles).
* **Live LED Feedback:** As the user holds Switch 1, onboard LEDs dynamically illuminate as each threshold is crossed, providing real-time visual feedback before the user releases the key.
### 2. Shift-Register & Framing Bit Decoding
* As Dots (`0`) and Dashes (`1`) are registered, they are shifted into a 5-bit `letter_buffer`.
* **Framing Bit:** To handle variable-length Morse (e.g., 'E' is 1 bit, 'Q' is 4 bits), I implemented a **"Leading 1"** framing strategy. This allows the Combinational LUT (`Letter_Convert`) to identify where the sequence begins and decode the binary pattern into the correct ASCII hex value.
### 3. Memory & UART Transmission
* **Live Terminal Echo:** Upon every button release, the FSM immediately transmits a `.` or `-` to the UART, giving the user instant feedback on their PC terminal.
* **Batch Memory Buffer:** Simultaneously, decoded characters are stored in a 64-byte Synchronous RAM block (`sentence_memory`), supporting sentences up to 58 characters before automatic abort.
* **Switch 2 (Transmit):** Triggers a secondary state machine that uses **Read and Write pointers** to loop through the memory and sequentially push the stored sentence to a custom `UART_TX` module.
* **Switch 3 (Backspace):** Shifts the `letter_buffer` backwards, allowing the user to delete their last inputted dot/dash, transmitting an ASCII backspace (`0x08`) via UART.
## 🛠️ Tools & Hardware
* **Language:** Verilog
* **Target:** Lattice iCE40 (Nandland Go Board)
* **Synthesis:** Yosys, NextPNR, and IceStorm (Open-source CLI flow)
* **Baud Rate:** 115200 (217 clocks per bit @ 25MHz)
## 🚀 Lessons Learned
As my first independent FPGA project, this changed how I approach system design. It taught me how to manage concurrent hardware logic, handle custom memory buffers, and interface with standard communication protocols.
 
I specifically learned how to manage **Synchronous RAM constraints**; since you cannot write to two memory addresses in a single clock cycle, I implemented an intermediate FSM state to handle the sequential injection of Carriage Return (`0x0D`) and Line Feed (`0x0A`) characters into the data stream. It also showed me that timing-critical problems get a lot easier when you drop the software layer entirely and do the work in hardware.
 
