pragma circom 2.1.6;

include "QuinSelector.circom";
include "swap.circom";

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
    var inxv = start;
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
    component qs = QuinSelector();
    qs.index <== idx;
    for (var i=0; i<n; i++){
        qs.in[i] <== in[i];
    }
    qs.out === min;
}

// Given an array in, swap start with the smallest element
// in front of it
template Select(n, start){
    signal input in[n]; // unsorted list
    signal output out[n]; // index 0 swapped with the min

    component minIdx0 = GetMinAtIdxStartingAt(n, start);
    for (var i=0; i<n; i++){
        minIdx0.in[i] <== in[i];
    }

    component Swap0 = Swap(n);
    Swap0.s <== start; // swap 0 with the min
    swap0.t <== minIdx0.idx; // with the min (could be idx 0)
    for (var i=0; i<n; i++){
        Swap0.in[i] <== in[i];
    }

    // copy to out
    for (var i=0; i<n; i++){
        out[i] <== Swap0.out[i];
    }
}

// ---- CORE ALGORITHM ----
