package FIFO_sequence_item_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_sequence_item extends uvm_sequence_item;
 `uvm_object_utils(FIFO_sequence_item)
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
bit clk;
rand logic [FIFO_WIDTH-1:0] data_in;
rand bit  rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;


 function new (string name = "FIFO_sequence_item");
  super.new(name);
 endfunction
  
function string convert2string ();
  return $sformatf("%s reset =0b%0b ,datain =0h%0h,wr_en =0b%0b,rd_en =0b%0b ,dataout =0h%0h,wr_ack =0b%0b,overflow =0b%0b,
  underflow =0b%0b ,full =0b%0b,empty =0b%0b,almostfull =0b%0b,almostempty =0b%0b",
  super.convert2string(),rst_n,data_in,wr_en,rd_en,data_out,wr_ack,overflow,underflow,full,empty,almostfull,almostempty);
endfunction

function string convert2string_stimulus ();
  return $sformatf(" reset =0b%0b ,datain =0h%0h,wr_en =0b%0b,rd_en =0b%0b",rst_n,data_in,wr_en,rd_en);
endfunction

constraint c1{rst_n dist{0:/5,1:/95};}
constraint c2{wr_en dist{0:/30 ,1:/70 };}
constraint c3{rd_en dist{0:/70,1:/30};}

endclass
endpackage