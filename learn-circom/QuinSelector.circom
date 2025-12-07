// in = [5,9,14,20]
// if we are to select item at 'index 2' which is 14, 
// we can create an array for the index, where the specified index
// in this case will be 1, while others will be zero
// [0,0,1,0]
// so to select the item, we do the inner product of the input array by the index array, then sum the result.
// 5 * 0 + 9 * 0 + 14 * 1 + 20 * 0
// which results in 14.

include "./node_modules/circomlib/comparators.circom";

template QuinSelector(n) {

  signal input in[n];
  signal input index;
  signal output out;

  // Ensure that index < n
  component lessThan = LessThan(252);
  lessThan.in[0] <== index;
  lessThan.in[1] <== n;
  lessThan.out === 1;

  component eqs[n];

  // prod keeps a running product
  signal prod[n];

  // prod = 1 * in[i] if i == index else 0 
  for (var i = 0; i < n; i++) {
    eqs[i] = IsEqual();
    eqs[i].in[0] <== i;
    eqs[i].in[1] <== index;

    prod[i] <== eqs[i].out * in[i];
  }

  // sum the result
  var sum;
  for (var i = 0; i < n; i++) {
    sum += prod[i];
  }

  out <== sum;
}