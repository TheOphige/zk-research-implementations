include "QuinSelector.circom";

template Swap(n){
    signal input in[n];
    signal input s;
    signal input t;
    signal output out[n];

    // we do not check that s < n or t < n because the Quin selector does that

    
    // if s=t then the value written to the index will be the value at that index added to itself.
    // To prevent this, we need to explicitly detect if s == t and multiply one of either branchS or branchT by zero to avoid doubling the value.
    
    // detect if s = t
    signal sEqT;
    sEqT <== IsEqual()([s, t]);

    // First, we cannot directly index an array of signals. For that, we need to use a Quin selector.
    
    // get the value at s
    component qss = QuinSelector(n);
    qss.index <== s;
    for (var i=0; i<n; i++){
        qss.in[i] <== in[i];
    }

    // get the value at t
    component qst = QuinSelector(n);
    qst.index <== t;
    for (var i=0; i<n; i++){
        qst.in[i] <== in[i];
    }
    // qss.out holds in[s]
    // qst.out holds in[t]

    // Second, we cannot “write to” a signal in an array of signals because signals are immutable.
    // Instead, we need to create a new array and copy the old values to the new array, subject to the following conditions:
    // If we are at index s, write the value at arr[t]
    // If we are at index t, write the value at arr[s]
    // Otherwise, write the original value

    component IdxEqS[n];
    component IdxEqT[n];
    component IdxNorST[n];
    signal branchS[n];
    signal branchT[n];
    signal branchNorST[n];
    for (var i=0; i<n; i++){
        IdxEqS[i] = IsEqual();
        IdxEqS[i].in[0] <== i;
        IdxEqS[i].in[1] <== s;

        IdxEqT[i] = IsEqual();
        IdxEqT[i].in[0] <== i;
        IdxEqT[i].in[1] <== t;

        // if IdxEqS[i].out + IdxEqT[i].out equals 0, then it is not i ≠ s and i ≠ t
        IdxNorST[i] = IsZero();
        IdxNorST[i].in <== IdxEqS[i].out + IdxEqT[i].out;

        // if we are at index s, write in[t]
        // if we are at index t, write in[s]
        // else write in[i]
        branchS[i] <== IdxEqS[i].out * qst.out;
        branchT[i] <== IdxEqT[i].out * qss.out;
        branchNorST[i] <== IdxNorST[i].out * in[i];

        // multiply branchS by zero if s equals T
        out[i] <== (i-sEqT) * (branchS[i]) + branchT[i] + branchNorST[i]; 
    }
}

// component main = Swap(2);