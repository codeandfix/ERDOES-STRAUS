---- WARNING: Silly AI Code! Beware of the Dog!
---- Anyway, maybe it works..

-- DER ULTIMATIVE ERDŐS-STRAUS STRESSTEST
-- Fokus auf große Primzahlen und "schwere" Restklassen

def is_es_solution (n a b c : Nat) : Prop :=
  4 * a * b * c = n * (b * c + a * c + a * b)

/-- Der eckige Master-Algo (Optimiert für große n) -/
def find_solution (n : Nat) (offset_limit : Nat) : Option (Nat × Nat × Nat) :=
  let a_start := n / 4 + 1
  (List.range offset_limit).findSome? (fun da =>
    let a := a_start + da
    let k : Int := 4 * a - n
    if k > 0 then
      let k_nat := k.toNat
      -- Wir suchen b als (n*a + d) / k, wobei d ein Teiler von n*a ist
      -- Das ist die effizienteste Form deiner Grundregel
      let target := n * a
      -- Wir prüfen die ersten 5000 möglichen Teiler-Strukturen für b
      (List.range 5000).findSome? (fun d =>
        if d > 0 && target % d == 0 then
          let b := (target + d) / k_nat
          let c := (n * a * b) / d -- c ergibt sich direkt aus der Teilbarkeit
          if 4 * a * b * c = n * (b * c + a * c + a * b) then some (a, b, c) else none
        else none
      )
    else none
  )

-- DEFINITION DER TESTFÄLLE (Schwere Primzahlen)
def test_cases : List Nat := [
  173,          -- Kleine "unbequeme" Primzahl
  1009,         -- Erste Primzahl über 1000
  1000003,      -- Deine Millionen-Primzahl
  1000000007,   -- Berühmte große Primzahl (10^9 + 7)
  1201,         -- Harte Restklasse (1201 mod 840 = 361)
  1000000000039, -- Eine Billion-Primzahl
  1000000000000000039,
  1000000000000000001
]

-- AUSFÜHRUNG DER VALIDIERUNG
#eval test_cases.map (λ n => (n, find_solution n 500))

/-!
### Was wir hier validieren:
1. **Skalierbarkeit**: Findet der Algo Lösungen für n = 10^12?
2. **Effizienz**: Rastet er bei großen Zahlen schnell ein?
3. **Korrektheit**: Die Rückgabe von 'some' garantiert die mathematische Wahrheit.
-/
