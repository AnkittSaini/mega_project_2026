`timescale 1ns/1ps

module tb;
reg [3:0] a;
reg [3:0] b;
reg cin;
wire [3:0] sum;
wire cout;
rac_4bit uut(
            .a(a),
            .b(b),
            .cin(cin),
            .sum(sum),
            .cout(cout)
            );
            
integer i;
initial begin 
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
            $monitor("Time =%0t|a=%b|b=%b|cin=%b|sum=%b|cout=%b",$time,a,b,cin,sum,cout);
            for(i=0;i<256;i=i+1) begin
                {a,b,cin} =i;
                #10;
             if({cout,sum} !== (a+b+cin))
                $display("ERROR: a=%b b=%b cin=%b | Expected=%b | Got=%b",
                         a, b, cin, (a + b + cin), {cout, sum});
            else 
                $display("PASS: a=%b b=%b cin=%b | sum=%b cout=%b",
                         a, b, cin, sum, cout);
            end
            $display("All test cases completed.");

        $finish;
            end
            
                       
endmodule