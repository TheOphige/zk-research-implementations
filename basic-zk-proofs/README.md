# Basic zero knowledge proofs with elliptic curves

Proof 1:

Claim: “I know two values `x` and `y` such that `x + y = 15`”
Proof: I multiply `x` by `G1` and `y` by `G1` and give those to you as `A` and `B`.
Verifier: You multiply `15` by `G1` and check that `A + B == 15G1`.

Proof 2:

Claim: “I know two values `x` and `y` such that `x + y = 15`”
Proof: I multiply `x` by `G1` and `y` by `G1` and give those to you as `A` and `B`.
Verifier: You multiply `15` by `G1` and check that `A + B == 15G1`.

