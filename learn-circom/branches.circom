// def foo(x):

//   if x == 5: // switch1(cond1)
//     out = 14 // branch1
//   elif x == 9: // switch2(cond2)
//     out = 22 // branch2
//   elif x == 10: // switch3(cond3)
//     out = 23 // branch3
//   else // switch4(cond4)
//     out = 45 // branch4

//   return out

// include "./node_modules/circomlib/circuits/comparators.circom";
// template Branch4(cond1, cond2, cond3, branch1, branch2, branch3, branch4){
//     signal input x;
//     signal output out;

//     signal switch1;
//     signal switch2;
//     signal switch3;
//     signal otherwise;

//     switch1 <== IsEqual()([x, cond1]);
//     switch2 <== IsEqual()([x, cond2]);
//     switch3 <== IsEqual()([x, cond3]);
//     otherwise <== IsZero()(switch1 + switch2 + switch3);

//     signal branches1_2 <== switch1 * branch1 + switch2 * branch2;
//     signal branches3_4 <== switch3 * branch3 + otherwise * branch4;

//     out <== branches1_2 + branches3_4;
// }
// template MultiBranchConditional(){
//     signal input x;
//     signal output out;

//     component branch4 = Branch4(5,9,10,14,22,23,45);

//     branch4.x <== x;
//     branch.out ==> out;
// }
// component main = MultiBranchConditional(); 



include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/multiplexer.circom";

template BranchN(n) {
  assert(n > 1); // too small

  signal input x;

  // conds n - 1 is otherwise
  signal input conds[n - 1];

  // branch n - 1 is the otherwise branch
  signal input branches[n];
  signal output out;

  signal switches[n];

  component EqualityChecks[n - 1];

  // only compute IsEqual up to the second-to-last switch
  for (var i = 0; i < n - 1; i++) {
    EqualityChecks[i] = IsEqual();

    EqualityChecks[i].in[0] <== x;
    EqualityChecks[i].in[1] <== conds[i];
    switches[i] <== EqualityChecks[i].out;
  }

  // check the last condition
  var total = 0;
  for (var i = 0; i < n - 1; i++) {
    total += switches[i];
  }

  // if none of the first n - 1 switches
  // are active, then `otherwise` must be 1
  switches[n - 1] <== IsZero()(total);

  component InnerProduct = EscalarProduct(n); 
  for (var i = 0; i < n; i++) {
    InnerProduct.in1[i] <== switches[i];
    InnerProduct.in2[i] <== branches[i];
  }

  out <== InnerProduct.out; // out <== switch1 * branch1 + switch2 * branch2 + ... + switchn * branchn;
}

template MultiBranchConditional() {
    signal input x;

    signal output out;

    component branchn = BranchN(4);

  var conds[3] = [5, 9, 10];
  var branches[4] = [14, 22, 23, 45];
  for (var i = 0; i < 4; i++) {
    if (i < 3) {
        branchn.conds[i] <== conds[i];
    }

    branchn.branches[i] <== branches[i];
  }

  branchn.x <== x;
  branchn.out ==> out; // same as out <== branch4.out
}

component main = MultiBranchConditional();