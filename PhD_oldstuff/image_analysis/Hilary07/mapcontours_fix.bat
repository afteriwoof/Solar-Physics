; Batch file to accompany the writing of mapcontours_fast.pro

; Last Edited: 22-02-07


;fls = file_search('~/PhD/Data_from_Alex/18-apr-00/*.fts')

;mreadfits, fls, in, da 
restore, 'da.sav'
restore, 'in.sav'

da = float(da)

da_norm = da
danb = da
sz = size(da, /dim)

;for i=0,sz[2]-1 do begin & $

;	im = da(*,*,i) & $

;	rm_inner, im, in[i], dr, thr=2.1 & $

;	da(*,*,i) = fmedian(im,5,3) & $

;	da_norm(*,*,i) = da(*,*,i) / in[i].exptime & $
	
;	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225) & $

;endfor

restore, 'da_norm.sav'
restore, 'danb.sav'

diffn = fltarr(sz[0],sz[1],sz[2]-1)
diffnb = diffn

for i=0,sz[2]-2 do begin & $

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i) & $

	diffnb(*,*,i) = bytscl(diffn(*,*,i), -10, 18) & $

endfor

newin = in(0:13)

index2map, newin, diffn, maps

index2map, newin, diffnb, mapsb

szd = size(diffn, /dim)

;loadct, 3

for i=0,szd[2]-1 do begin & $
;for i=0,0 do begin & $

	mu = moment( diffn(50:200, 200:950, i), sdev=sdev ) & $
	thresh = mu[0] + 3.*sdev & $

	contour, diffn(*,*,i),level=thresh,/over,path_info=info,path_xy=xy,/path_data_coords,c_color=3,thick=2 & $

	xy_org = xy & $
	
	xy(0,*) = ( xy(0,*)-in[i].crpix1 ) * in[i].cdelt1 & $
	xy(1,*) = ( xy(1,*)-in[i].crpix2 ) * in[i].cdelt2 & $

	plot_map, mapsb[i] & $

	;plots, xy(*,info[0].offset:(info[0].offset+info[0].n -1)),linestyle=0,/data & $
	;plots, xy(*,info[1].offset:(info[1].offset+info[1].n -1)),linestyle=0,/data & $

	k = 0 & $
                
	x_org = xy_org(0,info[k].offset:(info[k].offset+info[k].n-1)) & $
        y_org = xy_org(1,info[k].offset:(info[k].offset+info[k].n-1)) & $
	recpol, x_org, y_org, r_org, a_org, /degrees & $
	
	x = xy(0,info[k].offset:(info[k].offset+info[k].n-1)) & $
	y = xy(1,info[k].offset:(info[k].offset+info[k].n-1)) & $
	recpol, x, y, r, a, /degrees & $

	a_max1 = max(a) & $
	a_min1 = min(a) & $
	
	a = round(a) & $
	r = round(r) & $

	a_max = max(a) & $
	a_min = min(a) & $

	a_front = fltarr(a_max - a_min +1) & $
	r_front = fltarr(a_max - a_min +1) & $
	temp = 0. & $
	count = a_min & $
	stepsize = 1. & $
	while(count le a_max) do begin & $
		a_front(temp) = count & $
		r_front(temp) = max(r(where(a eq count))) & $
		temp = temp + 1 & $
		count = count + stepsize & $
	endwhile & $
	
	polrec, r_front, a_front, x_front, y_front, /degrees & $


	; Average point of front
	sz_x_front = size(x_front, /dim) & $
	sz_y_front = size(y_front, /dim) & $
	sumx = 0. & $
	sumy = 0. & $		
	count = 0. & $
	while(count lt sz_x_front[0]) do begin & $
		sumx = sumx + x_front[count] & $
		sumy = sumy + y_front[count] & $
		count = count + 1 & $
	endwhile & $
	x_front_bar = sumx / sz_x_front[0] & $
	y_front_bar = sumy / sz_y_front[0] & $

	plots, x_front, y_front & $
	plots, x_front_bar, y_front_bar, psym=7 & $

	recpol, x_front_bar, y_front_bar, r_bar, a_bar, /degrees & $
	r_a_bar = max(r(where(a eq round(a_bar)))) & $
	polrec, r_a_bar, a_bar, x_apex, y_apex, /degrees & $
	plots, x_apex, y_apex, psym=2 & $
	plots, [0,x_apex], [0,y_apex] & $




; Try to find the width from where the mid curve hits the CME contour front
;
;	tol = 200. & $
;	upr = r_bar + tol & $
;	lwr = r_bar - tol & $
;	allow = upr - lwr & $
;	temp = 0. & $
;	sz_r_front = size(r_front, /dim) & $
;	cross = fltarr(sz_r_front) & $
;	for j=0,sz_r_front[0]-2 do begin & $
;		diff = abs(r_front[j] - r_bar) & $
;		if diff le allow then begin & $
;			if j ne 0 then begin & $
;				if diff le temp then begin & $
;					cross[j] = r_front[j] & $
;				endif & $
;			endif else cross[j] = r_front[j] & $
;			temp = diff & $
;		endif & $
;	endfor & $
;
;	a_cross = a_front(where(cross ne 0)) & $
;	sz_a_cross = size(a_cross, /dim) & $
;	diff_cross = fltarr(sz_a_cross[0]-1) & $
;	for j=0,sz_a_cross[0]-2 do begin & $
;		diff_cross[j] = a_cross[j+1] - a_cross[j] & $
;	endfor & $
;	max_pos = where(diff_cross eq max(diff_cross)) & $
;	a_min_cross = a_cross[max_pos] & $
;	a_max_cross = a_cross[max_pos+1] & $
;	r_min_cross = r_front(where(a_front eq a_min_cross[0])) & $
;	r_max_cross = r_front(where(a_front eq a_max_cross[0])) & $
;	polrec, r_min_cross, a_min_cross, x1_cross, y1_cross, /degrees & $
;	polrec, r_max_cross, a_max_cross, x2_cross, y2_cross, /degrees & $

; Attempt2
;	crossing = where(r eq round(r_bar)) & $
;	count = 0 & $
;	while( size(crossing, /dim) ne 2) do begin & $
;		first_cross = crossing & $
;		second_cross = where(r eq round(r_bar)+count) & $
;		print, 'first:' & print, first_cross & $
;		print, 'second:' & print, second_cross & $
;		if second_cross eq -1 then second_cross = where(r eq round(r_bar)-count) & $
;		if second_cross ne -1 then begin & $
;			if a(second_cross) eq a(first_cross) then begin & $
;				crossing = [first_cross] & $
;				print, 'crossing:' & print, crossing & $
;			endif else begin & $
;				crossing = [[first_cross], [second_cross]] & $
;				print, 'crossing_2:' & print, crossing & $
;			endelse & $
;		endif & $
;		count = count + 1 & $
;	endwhile & $
;
;	polrec, round(r_bar), a(crossing), xedge, yedge, /degrees & $
;

; Attempt 3
	n = 25 & $
	count = 1 & $
	sign = 0 & $
	crossing = where(r eq round(r_bar)) & $
	range = [crossing] & $
	while (size(range,/dim) lt n) do begin & $
		if sign mod 2 eq 0 then crossings = where(r eq round(r_bar)+count) & $
		if sign mod 2 eq 1 then crossings = where(r eq round(r_bar)-count) & $
		range = [range,[crossings]] & $
		print, 'range:' & print, range & $
		count = count + 1 & $
		sign = sign + 1 & $
	endwhile & $
	
	a_width = max(a(range)) - min(a(range)) & $
	print, 'a_width:' & print, a_width & $

	polrec, r_bar, max(a(range)), x_width, y_width, /degrees & $
	plots, x_width, y_width, psym=7 & $
	polrec, r_bar, min(a(range)), x_width2, y_width2, /degrees & $
	plots, x_width2, y_width2, psym=7 & $

endfor & $

	
end	

	







