/******************************
* file   : bin2bcd.v
* date   : 2019-08-24
* author : lanjunjie250@outlook.com 
******************************/

module bin2bcd(
    rst_n,
    clk,
    start_en,
    busy_o,
    bin_i,
    bcd_o
);
//==========================
// define
//==========================
`define IDLE    0
`define WAIT    1
`define START   2
`define LOOPA   3
`define LOOPB   4
`define FINISH  5

//==========================
// input & output
//==========================
input           rst_n;
input           clk;
input           start_en;
output          busy_o;
input  [19:0]   bin_i;
output [23:0]   bcd_o;

//===========================
// register & signal
//===========================
reg [3:0] state;
reg [4:0] loop_cnt;
reg [23:0] bcd_buf;
reg [19:0] bin_i_lock;

//===========================
// logic 
//===========================
assign busy_o = (state == `WAIT) ? 1'b0 : 1'b1;
assign bcd_o = (state == `FINISH) ? bcd_buf: bcd_o;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= `IDLE;
        loop_cnt <= 'b0;
        bin_i_lock <= 'b0;
        bcd_buf <= 'b0;
    end else begin
        case (state)
            `IDLE  : begin
                state <= `WAIT;
                loop_cnt <= 'b0;
                bin_i_lock <= 'b0;
                bcd_buf <= 'b0;
            end
            `WAIT  : begin
                state <= start_en ? `START : `WAIT;
                // bin_i_lock <= bin_i;
            end
            `START : begin 
                state <= `LOOPA;
                bin_i_lock <= bin_i;
            end
            `LOOPA : begin
                state <= (loop_cnt < 5'd19) ? `LOOPB : `FINISH;
                loop_cnt <= loop_cnt + 1'b1;
                bin_i_lock <= {bin_i_lock[18:0],1'b0};
                bcd_buf <= {bcd_buf[22:0],bin_i_lock[19]};
            end
            `LOOPB : begin 
                state <= `LOOPA;
                bcd_buf[3:0]   <= add3(bcd_buf[3:0]);
                bcd_buf[7:4]   <= add3(bcd_buf[7:4]);
                bcd_buf[11:8]  <= add3(bcd_buf[11:8]);
                bcd_buf[15:12] <= add3(bcd_buf[15:12]);
                bcd_buf[19:16] <= add3(bcd_buf[19:16]);
                bcd_buf[23:20] <= add3(bcd_buf[23:20]);
            end
            `FINISH: state <= `IDLE;
            default: state <= `IDLE;
        endcase
    end
end

function [3:0] add3;
    input [3:0] in;
    begin
        if(in > 4'd4)
            add3 = in + 4'd3;
        else
            add3 = in;
    end
endfunction


endmodule //bin2bcd