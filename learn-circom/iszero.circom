template IsZero() {
  signal input in;
  signal output out;

  signal inv;

  inv <-- in!=0 ? 1/in : 0; // compute multiplicative inverse of in

  out <== -in*inv + 1; // disallowing both in and out to be zero.
  in*out === 0; // exactly one of in and out are zero
}