; Procedure to model a CME propagating at certain acceleration and deriving the kinemaitcs

; Created: 22-11-2010

pro model_CME

; heights
h = (indgen(10)+1) * 100
; cadence 10mins
t = (indgen(10)+1) * 60*10

plot, t, h, psym=2




end
