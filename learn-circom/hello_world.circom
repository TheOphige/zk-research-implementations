pragma circom 2.1.6;

// create template
template SomeCircuits() {
    // inputs
    signal input a;
    signal input b;
    signal input c;

    // constraints
    c === a * b;
}

// instantiate template
component main = SomeCircuits();

/* INPUT = {
    "a": 3,
    "b": 4,
    "c": 12,
} */