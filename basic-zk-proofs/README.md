
# Zero-Knowledge Proofs with Elliptic Curves (BN128)

This project demonstrates basic examples of zero-knowledge proofs (ZKPs) using elliptic curve arithmetic on the BN128 curve.  
We rely on the **discrete logarithm assumption**, which makes it infeasible to recover a secret scalar `x` from the point `xG`.

---

## Proof 1 – Sum Knowledge

**Claim:**  
I know two values `x` and `y` such that:

```

x + y = 15

```

**Prover:**  
Computes `A = xG` and `B = yG`.

**Verifier:**  
Checks that:
```

A + B == 15G

```

**File:** `proof1.py`

---

## Proof 2 – Linear System Knowledge

**Claim:**  
I know `x` and `y` such that:

```

3x + 2y = 16
x - y = 2

```

**Prover:**  
Computes `A = xG` and `B = yG`.

**Verifier:**  
Checks that:
```

3A + 2B == 16G
A - B == 2G

```

**File:** `proof2.py`

---

## Proof 3 – Scalar Multiplication Knowledge

**Claim:**  
I know `x` such that:

```

23x = 161

```

**Prover:**  
Computes `A = xG`.

**Verifier:**  
Checks that:
```

23A == 161G

```

**File:** `proof3.py`

**Generalization:**  
For a single linear equation:
```

a₁x₁ + a₂x₂ + ... + aₙxₙ = C

```
The verifier checks:
```

a₁X₁ + a₂X₂ + ... + aₙXₙ == C * G

```

---

## Proof 4 – General Linear Combination Knowledge

**Claim:**  
I know secret values `x₁, x₂, …, xₙ` such that:

```

a₁x₁ + a₂x₂ + ... + aₙxₙ = C

```

**Prover:**  
Computes commitments:
```

Xᵢ = xᵢG  for i = 1..n

```

**Verifier:**  
Checks that:
```

a₁X₁ + a₂X₂ + ... + aₙXₙ == C * G

```

**Example:**  
If `2x₁ + 3x₂ + 5x₃ = 46`, the verifier checks:
```

2X₁ + 3X₂ + 5X₃ == 46G

````

**File:** `proof4.py`

---

## Security Assumption

Security relies on the **discrete logarithm problem**:  
Given a point `P = xG`, it is computationally infeasible to determine `x`.  
BN128 offers approximately **128 bits of security**.

---

## Files

| File         | Description                                      |
|--------------|--------------------------------------------------|
| `proof1.py`  | Proves knowledge of `x, y` where `x + y = 15`     |
| `proof2.py`  | Proves knowledge of `x, y` for a linear system    |
| `proof3.py`  | Proves knowledge of `x` in a scalar relation      |
| `proof4.py`  | General proof for linear combinations of secrets |

---

## Requirements

Install dependencies:
```bash
pip install py_ecc
````

Run examples:

```bash
python proof1.py
python proof2.py
python proof3.py
python proof4.py
```
