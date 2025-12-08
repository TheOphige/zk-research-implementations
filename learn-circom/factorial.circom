// def factorial_mod_p(x, p):

//   assert x < 100
//   # allocate the array
//   ans = [0] * 100
//   ans[0] = 1 # 0! = 1

//   for i in range(1, 100):
//       ans[i] = (ans[i-1] * i) % p

//   return ans[x]

template factorial(n){
    signal input in;
    signal output out;

    // assert x < 100 i.e in < n
    signal inLTn;
    inLTn <== LessThan(252)([in, n]);
    inLTn == 1;

    // allocate the factorials array from 0 to n
    signal factorials[n+1];

    // compute the factorials
    factorials[0] <== 1;
    for (var i=1; i<=n; i++){
        factorials[i] <== factorials[i-1] * i;
    }

    // select the factorial of interest using quin selector
    component mux = Multiplexer(1, n);
    mux.sel <== in;

    // assign the factorials into themultiplexer
    for (var i=1; i<n; i++){
        mux.inp[i][0] <== factorials[i];
    }

    out <== mux.out[0];
}

component main = factorial(100);

/*
  INPUT = { "in": "3" }
*/