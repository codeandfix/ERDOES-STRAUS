
# Mathematical Description

## 1. Erdős–Straus Equation

We study integer solutions (a, b, c) in positive integers of the Diophantine equation

4/n = 1/a + 1/b + 1/c.

The Erdős–Straus conjecture asserts that such a decomposition exists for every integer n ≥ 2.

---

## 2. Anchor-Based Reduction of the Search Space

A classical heuristic starting point for a is

a₀ = floor(n/4) + 1.

We then explore nearby values via an offset parameter:

a = a₀ + da,  where  da = 0, 1, 2, …, Lₐ − 1.

For each candidate a, define

k = 4a − n.

Only values with

k > 0

are considered further.

---

## 3. Divisor-Driven Construction of b and c

For each valid a, define the product

T = n · a.

We scan candidate divisors d in the range

d = 1, 2, …, L_d.

A divisor is admissible if it divides T, i.e.

d | T.

Given such a divisor, the corresponding values of b and c are computed by

b = (T + d) / k  
c = (T · b) / d.

We require

b > 0 and c > 0 and both integers.

---

## 4. Verification Condition

A triple (a, b, c) is accepted if it satisfies the polynomial identity

4abc = n(bc + ac + ab),

which is equivalent to the original unit-fraction equation

4/n = 1/a + 1/b + 1/c.

---

## 5. Summary of the Heuristic Structure

The method reduces the practical search to two dimensions:

1. Anchor offset: a = a₀ + da  
2. Divisor scan: d divides (n · a)

From these, b and c follow deterministically.

No claim is made about completeness, correctness, or termination; this is purely an empirical search strategy.

---
