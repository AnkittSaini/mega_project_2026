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