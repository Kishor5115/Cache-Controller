module L2_Cache(clk,rst,address,Write_Data,Read_Enable,Write_Enable,Read_Data,L2_To_Mem_address,hit,miss);
input clk,rst,Read_Enable,Write_Enable;
input [31:0] Write_Data,address;
output reg [31:0] Read_Data,L2_To_Mem_address;
output reg hit,miss;

// L2_Cache paramters

parameter L2_Sets=64;
parameter L2_Ways=4;
parameter L2_Block_Size=4;
parameter L2_Tag_Size=22;
parameter L2_Index_Size=6;
parameter L2_Offset_Size=4;

// L2_cache memory

reg [L2_Tag_Size-1:0] L2_Tag_Array [L2_Sets-1:0][L2_Ways-1:0];
reg [31:0] L2_Data_Array [L2_Sets-1:0][L2_Ways-1:0][L2_Block_Size-1:0];
reg L2_Valid_Array [L2_Sets-1:0][L2_Ways-1:0];
reg [L2_Ways-1:0] L2_LRU [L2_Sets-1:0];

// fetching data from address

wire [L2_Index_Size-1:0] L2_Index = address[L2_Index_Size + L2_Offset_Size - 1 : L2_Offset_Size ] ;
wire [L2_Tag_Size-1:0] L2_tag = address[31 : 32-L2_Tag_Size] ;
wire [L2_Offset_Size-1:0] L2_Offset = address[L2_Offset_Size-1 : 0] ;

// L2_Cache operation 

integer i,j,k;

always @(posedge rst) 
    begin
        for(i=0;i<L2_Sets;i=i+1)
            begin
                for(j=0;j<L2_Ways;j=j+1)
                    begin
                        L2_Valid_Array[i][j]<=0;
                        for(k=0;k<L2_Block_Size;k=k+1)
                            begin
                                L2_Data_Array[i][j][k]<=0;
                            end
                    end
                    L2_LRU[i]<=0;
            end
            hit<=0;
            miss<=0;
    end

integer way_found=-1;

always @(posedge clk)
    begin
        hit<=0;
        miss<=0;
        
        if(Read_Enable || Write_Enable)
            begin
                for(j=0;j<L2_Ways;j=j+1)
                    begin
                        if(L2_Valid_Array[L2_Index][j] && L2_Tag_Array[L2_tag][j] == L2_tag )
                            way_found=j;
                    end

                if(way_found!=-1)
                    begin
                        hit<=1;
                        miss<=0;
                        if(Read_Enable)
                            Read_Data<=L2_Data_Array[L2_Index][way_found][L2_Offset];
                        if(Write_Enable)
                            L2_Data_Array[L2_Index][way_found][L2_Offset]<=Write_Data;
                        L2_LRU[L2_Index]<= (way_found+1) % L2_Ways ;
                    end    
                else
                    begin
                        hit<=0;
                        miss<=1;
                        L2_To_Mem_address<=address;

                    end     
            end
    end

endmodule