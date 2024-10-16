package FIFO_scoreboard_pck;
import FIFO_sequence_item_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_component;
 `uvm_component_utils(FIFO_scoreboard)
 uvm_analysis_export #(FIFO_sequence_item) sb_export;
 uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;
 FIFO_sequence_item seq_item_sb;


int error_count=0;
int correct_count=0;
logic [15:0] data_out_ref;
logic [15:0] mem [$];

function new (string name = "FIFO_scoreboard",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 sb_export=new("sb_export",this);
 sb_fifo=new("sb_fifo",this);
endfunction

function void connect_phase (uvm_phase phase);
 super.connect_phase(phase);
 sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever begin
    sb_fifo.get(seq_item_sb);
    ref_model(seq_item_sb);
    if(seq_item_sb.data_out != data_out_ref) begin
        `uvm_error("run_phase",$sformatf("comparison failed,transaction received by the dut %s while the refeence output
         is 0h%0h",seq_item_sb.convert2string(), data_out_ref));
        error_count++; end
    else begin
        `uvm_info("run_phase",$sformatf("correct dataout %s ",seq_item_sb.convert2string()),UVM_HIGH);
        correct_count++;
    end
 end
endtask

task ref_model( FIFO_sequence_item seq_item_chk);
if(seq_item_chk.rst_n) begin
    if(seq_item_chk.wr_en &&!seq_item_chk.rd_en && !seq_item_chk.full) begin
        mem.push_front(seq_item_chk.data_in);
    end
    else if(!seq_item_chk.wr_en && seq_item_chk.rd_en && !seq_item_chk.empty) begin
        data_out_ref=mem.pop_back;
         
    end

    else if(seq_item_chk.wr_en && seq_item_chk.rd_en && !seq_item_chk.full && !seq_item_chk.empty) begin
         mem.push_front(seq_item_chk.data_in);
         data_out_ref=mem.pop_back;
        
          
    end
    else if (seq_item_chk.wr_en && seq_item_chk.rd_en && seq_item_chk.full) begin
         data_out_ref=mem.pop_back;
          
    end
     else if (seq_item_chk.wr_en && seq_item_chk.rd_en && seq_item_chk.empty) begin
            mem.push_front(seq_item_chk.data_in);
    end
end
else if(!seq_item_chk.rst_n) begin
    mem.delete;
end


endtask

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("run_phase",$sformatf("total successful transactions : %d",correct_count),UVM_MEDIUM);
`uvm_info("run_phase",$sformatf("total failed transactions : %d",error_count),UVM_MEDIUM);
endfunction


endclass
endpackage