from py_ecc.bn128 import G1, multiply, add

# Prover: knows x such that 23x = 161
x = 7  # since 23 * 7 = 161

A = multiply(G1, x)
proof = (A, 23, 161)

# Verifier
lhs = multiply(proof[0], proof[1])
rhs = multiply(G1, proof[2])

if lhs == rhs:
    print("statement is true")
else:
    print("statement is false")
