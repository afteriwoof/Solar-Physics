; Code which uses the atrous wavelet to view data according to scales.
; Then the Canny edge detector is used to obtain the modulus maxima of the derivative of the wavelet convolution.
; Contouring brings out the detected edges.

pro WTMM4

;restore, '~/PhD/Data_sav_files/da.sav' ;18apr2000
;restore, '~/PhD/Data_sav_files/in.sav'

;fls = file_search('~/PhD/Data_from_James/21apr2002-lvl1/*.fts')
;mreadfits, fls, in, da
;c2 = da[*,*,where(in.detector eq 'C2')]
;c3 = da[*,*,where(in.detector eq 'C3')]
;save, c2, filename='c2.sav'
;save, c3, filename='c3.sav'
restore, 'c2.sav'
restore, 'c3.sav'
restore, 'in_c2.sav'
restore, 'in_c3.sav'

sz_c2 = size(c2, /dim)
sz_c3 = size(c3, /dim)

;decomps_c2 = fltarr(sz_c2[0], sz_c2[1], 10, sz_c2[2])
;decomps_c3 = fltarr(sz_c3[0], sz_c3[1], 10, sz_c3[2])

;for i=0,sz_c2[2]-1 do begin
;	atrous, c2[*,*,i], decomp=decomp
;	decomps_c2[*,*,*,i] = decomp
;endfor

;for i=0,sz_c3[2]-1 do begin
;	atrous, c3[*,*,i], decomp=decomp
;	decomps_c3[*,*,*,i] = decomp
;endfor

;save, decomps_c2, filename='decomps_c2.sav'
;save, decomps_c3, filename='decomps_c3.sav'
;restore, 'decomps_c2.sav'
;restore, 'decomps_c3.sav'



;restore, '~/PhD/Data_sav_files/da_norm.sav'
;restore, '~/PhD/Data_sav_files/danb.sav'

;restore, '~/PhD/Data_sav_files/decomps.sav' ; the decompositions of the data [*,*,*,10]

;zeroths = decomps[*,*,0,*]
;firsts = decomps[*,*,1,*]
;seconds = decomps[*,*,2,*]
;thirds = decomps[*,*,3,*]
;fourths = decomps[*,*,4,*]
;fifths = decomps_c3[*,*,5,*]
;sixths = decomps_c3[*,*,6,*]
;sevenths = decomps_c3[*,*,7,*]
;eights = decomps[*,*,8,*]
;ninths = decomps[*,*,9,*]
;save, zeroths, filename='zeroths.sav'
;save, firsts, filename='firsts.sav'
;save, seconds, filename='seconds.sav'
;save, thirds, filename='thirds.sav'
;save, fourths, filename='fourths.sav'
;save, fifths, filename='fifths_c3.sav'
;save, sixths, filename='sixths_c3.sav'
;save, sevenths, filename='sevenths_c3.sav'
;save, eights, filename='eights.sav'
;save, ninths, filename='ninths.sav'

;restore, 'fourths.sav'
restore, 'fifths_c3.sav'
restore, 'sixths_c3.sav'
restore, 'sevenths_c3.sav'

sz_fifths = size(fifths, /dim) ; [1024,1024,1,14]
array = fltarr(678, 656, sz_fifths[3])
;mapsnb = fltarr(1024,1024,14)
;restore, 'mapsnb_wtmm.sav'
index2map, in_c3, c3, maps_c3
save, maps_c3, filename='maps_c3.sav'

for i=0,sz_fifths[3]-1 do begin
	plot_map, maps_c3[i]
	result = canny(fifths[*,*,*,i],high=0.72,low=0.)
	contour, result, level=0.001, /over, path_info=info, path_xy=xy, $
		/path_data_coords, c_color=3, thick=2
	xy_org = xy
	xy(0,*) = ( xy(0,*)-in_c3[i].crpix1 ) * in_c3[i].cdelt1
	xy(1,*) = ( xy(1,*)-in_c3[i].crpix2 ) * in_c3[i].cdelt2
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


wr_movie, 'fifths_c3', array



end
