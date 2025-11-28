// multiply three numbers duch that d = a * b * c
template Mul3() {
    signal input a;
    signal input b;
    signal input c;
    signal input d;

    signal s;

    s <== a * b;

    d === s * c;
}

// multiply three numbers twice
// d = a * b * c and u = x * y * z
template Mul3x2() {
    signal input a;
    signal input b;
    signal input c;
    signal input d;

    signal input x;
    signal input y;
    signal input z;
    signal input u;

    component m3_1 = Mul3();

    m3_1.a <== a;
    m3_1.b <== b;
    m3_1.c <== c;
    m3_1.d <== d;

    component m3_2 = Mul3();

    m3_2.a <== x;
    m3_2.b <== y;
    m3_2.c <== z;
    m3_2.d <== u;
}