; Determining the bkgrd intensity drop off radially from Sun centre. 
; Note also the difference across the quadrants/poles.

; input image array:  im
; output average intensity ditribution:  bkgrd

; Last edited 24-05-07


pro allbkgrd, im, bkgrd


;window, 0
;!p.multi=[0,2,2]

restore, '~/PhD/Data_sav_files/in.sav'
;restore, '~/PhD/Data_sav_files/dan.sav'

;restore, 'multibkgrd.sav'


ans = ''

newim = fltarr(1024,1024)
newim = rm_inner(im,in[0],dr_px,thr=2.4)
newim = rm_outer(newim,in[0],dr_px,thr=6.)

plot_image, newim


for quadrant=1,4 do begin

;	plot_image, newim
	
;	if quadrant eq 1 then plots, [in[0].crpix1,1023], [in[0].crpix2, in[0].crpix2]
;	if quadrant eq 2 then plots, [in[0].crpix1, in[0].crpix1], [in[0].crpix2, 1024]
;	if quadrant eq 3 then plots, [in[0].crpix1, 0], [in[0].crpix2, in[0].crpix2]
;	if quadrant eq 4 then plots, [in[0].crpix1, in[0].crpix1], [in[0].crpix2, 0]

		

	; Attempting to define a radial line by simply increasing the angle but
	; through the idea of increasing the pixel in the y relative to its position
	; in the x.

	lines = fltarr(2, 512, 40)

	for j=0,511 do begin
		; declaring first radial line
		if quadrant eq 1 then begin
			lines[0,j,0] = in[0].crpix1 + j
			lines[1,j,0] = in[0].crpix2 
		endif else if quadrant eq 2 then begin
			lines[0,j,0] = in[0].crpix1 
			lines[1,j,0] = in[0].crpix2 + j
		endif else if quadrant eq 3 then begin
			lines[0,j,0] = in[0].crpix1 - j
			lines[1,j,0] = in[0].crpix2
		endif else if quadrant eq 4 then begin
			lines[0,j,0] = in[0].crpix1
			lines[1,j,0] = in[0].crpix2 - j
		endif
	endfor

;	oplot, lines[0,*,0], lines[1,*,0] 

	

	index2map, in[0], newim, map


	x_first = fltarr(20)
	y_first = fltarr(20)
	radius = 6000.
	if quadrant eq 1 then theta = 0.
	if quadrant eq 2 then theta = 90.
	if quadrant eq 3 then theat = 180.
	if quadrant eq 4 then theta = 270.
	
	for i=0,19 do begin
		polrec, radius, theta, x, y, /degrees
		x_first[i] = x
		y_first[i] = y
;		plots, [0,x], [0,y]
		theta = theta + 4.5
	endfor


	x_orig = fltarr(20)
	y_orig = fltarr(20)

	for i=0,19 do begin
		x_orig[i] = (x_first[i] / in[0].cdelt1 ) + in[0].crpix1
		y_orig[i] = (y_first[i] / in[0].cdelt2 ) + in[0].crpix2
;		plots, [in[0].crpix1, x_orig[i]], [in[0].crpix2, y_orig[i]]
	endfor
	
;	oplot, [512,512], [512,512], psym=7 
	
	profs = fltarr(512,20)

	result = profile(newim,xx,yy,xi=in[0].crpix1,xf=x_orig[0],yi=in[0].crpix2,yf=y_orig[0])
	

	if quadrant eq 1 then first = result
	if quadrant eq 2 then second = result
	if quadrant eq 3 then third = result
	if quadrant eq 4 then fourth = result
	
	
	
	sz_res = size(result, /dim)

	profs[0:sz_res[0]-1,0] = result

;	plots, [in[0].crpix1, x_orig[0]], [in[0].crpix2, y_orig[0]]
	
	for i=1,19 do begin
		result = profile(newim,xx,yy,xi=in[0].crpix1,xf=x_orig[i],yi=in[0].crpix2,yf=y_orig[i] )
		sz_res = size(result, /dim)
		profs[0:sz_res[0]-1,i] = result
		;oplot, profs[*,i]
;		plots, [in[0].crpix1, x_orig[i]], [in[0].crpix2, y_orig[i]]
		;read, 'ok?', ans
	endfor
	

	temp = fltarr(512, 20)
	
	profs0 = profs[where(profs[*,0] ne 0.), 0]
	
	sz_profs0 = size(profs0,/dim)
	
	temp[0:sz_profs0[0]-1,0] = profs0

;	if quadrant eq 1 then plot, temp[*,0], xr=[-100,300], yr=[0,.01200]
;	if quadrant eq 2 then plot, temp[*,0], xr=[-100,300], yr=[0,.01200]
;	if quadrant eq 3 then plot, temp[*,0], xr=[-100,300], yr=[0,.01200]
;	if quadrant eq 4 then plot, temp[*,0], xr=[-100,300], yr=[0,.01200]
	
	;oplot, temp[*,0]

	for i=0,19 do begin
		profs0 = profs[where(profs[*,i] ne 0.), i]
		sz_profs0 = size(profs0,/dim)
		temp[0:sz_profs0[0]-1,i] = profs0
		;oplot, temp[*,i], color=(i mod 10)
;		oplot, temp[*,i], color=quadrant
;		read, 'ok?', ans
	endfor
	



endfor


print, 'calculating average plots'

; Just obtaining the average distribution from the four 'poles'!

sz_first = size(first, /dim)
average = fltarr(sz_first[0])
for i=0,sz_first[0]-1 do begin
	average[i] = (first[i]+second[i]+third[i]+fourth[i])/4.
endfor
;!p.multi=[0,2,3]
;plot, first
;plot, second
;plot, third
;plot, fourth
;plot, average

bkgrd = average


end
