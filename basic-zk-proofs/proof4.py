from py_ecc.bn128 import G1, multiply, add

# ---------- Prover ----------
# Example: 2x1 + 3x2 + 5x3 = 46
# Secrets:
x1 = 5
x2 = 6
x3 = 4
a = [2, 3, 5]
C = 46

# Commitments
X1 = multiply(G1, x1)
X2 = multiply(G1, x2)
X3 = multiply(G1, x3)
proof = ([X1, X2, X3], a, C)

# ---------- Verifier ----------
commitments, coefficients, constant = proof

# Compute left-hand side: a1*X1 + a2*X2 + a3*X3
lhs = multiply(commitments[0], coefficients[0])
for i in range(1, len(coefficients)):
    lhs = add(lhs, multiply(commitments[i], coefficients[i]))

# Compute right-hand side: C * G1
rhs = multiply(G1, constant)

if lhs == rhs:
    print("statement is true")
else:
    print("statement is false")
