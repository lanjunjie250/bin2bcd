/********************************
* file : bin2bcd_tb.v
* date : 2018-08-25
* auther : lanjunjie250@outlook.com
* describe : 
********************************/
`timescale 1ns / 1ps

module bin2bcd_tb ();

integer i;
integer seed = 123456;
reg clk;
reg rst_n; 
reg [19:0] bin;
wire [23:0] bcd;
wire busy;

always #5 clk = ~clk;

initial 
begin
    clk = 0;
    rst_n = 0;
    bin = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;
    repeat (30) @(posedge clk);
    $display("====simulate begin====");
    for(i = 0;i<500;i++) begin
        repeat (1) @(posedge clk);
        if(busy == 0) begin
            // $display("=============");
            $display("bin = %d",bin);
            $display("bcd = %x",bcd);
            $display("===========================");
            repeat (1) @(posedge clk);
            // bin = $urandom(65536);
            bin = $random(seed);
        end
    end
    // $dumpfile("output/bin2bcd_tb.vcd");
    // $dumpvars();
    // repeat (100) @(posedge clk);
    $display("====simulate end====");
    $finish;
end

bin2bcd bin2bcd_inst(
    .rst_n      (rst_n),
    .clk        (clk),
    .start_en   (~busy),
    .busy_o     (busy),
    .bin_i      (bin),
    .bcd_o      (bcd)
);

endmodule //bin2bcd_tb
