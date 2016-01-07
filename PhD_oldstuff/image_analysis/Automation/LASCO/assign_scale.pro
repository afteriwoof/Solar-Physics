; Changing this from a function to a procedure.

; Last Edited: 20-03-08

pro assign_scale, scalemasks, da, scalemasks_new

sz_da = size(da,/dim)
sz = 6./sz_da[2]
gap=6

scalemasks_new = fltarr(sz_da[0],sz_da[1],sz_da[2])

for k=1,(size(scalemasks,/dim))[2] do begin
	temp = scalemasks[*,*,k-1]
	if round(gap) eq 0 then gap=1.
	temp[where(temp lt round(gap))] = 0
	temp[where(temp ne 0)] = 1
	scalemasks_new[*,*,k-1] = temp
	gap -= sz
endfor

end
