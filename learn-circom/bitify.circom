// convert bits to numbers in[0] * 1 + in[1] * 2 + in[2] * 4 + in[3] * 8... === v
template Bits2Num(n) {
    signal input in[n];
    signal output out;

    var acc;
    var powersOf2 = 1;
    for (var i=0; i<n; i++) {
        acc += in[i] * powersOf2;
        powersOf2 *= 2;
    }

    out <== acc;
}