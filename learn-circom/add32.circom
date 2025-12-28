include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/bitify.circom";

template Add32() {
    signal input x;
    signal input y;
    signal output out;

    // range check x and y
    component rCheckX = Num2Bits(32);
    component rCheckY = Num2Bits(32);
    rCheckX.in <== x;
    rCheckY.in <== y;

    // convert the sum to 33 bits
    component n2b33 = Num2Bits(33);
    n2b33.in <== x + y;

    // convert the least significant 32 bits to the final result
    component b2n = Bits2Num(32);
    for (var i =0; i < 32; i++){
        b2n.in[i] <== n2b33.out[i];
    }

    b2n.out ==> out;
}

component  main = Add32();