; After running noblink.pro now performing running difference

diffn = fltarr(1024,1024,14)

diffnb = diffn

for i=0,13 do begin & $

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i) & $

	diffnb(*,*,i) = bytscl(diffn(*,*,i), -10, 18) & $

endfor



