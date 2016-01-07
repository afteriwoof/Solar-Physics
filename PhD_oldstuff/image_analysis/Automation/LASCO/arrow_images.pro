; First call pre_spatiotemp.pro in the Michelmas07 folder
; Then based upon  pre_arrow_only.pro in the Michelmas07 folder we generate the image.
; Performed on only one image and the relevant mod, alp, row and col image.

; Last Edited: 01-02-08

pro arrow_images, in, da, filt, modgrad, alpgrad, rows, cols

sz = size(da,/dim)

modnorm = modgrad/max(modgrad)
modl = modnorm * 500
;!p.multi = [0,1,4]

mask = fltarr(sz[0], sz[1]) +1.
mask = rm_inner(mask, in, dr_px, thr=2.5)
mask = rm_outer(mask, in, dr_px, thr=6.85)
mask = rm_edges(mask, in, dr_px, edge=10)

r = rows*mask
c = cols*mask
dmod = modl*mask
dang = alpgrad*mask
filtered = filt*mask

im=fltarr(sz[0],sz[1])
;index2map, in, im, map
;index2map, in, dmod, dmodmap
;index2map, in, dang, dangmap
;submap, map, smap, xr=[-5000,-500], yr=[0,4500]
;submap, dmodmap, sdmodmap, xr=[-5000,-500], yr=[0,4500]
;submap, dangmap, sdangmap, xr=[-5000,-500], yr=[0,4500]

;cme = da[350:750,0:400]
plot_image, sigrange(da);, pos=[0,0,0.5,0.5], /isotropic

;dmod = dmod[350:750,0:400]
;dang = dang[350:750,0:400]
;cmefilt = filtered[350:750,0:400]
;for i=0,399,10 do begin
;	for j=0,399,10 do begin
;		if dmod[i,j] ne 0 then begin
;			arrow2, i, j, dang[i,j], dmod[i,j], /angle, /data, $
;				hsize=4, thick=2, hthick=2, color=255
;		endif
;	endfor
;endfor

for i=0,sz[0]-1,10 do begin
	for j=0,sz[1]-1,10 do begin
		if dmod[i,j] ne 0 then begin
			arrow2, i, j, dang[i,j], dmod[i,j], /angle, /data, $
				hsize=4, thick=2, hthick=1, color=255
		endif
	endfor
endfor


end
