package FIFO_test_pck;
import FIFO_env_pck::*;
import FIFO_config_pck::*;
import FIFO_main_sequence_pck::*;
import FIFO_reset_sequence_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;

`uvm_component_utils(FIFO_test);
 virtual FIFO_interface FIFO_vif;
FIFO_config FIFO_cfg;
FIFO_reset_sequence reset_seq;
FIFO_write_read write_read; 
FIFO_write_only write_only;
FIFO_read_only read_only;
FIFO_env env;
function new (string name = "FIFO_test",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 env=FIFO_env::type_id::create("env",this);
 FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);
 reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this);
 write_read = FIFO_write_read::type_id::create("write_read",this);
 write_only = FIFO_write_only::type_id::create("write_only",this);
 read_only = FIFO_read_only::type_id::create("read_only",this);

  if(!uvm_config_db #(virtual FIFO_interface)::get(this,"","FIFO_If",FIFO_cfg.FIFO_vif)) begin
   `uvm_fatal("bulid_phase","Test - Unable to get the virtual interface of the shift_reg from the uvm_config_db") ;end

 uvm_config_db #(FIFO_config)::set(this,"*","CFG",FIFO_cfg);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 `uvm_info("run_phase","reset asserted",UVM_MEDIUM);
  reset_seq.start(env.agt.sqr);
 `uvm_info("run_phase","reset deasserted",UVM_MEDIUM);
`uvm_info("run_phase","stimulas generation for write and read started",UVM_MEDIUM);
  write_read.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation for write and read ended",UVM_MEDIUM);
 `uvm_info("run_phase","stimulas generation for write only started",UVM_MEDIUM);
  write_only.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation for write only ended",UVM_MEDIUM);
 `uvm_info("run_phase","stimulas generation for read only started",UVM_MEDIUM);
  read_only.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation for read only endedd",UVM_MEDIUM);
 phase.drop_objection(this);
endtask

endclass
endpackage 