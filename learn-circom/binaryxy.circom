pragma circom 2.1.6;

// create template
template IsBinary() {

    // array of two inputs
    signal input in[2];

    in[0] * (in[0] - 1) === 0;
    in[1] * (in[1] - 1) === 0;
}

// instantiate template
component main = IsBinary();

/* INPUT = {
    "in": [0, 2]
} */ 