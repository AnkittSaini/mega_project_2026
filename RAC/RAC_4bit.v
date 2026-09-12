module rac_4bit(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    wire c1, c2, c3;

    // Bit 0 (LSB)
    FA_1bit uut0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    // Bit 1  
    FA_1bit uut1 (
        .a(a[1]),
        .b(b[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(c2)
    );

    // Bit 2
    FA_1bit uut2 (
        .a(a[2]),
        .b(b[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(c3)
    );

    // Bit 3 (MSB)
    FA_1bit uut3 (
        .a(a[3]),
        .b(b[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(cout)
    );

endmodule


module FA_1bit(
    input a, b, cin,
    output sum, cout
);

    wire s1, c1, c2;

    xor(s1, a, b);
    xor(sum, s1, cin);

    and(c1, a, b);
    and(c2, s1, cin);

    or(cout, c1, c2);

endmodule