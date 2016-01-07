; Code which produces normalised exposure time data array and byte-scaling of same from Alex's data 18-apr-2000.
; Also removes disk surrounding Solar disk.


; This code uses fmedian before it applies the normalisation or bytscl.
; fmedian calls fmedian_slow which takes a long time to run!!!


; The bottom part now includes code to try and contour the CME front as in pg.pro
; And to fit an ellipse to the array of data points.

; Last edited 05-02-07


pro noblink_recpol, xy,danb, diffnb

fls = file_search('../18-apr-2000/*')

mreadfits, fls, in, da

;restore, '~/PhD/18apr2000.sav'

;restore, '~/PhD/in.sav'

; Convert INT array to FLOAT
da = float(da)

da_norm = da

danb = da

sz = size(da, /dim)

; Remove inner disk
for i=0,sz[2]-1 do begin
	im = da(*,*,i)
	rm_inner, im, in[i], dr, thr=2.1
	
	;plot_image, im	
	;stop

	da(*,*,i) = fmedian(im, 5, 3)

	da_norm(*,*,i) = da(*,*,i) / in[i].exptime

	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225)
endfor

; Now computing Running Difference

diffn = fltarr(sz[0],sz[1],sz[2]-1)

diffnb = diffn

for i=0,sz[2]-2 do begin

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i)

	diffnb(*,*,i) = bytscl( diffn(*,*,i), -10, 18)

endfor

szd = size(diffn, /dim)

; Contour / Thresholding

!p.multi = [0,1,2]

for i=0,szd[2]-1 do begin

	mu = moment( diffn(50:200, 200:950, i), sdev=sdev)
	thresh = mu[0] + 3.*sdev
	thresh_lwr = mu[0] - 3.*sdev

	print, 'mu:' & print, mu
	print, 'thresh:' & print, thresh

	set_line_color

	plot_hist, diffn[50:200, 200:950, i], xr=[-10, 10] ; yr=[0,5000]
	plots, [ mu[0], mu[0] ], [0,3000], color=3
	plots, [ thresh, thresh ], [0,3000], color=5
	plots, [ thresh_lwr, thresh_lwr ], [0,3000], color=5

	loadct, 3
	plot_image, diffnb(*,*,i)

	contour, diffn(*,*,i), level=thresh, /over, path_info=info, $
		path_xy=xy, /path_data_coords, c_color=3, thick=2

	plots, xy(*, info[0].offset : (info[0].offset + info[0].n -1) ), $
		linestyle=0, /data

	plots, xy(*, info[1].offset : (info[1].offset + info[1].n -1) ), $
		linestyle=0, /data


	x1 = xy(0, info[0].offset : (info[0].offset + info[0].n -1))
	y1 = xy(1, info[0].offset : (info[0].offset + info[0].n -1))

	x1 = transpose(x1)
	y1 = transpose(y1)

	weights = 0.75/(4.0^2 + 0.1^2)

	p = mpfitellipse(x1,y1)

	phi = dindgen(101) * 2D * !dpi/100

	plots, p(2)+p(0)*cos(phi), p(3)+p(1)*sin(phi)
	
	
	; Transforming to polar coords for each case using recpol, and determining the midpoint in polar coords to transform back to cartesian and plot a line from sun centre to supposed CME apex

	recpol, xy(0,info[0].offset:(info[0].offset+info[0].n-1)), $
		xy(1,info[0].offset:(info[0].offset+info[0].n-1)), r, a, /degrees

	r_ave = (max(r)-min(r))/2. + min(r)


	; Drawing in line from centre to the edge I determined from diffn8 and messing with recpol
	plots, [512.634,633.708], [505.293,87.651]


	; @outeredge.bat
	
	a_int = a
	sz=size(a,/dim)
	for k=0,sz[1]-1 do begin 
	        a_int(*,k)=fix(a(*,k))
	endfor

	;plot, r, a_int

	;for i=0,13 do begin & $

	;window, /free &  plot_image, diffn(*,*,i) & $

	for j=min(a_int),max(a_int) do begin
	        sz1 = size(r(where(a_int eq j)),/dim)
	        if sz1 gt 2 then begin
			array1 = fltarr(1,sz1)
			array1 = r(where(a_int eq j))
			
			polrec, array1, j, xx, yy, /degrees
			plots, xx, yy
		endif
	endfor																			

	
	ans=''
	read, 'ok?', ans

endfor





end

