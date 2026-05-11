-- ERDŐS-STRAUS ANOMALY SCANNER (Lean 4)
set_option linter.unusedVariables false

/-- Zählt, wie viele Lösungen im Fenster (a_lim, d_lim) existieren -/
def count_solutions (n : Nat) (a_limit : Nat) (d_limit : Nat) : Nat := Id.run do
  let mut count := 0
  let a_start := n / 4 + 1
  for da in [0:a_limit] do
    let a := a_start + da
    let k := 4 * a - n
    if k > 0 then
      let target := n * a
      for d in [1:d_limit + 1] do
        if target % d == 0 then
          if (target + d) % k == 0 then
            count := count + 1
  return count

def scan_anomalies (start_n : Nat) (iterations : Nat) : IO Unit := do
  IO.println s!"--- ANOMALY SCAN @ n = {start_n} ---"
  let mut current := start_n
  for i in [1:iterations + 1] do
    -- Wir picken nur die statistisch härtesten Fälle
    if current % 840 == 1 then
      let solutions := count_solutions current 100 5000
      
      -- Wenn eine Zahl im Testfenster KEINE oder nur EINE Lösung hat, ist sie eine Anomalie
      if solutions <= 1 then
        IO.println s!"[!!!] ANOMALIE GEFUNDEN: n = {current} (Lösungen im Testfenster: {solutions})"
    
    if i % 10000 == 0 then
      IO.println s!"[PROGRESS] {i} geprüft..."
    
    current := current + 1

def main : IO Unit := do
  -- Wir gehen auf 10^30 - ein Bereich, der fast völlig unerforscht ist
  let start_point : Nat := 1000000000000000000000000000000 + 1
  scan_anomalies start_point 50000

#eval main
