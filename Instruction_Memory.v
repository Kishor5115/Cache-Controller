module  instr_Mem(A,rst,RD);
input [31:0] A;
input rst;
output  [31:0] RD;
 
reg [31:0]  Mem [0:1023];    //  Creating memory to store instructions

assign RD   =   (rst==1'b0) ?   32'h00000000    :   Mem[A[31:2]];    //  read data

integer i;

initial 
    begin
    for(i=0;i<1024;i=i+1)
        Mem[i]=i;
    end



endmodule