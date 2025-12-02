pragma circom 2.1.6;

include "./node_modules/circomlib/circuits/comparators.circom";

// To check that all items in a list are unique, the brute force solution of comparing every element to every other element. 
// check that one elementt is not equal to another
// This requires a nested for-loop.
template ForceNotEqual(){
    signal input in[2];

    component isEq = IsEqual();
    isEq.in[0] <== in[0];
    isEq.in[1] <== in[1];
    isEq.out <== 0;
}

template AllUnique(n){
    signal input in[n];

    // the nested loop below will run
    // n * (n - 1) / 2 times
    component Fneq[n * (n-1)/2];

    // loop from 0 to n - 1
    var index = 0;
    for (var i=0; i<n-1; i++){
        // loop from i + 1 to n
        for (var j=i+1; j<n, j++){
            fneq[index] = ForceNotEqual();
            fneq[index].in[0] <== in[i];
            fneq[index].in[1] <== in[j];
            index++;
        }
    }
}

component main = AllUnique(5);