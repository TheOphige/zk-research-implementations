// compute square of two numbers
template Square() {
    signal input in;
    signal output out;

    out <== in * in;
}

// calculate sum of two squares: a^2 + b^2 === sumOfSquares
template Main() {
    signal input a;
    signal input b;
    signal input sumOfSquares;

    component a2 = Square();
    component b2 = Square();

    a2.in <== a;
    b2.in <== b;

    a2.out + b2.out === sumOfSquares;
}

component main = Main();