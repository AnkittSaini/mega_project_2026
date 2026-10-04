`timescale 1ns/1ps

module tb_kogge_stone_adder_4bit;

    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    reg  [4:0] expected;
    integer    i, j, k;
    integer    errors;
    integer    total;

    // DUT
    kogge_stone_adder_4bit dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );

    // Waveform dump
    initial begin
        $dumpfile("kogge_stone_4bit.vcd");
        $dumpvars(0, tb_kogge_stone_adder_4bit);
    end

    initial begin
        errors = 0;
        total  = 0;

        $display("--------------------------------------------------");
        $display(" Time |  A   B  Cin | Cout Sum | Expected | Status");
        $display("--------------------------------------------------");

        // Exhaustive test
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    a   = i[3:0];
                    b   = j[3:0];
                    cin = k[0];
                    #10;

                    expected = a + b + cin;
                    total    = total + 1;

                    if ({cout, sum} !== expected) begin
                        errors = errors + 1;
                        $display("%5t | %2d  %2d   %b  |  %b   %2d  |   %2d     | FAIL",
                                 $time, a, b, cin, cout, sum, expected);
                    end
                    else if (total <= 16) begin
                        // print only first few passes to keep log short
                        $display("%5t | %2d  %2d   %b  |  %b   %2d  |   %2d     | PASS",
                                 $time, a, b, cin, cout, sum, expected);
                    end
                end
            end
        end

        $display("--------------------------------------------------");
        $display(" Total tests : %0d", total);
        $display(" Errors      : %0d", errors);
        if (errors == 0)
            $display(" RESULT      : ALL TESTS PASSED");
        else
            $display(" RESULT      : TESTS FAILED");
        $display("--------------------------------------------------");

        $finish;
    end

endmodule