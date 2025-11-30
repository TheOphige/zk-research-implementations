pragma circom 2.1.6;

include "circomlib/comparators.circom";
include "circomlib/gates.circom";

// check if x is less than 5 or x is greater than 17

template Less5OrGreater17() {
    signal input x;

    signal indicator1;
    signal indicator2;

    indicator1 <== LessThan(252)([x, 5]); // returns 1 if true else 0
    indicator2 <== GreaterThan(252)([x, 17]); // returns 1 if true else 0

    component or = OR(); // OR component is out <== a + b - a * b under the hood
    or.a <== indicator1;
    or.b <== indicator2;

    or.out === 1; // at least one of them would be 1
}

component main = Less5OrGreater17();

/* INPUT = {
  "x": "18"
} */
