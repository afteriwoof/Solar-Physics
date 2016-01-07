pro angleinfo, im

restore, '~/PhD/Data_sav_files/dan.sav'
restore, '~/PhD/Data_sav_files/in.sav'

ans = '' 

sz_dan = size(dan,/dim)

for i=0,sz_dan[2]-1 do begin


im = dan[*,*,i]

sz = size(im, /dim)

canny_atrous2d, im, modgrad, alpgrad

im = (modgrad[*,*,3]+modgrad[*,*,4]+modgrad[*,*,5])/modgrad[*,*,0]

im = rm_inner(im, in[i], dr_px, thr=2.6)
im = rm_outer(im, in[i], dr_px, thr=6.29)
im = rm_edges(im, in[i], dr_px, edge=25.)

im = bytscl(im)

plot_image, im^0.6

contour, im, lev=12., /over, path_xy=xy, path_info=info, /path_data_coords
thresh = 12.

newim = im

for a=0,sz[0]-1 do begin
	for b=0,sz[1]-1 do begin
		if im[a,b] lt thresh then newim[a,b]=0.
	endfor
endfor

plot_image, newim^0.6

; Multiplying by the angle image
mult = newim * alpgrad[*,*,7]
index2map, in[i], mult, anglemap


index2map, in[i], newim^0.6, map

plot_map, map

; Scaling for map coords
xy[0,*] = ( xy[0,*]-in[7].crpix1 ) * in[7].cdelt1
xy[1,*] = ( xy[1,*]-in[7].crpix2 ) * in[7].cdelt2

; Number of contours
c = 2

for k=0,c-1 do begin

	x = xy[0,info[k].offset:(info[k].offset+info[k].n-1)]
	y = xy[1,info[k].offset:(info[k].offset+info[k].n-1)]

;	plots, x, y, psym=3

	recpol, x, y, r, a, /degrees

	a_max1 = max(a)
	a_min1 = min(a)

	a = round(a)
	r = round(r)

	a_max = max(a)
	a_min = min(a)

	a_front = fltarr(a_max - a_min +1)
	r_front = fltarr(a_max - a_min +1)
	temp = 0.
	count = a_min
	stepsize = 1.
	while(count le a_max) do begin
		a_front(temp) = count
		if(where(a eq count) eq [-1]) then goto, jump1
		r_front(temp) = max(r(where(a eq count)))
		jump1:
		temp = temp+1
		count = count + stepsize
	endwhile

	polrec, r_front, a_front, x_front, y_front, /degrees

	plots, x_front, y_front, psym=3

	read, 'go on?', ans
	
	plot_map, anglemap
	plots, x_front, y_front, psym=7
	

	
endfor

endfor
	
end



