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





; Want to take out polar rings of arrows of the image

; Last Edited: 25-03-08

pro polar_rings, in, da, alpgrads, modgrads 

sz = size(da, /dim)

for s=1,sz[2]-1 do begin

im = da[*,*,s]


;mag_chain, modgrads, magchains
;xstepper, magchains, xs=700


im_pol = polar(im, in[s].crpix1, in[s].crpix2)
;tvscl, im_pol

alp_pol = rm_inner(alpgrads[*,*,s], in[s], dr_px, thr=2.5)
alp_pol = rm_outer(alp_pol, in[s], dr_px, thr=6.0)
mod_pol = rm_inner(modgrads[*,*,s], in[s], dr_px, thr=2.5)
mod_pol = rm_outer(mod_pol, in[s], dr_px, thr=6.0)
alp_pol = polar(alp_pol, in[s].crpix1, in[s].crpix2)
mod_pol = polar(mod_pol, in[s].crpix1, in[s].crpix2)

mod_sz = size(mod_pol, /dim)

mu = moment(mod_pol, sdev=sdev)
;print, mu, sdev
thresh = mu[0] + 1*sdev
;print, thresh
contour, mod_pol, lev=thresh, path_xy=xy, path_info=info, /path_data_coords
thresh_mask = fltarr(mod_sz[0], mod_sz[1])
for c=0,10 do begin
	x = xy[0,info[c].offset:(info[c].offset+info[c].n-1)]
	y = xy[1,info[c].offset:(info[c].offset+info[c].n-1)]	
	ind = polyfillv(x, y, mod_sz[0], mod_sz[1])
	thresh_mask[ind] = 1
endfor
alp_pol = alp_pol*thresh_mask
mod_pol = mod_pol*thresh_mask

;tvscl, alp_pol

mod_pol = mod_pol[200:500,*]
alp_pol = alp_pol[200:500,*]

mod_sz = size(mod_pol, /dim)

;*******************
; Use the cuts (ring plots!)
cut = fltarr(mod_sz[0],1)
;mean_alp_cuts = fltarr(mod_sz[0])
;mean_mod_cuts = fltarr(mod_sz[0])
;sdev_alp_cuts = fltarr(mod_sz[0])
;sdev_mod_cuts = fltarr(mod_sz[0])
;for i=0,mod_sz[0]-1 do begin
;	alp_cut = alp_pol[i,*]
;	mod_cut = mod_pol[i,*]
;	mu_alp_cut = moment(alp_cut, sdev=sdev)
;	mean_alp_cuts[i] = mu_alp_cut[0]
;	sdev_alp_cuts[i] = sdev
;	mu_mod_cut = moment(mod_cut, sdev=sdev)
;	mean_mod_cuts[i] = mu_mod_cut[0]
;	sdev_mod_cuts[i] = sdev
;endfor
; Use info to generate a space where the CME is located.
CMEspace = fltarr(mod_sz[0], mod_sz[1])
for i=0,mod_sz[0]-1 do begin
	alp_mean = moment(alp_pol[i,*], sdev=alp_sdev)
	mod_mean = moment(mod_pol[i,*], sdev=mod_sdev)
	if i eq 0 then CMEspace[i,*] = 0
	if i gt 0 then begin
		modchange_index = where(abs(mod_pol[i,*]-mod_pol[i-1,*]) gt mod_sdev*0.1)
		if modchange_index ne [-1] then	CMEspace[i,modchange_index] += 1
	endif	
endfor

;plot_image, CMEspace
;pause
; Making the movie of the rows now to see how the angle changes across image.
mov_row1_plot = fltarr(600,800,mod_sz[1])
!p.multi=[0,1,2]
total_mu = 0.
indiv_mu = fltarr(mod_sz[1])
for j=0,mod_sz[1]-1 do begin
	alp_row = alp_pol[*,j]
	mod_row = mod_pol[*,j]
        indiv_mu[j] = mean(alp_row)
        total_mu +=  indiv_mu[j]
	window, xs=600, ys=800
	plot_image, mod_pol, xtit = indiv_mu[j]
	plots,[0,mod_sz[0]-1], [j,j]
	plot, alp_pol[*,j], xtickname=[" "," "," "," "," "]
	for i=0,mod_sz[0]-1 do begin
		if mod_pol[i,j] ne 0 then begin
			arrow2, i, 30, alp_pol[i,j], mod_pol[i,j]*400, /angle, hsize=3, thick=1
			arrow2, 400, 30, alp_pol[i,j], mod_pol[i,j]*400, /angle, hsize=3, thick=1
		endif
	endfor
	mov_row1_plot[*,*,j] = tvrd()
endfor
wr_movie, 'mov_row1_plot', mov_row1_plot
;pause
; Using the idea of angle mean of angle not changing massively across the CME rows lines



; Make movie of the cuts across the image (the ring plots!)
;mov = fltarr(600,800,mod_sz[0])
;for i=0,mod_sz[0]-1 do begin
;	alp_cut = alp_pol[i,*]
;	mod_cut = mod_pol[i,*]
;	window, xs=600, ys=800
;	plot_image, mod_pol
;	plots, [i,i], [0,mod_sz[1]-1]
;	for j=0,mod_sz[1]-1 do begin
;		if mod_pol[i,j] ne 0 then begin
;			arrow2, j, 40, alp_pol[i,j], mod_pol[i,j]*400, /angle, hsize=3, thick=1
;		endif
;	endfor
;	mov[*,*,i] = tvrd()
;endfor
;wr_movie, 'mov', mov
;pause
; **********************

; Plotting arrows over the mod_pol image
;tvscl, mod_pol
;for i=0,mod_sz[0]-1,8 do begin
;	for j=0,mod_sz[1]-1,8 do begin
;		if mod_pol[i,j] ne 0 then begin
;			arrow2, i, j, alp_pol[i,j], mod_pol[i,j]*300., /angle, /device, hsize=3, thick=1
;		endif
;	endfor
;endfor


;stepsize=0.12
;
;black=fltarr(size(im,/dim))
;plot_image, black
;ring = fltarr(sz[0],sz[1])+1
;ring = rm_inner(ring, in[s], dr_px, thr=3.2)
;ring = rm_outer(ring, in[s], dr_px, thr=3.22)
;ind = where(ring gt 0)
;faint = ring
;faint[where(faint ne 1)]=.5
;plot_image, im*faint
;alpring = fltarr(n_elements(ind),5)
;modring = alpring
;for i=0,4 do alpring[*,i] = alpgrads[ind]
;for i=0,4 do modring[*,i] = modgrads[ind]
;
;coords = array_indices(im, ind)
;tvscl, faint
;for i=0,n_elements(ind)-1,5 do begin
;	for j=2,2 do begin
;		if modring[i,j] ne 0 then begin
;			arrow2, coords[0,i], coords[1,i], alpring[i,j], modring[i,j]*200, /angle, /device, hsize=3
;		endif
;	endfor
;endfor	
;
;
;for i=0,n_elements(ind)-1 do begin
;	for j=2,2 do begin
;		if modring[i,j] ne 0 then begin
;		arrow2, i,j,alpring[i,j],modring[i,j]*100, /angle, /device, hsize=3
;		endif
;	endfor
;endfor






;for i=10,80 do begin
;	im2 = im
;	im2 = rm_inner(im, in[s], dr_px, thr=(i/10.+stepsize-0.02))
;	im2 = rm_outer(im2, in[s], dr_px, thr=(i/10.+stepsize))
;	
;	ind = where(im2 gt 0)
;	if ind ne [-1] then begin
;		temp=fltarr(n_elements(ind))
;		temp[*] = im2[ind]
;		plot, temp
;	endif
;		
;endfor



endfor
end
