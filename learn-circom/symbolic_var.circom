template SymbolicVar() {
    signal input a;
    signal input b;
    signal input c;

    // symbolic variable v "contains" a * b
    var v = a * b
    
    // a * b === c under the hood
    v === c;
}