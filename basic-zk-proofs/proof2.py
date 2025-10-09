from py_ecc.bn128 import G1, multiply, add, neg

# Prover: knows x and y satisfying 3x + 2y = 16 and x - y = 2
x = 4
y = 2

A = multiply(G1, x)
B = multiply(G1, y)

proof = (A, B, 16, 2)

# Verifier checks both equations
lhs1 = add(multiply(A, 3), multiply(B, 2))
rhs1 = multiply(G1, proof[2])

lhs2 = add(A, neg(B))
rhs2 = multiply(G1, proof[3])

if lhs1 == rhs1 and lhs2 == rhs2:
    print("statement is true")
else:
    print("statement is false")
