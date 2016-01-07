; Code to chain through nearest neighbours w.r.t. magnitude on each pixel.

; Last Edited: 04-10-07

PRO mag_chain, da, magchain

s = 1
sz = size(da, /dim)
magchain = fltarr(sz[0],sz[1],sz[2])

for k=1,sz[2]-1 do begin

	im = da[*,*,k]

	for i=1,sz[0]-2 do begin
		for j=1,sz[1]-2 do begin

			modpix = im[i,j]
			if modpix ne 0 then begin
				modpix1 = im[i+1,j]
				modpix2 = im[i+1,j+1]
				modpix3 = im[i,j+1]
				modpix4 = im[i-1,j+1]
				modpix5 = im[i-1,j]
				modpix6 = im[i-1,j-1]
				modpix7 = im[i,j-1]
				modpix8 = im[i+1,j-1]

				premod = da[i,j,k-1]
				if ((modpix-premod) gt premod) then begin
				
				if ((abs(modpix-modpix1) lt s*modpix1) OR $
				      	(abs(modpix-modpix2) lt s*modpix2) OR $
					(abs(modpix-modpix3) lt s*modpix3) OR $
					(abs(modpix-modpix4) lt s*modpix4) OR $
					(abs(modpix-modpix5) lt s*modpix5) OR $
					(abs(modpix-modpix6) lt s*modpix6) OR $
					(abs(modpix-modpix7) lt s*modpix7) OR $
					(abs(modpix-modpix8) lt s*modpix8)) $
					then magchain[i,j,k]=1
				endif
			endif	
		endfor
	endfor
endfor

;for k=0,sz[2]-1 do begin
	
;	for i=1,sz[0]-2 do begin
;		for j=1,sz[1]-2 do begin
	
;			p = magchain[i,j,k]
;			p1 = magchain[i+1,j,k]
;			p2 = magchain[i+1,j+1,k]
;			p3 = magchain[i,j+1,k]
;			p4 = magchain[i-1,j+1,k]
;			p5 = magchain[i-1,j,k]
;			p6 = magchain[i-1,j-1,k]
;			p7 = magchain[i,j-1,k]
;			p8 = magchain[i+1,j-1,k]

;			if (p1 ne p AND p2 ne p AND p3 ne p AND p4 ne p AND $
;				p5 ne p AND p6 ne p AND p7 ne p AND p8 ne p) $
;				then magchain[i,j,k]=0
;		endfor
;	endfor
	
;endfor



END
