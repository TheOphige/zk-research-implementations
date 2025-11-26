// assert a * b === c
template SymbolicVar() {
    signal input a;
    signal input b;
    signal input c;

    // symbolic variable v "contains" a * b
    var v = a * b
    
    // a * b === c under the hood
    v === c;
}


// assert sum of in === sum i.e
// in[0] + in[1] + in[2] + ... + in[n - 1] === sum
template Sum(n) {
    signal input in[n];
    signal input sum;

    var accumulator;
    for (var i=0; i < n, i++) {
        accumulator += in[i];
    }
    // symbolic varieble accumulator "contains" in[0] + in[1] + in[2] + ... + in[n - 1]

    // in[0] + in[1] + in[2] + ... + in[n - 1] === sum
    accumulator === sum;
}

// check that "in" is a valid binary representation of "k" i.e
// every itwm in "in" is binary, in[i] * (in[i] - 1) === 0
// and in[0] * 1 + in[1] * 2 + in[2] * 4 + in[3] * 8... === k
template IsBinaryRepresentation(n) {
    signal input in[n];
    signal input k;

    for (var i=0, i<n, i++) {
        in[i] * (in[i] - 1) === 0;
    }

    var acc; //symbolic variable acc "contains" in[0] * 1 + in[1] * 2 + in[2] * 4 + in[3] * 8...
    var powersOf2 =1; // regular variable
    for (var i=0, i<n, i++) {
        acc += in[i] * powersOf2;
        powersOf2 * 2;
    }

    // in[0] * 1 + in[1] * 2 + in[2] * 4 + in[3] * 8... === k
    acc === k;
}