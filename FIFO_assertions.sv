
module FIFO_assertions (clk,data_in,rst_n, wr_en, rd_en,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow);

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input clk;
input [FIFO_WIDTH-1:0] data_in;
input  rst_n, wr_en, rd_en;
input [FIFO_WIDTH-1:0] data_out;
input wr_ack, overflow;
input full, empty, almostfull, almostempty, underflow;

always_comb begin : reset_check
	if(!rst_n)
	reset: assert final (DUT.count==0 && DUT.rd_ptr==0 && DUT.wr_ptr==0 && empty && !full && !almostfull && !almostempty);
	reset_cover:cover (DUT.count==0 && DUT.rd_ptr==0 && DUT.wr_ptr==0 && empty && !full && !almostfull && !almostempty);
end

always_comb begin : comb_checks
	if(rst_n) begin
		if(DUT.count==FIFO_DEPTH)begin
			full_check:assert(full==1'b1);
			full_cover:cover(full==1'b1);
		end
		if(DUT.count==inter.FIFO_DEPTH-1)begin
			almostfull_check:assert(almostfull==1'b1);
			almostfull_cover:cover(almostfull==1'b1);
		end
		if(DUT.count==0)begin
			empty_check:assert(empty==1'b1);
			empty_cover:cover(empty==1'b1);
		end
		if(DUT.count==1)begin
			almostempty_check:assert(almostempty==1'b1);
			almostempty_cover :cover(almostempty==1'b1);
		end
	end
end


property writing;
@(posedge clk) disable iff(!rst_n) (wr_en && !full) |=> (DUT.wr_ptr==$past(DUT.wr_ptr)+1'b1);
endproperty

writing_assert:assert property (writing);
writing_cover:cover property (writing);

property reading;
@(posedge clk) disable iff(!rst_n) (!wr_en && rd_en && !empty) |=> (DUT.rd_ptr==$past(DUT.rd_ptr)+1'b1);
endproperty

reading_assert:assert property (reading);
reading_cover:cover property (reading);

property WriteNotRead;
@(posedge clk) disable iff(!rst_n) (wr_en && rd_en && empty) |=> (DUT.wr_ptr==$past(DUT.wr_ptr)+1'b1);
endproperty

WriteNotRead_assert:assert property (WriteNotRead);
WriteNotRead_cover:cover property (WriteNotRead);

property ReadNotWrite;
@(posedge clk) disable iff(!rst_n) (wr_en && rd_en && full) |=> (DUT.rd_ptr==$past(DUT.rd_ptr)+1'b1);
endproperty

ReadNotWrite_assert:assert property (ReadNotWrite);
ReadNotWrite_cover:cover property (ReadNotWrite);

property accept_writing;
@(posedge clk) disable iff(!rst_n) (wr_en && !full) |=> (wr_ack);
endproperty

accept_writing_assert:assert property (accept_writing);
accept_writing_cover:cover property (accept_writing);

property refuse_writing;
@(posedge clk) disable iff(!rst_n) (wr_en && full) |=> (!wr_ack);
endproperty

refuse_writing_assert:assert property (refuse_writing);
refuse_writing_cover:cover property (refuse_writing);

property count_no_change;
@(posedge inter.clk) disable iff(!rst_n) (!wr_en && !rd_en) |=> ($stable(DUT.count));
endproperty

count_no_change_assert:assert property (count_no_change);
count_no_change_cover:cover property (count_no_change);

property count_up;
@(posedge inter.clk) disable iff(!inter.rst_n) ((wr_en && !rd_en && !full)||(wr_en && rd_en && empty)) 
|=> (DUT.count==$past(DUT.count)+1'b1);
endproperty

count_up_assert:assert property (count_up);
count_up_cover:cover property (count_up);

property count_down;
@(posedge clk) disable iff(!rst_n) ((!wr_en && rd_en && !empty)||(wr_en && rd_en && full)) 
|=> (DUT.count==$past(DUT.count)-1'b1);
endproperty

count_down_assert:assert property (count_down);
count_down_cover:cover property (count_down);

property count_above;
@(posedge clk) (DUT.count < 4'b1001) ;
endproperty

count_above_assert:assert property (count_above);
count_above_cover:cover property (count_above);

property over_flow;
@(posedge clk) disable iff(!rst_n) (wr_en && !rd_en && full) |=> (overflow);
endproperty

over_flow_assert:assert property (over_flow);
over_flow_cover:cover property (over_flow);

property under_flow;
@(posedge clk) disable iff(!rst_n) (!wr_en && rd_en && empty) |=> (underflow);
endproperty

under_flow_assert:assert property (under_flow);
under_flow_cover:cover property (under_flow);

endmodule