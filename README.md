# DLD-Project-2024
Milan Technical University's Digital Logic Design project.

This project aims to implement a hardware module written in VHDL that interfaces with a memory and complies with the provided specifications. The system processes a sequence of K words (W) with values between 0 and 255:
- Values of 0 are considered as "unspecified values."
- The sequence is read starting from a specified memory address and is completed as follows:
- Missing values are replaced with the last valid non-zero value.
- A credibility value (C) is associated and decreases over time.
---

Module Operation
| signal     | meaning                                        |
|------------|------------------------------------------------|
| i_clk      | Inputs clock signal                            |
| i_rst      | Inputs asynchronous reset signal               |
| i_start    | Inputs to start the process                    |
| i_k        | Length of the sequence to process (10 bits)    |
| i_add      | Initial address of the sequence (16 bits)      |
| o_done     | Output signal indicating the end of processing |
| o_mem_addr | Output signal to the memory address            |
| i_mem_data | Input data read from memory                    |
| o_mem_data | Output data processed to memory                |
| o_mem_en   | Enable signal for the memory                   |
| o_mem_we   | Write enable signal for the memory             |


