pro mycontour

;
; A simple programme
;

npts = 256 ;no of points
nsig = 4. ;no of sigma

x = -nsig + findgen(npts)/float(npts) *2*nsig

gs = fltarr(npts,npts)

for j=0,npts-1 do begin
	for i=0,npts-1 do begin
		gs[i,j] = exp(-(x[i]^2 + x[j]^2) /2.)
	endfor
endfor

contour, gs, x, x, nlev=255, /iso, /fill

end
