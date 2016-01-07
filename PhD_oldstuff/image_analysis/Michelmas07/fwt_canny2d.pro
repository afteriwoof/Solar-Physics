; Code which takes the canny_atrou2d.pro from James but uses the filteres in Alex's fwt2_mallet.m from the Robbrecht & Bergmans paper.

; Last Edited: 26-09-07

PRO fwt_canny2d, im, modgrad, alpgrad, rows=rows, columns=columns

	im = float(im)
	sz_x = (size(im,/dim))[0]
	sz_y = (size(im,/dim))[1]

	n_scales = floor(alog(sz_x)/5.)/alog(2))

	rows = fltarr(sz_x, sz_y, n_scales+1)
	columns = fltarr(sz_x, sz_y, n_scales+1)

	; calculate the rows WT
	for i=0,sz_y-1 do begin
		fwt_canny, [reverse(reform(im[*,i])),reform(im[*,i]), $
			reverse(reform(im[*,i]))], decomp=res, /mirror_padded
		rows[*,i,*] = res[sz_x:(2*sz_x)-1,*]
	endfor

	; calculate the columns WT
	for i=0,sz_x-1 do begin
		fwt_canny, [reverse(reform(im[i,*])),reform(im[i,*]), $
			reverse(reform(im[i,*]))], decomp=res, /mirror_padded
		columns[i,*,*] = res[sz_y:(2*sz_y)-1,*]
	endfor

	; create the modulus and the argument
	modgrad = rows*0.
	alpgrad = rows*0.
	for i=0,n_scales do begin
		modgrad[*,*,i] = sqrt(rows[*,*,i]^2.+columns[*,*,i]^2.)
		zeros = where(rows[*,*,i] eq 0, zero_count)
		if zero_count ne 0 then begin
			temp = rows[*,*,i]
			temp[zeros] = 3e-8
			arctan, temp, columns[*,*,i], a, adeg
			alpgrad[*,*,i] = adeg
		endif else begin
			arctan, rows[*,*,i], columns[*,*,i], a, adeg
			alpgrad[*,*,i] = adeg
		endelse
	endfor


END
