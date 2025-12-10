pragma circom 2.1.6;

include "QuinSelector.circom";
include "swap.circom";

// take input array
// create intermediate states, an array that hold the state after each swap
// at i=0, the intermediate state is same as in[i]
// the select sort algorithm(which swaps) takes in the present intermediate state
// the output of the select sort is the next intermediate state
// write the final state to the output array

// The first step in Selection Sort is to swap the item at 
// index 0 with the minimum item in the entire list (which could be the item at index 0).

// a template that proves we correctly identified the index of the minimum value in a sublist
template GetMinAtIdxStartingAt(n, start){
    signal input in[n];
    signal output min; // min value in the list
    signal output idx; // index of the minimum value

    // compute the minimum and its index outside of the constraints
    // only look for values start and later
    var minv = in[start];
    var idxv = start;
    for (var i = start+1; i<n; i++){
        if (in[i] < minv){
            minv = in[i];
            idxv = i;
        }
    }
    min <-- minv;
    idx <-- idxv;

    // constrain that min is ≤ all others
    // only compare to values start and later
    component lt[n];
    for (var i=start; i<n; i++){
        lt[i] = LessThan(252);
        lt[i].in[0] <== min;
        lt[i].in[1] <== in[i];
        lt[i].out === 1;
    }

    // assert min is really at in[idx]
    component qs = QuinSelector(n);
    qs.index <== idx;
    for (var i=0; i<n; i++){
        qs.in[i] <== in[i];
    }
    qs.out === min;
}

// Given an array in, swap start with the smallest element in front of it
template SelectSwap(n, start){
    signal input in[n]; // unsorted list
    signal output out[n]; // index 0 swapped with the min

    component minIdx0 = GetMinAtIdxStartingAt(n, start);
    for (var i=0; i<n; i++){
        minIdx0.in[i] <== in[i];
    }

    component Swap0 = Swap(n);
    Swap0.s <== start; // swap 0 with the min
    Swap0.t <== minIdx0.idx; // with the min (could be idx 0)
    for (var i=0; i<n; i++){
        Swap0.in[i] <== in[i];
    }

    // copy to out
    for (var i=0; i<n; i++){
        out[i] <== Swap0.out[i];
    }
}

// ---- CORE ALGORITHM ----
template SelectionSort(n){
    assert(n>0);

    signal input in[n];
    signal output out[n];

    signal intermediateStates[n][n];

    component SSort[n-1];
    for (var i=0; i<n; i++){
        // copy the input to the first row of intermediateStates. 
        // Note that we can do if(i == 0) because i is not a signal
        // and i is known at compile time
        if (i == 0){
            for (var j=0; j<n; j++){
                intermediateStates[0][j] <== in[j];
            }
        }

        else {
            // select sort n items starting at i - 1
            // for i = 1, we compare item at 0 to the rest of the list
            SSort[i-1] = SelectSwap(n, i-1);

            // load in the intermediate state i -1
            for (var j=0; j<n; j++){
                SSort[i-1].in[j] <== intermediateStates[i-1][j];
            }

            // write the sorted result to row i
            for (var j=0; j<n; j++){
                SSort[i-1].out[j] ==> intermediateStates[i][j];
            }
        }
    }

    // write the final state to the ouput
    for (var i=0; i<n; i++){
        intermediateStates[n-1][i] ==> out[i];
    }
}

component main = SelectionSort(9);

/* INPUT = {"in": [3,1,8,2,4,0,1,2,4]} */