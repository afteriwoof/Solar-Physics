; Want to take out rings of the image

; Last Edited: 20-03-08

pro rings, in, da, alpgrads, modgrads 

sz = size(da, /dim)

s = 1
im = da[*,*,s]

!p.multi=[0,2,1]

stepsize=0.12

black=fltarr(size(im,/dim))
plot_image, black
ring = fltarr(sz[0],sz[1])+1
ring = rm_inner(ring, in[s], dr_px, thr=3.2)
ring = rm_outer(ring, in[s], dr_px, thr=3.22)
ind = where(ring gt 0)
faint = ring
faint[where(faint ne 1)]=.5
plot_image, im*faint
alpring = fltarr(n_elements(ind),5)
modring = alpring
for i=0,4 do alpring[*,i] = alpgrads[ind]
for i=0,4 do modring[*,i] = modgrads[ind]

coords = array_indices(im, ind)
tvscl, faint
for i=0,n_elements(ind)-1,5 do begin
	for j=2,2 do begin
		if modring[i,j] ne 0 then begin
			arrow2, coords[0,i], coords[1,i], alpring[i,j], modring[i,j]*200, /angle, /device, hsize=3
		endif
	endfor
endfor	


for i=0,n_elements(ind)-1 do begin
	for j=2,2 do begin
		if modring[i,j] ne 0 then begin
		arrow2, i,j,alpring[i,j],modring[i,j]*100, /angle, /device, hsize=3
		endif
	endfor
endfor






;for i=10,80 do begin
;	im2 = im
;	im2 = rm_inner(im, in[s], dr_px, thr=(i/10.+stepsize-0.02))
;	im2 = rm_outer(im2, in[s], dr_px, thr=(i/10.+stepsize))
;	
;	ind = where(im2 gt 0)
;	if ind ne [-1] then begin
;		temp=fltarr(n_elements(ind))
;		temp[*] = im2[ind]
;		plot, temp
;	endif
;		
;endfor




end
