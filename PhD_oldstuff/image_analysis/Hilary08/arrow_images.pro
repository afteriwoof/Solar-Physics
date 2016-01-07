; First call pre_spatiotemp.pro in the Michelmas07 folder
; Then based upon  pre_arrow_only.pro in the Michelmas07 folder we generate the image.
; Performed on only one image and the relevant mod, alp, row and col image.

; Last Edited: 01-02-08

pro arrow_images, in, da, filt, modgrad, alpgrad, rows, cols

sz = size(da,/dim)

modnorm = modgrad/max(modgrad)
modl = modnorm * 70
;!p.multi = [0,1,4]

mask = fltarr(sz[0], sz[1]) +1
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

cme = im[50:450,500:900]
plot_image, cme;, pos=[0,0,0.5,0.5], /isotropic
dmod = dmod[50:450,500:900]
dang = dang[50:450,500:900]
cmefilt = filtered[50:450,500:900]
for i=0,399,15 do begin
	for j=0,399,15 do begin
		if dmod[i,j] ne 0 then begin
			arrow2, i, j, dang[i,j], dmod[i,j], /angle, /data, $
				hsize=160, thick=8, hthick=8, color=255
		endif
	endfor
endfor




end
