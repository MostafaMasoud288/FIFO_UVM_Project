import uvm_pkg::*;
`include "uvm_macros.svh"

interface FIFO_interface(clk) ;
////ports////
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input clk;
logic [FIFO_WIDTH-1:0] data_in;
bit  rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;

////directions////
modport dut (input clk,data_in,rst_n, wr_en, rd_en,
              output data_out, overflow,wr_ack,full, empty, almostfull, almostempty, underflow);
modport monitor (input clk,data_in,rst_n, wr_en, rd_en,
              data_out, overflow,wr_ack,full, empty, almostfull, almostempty, underflow);
endinterface