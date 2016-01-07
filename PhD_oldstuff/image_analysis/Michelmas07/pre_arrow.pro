; Code to do the canny_atrous2d and necessary declarations for calling arrow_mask

; Last Edited: 28-09-07

PRO pre_arrow, da, hdr, ims, mov

sz = size(da, /dim)

mov = fltarr(sz[0], sz[1], sz[2])

for k=0,sz[2]-1 do begin

	canny_atrous2d, da[*,*,k], modgrad, alpgrad, rows=rows, columns=columns

	;normalise
	modgrad5 = modgrad[*,*,5]/max(modgrad[*,*,5])
	maxmod5 = max(modgrad[*,*,5])
	modgrad5 = modgrad5*300*maxmod5
	alpgrad5 = alpgrad[*,*,5]
	row5 = rows[*,*,5]
	col5 = columns[*,*,5]

	arrow_mask, ims[*,*,k], hdr[k], row5, col5, modgrad5, alpgrad5
	
	mov[*,*,k] = tvrd()

endfor

END
