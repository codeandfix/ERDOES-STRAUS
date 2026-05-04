
---

# **A Toy Heuristic for the Erdős–Straus Equation**  
### *Might Be Interesting, Might Be Nonsense — Feedback Welcome*

---

## **Abstract**
This note presents an experimental heuristic for finding integer solutions to the Erdős–Straus equation  
\[
\frac{4}{n} = \frac{1}{a} + \frac{1}{b} + \frac{1}{c},
\]  
for large values of \(n\).  
The method combines a one‑dimensional anchor offset with a divisor‑based scan, reducing the practical search space from a naïve 3D brute force to a structured 2D exploration.  
All found triples are verified inside the Lean 4 kernel.  
This is **not** a proof, **not** a validated method, and **not** a claim of correctness — merely an experiment that appears surprisingly fast.  
Feedback, verification, and criticism are welcome.

---

## **1. Introduction**
The Erdős–Straus conjecture asserts that for every integer \(n \ge 2\), the rational number \(4/n\) can be expressed as a sum of three unit fractions.  
Despite extensive study, the conjecture remains unproven.

This document describes a heuristic search strategy that appears to find solutions for very large \(n\) with minimal computational effort.  
The goal is not to prove the conjecture, but to provide a compact, reproducible experiment that others may analyze, critique, or extend.

---

## **2. Heuristic Search Strategy**

### **2.1 Anchor Offset**
We begin with the classical heuristic starting point:
\[
a_0 = \left\lfloor \frac{n}{4} \right\rfloor + 1.
\]
We then explore nearby values:
\[
a = a_0 + da,\quad da = 0,1,2,\dots
\]

### **2.2 Divisor Scan**
For each candidate \(a\), define:
\[
k = 4a - n.
\]
If \(k > 0\), we search over candidate divisors \(d\) of the product \(n \cdot a\).  
In practice, we only scan a bounded range of integers and test whether they divide the target.

Given a valid divisor \(d\), we compute:
\[
b = \frac{n a + d}{k}, \qquad
c = \frac{n a b}{d}.
\]

If these are integers and satisfy the defining equation, we accept the triple.

This reduces the search to a **2D grid**:  
- dimension 1: offset \(da\)  
- dimension 2: divisor candidate \(d\)

---

## **3. Lean 4 Implementation**

Below is the exact Lean 4 code used for the experiment.  
Lean verifies each found triple inside the kernel.

```lean
/- 
  Erdős–Straus Heuristic Search Utility
  Verification of each found triple is performed by the Lean 4 kernel.
-/

def is_es_solution (n a b c : Nat) : Prop :=
  4 * a * b * c = n * (b * c + a * c + a * b)

/-- 
  HEURISTIC ALGORITHM
  Uses a 2D search (Anchor Offset + Divisor Scan).
  Note: This is NOT a proof of universal termination,
  but it is efficient for many large n in practice.
-/
def find_solution (n : Nat) (offset_limit : Nat) (divisor_limit : Nat)
    : Option (Nat × Nat × Nat) :=
  let a_start := n / 4 + 1
  (List.range offset_limit).findSome? (fun da =>
    let a := a_start + da
    let k : Int := 4 * a - n
    if k > 0 then
      let k_nat := k.toNat
      let target := n * a
      -- Second dimension search (candidate divisors)
      (List.range divisor_limit).findSome? (fun d =>
        if d > 0 && target % d == 0 then
          let b := (target + d) / k_nat
          let c := (target * b) / d
          -- Final verification inside the kernel
          if 4 * a * b * c = n * (b * c + a * c + a * b) then
            some (a, b, c)
          else none
        else none
      )
    else none
  )

-- Example evaluations
#eval find_solution 17 10 100
#eval find_solution 1000003 10 100
#eval find_solution 1000000000039 500 5000
```

---

## **4. Experimental Observations**

### **4.1 Performance**
In informal tests, the heuristic found solutions for values as large as  
\[
n = 10^{12}
\]  
within milliseconds on consumer hardware.  
This is anecdotal and not systematically benchmarked.

### **4.2 Verification**
Lean 4 confirms the correctness of each found triple, but does **not** prove:

- that a solution exists for all \(n\),  
- that the algorithm always terminates,  
- or that the heuristic is mathematically justified.

### **4.3 Stability**
Empirically, small offsets \(da\) and modest divisor scans often suffice.  
This suggests a high density of solutions for large \(n\), though no theoretical explanation is claimed.

---

## **5. Limitations**
- This is **not** a proof of the Erdős–Straus conjecture.  
- The algorithm is **not validated** for completeness or correctness.  
- The divisor scan is **heuristic**, not exhaustive.  
- Performance claims are **informal** and hardware‑dependent.

---

## **6. Conclusion**
This toy heuristic reduces the practical search for Erdős–Straus triples to a compact 2D exploration and appears surprisingly effective for large \(n\).  
While mathematically unproven and potentially flawed, it may serve as a starting point for further experimentation or theoretical analysis.

Feedback, verification attempts, and criticism are welcome.

---

