package FIFO_monitor_pck ;
import uvm_pkg::*;
import FIFO_sequence_item_pck::*;
`include "uvm_macros.svh"

class FIFO_monitor extends uvm_monitor;
`uvm_component_utils(FIFO_monitor)

 virtual FIFO_interface FIFO_vif;
FIFO_sequence_item rsp_seq_item;
uvm_analysis_port #(FIFO_sequence_item) mon_ap;

function new (string name = "FIFO_monitor",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
mon_ap =new("mon_ap",this);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
rsp_seq_item = FIFO_sequence_item::type_id::create("rsp_seq_item");
@(negedge FIFO_vif.clk);
rsp_seq_item.rst_n=FIFO_vif.rst_n;
rsp_seq_item.wr_en=FIFO_vif.wr_en;
rsp_seq_item.rd_en=FIFO_vif.rd_en;
rsp_seq_item.data_in=FIFO_vif.data_in;
rsp_seq_item.data_out=FIFO_vif.data_out;
rsp_seq_item.overflow=FIFO_vif.overflow;
rsp_seq_item.underflow=FIFO_vif.underflow;
rsp_seq_item.full=FIFO_vif.full;
rsp_seq_item.almostfull=FIFO_vif.almostfull;
rsp_seq_item.empty=FIFO_vif.empty;
rsp_seq_item.almostempty=FIFO_vif.almostempty;
rsp_seq_item.wr_ack=FIFO_vif.wr_ack;
mon_ap.write(rsp_seq_item);
`uvm_info("run_phase",rsp_seq_item.convert2string (),UVM_HIGH)
end
  
endtask

endclass
endpackage