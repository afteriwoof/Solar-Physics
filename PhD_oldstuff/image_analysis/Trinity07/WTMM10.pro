; Trying to automate the detection of the front and eliminate streamers.

pro WTMM10

loadct, 0

ans = ''

;restore, '~/PhD/Data_sav_files/da.sav' ;18apr00
;restore, '~/PhD/Data_sav_files/in.sav' ;headers


;restore, '~/PhD/Data_sav_files/decomps.sav' ;atrous decompositions
;sz_decomps = size(decomps, /dim)

;scales = fltarr(sz_decomps[0], sz_decomps[1], sz_decomps[2]-1,sz_decomps[3])

;for i=0,sz_decomps[2]-2 do begin
	
;	scales[*,*,i,*] = decomps[*,*,i+1,*] - decomps[*,*,i,*]

;	delvarx, decomps[*,*,i,*]
;endfor

;restore, 'scales.sav'

;sz_scales = size(scales, /dim) ;[1024,1024,9,14]

;thirds = fltarr(sz_scales[0], sz_scales[1], sz_scales[3])
;fourths = fltarr(sz_scales[0], sz_scales[1], sz_scales[3])

;for i=0,sz_scales[3]-1 do begin
;	thirds[*,*,i] = scales[*,*,3,i]
;	fourths[*,*,i] = scales[*,*,4,i]	
;endfor

;save, fourths, filename='fourths_scales.sav'

;restore, 'thirds_scales.sav' ;thirds
restore, 'fourths_scales.sav' ;fourths

;sz_thirds = size(thirds, /dim)
sz_fourths = size(fourths, /dim)

;modgrads = fltarr(sz_fourths[0], sz_fourths[1], sz_fourths[2])
;alpgrads = modgrads
;help, modgrads

;for i=0,sz_fourths[2]-1 do begin
;	canny_atrous2d, fourths[*,*,i], modgrad, alpgrad
;	modgrads[*,*,i] = modgrad[*,*,7]
;	alpgrads[*,*,i] = alpgrad[*,*,7]
;endfor

;save, modgrads, filename='modgrads_scales.sav'
;save, alpgrads, filename='alpgrads_scales.sav'
restore, 'modgrads_scales.sav'
restore, 'alpgrads_scales.sav'

array = fltarr(740, 690, sz_fourths[2])


;for i=0,sz_fourths[2]-1 do begin
for i=8,8 do begin
	
	im = modgrads[*,*,i]^0.25
;	plot_image, im
;	read, ans
	
	result = canny(fourths[*,*,i], high=0.65, low=0.)
;	plot_image, result
;	read, ans

	contour, result, lev=0.001, /over, path_info=info, $
		path_xy=xy, /path_data_coords

;	plots, xy[0,*], xy[1,*], psym=3
;	read, ans

	sz_contour = size(info, /dim)
	points = fltarr(1024,1024)
	
	points[xy[0,*], xy[1,*]] = alpgrads[xy[0,*], xy[1,*]]
;	plot_image, points
;	read, ans
	
	newpoints = fltarr(1024,1024)
	
	
	for k=0,sz_contour[0]-1 do begin
		
		temp = fltarr(1024,1024)
		x = xy[0,info[k].offset:(info[k].offset+info[k].n-1)]
		y = xy[1,info[k].offset:(info[k].offset+info[k].n-1)]
		temp[x,y] = points[x,y]
		mx = max(temp[where(temp ne 0)])
		mn = min(temp[where(temp ne 0)])
		diff = mx - mn

		if diff gt 80 then begin
			;newpoints[x,y] = points[x,y]
			;newpoints[x,y] = 1
		endif
	endfor

	loadct, 0
	plot_image, newpoints
;	read, ans

;	entry = tvrd()
;	array[*,*,i] = entry
	
endfor

;wr_movie, 'WTMM10_forths_h0-65_l0', array

end


