pragma circom 2.1.4;

include "./node_modules/circomlib/circuits/comparators.circom";
include "DivMod.circom";

template RightShift32() {
    signal input x;
    signal input s;
    signal output out;

    // range check
    component n2bX = Num2Bits(32);
    component n2bS = Num2Bits(6);
    n2bX.in <== x;
    n2bS.in <== s;

    // Precompute powers of 2
    signal pow2[32];
    pow2[0] <== 1;
    for (var i = 1; i < 32; i++) {
        pow2[i] <== pow2[i - 1] * 2;
    }

    // Compute (s < 32) but DO NOT fail
    component lt = LessThan(6);
    lt.in[0] <== s;
    lt.in[1] <== 32;
    signal sLT32;
    sLT32 <== lt.out;

    // Quin-style selector
    signal prod[32];
    component eqs[32];

    for (var i = 0; i < 32; i++) {
        eqs[i] = IsEqual();
        eqs[i].in[0] <== i;
        eqs[i].in[1] <== s;
        prod[i] <== eqs[i].out * pow2[i];
    }

    var sum;
    for (var i = 0; i < 32; i++) {
        sum += prod[i];
    }

    signal factor;
    factor <== sum * sLT32; // zero if s >= 32

    // Use DivMod template
    component divmod = DivMod(32);
    divmod.numerator <== x;
    divmod.denominator <== factor; // safe because DivMod checks for zero
    out <== divmod.quotient;
}

component main = RightShift32();
