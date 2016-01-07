; Program to just try and take the minimum pixel values of a data set and assign that as the background against which to threshold.

; Last edited 03-05-07

function circle, xcenter, ycenter, radius

points = (2*!PI/99.0) * findgen(100)

x = xcenter + radius*cos(points)
y = ycenter + radius*sin(points)

return, [[x],[y]]

end



pro minpix, bkgrd

restore, '~/PhD/Data_sav_files/da_18apr00.sav'
restore, '~/PhD/Data_sav_files/in_18apr00.sav'


da = float(da)
;daf = da
;dafn = da
sz = size(da, /dim)


;for i=0,sz[2]-1 do begin
;	im=rm_inner(da[*,*,i], in[i], dr_px, thr=2.2, plot=plot, fill=fill)
;	daf[*,*,i] = fmedian(im, 3, 5)
;	dafn[*,*,i] = daf[*,*,i] / in[i].exptime
;endfor

;save, dafn, f='dafn_18apr00.sav'

restore, '~/PhD/Data_sav_files/dafn_18apr00.sav'

;xstepper, dafn, xs=500, ys=500


;bkgrd = fltarr(sz[0],sz[1])

ans = ''

;for i=0,sz[0]-1 do begin

;	for j=0,sz[1]-1 do begin

;		for k=0,sz[2]-2 do begin

;			if k eq 0 then bkgrd[i,j] = dafn[i,j,k]
			
;			if k ne 0 then begin
				
;				temp = dafn[i,j,k-1]
				
;				pix = dafn[i,j,k] 
		
;				if pix lt temp then begin
;					bkgrd[i,j] = pix
;				endif
			
;			endif
		
;		endfor

;	endfor

;endfor



bkgrd = min(da, dim=3)
plot_image, bkgrd
read, 'bkgrd', ans


index2map, in[0], bkgrd, bkgrdmap
plot_map, bkgrdmap
read, '', ans

plot_image, bytscl(bkgrd)
read, '', ans
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
read, '', ans

plot_hist, ring(where(ring ne 0.))

end


