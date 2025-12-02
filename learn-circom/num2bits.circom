// decomposes a signal into n bits
template Num2Bits(n){
    signal input in;
    signal output out[n];

    var acc = 0;
    var powersOf2 = 1;
    for (var i=0; i<n; i++) {
        out[i] <-- (in >> i) & 1; // if the bit is 1
        out[i] * (out[i] - 1) === 0; // constrain to binary 0 or 1
        acc += out[i] * powersOf2;
        powersOf2 *= 2;
    }

    acc === in; // constrain that the computed binary value matches the original value
}