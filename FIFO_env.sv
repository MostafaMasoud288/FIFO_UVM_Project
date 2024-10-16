package FIFO_env_pck;
import  FIFO_driver_pck::*;
import  FIFO_agent_pck::*;
import  FIFO_coverage_pck::*;
import  FIFO_scoreboard_pck::*;
import  FIFO_sequence_item_pck::*;
import  FIFO_sequencer_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_env extends uvm_env;
`uvm_component_utils(FIFO_env)
 FIFO_agent agt;
 FIFO_coverage cov;
 FIFO_scoreboard sb;
function new (string name = "FIFO_env",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);

 agt = FIFO_agent::type_id::create("agt",this);
  cov = FIFO_coverage::type_id::create("cov",this);
   sb = FIFO_scoreboard::type_id::create("sb",this);
endfunction

function void connect_phase (uvm_phase phase);
 agt.agt_ap.connect(sb.sb_export);
 agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage