package FIFO_coverage_pck;
import FIFO_sequence_item_pck::*;
import FIFO_config_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_coverage extends uvm_component;
 `uvm_component_utils(FIFO_coverage)
 uvm_analysis_export #(FIFO_sequence_item) cov_export;
 uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;
 FIFO_sequence_item seq_item_cov;

covergroup cvr_grp ;
wr_ack_cp:coverpoint seq_item_cov.wr_ack
{
    bins wr_ack_0={0};
    bins wr_ack_1={1};
}
overflow_cp:coverpoint seq_item_cov.overflow
{
    bins overflow_0={0};
    bins overflow_1={1};
}
underflow_cp:coverpoint seq_item_cov.underflow
{
    bins underflow_0={0};
    bins underflow_1={1};
}
full_cp:coverpoint seq_item_cov.full
{
    bins full_0={0};
    bins full_1={1};
}
almostfull_cp:coverpoint seq_item_cov.almostfull
{
    bins almostfull_0={0};
    bins almostfull_1={1};
}
empty_cp:coverpoint seq_item_cov.empty
{
    bins empty_0={0};
    bins empty_1={1};
}
almostempty_cp:coverpoint seq_item_cov.almostempty
{
    bins almostempty_0={0};
    bins almostempty_1={1};
}
wr_en_cp:coverpoint seq_item_cov.wr_en
{
    bins wr_en_0={0};
    bins wr_en_1={1};
}
rd_en_cp:coverpoint seq_item_cov.rd_en
{
    bins rd_en_0={0};
    bins rd_en_1={1};
}
wr_ack: cross wr_en_cp, rd_en_cp,wr_ack_cp
{
    illegal_bins wr_ack_illegal_1 = binsof (wr_en_cp.wr_en_0)&&binsof (rd_en_cp.rd_en_0) && binsof (wr_ack_cp.wr_ack_1);
    illegal_bins wr_ack_illegal_2 = binsof (wr_en_cp.wr_en_0)&&binsof (rd_en_cp.rd_en_1) && binsof (wr_ack_cp.wr_ack_1) ;

}
overflow: cross wr_en_cp, rd_en_cp,overflow_cp;
underflow: cross wr_en_cp, rd_en_cp,underflow_cp
{
    illegal_bins underflow_illegal_1 = binsof (wr_en_cp.wr_en_0)&&binsof (rd_en_cp.rd_en_0) && binsof (underflow_cp.underflow_1);
}
full: cross wr_en_cp, rd_en_cp,full_cp
{
    illegal_bins full_illegal_1 = binsof (wr_en_cp.wr_en_0)&&binsof (rd_en_cp.rd_en_1) && binsof (full_cp.full_1);
    illegal_bins full_illegal_2 = binsof (wr_en_cp.wr_en_1)&&binsof (rd_en_cp.rd_en_1) && binsof (full_cp.full_1) ;
    
}
empty: cross wr_en_cp, rd_en_cp,empty_cp;
almostfull: cross wr_en_cp, rd_en_cp,almostfull_cp;
almostempty: cross wr_en_cp, rd_en_cp,almostempty_cp;
endgroup

 function new (string name = "FIFO_coverage",uvm_component parent =null);
  super.new(name,parent);
  cvr_grp=new();
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 cov_export=new("cov_export",this);
 cov_fifo=new("cov_fifo",this);
endfunction

function void connect_phase (uvm_phase phase);
 super.connect_phase(phase);
 cov_export.connect(cov_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever begin
    cov_fifo.get(seq_item_cov);
    cvr_grp.sample();
 end
endtask

endclass 
endpackage