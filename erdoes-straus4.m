Clear[FindESSolution]

FindESSolution[n_Integer, offsetLimit_Integer, divisorLimit_Integer] := Module[
  {aStart, a, k, target, d, b, c},
  
  aStart = Floor[n/4] + 1;
  
  Do[
    a = aStart + da;
    k = 4 a - n;
    If[k <= 0, Continue[]];
    
    target = n a;
    
    Do[
      If[Mod[target, d] =!= 0, Continue[]];
      
      b = (target + d)/k;
      If[! IntegerQ[b] || b <= 0, Continue[]];
      
      c = (target b)/d;
      If[! IntegerQ[c] || c <= 0, Continue[]];
      
      If[4 a b c == n (b c + a c + a b),
        Return[{a, b, c}];
      ],
      {d, 1, divisorLimit}
    ],
    {da, 0, offsetLimit - 1}
  ];
  
  Return[None]
]

(* Example calls *)
FindESSolution[17, 10, 100]
FindESSolution[1000003, 10, 100]
FindESSolution[1000000000039, 500, 5000]
