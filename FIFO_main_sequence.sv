package FIFO_main_sequence_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pck::*;
class FIFO_write_read extends uvm_sequence #(FIFO_sequence_item);
 `uvm_object_utils(FIFO_write_read)
FIFO_sequence_item seq_item;

function new (string name = "FIFO_write_read");
  super.new(name);
endfunction

task body;
repeat(5000) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
 assert(seq_item.randomize());
finish_item(seq_item); end
endtask
endclass

class FIFO_write_only extends uvm_sequence #(FIFO_sequence_item);
 `uvm_object_utils(FIFO_write_only)
FIFO_sequence_item seq_item;

function new (string name = "FIFO_write_only");
  super.new(name);
endfunction

task body;
repeat(500) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.wr_en=1;
seq_item.rd_en=0;
seq_item.wr_en.rand_mode(0);
seq_item.rd_en.rand_mode(0);
 assert(seq_item.randomize());
finish_item(seq_item); end
endtask
endclass

class FIFO_read_only extends uvm_sequence #(FIFO_sequence_item);
 `uvm_object_utils(FIFO_read_only)
FIFO_sequence_item seq_item;

function new (string name = "FIFO_read_only");
  super.new(name);
endfunction

task body;
repeat(500) begin
seq_item = FIFO_sequence_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.wr_en=0;
seq_item.rd_en=1;
seq_item.wr_en.rand_mode(0);
seq_item.rd_en.rand_mode(0);
 assert(seq_item.randomize());
finish_item(seq_item); end
endtask
endclass
endpackage