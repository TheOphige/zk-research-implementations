include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/bitify.circom";

template DivMod(wordsize){
    // a wordsize 124 could overflow 252
    assert(wordsize < 125);

    signal input numerator;
    signal input denominator;

    signal output quotient;
    signal output remainder;

    quotient <-- numerator \ denominator;
    remainder <-- numerator % denominator;

    //range check
    component n2bN = Num2Bits(wordsize);
    component n2bD = Num2Bits(wordsize);
    component n2bQ = Num2Bits(wordsize);
    component n2bR = Num2Bits(wordsize);
    n2bN.in <== numerator;
    n2bD.in <== denominator;
    n2bQ.in <== quotient;
    n2bR.in <== remainder;

    // core constraint
    numerator === quotient * denominator + remainder;

    // remainder must be less than denominator
    signal remLtDen;
    // depending on the application, we might be able to use fewer than 252 bits
    remLtDen <== LessThan(wordsize)([remainder, denominator]);
    remLtDen === 1;

    // denominator is not zero
    signal IsZero;
    IsZero <== IsZero()(denominator);
    IsZero === 0;
}

component main = DivMod(32);