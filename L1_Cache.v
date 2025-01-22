
module L1_Cache(clk,rst,address,Write_Data,Read_Enable,Write_Enable,Read_Data,hit,miss,L1_To_L2_address);
input clk,rst,Read_Enable,Write_Enable;
input [31:0] Write_Data,address;
output reg [31:0] Read_Data,L1_To_L2_address;
output reg hit,miss;

// L1_Cache parameters

parameter L1_Cache_Size=256; // no. of cache lines
parameter L1_Block_Size=4;
parameter L1_Index_Size=8;
parameter L1_Tag_Size=20;
parameter L1_Offset_Size=4;

// L1_Cache memory 

reg [31:0] L1_Data_Array [L1_Cache_Size-1:0][L1_Block_Size-1:0] ;  //Data array
reg [L1_Tag_Size-1:0] L1_Tag_Array [L1_Cache_Size-1:0] ; // Tag array
reg L1_Valid_Array [L1_Cache_Size-1:0]; // valid bit array 

// fetching data from address 

wire [L1_Index_Size-1:0] L1_index = address[L1_Index_Size + L1_Offset_Size - 1 :L1_Offset_Size] ;
wire [L1_Tag_Size-1:0] L1_tag= address[31 : 31 - L1_Tag_Size + 1] ;
wire [L1_Offset_Size-1:0] L1_offset =address[L1_Offset_Size - 1 : 0] ;

// L1_Cache operation 
integer i,j;
always @(posedge rst)
        begin  
            for(i=0;i<L1_Cache_Size;i=i+1) 
                begin
                    L1_Valid_Array[i]<=0;
                    L1_Tag_Array[i]<=0;
                    for(j=0;j<L1_Block_Size;j=j+1)
                    begin
                        L1_Data_Array[i][j]<=0;
                    end
                end     
        end 

always @(posedge clk)
begin
    if(Read_Enable || Write_Enable)
        begin
            if(L1_Valid_Array[L1_index] && L1_Tag_Array[L1_tag] == L1_tag)
                begin
                    hit<=1;
                    miss<=0;
                    if(Read_Enable)
                        Read_Data<=L1_Data_Array[L1_index][L1_offset];
                    if(Write_Enable)
                        L1_Data_Array[L1_index][L1_offset]<=Write_Data;
                end 
            else
                begin
                    hit<=0;
                    miss<=1;
                    L1_To_L2_address<=address;
                end
        end 
end


endmodule