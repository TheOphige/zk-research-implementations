// anonymous component
// Rather than assign the input signals to a component separately, it is possible to provide them as an argument.
// implement mul3 again
template Mul3() {
    signal input in[3];
    signal output out;

    signal s;

    s <== in[0] * in[1];

    out <== s * in[2];
}

template Example() {
    signal input a; 
    signal input b;
    signal input c;

    signal output out;

    // one line instantiaiton
    out <== Mul3()([a, b, c]);
}

component main = Example();