////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
module FIFO(FIFO_interface.dut inter);
 
localparam max_fifo_addr = $clog2(inter.FIFO_DEPTH);

reg [inter.FIFO_WIDTH-1:0] mem [inter.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr=0, rd_ptr=0;
reg [max_fifo_addr:0] count=0;//

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		wr_ptr <= 0;
		inter.wr_ack <= 0;//
	end
	else if (inter.wr_en &&  count < inter.FIFO_DEPTH) begin//
		mem[wr_ptr] <= inter.data_in;
		inter.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		inter.wr_ack <= 0; 
		if (inter.full && inter.wr_en && !inter.rd_en)
			inter.overflow <= 1;
		else
			inter.overflow <= 0;
	end
end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		rd_ptr <= 0;
	end
	else if (inter.rd_en  &&count != 0) begin
		inter.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin  
		if (inter.empty && inter.rd_en && !inter.wr_en)
			inter.underflow <= 1;
		else
			inter.underflow <= 0;
	end
end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({inter.wr_en, inter.rd_en} == 2'b10) && !inter.full) 
			count <= count + 1;
		else if ( ({inter.wr_en, inter.rd_en} == 2'b01) && !inter.empty)
			count <= count - 1;
		else if ( ({inter.wr_en, inter.rd_en} == 2'b11) && inter.full)
			count <= count - 1;
		else if ( ({inter.wr_en, inter.rd_en} == 2'b11) && inter.empty)
			count <= count + 1;
	end
end

assign inter.full = (count == inter.FIFO_DEPTH)? 1 : 0;
assign inter.empty = (count == 0)? 1 : 0;
assign inter.almostfull = (count == inter.FIFO_DEPTH-1)? 1 : 0; 
assign inter.almostempty = (count == 1)? 1 : 0;


`ifdef SIM
always_comb begin : reset_check
	if(!inter.rst_n)
	reset: assert final (count==0 && rd_ptr==0 && wr_ptr==0 && inter.empty && !inter.full && !inter.almostfull && !inter.almostempty);
	reset_cover:cover (count==0 && rd_ptr==0 && wr_ptr==0 && inter.empty && !inter.full && !inter.almostfull && !inter.almostempty);
end

always_comb begin : comb_checks
	if(inter.rst_n) begin
		if(count==inter.FIFO_DEPTH)begin
			full_check:assert(inter.full==1'b1);
			full_cover:cover(inter.full==1'b1);
		end
		if(count==inter.FIFO_DEPTH-1)begin
			almostfull_check:assert(inter.almostfull==1'b1);
			almostfull_cover:cover(inter.almostfull==1'b1);
		end
		if(count==0)begin
			empty_check:assert(inter.empty==1'b1);
			empty_cover:cover(inter.empty==1'b1);
		end
		if(count==1)begin
			almostempty_check:assert(inter.almostempty==1'b1);
			almostempty_cover :cover(inter.almostempty==1'b1);
		end
	end
end


property writing;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && !inter.full) |=> (wr_ptr==$past(wr_ptr)+1'b1);
endproperty

writing_assert:assert property (writing);
writing_cover:cover property (writing);

property reading;
@(posedge inter.clk) disable iff(!inter.rst_n) (!inter.wr_en && inter.rd_en && !inter.empty) |=> (rd_ptr==$past(rd_ptr)+1'b1);
endproperty

reading_assert:assert property (reading);
reading_cover:cover property (reading);

property WriteNotRead;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && inter.rd_en && inter.empty) |=> (wr_ptr==$past(wr_ptr)+1'b1);
endproperty

WriteNotRead_assert:assert property (WriteNotRead);
WriteNotRead_cover:cover property (WriteNotRead);

property ReadNotWrite;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && inter.rd_en && inter.full) |=> (rd_ptr==$past(rd_ptr)+1'b1);
endproperty

ReadNotWrite_assert:assert property (ReadNotWrite);
ReadNotWrite_cover:cover property (ReadNotWrite);

property accept_writing;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && !inter.full) |=> (inter.wr_ack);
endproperty

accept_writing_assert:assert property (accept_writing);
accept_writing_cover:cover property (accept_writing);

property refuse_writing;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && inter.full) |=> (!inter.wr_ack);
endproperty

refuse_writing_assert:assert property (refuse_writing);
refuse_writing_cover:cover property (refuse_writing);

property count_no_change;
@(posedge inter.clk) disable iff(!inter.rst_n) (!inter.wr_en && !inter.rd_en) |=> ($stable(count));
endproperty

count_no_change_assert:assert property (count_no_change);
count_no_change_cover:cover property (count_no_change);

property count_up;
@(posedge inter.clk) disable iff(!inter.rst_n) ((inter.wr_en && !inter.rd_en && !inter.full)||(inter.wr_en && inter.rd_en && inter.empty)) 
|=> (count==$past(count)+1'b1);
endproperty

count_up_assert:assert property (count_up);
count_up_cover:cover property (count_up);

property count_down;
@(posedge inter.clk) disable iff(!inter.rst_n) ((!inter.wr_en && inter.rd_en && !inter.empty)||(inter.wr_en && inter.rd_en && inter.full)) 
|=> (count==$past(count)-1'b1);
endproperty

count_down_assert:assert property (count_down);
count_down_cover:cover property (count_down);

property count_above;
@(posedge inter.clk) (count < 4'b1001) ;
endproperty

count_above_assert:assert property (count_above);
count_above_cover:cover property (count_above);

property over_flow;
@(posedge inter.clk) disable iff(!inter.rst_n) (inter.wr_en && !inter.rd_en && inter.full) |=> (inter.overflow);
endproperty

over_flow_assert:assert property (over_flow);
over_flow_cover:cover property (over_flow);

property under_flow;
@(posedge inter.clk) disable iff(!inter.rst_n) (!inter.wr_en && inter.rd_en && inter.empty) |=> (inter.underflow);
endproperty

under_flow_assert:assert property (under_flow);
under_flow_cover:cover property (under_flow);

`endif 

endmodule