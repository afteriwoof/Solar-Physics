; Code which determines from a running difference, where the CME is and creates a window.
; This window can then be the area on which the multiscale analysis works -> faster!

; Last Edited: 26-09-07

PRO CME_window, dafn, in, diff, sectors

	sz = size(dafn, /dim)

;	bkgrd = min(dafn, dim=3)
	
;	ring = bkgrd
;	for i=0,sz[0]-1 do begin
;		for j=0,sz[1]-1 do begin
;			distance = sqrt( (i-in[0].crpix1)^2 + (j-in[0].crpix2)^2 )
;			if distance gt 450 then ring[i,j]=0
;			if distance lt 250 then ring[i,j]=0
;		endfor
;	endfor

;	features = fltarr(sz[0], sz[1], sz[2])
;	for i=0,sz[2]-1 do begin
;		features[*,*,i] = dafn[*,*,i] - bkgrd
;		plot_image, features[*,*,i]
;		pause
;	endfor
;	index2map, in, features, fmaps
	
	; Create running difference array
	diff = fltarr(sz[0], sz[1], sz[2]-1)
	for i=0,sz[2]-2 do begin
		diff[*,*,i] = dafn[*,*,i+1] - dafn[*,*,i]
		diff[*,*,i] = rm_inner(diff[*,*,i], in[i], dr_px, thr=2.25)
	endfor
	newin = in[1:sz[2]-1]
	index2map, newin, diff, maps
	szmap = size(maps.data, /dim)
	
	sectors = fltarr(sz[0], sz[1], sz[2]-1)
	
	; Main body
	for i=0,sz[2]-2 do begin
	
		plot_image, sigrange(diff[*,*,i])
		
		mu = moment( diff[*,*,i], sdev=sdev )
		thresh = mu[0] + 3*sdev
	
		contour, diff[*,*,i], lev=thresh, /over	
		contour, diff[*,*,i], level=thresh, /over, path_info=info, $
			path_xy=xy, /path_data_coords, thick=2
		xy_org = xy
		xy[0,*] = ( xy[0,*]-in[i].crpix1 ) * in[i].cdelt1
		xy[1,*] = ( xy[1,*]-in[i].crpix2 ) * in[i].cdelt2

		; c is number of contours
		c=1
		for k=0,c-1 do begin

			x_map = xy[0,info[k].offset:(info[k].offset+info[k].n-1)]
			y_map = xy[1,info[k].offset:(info[k].offset+info[k].n-1)]
			recpol, x_map, y_map, r, a

			plot, r, a, psym=3
			pause
			a_max1 = max(a)
			a_min1 = min(a)
			a = round(a)
			r = round(r)
			a_max = max(a)
			a_min = min(a)
			a_front = fltarr(a_max - a_min +1)
			r_front = fltarr(a_max - a_min +1)
			temp=0
			count = a_min
			stepsize=1
			while(count le a_max) do begin
				a_front[temp] = count
				if (where(a eq count) eq [-1]) then goto, jump1
				r_front[temp] = max(r(where(a eq count)))
				jump1:
				temp += 1
				count += stepsize
			endwhile
			polrec, r_front, a_front, x_front, y_front

			plot_map, maps[i]
			plots, x_front, y_front, psym=1
			pause

			r_inner = min(r_front) - 5
			r_outer = max(r_front) + 5
			r_sun = ( pb0r(in[i].date_obs, /arc, /soho) )[2]
			thr_inner = (r_inner/r_sun)
			thr_outer = (r_outer/r_sun)
			disc = rm_inner(dafn[*,*,i], in[i], dr_px, thr=thr_inner)
			disc = rm_outer(disc, in[i], dr_px, thr=thr_outer)
			sz_a_front = size(a_front, /dim)
			first_a = a_front[0]
			last_a = a_front[sz_a_front]
			sectors[*,*,i] = rm_sector(disc, in[i], dr_px, thr1=first_a, thr2=last_a, mask)
		endfor	
	endfor
			
			
	









END
