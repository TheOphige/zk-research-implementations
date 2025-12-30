include "./node_modules/circomlib/circuits/gates.circom";
include "./node_modules/circomlib/circuits/bitify.circom";

template BitwiseAnd32(){
    signal input a;
    signal input b;

    signal out;

    // range check
    component n2ba = Num2Bits(32);
    component n2bb = Num2Bits(32);
    n2ba.in <== a;
    n2bb.in <== b;

    component b2n = Bits2Num(32);
    component Ands[32];
    for (var i=0; i<32; i++){
        Ands[i] = AND();
        Ands[i].a <== n2ba.out[i];
        Ands[i].b <== n2bb.out[i];
        Ands[i].out ==> b2n.in[i];
    }

    b2n.out ==> out;
}

component main = BitwiseAnd32();