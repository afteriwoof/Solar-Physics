function assign_scale, scalemasks, da

sz_da = size(da,/dim)
sz = 6./sz_da[2]
gap=6

for k=1,(size(scalemasks,/dim))[2] do begin
	temp = scalemasks[*,*,k-1]
	if round(gap) eq 0 then gap=1.
	temp[where(temp lt round(gap))] = 0
	temp[where(temp ne 0)] = 1
	scalemasks[*,*,k-1] = temp
	gap -= sz
endfor

return, scalemasks

end
