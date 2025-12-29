pragma circom 2.1.4;

include "./node_modules/circomlib/circuits/multiplexer.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

template LeftShift32(wordsize) {
    assert(wordsize >= 1);
    
    signal input x;
    signal input s;

    signal output out;

    // range check
    component n2bX = Num2Bits(wordsize);
    component n2bS = Num2Bits(wordsize);
    n2bX.in <== x;
    n2bS.in <== s;

    // ensure that s < wordsize
    signal sLTwordsize;
    sLTwordsize <== LessThan(252)([s, wordsize]);
    sLTwordsize === 1;

    // precompute powers sequence from 0 to 31: power[i] = base^i
    signal pow2[32];
    pow2[0] <== 1;
    for (var i = 1; i < 32; i++) {
        pow2[i] <== pow2[i - 1] * 2;
    }

    // select the power number of interest
    component mux = Multiplexer(1, wordsize);
    mux.sel <== s;

    // select the power into the quin selector
    for (var i=0; i<wordsize; i++){
        mux.inp[i][0] <== pow2[i];
    }

    signal factor;
    factor <== sLTwordsize * mux.out[0];

    out <== x * factor;
}

component main = LeftShift32(32);

