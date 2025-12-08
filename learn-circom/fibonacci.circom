include "./node_modules/circomlib/circuits/multiplexer.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

template Fibonacci(n){
    assert(n>=2); // so we don't break the hardcording

    signal input in; // compute the kth fibonacci number
    signal output out;

    // ensure that in < n
    signal inLTn;
    inLTn <== LessThan(252)([in,n]);
    inLTn === 1;

    // precompute fibonacci sequence from 0 to n
    signal fib[n+1];

    // compute the factorials
    fib[0] = 1;
    fib[1] = 1;

    for (var i=2; i<n; i++){
        fib[i] <== fib[i-1] + fib[i-2];
    }

    // select the fibonacci number of interest
    component mux = multiplexer(1, n);
    mux.sel <== in;

    // select the fibonacci into the quin selector
    for (var i=0; i<n; i++){
        mux.inp[i][0] <== fib[i];
    }

    out <== mux.out[0];
}

component main = Fibonacci(99);

/*
  INPUT = {"in": 5}
*/