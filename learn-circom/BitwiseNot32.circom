include "./node_modules/circomlib/circuits/gates.circom";
include "./node_modules/circomlib/circuits/bitify.circom";

template BitwiseNot32(){
    signal input x;

    signal out;

    // range check
    component n2bx = Num2Bits(32);
    n2bx.in <== x;

    component b2n = Bits2Num(32);
    component Nots[32];
    for (var i=0; i<32; i++){
        Nots[i] = NOT();
        Nots[i].in <== n2bx.out[i];
        Nots[i].out ==> b2n.in[i];
    }

    b2n.out ==> out;
}

component main = BitwiseNot32();