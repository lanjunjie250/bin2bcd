/********************************
* file : bin2bcd_tb.v
* date : 2018-08-25
* auther : lanjunjie250@outlook.com
* describe : 
********************************/
`timescale 1ns / 1ps

module bin2bcd_tb ();

reg clk; 

always #5 clk = ~clk;

initial 
begin
    clk = 0;
    $display("simulate begin");
    $dumpfile("output/bin2bcd_tb.vcd");
    $dumpvars();
    repeat (100) @(posedge clk);
    $display("simulate end");
    $finish;
end

endmodule //bin2bcd_tb
