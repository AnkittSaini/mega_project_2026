`timescale 1ns/1ps

module tb;

    reg  [3:0] a;
    reg  [3:0] b;
    reg        cin;

    wire [3:0] sum;
    wire       cout;

    reg [4:0] expected;
    integer i;
    integer errors;

    // DUT: Device Under Test
    CLA_4bit_gate_level uut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    initial begin

        // Create waveform file
        $dumpfile("CLA_4bit_gate_level.vcd");
        $dumpvars(0, tb);

        errors = 0;

        // Test all 4-bit input combinations
        for (i = 0; i < 512; i = i + 1) begin

            {a, b, cin} = i;

            #10;

            // Expected 5-bit result
            expected = {1'b0, a}
                     + {1'b0, b}
                     + {4'b0000, cin};

            // Compare actual and expected result
            if ({cout, sum} !== expected) begin

                errors = errors + 1;

                $display(
                    "ERROR: a=%b b=%b cin=%b | Expected=%b | Got=%b",
                    a, b, cin, expected, {cout, sum}
                );

            end

        end

        if (errors == 0)
            $display("ALL 512 TEST CASES PASSED");
        else
            $display("TEST FAILED: %0d errors found", errors);

        $finish;

    end

endmodule