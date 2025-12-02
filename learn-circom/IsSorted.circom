pragma circom 2.1.6;
include "./node_modules/circomlib/circuits/comparators.circom";

// check if an array is sorted
template IsSorted(n) {
    signal input in[n];

    component lessThan[n];

    for (var i=0; i<n-1; i++) {
        lessThan[i] = LessEqThan(252);
        lessThan[i].in[0] <== in[i];
        lessThan[i].in[1] <== in[i+1];
        lessThan[i].out <== 1;
    }
}