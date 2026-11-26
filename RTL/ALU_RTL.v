module ALU_RTL#(
  parameter WIDTH=8)
  (
  input [WIDTH-1:0]A,
  input [WIDTH-1:0]B,
  input [2:0]sel,
  output reg [WIDTH-1:0]Y,
  output reg carry,zero,overflow
);
  reg [WIDTH:0]temp;
  always@(*)begin
    Y={WIDTH{1'b0}};
    zero=1'b0;
    carry=1'b0;
    overflow=1'b0;
    temp={(WIDTH+1){1'b0}};
    
    case(sel)
    //ADDITION
      3'b000:begin
        temp={1'b0,A}+{1'b0,B};
        Y=temp[WIDTH-1:0];
        carry=temp[WIDTH];
        overflow=(~(A[WIDTH-1]^B[WIDTH-1]))&(Y[WIDTH-1]^A[WIDTH-1]);
      end
    //SUBTRACTION
      3'b001:begin
        temp={1'b0,A}-{1'b0,B};
        Y=temp[WIDTH-1:0];
      carry=(A>=B);
        overflow=(A[WIDTH-1]^B[WIDTH-1])&(Y[WIDTH-1]^A[WIDTH-1]);
      end
    //DIVISION
      3'b010:begin
        if(B!=0)
          Y=A/B;
        else
        Y={WIDTH{1'b0}};
      end
    //LOGICAL  
      3'b011:Y=A&B;
      3'b100:Y=A|B;
      3'b101:Y=A^B;
   //SHIFTING   
      3'b110:Y=A<<1;
      3'b111:Y=A>>1;
     default:
       Y={WIDTH{1'b0}};
    endcase
   zero = (Y == {WIDTH{1'b0}});
   end
endmodule 
  
    
