-- THE ANOMALY EXECUTIONER (Lean 4)
set_option linter.unusedVariables false

def find_all_solutions (n : Nat) (a_limit : Nat) (d_limit : Nat) : IO Unit := do
  IO.println s!"--- DEEP ANALYSIS FOR ANOMALY: n = {n} ---"
  let mut found := 0
  let a_start := n / 4 + 1
  
  for da in [0:a_limit] do
    let a := a_start + da
    let k := 4 * a - n
    if k > 0 then
      let target := n * a
      for d in [1:d_limit + 1] do
        if target % d == 0 then
          if (target + d) % k == 0 then
            let b := (target + d) / k
            let c := (target * b) / d
            found := found + 1
            IO.println s!"[LÖSUNG #{found}] a={a}, b={b}, c={c}"
  
  if found == 0 then
    IO.println "[!!!] KEINE LÖSUNG GEFUNDEN. MÖGLICHER GEGENBEWEIS!"
  else
    IO.println s!"--- ANALYSE BEENDET. INSGESAMT {found} LÖSUNGEN GEFUNDEN ---"

def main : IO Unit := do
  -- Deine Fundstelle von 10^30
  let n_anomaly : Nat := 1000000000000000000000000027321
  
  -- Wir bohren 10x tiefer als im Scan
  find_all_solutions n_anomaly 2000 100000

#eval main
