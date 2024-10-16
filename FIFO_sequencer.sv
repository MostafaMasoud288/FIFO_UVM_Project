package FIFO_sequencer_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_sequence_item_pck::*;
class FIFO_sequencer extends uvm_sequencer#(FIFO_sequence_item);
 `uvm_component_utils(FIFO_sequencer)

function new (string name = "FIFO_sequencer",uvm_component parent =null);
  super.new(name,parent);
endfunction

endclass
endpackage
