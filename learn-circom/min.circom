include "./node_modules/circomlib/circuits/comparators.circom";

// compute minSignal, GreaterEqThan, IsEqual
template Min(n) {
    signal input in[n];
    signal input out;

    var min = 0;
    for (var i=0; i<n; i++) {
        min = in[i] > min ? in[i] : min;
    }

    signal minSignal;
    minSignal <-- min;

    component GTE[n];
    component EQ[n];

    var acc;

    for (var i=0; i<n; i++) {
        GTE[i] = GreaterEqThan(252);
        GTE[i].in[0] <== minSignal;
        GTE[i].in[1] <== in[i];
        GTE[i].out === 1;

        EQ[i] = IsEqual();
        EQ[i].in[0] <== minSignal;
        EQ[i].in[1] <== in[i];

        acc += EQ[i].out;
    }

    signal allZero;
    allZero <== IsEqual()([0, acc]);
    allZero === 0;
    out <== min;
}

component  main = Min(8);