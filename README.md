NAME
5 stage pipelined processor written in Verilog

DESCRIPTION
  •	  32-bit processor implemented in Verilog
  •	  5 stage pipeline (Fetch, Decode, Execute, Memory access, Write back)
  •	  branch detection in decode (stage 2) and start running from branch address
  •	  supports stalls to avoid read after write (RAW) and other hazards
  •	  can forward data from memory (stage 4) and write back (stage 5) to avoid stalls

Major part of the processor design was inspired by the book “Computer Organization and Design” by David A. Patterson and John L. Hennessy.

Running Test Files  
This project uses 2 memories which can be edited from the txt file. (Data memory and Instruction memory) One can change the content of memory depending upon the different inputs. 
There are two programme attached. One for Fibonacci series and other is for division program. In order to run these codes, you need to copy the binary codes to the instruction memory. Assembly codes for these programmes are for reference in order to change the inputs.

REQUIREMENTS
This project requires a Verilog simulator such as Xilinx ISE, ModelSim. 

AUTHOR
Harsh Thakkar
harshthakkar456@gmail.com
http://github.com/harshthakkar01
