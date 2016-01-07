; Code which uses the atrous wavelet to view data according to scales.
; Then the Canny edge detector is used to obtain the modulus maxima of the derivative of the wavelet convolution.
; Contouring brings out the detected edges.

pro WTMM6, xy, info, points, temp, alpgrads

loadct, 3

ans = ''

;restore, '~/PhD/Data_sav_files/da.sav' ;18apr2000
;restore, '~/PhD/Data_sav_files/in.sav'
;restore, '~/PhD/Data_sav_files/da_norm_221194.sav'
;restore, '~/PhD/Data_sav_files/in_221194.sav'
;restore, '~/PhD/Data_sav_files/pb.sav'


;decomps = fltarr(sz[0], sz[1], 10, sz[2])
;for i=0,sz[2]-1 do begin
;	atrous, da[*,*,i], decomp=decomp
;	decomps[*,*,*,i] = decomp
;endfor
;save, decomps, filename='decomps_pb.sav'
;restore, '~/PhD/Data_sav_files/decomps_pb.sav' ; the decompositions of the data [*,*,*,10]
;restore, '~/PhD/Data_sav_files/decomps.sav'

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
;save, zeroths, filename='zeroths_pb.sav'
;save, firsts, filename='firsts_pb.sav'
;save, seconds, filename='seconds_pb.sav'
;save, thirds, filename='thirds_pb.sav'
;save, fourths, filename='fourths_pb.sav'
;save, fifths, filename='fifths_pb.sav'
;save, sixths, filename='sixths_pb.sav'
;save, sevenths, filename='sevenths_pb.sav'
;save, eights, filename='eights_pb.sav'
;save, ninths, filename='ninths_pb.sav'


;restore, 'fourths.sav'
restore, 'fifths.sav'
;restore, 'sixths.sav'
fifth = fifths[*,*,*,8]
delvarx, fifths

;sz_fifths = size(fifths, /dim) ; [1024,1024,1,14]
;array = fltarr(678, 656, sz_fifths[3])
;modgrads = fltarr(1024, 1024, sz_fifths[3])
;alpgrads = modgrads
;restore, 'mapsnb_221194.sav'
;index2map, in, da, maps

;for i=0,sz_fifths[3]-1 do begin
;	canny_atrous2d, fifths[*,*,*,i], modgrad, alpgrad
;	modgrads[*,*,i] = modgrad[*,*,7]
;	alpgrads[*,*,i] = alpgrad[*,*,7]
;endfor
;save, modgrads, filename='modgrads.sav'
;save, alpgrads, filename='alpgrads.sav'
restore, 'modgrads.sav'
restore, 'alpgrads.sav'
modgrad = modgrads[*,*,7]
delvarx, modgrads
alpgrad = alpgrads[*,*,7]
delvarx, alpgrads

;for i=0,sz_fifths[3]-1 do begin
;	plot_map, maps[i]
;	result = canny(modgrads[*,*,i]^0.25, high=0.85, sigma=10.)
;	contour, result, level=0.001, /over, path_info=info, path_xy=xy, $
;		/path_data_coords, c_color=3, thick=2
;	xy_org = xy
;	xy(0,*) = ( xy(0,*)-in[i].crpix1 ) * in[i].cdelt1
;	xy(1,*) = ( xy(1,*)-in[i].crpix2 ) * in[i].cdelt2
;	plots, xy[0,*], xy[1,*], psym=3	

	;plot_image, modgrads[*,*,i]^0.25
	;plot_image, alpgrads[*,*,i]
;	entry = tvrd()
;	array[*,*,i] = entry
;endfor

tst = modgrad^0.25
plot_image, tst
result = canny(fifth)
plot_image, result

contour,canny(fifth),lev=0.001,/over,path_info=info,path_xy=xy,/path_data_coords

help, xy, info
plots, xy[0,*], xy[1,*], psym=3

plot_image, alpgrad
plots, xy[0,*], xy[1,*], psym=3

points = fltarr(1024, 1024)
points[xy[0,*], xy[1,*]] = alpgrad[xy[0,*], xy[1,*]]
plot_image, points

;Taking one of the radial lines
x = xy[0,info[8].offset:(info[8].offset+info[8].n-1)]
y = xy[1,info[8].offset:(info[8].offset+info[8].n-1)]

temp = fltarr(1024,1024)
temp[x, y] = points[x, y]
plot_image, temp


set_line_color
sz_contour = size(info, /dim)
temp = fltarr(1024,1024)

newpoints = fltarr(1024,1024)

for k=0,sz_contour[0]-1 do begin
	
	temp = fltarr(1024,1024)
	x = xy[0,info[k].offset:(info[k].offset+info[k].n-1)]
	y = xy[1,info[k].offset:(info[k].offset+info[k].n-1)]
	temp[x,y] = points[x,y]
	
	mn = mean(temp[where(temp ne 0)])
	mx = max(temp[where(temp ne 0)])
	mi = min(temp[where(temp ne 0)])

	diff = mx - mi

	if diff gt 60 then begin
		newpoints[x,y] = points[x,y]
	endif
	
;	plots, xy[0,info[k].offset:(info[k].offset+info[k].n-1)], $
;		xy[1,info[k].offset:(info[k].offset+info[k].n-1)], psym=3, color=5

endfor

plot_image, newpoints

;save, mapsnb, filename='mapsnb_221194.sav'

;for i=0,sz_fifths[3]-1 do begin

;	plot_image, fifths[*,*,*,i]
;	contour, canny(fifths[*,*,*,i], high=0.74, low=0.), level=0.001, /over
;	entry = tvrd()
;	array[*,*,i] = entry

;endfor


;wr_movie, 'alpgrads', array



end
