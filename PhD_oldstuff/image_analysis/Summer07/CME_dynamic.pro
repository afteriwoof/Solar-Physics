; Code which produces normalised exposure time data array and byte-scaling of same

; Also removes disk surrounding Solar disk.

; This code uses fmedian before it applies the normalisation or bytscl.
; fmedian calls fmedian_slow which takes a long time to run!!!

; Creating MAPS from the data and scaling contour values to maps coords.

; Made tangents to the CME edges and also lines at intervals of ten through CME angle.

; Obtains average point of CME front and deduces the apex.

; Derives width of CME from the maximum width close to the mid curve through ave. point.

; Sample attempt to fit an ellipse to the array of data points.

; Uses ellipse fit to average point of front to give start params for mpfitellipse.pro

; Want to use the difference technique to give an extimate of the disc which the CME lies in.

; Last edited 15-06-07

; This function has been independently written in idl_codes/circle.pro
;function circle, xcenter, ycenter, radius
;
;points = (2*!PI/99.0) * findgen(100)
;
;x = xcenter + radius*cos(points)
;y = ycenter + radius*sin(points)
;
;return, [[x],[y]]
;
;end


pro CME_dynamic, tangents=tangents, previous=previous, lines=lines


loadct, 0
!p.background = 100.

;fls = file_search('~/PhD/Data_from_Alex/18-apr-00/*.fts')
;fls = file_search('~/PhD/Data_from_James/010515/*.fts')

;mreadfits, fls, in, da
;save, da, filename='da.sav'
;save, in, filename='in.sav'
restore, '~/PhD/Data_sav_files/da.sav'
restore, '~/PhD/Data_sav_files/in.sav'

;restore, '~/PhD/Data_sav_files/da_240107.sav'
;restore, '~/PhD/Data_sav_files/in_240107.sav'

;restore, '~/PhD/Data_sav_files/da_221194.sav'
;restore, '~/PhD/Data_sav_files/in_221194.sav'

ans = ''

; Operations to be done on James's data
;c2data = where( in.detector eq 'C2' and in.naxis1 eq 1024)
;mreadfits, fls(c2data), in, c2data
;ssw_fill_cube2, c2data, da

;restore, '~/PhD/Data_sav_files/18apr2000.sav'

;restore, '~/PhD/Data_sav_files/in.sav'

; Convert INT array to FLOAT
da = float(da)

da_norm = da

danb = da

sz = size(da, /dim)


;for i=0,sz[2]-1 do begin
	
;	im = da(*,*,i)

	; Remove inner disk
;	im = rm_inner(im, in[i], dr_px, thr=2.2)
	
	; Median operator to smooth noise pixels
;	da(*,*,i) = fmedian(im, 5, 3)

	; Normalising the data with regard to exposure time
;	da_norm(*,*,i) = da(*,*,i) / in[i].exptime

	; Bytscaling for image presentation only.
;	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225)

;	plot_image, da_norm[*,*,i]
	;read, '', ans

;endfor

;save, da_norm, f='dan_240107.sav'
;save, danb, f='danb_240107.sav'

;restore, '~/PhD/Data_sav_files/dan_240107.sav'

;save, da_norm, filename='da_norm.sav'
;save, danb, filename='danb.sav'

;restore, '~/PhD/Data_sav_files/da_norm.sav'
;restore, '~/PhD/Data_sav_files/danb.sav'

;restore, '~/PhD/Data_sav_files/da_norm_221194.sav'
;restore, '~/PhD/Data_sav_files/danb_221194.sav'



restore, '~/PhD/Data_sav_files/dafn_18apr00.sav'


; Now computing Running Difference

diffn = fltarr(sz[0],sz[1],sz[2]-1)

diffnb = diffn

for i=0,sz[2]-2 do begin
        diffn[*,*,i] = dafn[*,*,i+1] - dafn[*,*,i]
endfor


;********
; Creating the background image as in minpix.pro

bkgrd = min(dafn, dim=3)

index2map, in[0], bkgrd, bkgrdmap
plot_map, bkgrdmap
print, 'bkgrd for fixed diff'
plot_image, bkgrd

; Maybe take a disc about the main body of the background image and set that as the threshold basis.

xy1 = circle( in[0].crpix1, in[0].crpix2, 250 )
plots, xy1[*,0], xy1[*,1], psym=3
xy2 = circle( in[0].crpix1, in[0].crpix2, 450)
plots, xy2[*,0], xy2[*,1], psym=3
ring = bkgrd

for i=0,sz[0]-1 do begin
	for j=0,sz[1]-1 do begin
		dist = sqrt( (i-in[0].crpix1)^2 + (j-in[0].crpix2)^2)
		if dist gt 450 then ring[i,j]=0.
		if dist lt 250 then ring[i,j]=0.
	endfor
endfor

plot_image, ring
plot_hist, ring(where(ring ne 0.))


;*****
; Subtract bkgrd from each image to highlight moving features.

features = fltarr(sz[0], sz[1], sz[2])

for i=0,sz[2]-1 do begin
	features[*,*,i] = dafn[*,*,i] - bkgrd
endfor

index2map, in, features, fmaps

szd = size(diffn, /dim)

; Creating maps but note the header isn't being edited (the times will be wrong)!

newin = in[0:szd[2]-1]

index2map, newin, diffn, maps

index2map, newin, diffnb, mapsb

szmap = size(maps.data, /dim)


;For making the movie: 
temparr = fltarr(888, 762, szd[2])

; Contour / Thresholding

delvarx, da, danb

for i=0,szd[2]-1 do begin

	mu = moment( ring[where(ring ne 0.)], sdev=sdev )	
	
	thresh = mu[0] - 5.*sdev
print, mu, sdev

	set_line_color
	loadct, 0
	pmm, features[*,*,i]
	contour, features[*,*,i], level=thresh, /over, path_info=info, $
		path_xy=xy, /path_data_coords, c_color=3, thick=2

	
	; Scaling the xy indices for map, lining up according to the Sun's centre.
	xy_org = xy
	
	xy[0,*] = ( xy[0,*]-in[i].crpix1 ) * in[i].cdelt1
	xy[1,*] = ( xy[1,*]-in[i].crpix2 ) * in[i].cdelt2

	plot_map, fmaps[i]
	
	
	; plotting tangents from previous image, only if keyword tangents is also set.
	if keyword_set(previous) then begin
		if i ne 0 then begin	
			set_line_color
			plots, [0,x_apex], [0,y_apex], color=3
			plots, [0,x_edge1],[0,y_edge1], color=5
			plots, [0,x_edge2],[0,y_edge2], color=4	
		endif
	endif


	; Increase c to include more contours
	c = 1
	for k=0,c-1 do begin

		x_org = xy_org[0,info[k].offset:(info[k].offset+info[k].n-1)]
		y_org = xy_org[1,info[k].offset:(info[k].offset+info[k].n-1)]
	
;***************************************************
		; Calling function ellipsefit.pro to plot ellipse	
		ellipse = ellipsefit(x_org, y_org)
		aprime = ellipse[0:(size(ellipse,/dim)-2)/2-1]
		bprime = ellipse[(size(ellipse,/dim)-2)/2:(size(ellipse,/dim)-2)-1]
	
		aprime = (aprime-in[i].crpix1) * in[i].cdelt1
		bprime = (bprime-in[i].crpix2) * in[i].cdelt2 
		x_bar_org = ellipse[size(ellipse,/dim)-2]
		y_bar_org = ellipse[size(ellipse,/dim)-1]
		x_bar = (x_bar_org-in[i].crpix1) * in[i].cdelt1
		y_bar = (y_bar_org-in[i].crpix2) * in[i].cdelt2	
		set_line_color
;		plots, aprime, bprime, color=2 ;plots my ellipse
;		plots, x_bar, y_bar, psym=4	
;****************************************************


		recpol, x_org, y_org, r_org, a_org, /degrees

		
		x_map = xy[0,info[k].offset:(info[k].offset+info[k].n-1)]
		y_map = xy[1,info[k].offset:(info[k].offset+info[k].n-1)]
		recpol, x_map, y_map, r, a, /degrees

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
		while (count le a_max) do begin
			a_front[temp] = count
			if (where(a eq count) eq [-1]) then goto, jump1
			r_front[temp] = max(r(where(a eq count)))
			jump1:
			temp = temp + 1
			count = count + stepsize
		endwhile

		polrec, r_front, a_front, x_front, y_front, /degrees

		; Average point of front

		sz_x_front = size(x_front, /dim)
		sz_y_front = size(y_front, /dim)
		sumx = 0.
		sumy = 0.
		count = 0.
		while (count lt sz_x_front[0]) do begin
			sumx = sumx + x_front[count]
			sumy = sumy + y_front[count]
			count = count + 1
		endwhile

		x_front_bar = sumx / sz_x_front[0]
		y_front_bar = sumy / sz_y_front[0]

		plots, x_front, y_front
		;plots, x_front_bar, y_front_bar, psym=7
		
		recpol, x_front_bar, y_front_bar, r_bar, a_bar, /degrees
		r_a_bar = max(r[where(a eq round(a_bar))])
		polrec, r_a_bar, a_bar, x_apex, y_apex, /degrees
		;plots, x_apex, y_apex, psym=2	
		;print, 'apex:' & print, r_a_bar	

		;****************
		; Finding the disc of CME position

		r_inner = min(r_front) - 5.
		r_outer = max(r_front) + 5.
		r_sun = (pb0r(in[i].date_obs, /arc, /soho))[2]

		thr_inner = r_inner
		thr_outer = r_outer

		thr_inner = (thr_inner / r_sun)
		thr_outer = (thr_outer / r_sun)

		disc = rm_inner(dafn[*,*,i],in[i],dr_px,thr=thr_inner)
		disc = rm_outer(disc,in[i],dr_px,thr=thr_outer)

		index2map, in[i], disc, discmap
;		plot_map, discmap
	
;		plots, x_front, y_front, color=2

		radius_thresh = r_outer ; <--- This is the value to use for threshold wrt bkgrd	
		print, radius_thresh
		
;		read, 'go on?', ans
		
		;****************

;*****************************************************************

; NOW PUTTING IN THE WAVELET DECOMPS AND SETTING DYNAMIC BKGRD FOR THRESHOLDING AT radius_thresh

		
	
	; From CME_multiscale.pro

		canny_atrous2d, dafn[*,*,i], modgrad, alpgrad

		im_decomp = (modgrad[*,*,3]+modgrad[*,*,4]+modgrad[*,*,5]) / modgrad[*,*,0]

		im_decomp = rm_inner(im_decomp, in[i], dr_px, thr=2.6)
		im_decomp = rm_outer(im_decomp, in[i], dr_px, thr=6.2)
		im_decomp = rm_edges(im_decomp, in[i], dr_px, edge=25.)


	; From allbkgrd.pro

	if i eq 0 then begin
		
		plot_image, im_decomp^0.4, tit='Decomps(3+4+5)/0'
		
		bkgrd_decomp = (modgrad[*,*,3]+modgrad[*,*,4]+modgrad[*,*,5]) / modgrad[*,*,0]

		; Calling allbkgrd to calculate the average radial intensity drop off of image.
	;	allbkgrd, bkgrd_decomp, bkgrd_average
restore, 'temp_bkgrd_ave.sav'
		plot, bkgrd_average
	
	endif


		r_thresh = radius_thresh / in[i].cdelt1
		
		loadct, 0
		plot_map, discmap
		plots, x_front, y_front

;		plot, bkgrd_average
;		plots, [r_thresh,r_thresh], [0,0.012]
		;read,'ok?', ans


	;**********
	; Using idea of scaling the threshold relative to the bkgrd_average intensity drop-off.

		max_dropoff = max(bkgrd_average)
		min_dropoff = min(bkgrd_average)

		percent = (max_dropoff - min_dropoff) / 100.

		median_dropoff = median(bkgrd_average)

		dynamic_thresh = bkgrd_average[r_thresh]
				
	
	; With this New dynamic threshold, now go through the code again!

	
		;pmm, im_decomp
		thresh_dyn = 1.9*dynamic_thresh
		contour, im_decomp, lev=thresh_dyn, path_xy=xy, path_info=info, $
			/path_data_coords
		
		index2map, in[i], im_decomp, map_decomp
		
		plot_map, map_decomp

		sz_decomp = size(im_decomp, /dim)
		
		newim2_decomp = fltarr(sz_decomp[0], sz_decomp[1])
		
		for l=0,8 do begin
			x_dyn = xy[0,info[l].offset:(info[l].offset+info[l].n-1)]               
			y_dyn = xy[1,info[l].offset:(info[l].offset+info[l].n-1)]	
			
			x_dyn_map = (x_dyn - in[i].crpix1) * in[i].cdelt1
			y_dyn_map = (y_dyn - in[i].crpix2) * in[i].cdelt2
			
			plots, x_dyn_map, y_dyn_map
		
			recpol, x_dyn_map, y_dyn_map, r_dyn, a_dyn, /degrees

			a_dyn = round(a_dyn)
			r_dyn = round(r_dyn)

			a_maxd = max(a_dyn)
			a_mind = min(a_dyn)

			a_frontd = fltarr(a_maxd - a_mind +1)
			r_frontd = fltarr(a_maxd - a_mind +1)
			temp = 0.
			count = a_mind
			stepsize = 1.
			while(count le a_maxd) do begin
				a_frontd[temp] = count
				if(where(a_dyn eq count) eq [-1]) then goto, jump_1
				r_frontd[temp] = max(r_dyn(where(a_dyn eq count)))
				jump_1:
				temp = temp + 1
				count = count + stepsize
			endwhile

			polrec, r_frontd, a_frontd, x_front_dyn, y_front_dyn, /degrees

			set_line_color
			plots, x_front_dyn, y_front_dyn, psym=-1, color=3


		; Same idea as below from angleinfo.pro, but taking only the fronts of the biggest contours:

			x_front_dyn2 = (x_front_dyn / in[0].cdelt1) + in[0].crpix1
			y_front_dyn2 = (y_front_dyn / in[0].cdelt2) + in[0].crpix2

			sz_front_dyn2 = size(x_front_dyn2, /dim)

			for temp=0,sz_front_dyn2[0]-1 do begin
				newim2_decomp[x_front_dyn2[temp], y_front_dyn2[temp]] = 1.
			endfor

		endfor
		
	; From angleinfo.pro taking the angle information from alpgrad

		newim_decomp = im_decomp
		
		for xpix=0,sz_decomp[0]-1 do begin
			for ypix=0,sz_decomp[1]-1 do begin
				if im_decomp[xpix, ypix] lt thresh_dyn then $
					newim_decomp[xpix, ypix] = 0.
				if im_decomp[xpix, ypix] ge thresh_dyn then $
					newim_decomp[xpix, ypix] = 1.
			endfor
		endfor
		
		;Multiplying by the angle image
		mult = newim_decomp * alpgrad[*,*,7]
		index2map, in[i], mult, anglemap

;		plot_image, newim2_decomp
		
		loadct, 6
		plot_map, anglemap
	
;		display_angle, newim_decomp, alpgrad[*,*,7], pix_step=5
		
;		read, 'yeah?', ans

		mult2 = newim2_decomp * alpgrad[*,*,7]
		index2map, in[i], mult2, anglemapfront

;		plot_map, anglemapfront
		
	

	; Want to now 'chain' pixels together to form the edges (re: James' paper)
	; "At each scale, s, pixel [x1, y1] is chained to pixel [x2, y2] if the modulus
	; and the angle of the gradient at [x1, y1] is similar to that of [x2, y2] and
	; if the line connecting the these two points is perpindicular to the angle of
	; the maximum gradient at each.
	

		plot_image, mult

		; array to take the edge defined pixels
		chained_edges = fltarr(sz_decomp[0], sz_decomp[1])
		
		; arrays to assign the surrounding pixels
		modpix = fltarr(3,3)
		alppix = fltarr(3,3)
		
		
		for xpix=0,sz_decomp[0]-1 do begin
			for ypix=0,sz_decomp[1]-1 do begin
				
				if mult[xpix, ypix] ne 0. then begin
					
				modpix[1,1] = im_decomp[xpix, ypix]
			       	alppix[1,1] = alpgrad[xpix, ypix, 7]

				modpix[2,1] = im_decomp[xpix+1, ypix]
				alppix[2,1] = alpgrad[xpix+1, ypix, 7]

				modpix[0,1] = im_decomp[xpix-1, ypix]
				alppix[0,1] = alpgrad[xpix-1, ypix, 7]

				modpix[1,2] = im_decomp[xpix, ypix+1]                                
				alppix[1,2] = alpgrad[xpix, ypix+1, 7]

				modpix[1,0] = im_decomp[xpix, ypix-1]
				alppix[1,0] = alpgrad[xpix, ypix-1, 7]

				modpix[2,2] = im_decomp[xpix+1, ypix+1]                                
				alppix[2,2] = alpgrad[xpix+1, ypix+1, 7]
				
				modpix[2,0] = im_decomp[xpix+1, ypix-1]                                
				alppix[2,0] = alpgrad[xpix+1, ypix-1, 7]
				
				modpix[0,2] = im_decomp[xpix-1, ypix+1]                                
				alppix[0,2] = alpgrad[xpix-1, ypix+1, 7]
			
				modpix[0,0] = im_decomp[xpix-1, ypix-1]
				alppix[0,0] = alpgrad[xpix-1, ypix-1, 7]
				
			;	!p.multi=0	
			;	plot_image, modpix
			;	print, modpix
			;	read, 'modpix?', ans
			;	plot_image, alppix
			;	print, alppix
			;	read, 'alppix?', ans
	
			;	pmm, im_decomp

				mod_thr = max(im_decomp) / 100000.
				print, mod_thr
				alp_thr = 0.1
				
				
				for tempx=0,2 do begin
					for tempy=0,2 do begin
						
						; switch to say whether pixels in question are chainable
						modtrue = 0.
						alptrue = 0.
						moddiff = abs(modpix[1,1] - modpix[tempx,tempy])
						alpdiff = abs(alppix[1,1] - alppix[tempx,tempy])
												
						if tempx eq 1 then begin
							if tempy eq 1 then begin
								moddiff = 1.
								alpdiff = 1.
							endif
						endif
						if moddiff le mod_thr then begin
							modtrue = 1. & print, 'moddiff:' & print, moddiff
						endif
						if alpdiff le alp_thr then begin
							alptrue = 1. & print, 'alpdiff:' & print, alpdiff
						endif
						
						;read,'go on', ans

						if modtrue eq 1. then begin
							if alptrue eq 1. then begin
								perp1 = alppix[1,1]+90.
								perp2 = alppix[tempx,tempy]+90.
								perpdiff = abs(perp1-perp2)
								print, 'perpdiff:' & print, perpdiff
								;read, 'on?', ans
								if perpdiff lt 1. then chained_edges[xpix,ypix] = 1.	
							endif
						endif
						
					endfor
				endfor

				set_line_color
				if chained_edges[xpix,ypix] ne 0. then plots, xpix, ypix, psym=3, color=3
				
				endif
				
				; Condition on image edge / corner pixels will need to be put in too!

			endfor
		endfor

		plot_image, chained_edges
		help, chained_edges
		read, 'edges?', ans

		

		
		
;*****************************************************************
		
		; Find the width of my first CME fit used in start params of mpfitellipse.pro

		n = 30
		count = 1
		sign = 0
		crossing = where(r eq round(r_bar))
		range = [crossing]
		while (size(range, /dim) lt n) do begin
			if sign mod 2 eq 0 then crossings = where(r eq round(r_bar)+count)
			if sign mod 2 eq 1 then crossings = where(r eq round(r_bar)-count)
			range = [range, [crossings]]
			count = count + 1
			sign = sign + 1
		endwhile

		a_width = max(a[range]) - min(a[range])
		polrec, r_bar, max(a[range]), x_width1, y_width1, /degrees
		polrec, r_bar, min(a[range]), x_width2, y_width2, /degrees
		
		; These plots show the initial width approximation from first ellipse fit.
		;plots, x_width1, y_width1, psym=7
		;plots, x_width2, y_width2, psym=7
		;plots, [x_width1,x_width2], [y_width1,y_width2], color=8
		
		width = fltarr(szd[2],c+1)
		;slope_width = (y_width2 - y_width1) / (x_width2 - x_width1)
		width[i,k] = sqrt((y_width2 - y_width1)^2 + (x_width2 - x_width1)^2)
		;print, 'width:' & print, width

;*****************************************************************

	;********
		; drawing circle of solar limb
		r_sun = pb0r(maps[i].time, /soho, /arcsec)
		draw_circle, 0, 0, r_sun[2]
	
	;********
		
		; drawing tangents to the CME edges
		if keyword_set(tangents) then begin
			loadct, 0
			;plotting lines to points of width
			;plots, [0,x_width1], [0,y_width1]
			;plots, [0,x_width2], [0,y_width2]
			;plotting line to apex
			;plots, [0,x_apex], [0,y_apex]
			slope1 = sqrt((y_front[0] / x_front[0])^2)
			y_edge1 = (in[i].naxis2 - in[i].crpix2) * in[i].cdelt2
			x_edge1 = y_edge1/slope1
			if y_front[0] lt 0 then begin
				y_edge1 = -y_edge1
				if x_front[0] lt 0 then begin
					x_edge1 = -x_edge1
				endif
			endif else begin
				if x_front[0] lt 0 then begin
					x_edge1 = -x_edge1
				endif
			endelse
			plots, [0,x_edge1], [0,y_edge1]		
			;plots, [0,x_new[0]], [0, y_new[0]]
		
			szx_front = size(x_front, /dim)
			szy_front = size(y_front, /dim)
		
			slope2 = sqrt((y_front[szy_front] / x_front[szx_front])^2)
       		 	y_edge2 = (in[i].naxis2 - in[i].crpix2) * in[i].cdelt2
       		 	x_edge2 = y_edge2/slope2
       		 	if y_front[szy_front] lt 0 then begin
       		        	y_edge2 = -y_edge2
       		        	if x_front[szx_front] lt 0 then begin
       		                	x_edge2 = -x_edge2
       		         	endif   
		       	endif else begin
		                if x_front[szx_front] lt 0 then begin
       		         	        x_edge2 = -x_edge2
       		         	endif   
      	 	 	endelse
        		plots, [0,x_edge2], [0,y_edge2]
			;plots, [0,x_front[szx_front]], [0,y_front[szy_front]]
		read, 'tangents?', ans
		endif


		; plotting N angle lines along CME
		;if keyword_set(lines) then begin
			dist = a_max1 - a_min1
			n = 30.
			steps = dist / n
			angles = fltarr(n+1)
			r_angles = fltarr(n+1)
			r_mid = fltarr(n+1)
			r_front = fltarr(n+1)
			count = a_min1
			temp = 0
			;print, angles
			;print, temp
			;print, count
			;print, steps
			;print, a_max1	
			while (count le a_max1) do begin
				angles[temp] = count
				if(where(a eq round(count)) eq [-1]) then goto, jump2
				r_angles[temp] = max(r(where(a eq round(count)))) 
				jump2:
				r_mid[temp] = r_bar
				r_front[temp] = r_a_bar
				temp = temp + 1
				count = count + steps
			endwhile		
			r_mid = r_mid[where(r_mid ne 0)]	
			polrec, r_angles, angles, x_step, y_step, /degrees
			polrec, r_mid, angles, x_mid, y_mid, /degrees
			polrec, r_front, angles, x_front2, y_front2, /degrees
			;plots, x_front2, y_front2	
	;		plots, x_mid, y_mid
			szx_step = size(x_step, /dim)
		
		if keyword_set(lines) then begin	
			for j=0,szx_step[0]-1 do begin
				loadct, 0
				plots, [0,x_step[j]],[0,y_step[j]]
			endfor
		endif


;*****************************************************************
;               Using the average point of the front coords (scaled to origin) 
;		to find the fit given by MPFITFUN for inclined ellipse equation.

		xbar = (x_bar_org[0]-in[i].crpix1) * in[i].cdelt1
		ybar = (y_bar_org[0]-in[i].crpix2) * in[i].cdelt2
		x0 = x_front - xbar
		y0 = y_front - ybar
		recpol, x0, y0, y, x
		radiusbar = sqrt(xbar^2.+ybar^2.)
		;fit = 'sqrt((p[0]^2.*p[1]^2.)/((p[0]^2.+p[1]^2.)/2.-((p[0]^2.-p[1]^2.)/2.)*cos(x*2.-p[2]*2.)))'
		fit = 'sqrt((p[0]^2.*p[1]^2.)/((p[0]^2.+p[1]^2.)/2.-((p[0]^2.-p[1]^2.)/2.)*cos(2.*x-2.*p[2])))'
		parinfo = replicate({value:0.D, fixed:0, limited:[0,0], limits:[0.D,0]},3)
		parinfo(*).value = [10*width[i,k], 10*width[i,k], 1.]
		param = mpfitexpr(fit, x, y, y*0.1, parinfo=parinfo, perror=perror, yfit=yfit)

		x_fit = x_front
		y_fit = y_front

	; MPFITELLIPSE	

		start_params = [param[0], param[1], xbar, ybar, param[2]]
	       	
		p = mpfitellipse(x_fit, y_fit, start_params, /tilt, weights=wts)
		phi = dindgen(101)*2D*!dpi/100.
		
		x_ellipse = p[2]+p[0]*cos(phi)
		y_ellipse = p[3]+p[1]*sin(phi)
		
		; transform by swinging about the map centre:
		x_ellipse2 = x_ellipse*cos(p[4]) + y_ellipse*sin(p[4])
		y_ellipse2 = y_ellipse*cos(p[4]) - x_ellipse*sin(p[4])

		shift_xbar = p[2]*cos(p[4]) + p[3]*sin(p[4])
		shift_ybar = p[3]*cos(p[4]) - p[2]*sin(p[4])
		
		shift_factor_x = shift_xbar - p[2]
		shift_factor_y = shift_ybar - p[3]
		
		x_ellipse_new = x_ellipse2 - shift_factor_x
		y_ellipse_new = y_ellipse2 - shift_factor_y
	
		if p[0]	lt 12000 then begin
			if p[1] lt 12000 then begin
				plots, x_ellipse_new, y_ellipse_new
				plots, p[2], p[3], psym=2
			endif
		endif


	endfor

	
	;for making the movie
	;entry = tvrd()
	;print, size(entry,/dim)
	;temparr(*,*,i) = entry
	
	ans=''
;	read, 'ok?', ans

endfor

;wr_movie, 'CME_ell_bkgrd', temparr



end




