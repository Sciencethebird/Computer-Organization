//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:    0511105   
//----------------------------------------------
//Date:     2019/05/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Hazard_Detection_Unit(
    IFID_RsRt, //10
    IDEX_Rt, //5
    M, //3
    PCSrc,///???1
    
    IDFlush, //
    EXFlush, //
    IFFlush, //
    PCWrite, //
    IFIDWrite
);
               
//I/O ports
input   [10-1:0] IFID_RsRt;
input   [5-1:0]   IDEX_Rt;
input   [3-1:0]   M;
input   PCSrc;

output reg IDFlush;
output reg EXFlush;
output reg IFFlush;
output reg PCWrite;
output reg IFIDWrite;

always@(IFID_RsRt, IDEX_Rt, M, PCSrc) begin
//$display("lala%b\n%b\n%b\n%b\n",IFID_RsRt, IDEX_Rt, M, PCSrc);
    if(PCSrc)begin
            IDFlush <= 1;
            EXFlush <= 1;
            IFFlush <= 1;
            PCWrite <= 1; // 1 is no stall
            IFIDWrite <=1;
    end

    else  if((IFID_RsRt[9:5] == IDEX_Rt || IFID_RsRt[4:0] == IDEX_Rt) &&  IDEX_Rt != 0 && M[1]) begin
           //$display("flush   lala%b\n%b\n%b\n%b\n",IFID_RsRt, IDEX_Rt, M, PCSrc);
           //$display("flush");
            IDFlush <= 0;
            EXFlush <= 0;
            IFFlush <= 0;
            PCWrite <= 0;
            IFIDWrite <=0;
        end
    else begin
           //$display("no flush");
            IDFlush <= 0;
            EXFlush <= 0;
            IFFlush <= 0;
            PCWrite <= 1;
            IFIDWrite <=1;
            //$display("IDEXIFPC ,%b, %b, %b, %b", IDFlush, EXFlush, IFFlush, PCWrite );
       end

end     
endmodule      
     