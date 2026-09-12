module CLA_4bit_gate_level (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    // Propagate and generate signals
    wire [3:0] p;
    wire [3:0] g;

    // Carry signals
    wire c1, c2, c3, c4;

    // Intermediate carry terms
    wire c1_term0;

    wire c2_term0;
    wire c2_term1;
    wire c2_term2;

    wire c3_term0;
    wire c3_term1;
    wire c3_term2;
    wire c3_term3;

    wire c4_term0;
    wire c4_term1;
    wire c4_term2;
    wire c4_term3;
    wire c4_term4;

    // Intermediate product terms for c3
    wire p2_p1;
    wire p2_p1_p0;

    // Intermediate product terms for c4
    wire p3_p2;
    wire p3_p2_p1;
    wire p3_p2_p1_p0;

    // -------------------------------------------------
    // Propagate and generate logic
    // -------------------------------------------------

    xor p0_gate (p[0], a[0], b[0]);
    xor p1_gate (p[1], a[1], b[1]);
    xor p2_gate (p[2], a[2], b[2]);
    xor p3_gate (p[3], a[3], b[3]);

    and g0_gate (g[0], a[0], b[0]);
    and g1_gate (g[1], a[1], b[1]);
    and g2_gate (g[2], a[2], b[2]);
    and g3_gate (g[3], a[3], b[3]);

    // -------------------------------------------------
    // Carry c1
    //
    // c1 = g0 + p0*cin
    // -------------------------------------------------

    and c1_and (c1_term0, p[0], cin);
    or  c1_or  (c1, g[0], c1_term0);

    // -------------------------------------------------
    // Carry c2
    //
    // c2 = g1 + p1*g0 + p1*p0*cin
    // -------------------------------------------------

    and c2_and0 (c2_term0, p[1], g[0]);
    and c2_and1 (c2_term1, p[1], p[0]);
    and c2_and2 (c2_term2, c2_term1, cin);

    or c2_or0 (c2, g[1], c2_term0, c2_term2);

    // -------------------------------------------------
    // Carry c3
    //
    // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
    // -------------------------------------------------

    and p2p1_gate (p2_p1, p[2], p[1]);

    and c3_and0 (c3_term0, p[2], g[1]);
    and c3_and1 (c3_term1, p2_p1, g[0]);

    and p2p1p0_gate (p2_p1_p0, p2_p1, p[0]);
    and c3_and2 (c3_term2, p2_p1_p0, cin);

    or c3_or0 (
        c3,
        g[2],
        c3_term0,
        c3_term1,
        c3_term2
    );

    // -------------------------------------------------
    // Carry c4
    //
    // c4 = g3 + p3*g2 + p3*p2*g1
    //      + p3*p2*p1*g0 + p3*p2*p1*p0*cin
    // -------------------------------------------------

    and p3p2_gate (p3_p2, p[3], p[2]);

    and c4_and0 (c4_term0, p[3], g[2]);
    and c4_and1 (c4_term1, p3_p2, g[1]);

    and p3p2p1_gate (p3_p2_p1, p3_p2, p[1]);
    and c4_and2 (c4_term2, p3_p2_p1, g[0]);

    and p3p2p1p0_gate (p3_p2_p1_p0, p3_p2_p1, p[0]);
    and c4_and3 (c4_term3, p3_p2_p1_p0, cin);

    or c4_or0 (
        c4,
        g[3],
        c4_term0,
        c4_term1,
        c4_term2,
        c4_term3
    );

    // -------------------------------------------------
    // Sum logic
    //
    // sum[i] = p[i] XOR c[i]
    // -------------------------------------------------

    xor sum0_gate (sum[0], p[0], cin);
    xor sum1_gate (sum[1], p[1], c1);
    xor sum2_gate (sum[2], p[2], c2);
    xor sum3_gate (sum[3], p[3], c3);

    // Final carry output
    buf cout_gate (cout, c4);

endmodule
