
module calculator(
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,

    output reg [7:0] result,
    output reg carry,
    output reg zero,
    output reg overflow
);

    reg [8:0] temp;

    always @(*) begin

        result   = 8'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = 9'b0;

        case(opcode)

            3'b000: begin
                temp = {1'b0, A} + {1'b0, B};
                result = temp[7:0];
                carry = temp[8];
                overflow = (~(A[7] ^ B[7])) &
                          (A[7] ^ result[7]);
            end

            3'b001: begin
                temp = {1'b0, A} - {1'b0, B};
                result = temp[7:0];
                overflow = (A[7] ^ B[7]) &
                           (A[7] ^ result[7]);
            end

            3'b010: result = A & B;

            3'b011: result = A | B;

            3'b100: result = A ^ B;

            3'b101: result = ~A;

            3'b110: result = A << 1;

            3'b111: result = A >> 1;

            default: result = 8'b0;

        endcase

        zero = (result == 8'b0);

    end

endmodule
