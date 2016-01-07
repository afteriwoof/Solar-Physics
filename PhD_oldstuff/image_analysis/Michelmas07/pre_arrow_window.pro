; Code to do the canny_atrous2d and necessary declarations for calling arrow_mask

; Last Edited: 09-10-07

PRO pre_arrow_window, da, hdr, ims, win, mov

sz = size(da, /dim)

mov = fltarr(sz[0], sz[1], sz[2])

for k=3,3 do begin

	canny_atrous2d, da[*,*,k], modgrad, alpgrad, rows=rows, columns=columns

	;normalise
	modgrad5 = modgrad[*,*,5]/max(modgrad[*,*,5])
	maxmod5 = max(modgrad[*,*,5])
	modgrad5 = modgrad5*50*maxmod5 * win[*,*,k]
	alpgrad5 = alpgrad[*,*,5] * win[*,*,k]
	row5 = rows[*,*,5] * win[*,*,k]
	col5 = columns[*,*,5] * win[*,*,k]

	arrow_mask_window, ims[*,*,k], hdr[k], row5, col5, modgrad5, alpgrad5
	
	;mov[*,*,k] = tvrd()

endfor

END
