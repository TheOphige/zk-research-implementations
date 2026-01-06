// check if an array is a permutation of the other
// we use Schwartz-Zippel lemma where a random number x 
// (x-a)(x-b)(x-c) === (x-c)(x-b)(x-a) proves that is a permutation
// x is going to be the hash of the inputs

include "./node_modules/circomlib/circuits/poseidon.circom";

template IsPermutation(n){
    signal input a[n];
    signal input b[n];

    // the random point will be the hash
    // of the concatenation of the arrays
    component hash = Poseidon(2 * n);
    for (var i=0; i<n; i++){
        hash.inputs[i] <== a[i];
        hash.inputs[i + n] <== b[i];
    }

    signal prodA[n];
    signal prodB[n];

    prodA[0] <== hash.out - a[0];
    prodB[0] <== hash.out - b[0];

    for (var i=1; i<n; i++){
        prodA[i] <== (hash.out - a[i]) * prodA[i - 1];
        prodB[i] <== (hash.out - a[i]) * prodB[i - 1];
    }

    // the evaluation of the polynomials at r = hash.out
    prodA[n - 1] === prodB[n - 1];
}

component main = IsPermutation(3);

/* INPUT = {
  "a": [1,2,3,4,5,6],
  "b": [1,2,3,4,6,5]
}
*/