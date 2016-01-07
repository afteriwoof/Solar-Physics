; Code to threshold out of the canny_atrous_nrgf images.

; Last Edited: 03-10-07

PRO spatiotemp, da, modgrads, alpgrads, newim


sz = size(da, /dim)

newim = fltarr(sz[0],sz[1],sz[2])

for k=1,sz[2]-2 do begin

	im = da[*,*,k]
	;plot_image, im
	modgrad = modgrads[*,*,k]
	alpgrad = alpgrads[*,*,k]
	
	for i=1,sz[0]-2 do begin
		for j=1,sz[1]-2 do begin

			pix = im[i,j]
			pix1 = da[i,j,k-1]
			pix2 = da[i,j,k+1]
			
			mc = modgrad[i,j]
			mc1 = modgrad[i+1,j]
			mc2 = modgrad[i,j+1]
			mc3 = modgrad[i-1,j]
			mc4 = modgrad[i,j-1]

			mp = modgrads[i,j,k-1]
			mp1 = modgrads[i+1,j,k-1]
			mp2 = modgrads[i,j+1,k-1]
			mp3 = modgrads[i-1,j,k-1]
			mp4 = modgrads[i,j-1,k-1]

			mn = modgrads[i,j,k+1]
			mn1 = modgrads[i+1,j,k+1]
			mn2 = modgrads[i,j+1,k+1]
			mn3 = modgrads[i-1,j,k+1]
			mn4 = modgrads[i,j-1,k+1]
			
			ac = alpgrad[i,j]
			ac1 = alpgrad[i+1,j]
			ac2 = alpgrad[i,j+1]
			ac3 = alpgrad[i-1,j]
			ac4 = alpgrad[i,j-1]
			
			ap = alpgrads[i,j,k-1]
			ap1 = alpgrads[i+1,j,k-1]
			ap2 = alpgrads[i,j+1,k-1]
			ap3 = alpgrads[i-1,j,k-1]
			ap4 = alpgrads[i,j-1,k-1]

			an = alpgrads[i,j,k+1]
			an1 = alpgrads[i+1,j,k+1]
			an2 = alpgrads[i,j+1,k+1]
			an3 = alpgrads[i-1,j,k+1]
			an4 = alpgrads[i,j-1,k+1]
			
			
			acpdiff = abs(ac-ap)
			if (acpdiff gt 10) then begin
			       if abs(ac-ac1) gt 10 or abs(ac-ac2) gt 10 or abs(ac-ac3) gt 10 $
				       or abs(ac-ac4) gt 10 then begin
				       if abs(ac-ac1) lt 30 OR abs(ac-ac2) lt 30 OR $
					       abs(ac-ac3) lt 30 OR abs(ac-ac4) lt 30 $
					       then newim[i,j,k]=im[i,j]
			       endif
		       	endif
			
		endfor
	endfor
	;plot_image, newim[*,*,k]
endfor	

END
