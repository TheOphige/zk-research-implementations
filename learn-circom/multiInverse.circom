template MulInv(){
    signal input in;
    signal output out;

    out <-- 1/in; //compute

    out * in === 1; //constrain
}

component main = MulInv();