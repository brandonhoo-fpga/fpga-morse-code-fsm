// ============================================================================
// File Name   : Letter_Convert.v   
// Author      : Brandon Hoo
// Description : Combinational Look-Up Table (LUT) to convert custon 5-bit
//               Morse Code symbols into standard 8-bit ASCII Hex characters
//
//               Note: The 5-bit buffer uses a leading "1" (framing bit) to
//               dictate where the valid Morse sequence begins.
// ============================================================================

module Letter_Convert (
    input [4:0]letter_buffer, // 5-bit encoded Morse symbol
    output reg [7:0]ascii_hex // 8-bit ASCII character code output
);

// Maps each 5-bit Morse Code pattern to its ASCII equivalent
// Unrecognized patterns default to '?'
always @(*)
    case(letter_buffer)
        5'b00101: ascii_hex = 8'h41; // 'A'
        5'b11000: ascii_hex = 8'h42; // 'B' 
        5'b11010: ascii_hex = 8'h43; // 'C'
        5'b01100: ascii_hex = 8'h44; // 'D'
        5'b00010: ascii_hex = 8'h45; // 'E'
        5'b10010: ascii_hex = 8'h46; // 'F'
        5'b01110: ascii_hex = 8'h47; // 'G'
        5'b10000: ascii_hex = 8'h48; // 'H'
        5'b00100: ascii_hex = 8'h49; // 'I'
        5'b10111: ascii_hex = 8'h4A; // 'J'
        5'b01101: ascii_hex = 8'h4B; // 'K'
        5'b10100: ascii_hex = 8'h4C; // 'L'
        5'b00111: ascii_hex = 8'h4D; // 'M'
        5'b00110: ascii_hex = 8'h4E; // 'N'
        5'b01111: ascii_hex = 8'h4F; // 'O'
        5'b10110: ascii_hex = 8'h50; // 'P'
        5'b11101: ascii_hex = 8'h51; // 'Q'
        5'b01010: ascii_hex = 8'h52; // 'R'
        5'b01000: ascii_hex = 8'h53; // 'S'
        5'b00011: ascii_hex = 8'h54; // 'T'
        5'b01001: ascii_hex = 8'h55; // 'U'
        5'b10001: ascii_hex = 8'h56; // 'V'
        5'b01011: ascii_hex = 8'h57; // 'W'
        5'b11001: ascii_hex = 8'h58; // 'X'
        5'b11011: ascii_hex = 8'h59; // 'Y'
        5'b11100: ascii_hex = 8'h5A; // 'Z'

        default: ascii_hex = 8'h3F;  // '?'
    endcase

endmodule