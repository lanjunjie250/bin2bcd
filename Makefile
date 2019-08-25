#########################################
# file : Makefile
# date : 2018-08-25
# author : lanjunjie250@outlook.com
# description : Used for iverilog
#########################################


all: rtl vvp gtk

rtl:
	iverilog tb/bin2bcd_tb.v -o output/bin2bcd_tb.vvp

vvp:
	vvp output/bin2bcd_tb.vvp

gtk:
	gtkwave output/bin2bcd_tb.vcd

clean:
	@rm -rf output/* 
