function polar, image, xcen, ycen
	sz = size(image)
        xmax = max([abs(sz(1)-xcen-1),xcen])
        ymax = max([abs(sz(2)-ycen-1),ycen])
        rmax = sqrt(xmax^2 + ymax^2)
        nr = round(rmax)+1
        r = findgen(nr) # replicate(1,360)
        theta = replicate(!dtor,nr) # findgen(360)
        i = fix(r*cos(theta) + xcen)
        j = fix(r*sin(theta) + ycen)
        w = where((i lt 0) or (i ge sz(1)) or (j lt 0) or (j ge sz(2)))
        if sz(0) eq 3 then nz=sz(3) else nz=1
        result = fltarr(nr,360,nz)

        for k=0,nz-1 do begin
		temp = image(*,*,k)
		temp = temp(i,j)
		temp(w) = 0
		result(0,0,k) = temp
	endfor

        return, result
end	





; Want to take out polar regions of arrows of the image

; Taken from attempts written in polar_rings.pro

; Finalised as polar_regions.pro and renamed to cme_detection.pro

; Last Edited: 13-05-08

; Best to read in NRGF data

pro cme_detection, in, da, alpgrads, modgrads 

sz = size(da, /dim)
;!p.multi=[0,1,2]
cme_detect = fltarr(600,800,180)
count = 0

for s=0,sz[2]-1 do begin
	
	im = da[*,*,s]
	
	
	;mag_chain, modgrads, magchains
	;xstepper, magchains, xs=700
	
	
	im_pol = polar(im, in[s].crpix1, in[s].crpix2)
	;tvscl, im_pol
   	case in[s].detector of
	'C2':	begin
                alp_pol = rm_inner(alpgrads[*,*,s], in[s], dr_px, thr=2.5)
                alp_pol = rm_outer(alp_pol, in[s], dr_px, thr=6.0)
                mod_pol = rm_inner(modgrads[*,*,s], in[s], dr_px, thr=2.5)
                mod_pol = rm_outer(mod_pol, in[s], dr_px, thr=6.0)
        	mod_pol = polar(mod_pol, in[s].crpix1, in[s].crpix2)
		alp_pol = polar(alp_pol, in[s].crpix1, in[s].crpix2)
		mod_pol = mod_pol[200:500,*]
		alp_pol = alp_pol[200:500,*]
		end
        'C3':	begin
                alp_pol = rm_inner(alpgrads[*,*,s], in[s], dr_px, thr=4.5)
                alp_pol = rm_outer(alp_pol, in[s], dr_px, thr=29)
                mod_pol = rm_inner(modgrads[*,*,s], in[s], dr_px, thr=4.5)
                mod_pol = rm_outer(mod_pol, in[s], dr_px, thr=29)
		alp_pol = polar(alp_pol, in[s].crpix1, in[s].crpix2)
		mod_pol = polar(mod_pol, in[s].crpix1, in[s].crpix2)
        	mod_pol = mod_pol[80:500,*]
		plot_image, mod_pol
		pause
		end
	'COR1':	begin
		alp_pol = rm_inner(alpgrads[*,*,s], in[s], dr_px, thr=1.51)
		alp_pol = rm_outer(alp_pol, in[s], dr_px, thr=4.33)
		mod_pol = rm_inner(modgrads[*,*,s], in[s], dr_px, thr=1.51)
		mod_pol = rm_outer(mod_pol, in[s], dr_px, thr=4.33)
		mod_pol = polar(mod_pol, in[s].crpix1, in[s].crpix2)
		alp_pol = polar(alp_pol, in[s].crpix1, in[s].crpix2)
		mod_pol = mod_pol[200:500,*]
		alp_pol = alp_pol[200:500,*]
		end
	endcase	

        mod_sz = size(mod_pol, /dim)
	
	;print, mu, sdev
	;print, thresh
	

	mu = moment(mod_pol, sdev=sdev)
	thresh = mu[0]; + 1*sdev
	plot_image, sigrange(mod_pol)
	contour, mod_pol, lev=thresh, path_xy=xy, path_info=info, /path_data_coords
	mask = bytarr(mod_sz[0], mod_sz[1])
	mod_contoured = fltarr(mod_sz[0], mod_sz[1])
	for c=0,10 do begin
		x = xy[0,info[c].offset:(info[c].offset+info[c].n-1)]
		y = xy[1,info[c].offset:(info[c].offset+info[c].n-1)]
		ind = polyfillv(x, y, mod_sz[0], mod_sz[1])
		mask[ind] = 1
		mod_contoured = mask * mod_pol
	endfor
	plot_image, sigrange(mod_contoured)
	window, xs=600, ys=800
		;plot_image, sigrange(mod_pol*thresh_mask_show)
		;pause
		
		;tvscl, alp_pol
	
		; Making the movie of the rows now to see how the angle changes across image.
		total_mu = 0.
		indiv_mu = fltarr(mod_sz[1])
		for j=0,mod_sz[1]-1 do begin
			alp_row = alp_pol[*,j]
			mod_row = mod_pol[*,j]
		 	indiv_mu[j] = mean(alp_row)
		        total_mu += indiv_mu[j]
			;window, xs=600, ys=800
			plot_image, sigrange(mod_pol), xtit = indiv_mu[j]
			plots,[0,mod_sz[0]-1], [j,j]
			;plot, alp_pol[*,j], xtickname=[" "," "," "," "," "]
			for i=0,mod_sz[0]-1 do begin
				if mod_pol[i,j] ne 0 then begin
					arrow2, i+50, 30, alp_pol[i,j], mod_pol[i,j]*400, /angle, hsize=3, thick=1
					arrow2, 500, 30, alp_pol[i,j], mod_pol[i,j]*400, /angle, hsize=3, thick=1
				endif
			endfor
			if (j mod 2) ne 1 then begin
				cme_detect[*,*,count] = tvrd()
				count += 1
			endif
		endfor
		wr_movie, 'cme_detect', cme_detect	

endfor

	;wr_movie, 'cme_detect', cme_detect	

end
