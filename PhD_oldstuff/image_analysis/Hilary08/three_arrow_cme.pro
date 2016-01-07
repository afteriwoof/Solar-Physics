; Code to read the different images for print out arrow overlays for the paper.

; Last Edited: 20-02-08

pro three_arrow_cme, dilations

cd,'~/phd/data_vso/20000102/'
@read.b
k=2
cd, '~/phd/idlstuff/image_analysis/michelmas07/nrgf'
nrgf_stepsc2, inc2, dac2, filtc2
cd,'..'
sz = size(dac2, /dim)
pre_spatiotemp, dac2, 5, modgrads, alpgrads, rows, cols
spatiotemp, filtc2, modgrads, alpgrads, newfilt
scale_chain, dac2, scalemasks
.r assign_scale
scalemasks = assign_scale(scalemasks, dac2)
mults = fltarr(sz[0], sz[1], sz[2])
for i=0,sz[2]-1 do begin
	mults[*,*,i] = scalemasks[*,*,i]*newfilt[*,*,i]
endfor
mag_chain, modgrads, magchains
combined = fltarr(sz[0], sz[1], sz[2])
dilations = combined
se = fltarr(8,8)+1
for i=0,sz[2]-1 do begin
	combined[*,*,i] = magchains[*,*,i]*scalemasks[*,*,i]
	dilations[*,*,i] = dilate(magchains[*,*,i], se) * dilate(scalemasks[*,*,i], se)
endfor
frontmasks = fltarr(sz[0], sz[1], sz[2])
for i=1,sz[2]-1 do begin
	im = rm_inner(dilations[*,*,i], inc2[i], dr_px, thr=2.2)
	mu = moment(im, sdev=sdev)
	thr=1
	contour, im, lev=thr, path_xy=xy, path_info=info, /path_data_coords
	x = xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y = xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
	frontmask = fltarr(sz[0], sz[1])
	index = polyfillv(x,y,sz[0],sz[1])
	frontmask[index]=1
	frontmasks[*,*,i] = erode(frontmask, se)
endfor
pre_arrow_window, filtc2, inc2, dac2, frontmasks


end
