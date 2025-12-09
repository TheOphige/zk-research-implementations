/// INDICATE THEN CONSTRAIN
pragma circom 2.1.6;

include "node_modules/circomlib/circuits/comparators.circom";
include "node_modules/circomlib/circuits/gates.circom";

// check if x is less than 5 or x is greater than 17

template DisjointExample1() {
    signal input x;

    component or = OR(); // OR component is out <== a + b - a * b under the hood
    or.a <== LessThan(252)([x, 5]); // returns 1 if true else 0 and assign to or.a /// INDICATE
    or.b <== GreaterThan(252)([x, 17]); // returns 1 if true else 0 and assign to or.b /// INDICATE

    or.out === 1; // at least one of them would be 1 /// CONSTRAIN
}

component main = DisjointExample1();

/* INPUT = {
  "x": "18"
} */


// pragma circom 2.1.6;

// include "circomlib/comparators.circom";
// include "circomlib/gates.circom";

// // check that both x < 100 and y < 100

// template DisjointExample2() {
//     signal input x;
//     signal input y;

//     component nand = NAND(); // NAND gate returns 1 for all combinations except when both inputs are 1
//     nand.a <== LessThan(252)([x, 100]); // returns 1 if true else 0 and assign to nand.a
//     nand.b <== LessThan(252)([y, 100]); // returns 1 if true else 0 and assign to nand.b

//     nand.out === 1; 
// }

// component main = DisjointExample2();

// /* INPUT = {
//   "x": "18",
//   "y": "100"
// } */



// pragma circom 2.1.6;

// include "circomlib/comparators.circom";
// include "circomlib/gates.circom";

// // check that k is greater than at least 2 of x, y, or z

// template DisjointExample3() {
//     signal input x;
//     signal input y;
//     signal input z;
//     signal input k;

//     signal totalGreaterThan;

//     signal greaterThanX;
//     signal greaterThanY;
//     signal greaterThanZ;

//     greaterThanX <== GreaterThan(252)([k, x]);
//     greaterThanY <== GreaterThan(252)([k, y]);
//     greaterThanZ <== GreaterThan(252)([k, z]);

//     totalGreaterThan = greaterThanX + greaterThanY + greaterThanZ;

//     signal atLeastTwo;
//     atLeastTwo <== GreaterEqThan(252)([totalGreaterThan, 2]);
//     atLeastTwo === 1;
// }

// component main = DisjointExample3();

// /* INPUT = {
//   "k": 20
//   "x": 18,
//   "y": 100,
//   "z": 10
// } */



/// Do not forget to constrain the outputs of components! {can lead to security vulnerability}