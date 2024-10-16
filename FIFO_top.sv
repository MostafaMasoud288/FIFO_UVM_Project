
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pck::*;

module FIFO_top();
bit clk;

initial begin
    clk=1'b1;
forever begin
#5 clk=~clk;
end
end

FIFO_interface FIFO_if (clk);
FIFO DUT (FIFO_if);
bind FIFO FIFO_assertions #(FIFO_if.FIFO_WIDTH,FIFO_if.FIFO_DEPTH) INIT(FIFO_if.clk,FIFO_if.data_in,FIFO_if.rst_n,
 FIFO_if.wr_en, FIFO_if.rd_en,FIFO_if.data_out,FIFO_if.wr_ack,FIFO_if.overflow,FIFO_if.full, FIFO_if.empty, 
 FIFO_if.almostfull, FIFO_if.almostempty, FIFO_if.underflow);

initial begin
uvm_config_db #(virtual FIFO_interface)::set(null,"uvm_test_top","FIFO_If",FIFO_if);
run_test("FIFO_test");
end
endmodule