-- DER UNBESTECHLICHE ERDŐS-STRAUS SOLVER (Lean 4)

/-- 
  Sucht eine Lösung für 4/n = 1/a + 1/b + 1/c.
  Nutzt effiziente for-loops statt List.range, um Memory-Fehler zu vermeiden.
-/
def find_solution (n : Nat) (a_offset_limit d_limit : Nat) : Option (Nat × Nat × Nat) := Id.run do
  let a_start := n / 4 + 1
  
  -- Erster Loop: Wir variieren 'a' leicht oberhalb von n/4
  for da in [0:a_offset_limit] do
    let a := a_start + da
    let k_int : Int := 4 * (a : Int) - (n : Int)
    
    if k_int > 0 then
      let k := k_int.toNat
      let target := n * a
      
      -- Zweiter Loop: Wir suchen einen Teiler 'd', der b und c ganzzahlig macht
      for d in [1:d_limit] do
        -- 1. Sicherheitsriegel: d muss n*a teilen
        if target % d == 0 then
          let numerator := target + d
          -- 2. Sicherheitsriegel: Der Zähler muss durch k teilbar sein für ein ganzzahliges b
          if numerator % k == 0 then
            let b := numerator / k
            let c := (target * b) / d
            
            -- Finaler mathematischer Check (Die absolute Wahrheit)
            if 4 * a * b * c = n * (b * c + a * c + a * b) then
              return some (a, b, c)
            
  return none

/-- Validiert das Ergebnis und gibt Klartext aus -/
def run_validator (n : Nat) : String :=
  -- Wir erhöhen das d_limit auf 100.000 für bessere Trefferchancen
  match find_solution n 500 100000 with

  | some (a, b, c) => s!"[SUCCESS] Lösung gefunden: a={a}, b={b}, c={c}"
  | none           => s!"[FAILED] Keine Lösung im Bereich (a+500, d+100000) für n={n}"

-- DEINE TESTFÄLLE
def test_cases : List Nat := [
  173,
  1000000000000000039,
  -- Die 100-stellige Zahl
  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567891
]

#eval test_cases.map run_validator
