; Code which uses the atrous wavelet to view data according to scales.
; Then the Canny edge detector is used to obtain the modulus maxima of the derivative of the wavelet convolution.
; Contouring brings out the detected edges.

pro WTMM

;restore, '~/PhD/Data_sav_files/da.sav' ;18apr2000
restore, '~/PhD/Data_sav_files/in.sav'

;sz_da = size(da, /dim)

;restore, '~/PhD/Data_sav_files/da_norm.sav'
;restore, '~/PhD/Data_sav_files/danb.sav'

;restore, '~/PhD/Data_sav_files/decomps.sav' ; the decompositions of the data [*,*,*,10]

;zeroths = decomps[*,*,0,*]
;firsts = decomps[*,*,1,*]
;seconds = decomps[*,*,2,*]
;thirds = decomps[*,*,3,*]
;fourths = decomps[*,*,4,*]
;fifths = decomps[*,*,5,*]
;sixths = decomps[*,*,6,*]
;sevenths = decomps[*,*,7,*]
;eights = decomps[*,*,8,*]
;ninths = decomps[*,*,9,*]
;save, zeroths, filename='zeroths.sav'
;save, firsts, filename='firsts.sav'
;save, seconds, filename='seconds.sav'
;save, thirds, filename='thirds.sav'
;save, fourths, filename='fourths.sav'
;save, fifths, filename='fifths.sav'
;save, sixths, filename='sixths.sav'
;save, sevenths, filename='sevenths.sav'
;save, eights, filename='eights.sav'
;save, ninths, filename='ninths.sav'


restore, 'fourths.sav'
restore, 'fifths.sav'
restore, 'sixths.sav'

sz_fourths = size(fourths, /dim) ; [1024,1024,1,14]
array = fltarr(678, 656, sz_fourths[3])
;mapsnb = fltarr(1024,1024,14)
restore, 'mapsnb_wtmm.sav'
;index2map, in, danb, mapsnb

for i=0,sz_fourths[3]-1 do begin
	plot_map, mapsnb[i]
	result = canny(fourths[*,*,*,i],high=0.72,low=0)
	contour, result, level=0.001, /over, path_info=info, path_xy=xy, $
		/path_data_coords, c_color=3, thick=2
	xy_org = xy
	xy(0,*) = ( xy(0,*)-in[i].crpix1 ) * in[i].cdelt1
	xy(1,*) = ( xy(1,*)-in[i].crpix2 ) * in[i].cdelt2
	plots, xy[0,*], xy[1,*], psym=3	

	entry = tvrd()
	array[*,*,i] = entry
endfor

;save, mapsnb, filename='mapsnb_wtmm.sav'

;for i=0,sz_fifths[3]-1 do begin

;	plot_image, fifths[*,*,*,i]
;	contour, canny(fifths[*,*,*,i], high=0.74, low=0.), level=0.001, /over
;	entry = tvrd()
;	array[*,*,i] = entry

;endfor


;wr_movie, 'map_fourths_h0-72_l0', array



end
