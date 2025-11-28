include "bitify.circom";

// using bitify.circom
// convert bits to numbers in[0] * 1 + in[1] * 2 + in[2] * 4 + in[3] * 8... === v
template Main(n) {
    signal input in[n];
    signal input v;

    component b2n = Bits2Num(n);

    for (var i=0; i<n; i++) {
        b2n.in[i] <== in[i];
    }

    b2n.out === v;
}

component main = Main(4);

/* INPUT = {"in": [1, 0, 0, 1], "v": 9} */