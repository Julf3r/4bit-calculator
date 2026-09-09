module hex7seg (
    input  [3:0] value,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
);

    wire n3, n2, n1, n0;

    wire m0,  m1,  m2,  m3;
    wire m4,  m5,  m6,  m7;
    wire m8,  m9,  mA,  mB;
    wire mC,  mD,  mE,  mF;

    not (n3, value[3]);
    not (n2, value[2]);
    not (n1, value[1]);
    not (n0, value[0]);

    and (m0, n3,n2,n1,n0);
    and (m1, n3,n2,n1,value[0]);
    and (m2, n3,n2,value[1],n0);
    and (m3, n3,n2,value[1],value[0]);

    and (m4, n3,value[2],n1,n0);
    and (m5, n3,value[2],n1,value[0]);
    and (m6, n3,value[2],value[1],n0);
    and (m7, n3,value[2],value[1],value[0]);

    and (m8, value[3],n2,n1,n0);
    and (m9, value[3],n2,n1,value[0]);
    and (mA, value[3],n2,value[1],n0);
    and (mB, value[3],n2,value[1],value[0]);

    and (mC, value[3],value[2],n1,n0);
    and (mD, value[3],value[2],n1,value[0]);
    and (mE, value[3],value[2],value[1],n0);
    and (mF, value[3],value[2],value[1],value[0]);

    // Segmentos activos en alto, por ahora.
    // a
    or (a,
        m0,m2,m3,m5,m6,m7,
        m8,m9,mA,mC,mE,mF);

    // b
    or (b,
        m0,m1,m2,m3,m4,m7,
        m8,m9,mA,mD);

    // c
    or (c,
        m0,m1,m3,m4,m5,m6,
        m7,m8,m9,mA,mB,mD);

    // d
    or (d,
        m0,m2,m3,m5,m6,m8,
        m9,mB,mC,mD,mE);

    // e
    or (e,
        m0,m2,m6,m8,mA,mB,
        mC,mD,mE,mF);

    // f
    or (f,
        m0,m4,m5,m6,m8,m9,
        mA,mB,mC,mE,mF);

    // g
    or (g,
        m2,m3,m4,m5,m6,m8,
        m9,mA,mB,mD,mE,mF);

endmodule