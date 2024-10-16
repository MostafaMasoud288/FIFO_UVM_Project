package FIFO_reset_sequence_pck;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pck::*;
class FIFO_reset_sequence extends uvm_sequence #(FIFO_sequence_item);
 `uvm_object_utils(FIFO_reset_sequence)
FIFO_sequence_item seq_item;

function new (string name = "FIFO_reset_sequence");
  super.new(name);
endfunction

task body;
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n=1'b0;
finish_item(seq_item);
endtask

endclass
endpackage