`timescale 1ns/1ps

module RTL_TB();

    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] sel;

    wire [7:0] Y;
    wire carry, zero, overflow;

    integer pass_count;
    integer fail_count;

    // ALU instantiation
    ALU_RTL #(.WIDTH(8)) dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );

    // Test task
    task check;
        input [7:0] A_test;
        input [7:0] B_test;
        input [2:0] sel_test;
        input [7:0] Y_test;
        input test_carry;
        input test_zero;
        input test_overflow;

        begin
            A = A_test;
            B = B_test;
            sel = sel_test;

            #10;

            if ((Y === Y_test) &&
                (carry === test_carry) &&
                (zero === test_zero) &&
                (overflow === test_overflow)) begin

                $display("PASS: A=%d B=%d Sel=%b Y=%d",
                         A, B, sel, Y);

                pass_count = pass_count + 1;
            end
            else begin

                $display("FAIL: A=%d B=%d Sel=%b",
                         A, B, sel);

                $display("Expected Y=%d C=%b Z=%b V=%b",
                         Y_test,
                         test_carry,
                         test_zero,
                         test_overflow);

                $display("Actual   Y=%d C=%b Z=%b V=%b",
                         Y, carry, zero, overflow);

                fail_count = fail_count + 1;
            end
        end
    endtask

    // Test cases
    initial begin

        pass_count = 0;
        fail_count = 0;

        $dumpfile("alu_wave.vcd");
        $dumpvars(0, RTL_TB);

        // ADDITION
        check(8'd10, 8'd5, 3'b000,
              8'd15, 0, 0, 0);

        // ADDITION WITH CARRY
        check(8'd255, 8'd1, 3'b000,
              8'd0, 1, 1, 0);

        // ADDITION WITH SIGNED OVERFLOW
        check(8'd127, 8'd1, 3'b000,
              8'd128, 0, 0, 1);

        // SUBTRACTION
        check(8'd10, 8'd5, 3'b001,
              8'd5, 1, 0, 0);

        // SUBTRACTION RESULT ZERO
        check(8'd5, 8'd5, 3'b001,
              8'd0, 1, 1, 0);

        // SUBTRACTION WITH BORROW
        check(8'd3, 8'd5, 3'b001,
              8'd254, 0, 0, 0);

        // DIVISION
        check(8'd10, 8'd2, 3'b010,
              8'd5, 0, 0, 0);

        // DIVISION BY ZERO
        check(8'd10, 8'd0, 3'b010,
              8'd0, 0, 1, 0);

        // AND
        check(8'd12, 8'd10, 3'b011,
              8'd8, 0, 0, 0);

        // OR
        check(8'd12, 8'd10, 3'b100,
              8'd14, 0, 0, 0);

        // XOR
        check(8'd12, 8'd10, 3'b101,
              8'd6, 0, 0, 0);

        // LEFT SHIFT
        check(8'd5, 8'd0, 3'b110,
              8'd10, 0, 0, 0);

        // RIGHT SHIFT
        check(8'd10, 8'd0, 3'b111,
              8'd5, 0, 0, 0);

        // SIGNED OVERFLOW IN SUBTRACTION
        check(8'd128, 8'd1, 3'b001,
              8'd127, 1, 0, 1);

        // Final results
        
        $display("TOTAL PASS = %d", pass_count);
        $display("TOTAL FAIL = %d", fail_count);
       

        $finish;

    end

endmodule

