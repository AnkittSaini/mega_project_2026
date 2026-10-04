`timescale 1ns/1ps

// 4-bit Kogge-Stone Adder - Gate Level
module kogge_stone_adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    // ---------------------------------------------------
    // Stage 0 : Bitwise Propagate / Generate
    // p = a ^ b , g = a & b
    // ---------------------------------------------------
    wire [3:0] p0, g0;

    xor xp0 (p0[0], a[0], b[0]);
    xor xp1 (p0[1], a[1], b[1]);
    xor xp2 (p0[2], a[2], b[2]);
    xor xp3 (p0[3], a[3], b[3]);

    and ag0 (g0[0], a[0], b[0]);
    and ag1 (g0[1], a[1], b[1]);
    and ag2 (g0[2], a[2], b[2]);
    and ag3 (g0[3], a[3], b[3]);

    // Fold carry-in into bit 0: G0 = g0 | (p0 & cin)
    wire t_cin, gc0;
    and ac0 (t_cin, p0[0], cin);
    or  oc0 (gc0, g0[0], t_cin);

    // ---------------------------------------------------
    // Stage 1 : prefix distance = 1
    // G1[i] = G0[i] | (P0[i] & G0[i-1])
    // P1[i] = P0[i] & P0[i-1]
    // ---------------------------------------------------
    wire [3:0] g1, p1;
    wire       t11, t12, t13;

    // bit 0 : pass-through
    buf bg10 (g1[0], gc0);
    buf bp10 (p1[0], p0[0]);

    // bit 1
    and a11 (t11, p0[1], gc0);
    or  o11 (g1[1], g0[1], t11);
    and ap11(p1[1], p0[1], p0[0]);

    // bit 2
    and a12 (t12, p0[2], g0[1]);
    or  o12 (g1[2], g0[2], t12);
    and ap12(p1[2], p0[2], p0[1]);

    // bit 3
    and a13 (t13, p0[3], g0[2]);
    or  o13 (g1[3], g0[3], t13);
    and ap13(p1[3], p0[3], p0[2]);

    // ---------------------------------------------------
    // Stage 2 : prefix distance = 2
    // G2[i] = G1[i] | (P1[i] & G1[i-2])
    // (P2 not needed: every group now reaches bit 0 / cin)
    // ---------------------------------------------------
    wire [3:0] g2;
    wire       t22, t23;

    // bits 0,1 : already final
    buf bg20 (g2[0], g1[0]);
    buf bg21 (g2[1], g1[1]);

    // bit 2
    and a22 (t22, p1[2], g1[0]);
    or  o22 (g2[2], g1[2], t22);

    // bit 3
    and a23 (t23, p1[3], g1[1]);
    or  o23 (g2[3], g1[3], t23);

    // ---------------------------------------------------
    // Stage 3 : Sum generation
    // sum[i] = p0[i] ^ carry[i]
    // carry[0]=cin, carry[1]=g2[0], carry[2]=g2[1], carry[3]=g2[2]
    // ---------------------------------------------------
    xor xs0 (sum[0], p0[0], cin);
    xor xs1 (sum[1], p0[1], g2[0]);
    xor xs2 (sum[2], p0[2], g2[1]);
    xor xs3 (sum[3], p0[3], g2[2]);

    // Carry out
    buf bco (cout, g2[3]);

endmodule