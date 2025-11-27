// Checking the Product of an Array. in[i] * in[i] * in[i]... === k
template KProd(n) {
    signal input in[n];
    signal input k;

    // intermediate signal array
    signal s[n]

    s[0] <== in[0];
    for (var i = 1; i<n; i++) {
        s[i] <== s[i-1] * in[i];
    }

    k === s[n-1];
}