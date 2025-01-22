`include "Instruction_Memory.v"
`include "L1_Cache.v"
`include "L2_Cache.v"

module Cache_Controller(clk,rst,address,Write_Data,Read_Enable,Write_Enable,Read_Data,hit,miss);

input clk,rst,Read_Enable,Write_Enable;
input [31:0] address,Write_Data;
output hit,miss;
output [31:0] Read_Data;

wire [31:0] L2_To_Mem_address,L1_To_L2_address;

L1_Cache L1_Cache
    (
        .clk(clk),
        .rst(rst),
        .address(address),
        .Write_Data(Write_Data),
        .Read_Enable(Read_Enable),
        .Write_Enable(Write_Enable),
        .Read_Data(Read_Data),
        .hit(hit),
        .miss(miss),
        .L1_To_L2_address(L1_To_L2_address)
    );

L2_Cache L2_Cache
    (
       .clk(clk),
        .rst(rst),
        .address(L1_To_L2_address),
        .Write_Data(Write_Data),
        .Read_Enable(Read_Enable),
        .Write_Enable(Write_Enable),
        .Read_Data(Read_Data),
        .hit(hit),
        .miss(miss),
        .L2_To_Mem_address(L2_To_Mem_address) 
    );

instr_Mem Main_Memory
    (
        .A(L2_To_Mem_address),
        .RD(Read_Data)
    );

endmodule