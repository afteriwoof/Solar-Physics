; Program written to go step by step through the important wavelet analysis for WTMM chaining

; Last Edited: 22-06-07

PRO new, path

path = '~/PhD/Data_from_Alex/18-apr-00/*fts'
ans = ''

; Perform steps of rundiff.pro to give data, headers & running-differences
fls = file_search(path)
;mreadfits, fls, in, da
; C2 data only
;c2da = where(in.detector eq 'C2') ;and in.naxis1 eq 1024)
;mreadfits, fls[c2da], in, c2da
;ssw_fill_cube2, c2da, da
; convert int to float
;da = float(da)
restore, 'da.sav'
restore, 'in.sav'
dafn = da
sz = size(da, /dim)

; Perform background subtraction
tempim = readfits(fls[0], hdr)
bkgrd = getbkgimg(hdr, bkgrg_hdr)
plot_image, bkgrd, tit='Lasco Median Calculated Background'
corrected = fltarr(sz[0],sz[1],sz[2])
for i=0,sz[2]-1 do begin
	corrected[*,*,i] = da[*,*,i] - bkgrd
endfor

da = corrected
delvarx, corrected

; Remove inner disc and perform fmedian filter (slow!)
for i=0,sz[2]-1 do begin
	da[*,*,i] = rm_inner(da[*,*,i], in[i], dr_px, thr=2.2)
	dafn[*,*,i] = fmedian( (da[*,*,i]/in[i].exptime), 5, 3)
endfor
save, dafn, f='dafn.sav'
;restore, 'dafn.sav'
; Compute running differences
diffn = fltarr(sz[0], sz[1], sz[2]-1)
for i=0,sz[2]-2 do begin
	diffn[*,*,i] = dafn[*,*,i+1] - dafn[*,*,i]
endfor
save, diffn, f='diffn.sav'
;restore, 'diffn.sav'
stop
; **** WAVELET: a trous ****
; Calling canny_atrous to perform a wavelet decomposition with mod & angle info
;modscales = fltarr(sz[0], sz[1], sz[2], 8)
;alpscales = fltarr(sz[0], sz[1], sz[2], 8)
;for i=0,sz[2]-1 do begin
;	canny_atrous2d, dafn[*,*,i], modgrad, alpgrad
;	modscales[*,*,i,*] = modgrad
;	alpscales[*,*,i,*] = alpgrad
;endfor
restore, 'modscales.sav'
restore, 'alpscales.sav'
;TESTING OUT JAMES' CODES calc_wtmm2, chain_wtmm, binary_mask
;md6 = modscales[*,*,7,6]
;al6 = alpscales[*,*,7,6]
;md6 = reform(md6)
;al6 = reform(al6)
;calc_wtmm2, md6, al6, wtmm6
;restore, 'wtmm6.sav'
;chain_wtmm, wtmm6, md6, al6, chains6, linked_wtmm6
;save, chains6, f='chains6.sav'
;save, linked_wtmm6, f='linked_wtmm6.sav'
;
;md5 = modscales[*,*,7,5]
;al5 = alpscales[*,*,7,5]
;md5 = reform(md5)
;al5 = reform(al5)
;calc_wtmm2, md5, al5, wtmm5
;save, wtmm5, f='wtmm5.sav'
;chain_wtmm, wtmm5, md5, al5, chains5, linked_wtmm5
;save, chains5, f='chains5.sav'
;save, linked_wtmm5, f='linked_wtmm5.sav'

; Removing discs of unwanted data, by making a mask according to thresholds of rm_inner/outer/edges
;mask = fltarr(sz[0], sz[1], sz[2]) +1.
;mask = rm_inner(mask, in[0], dr_px, thr=2.6)
;mask = rm_outer(mask, in[0], dr_px, thr=6.2)
;mask = rm_edges(mask, in[0], dr_px, edge=25.)
restore, 'mask.sav'

;md5 = fltarr(sz[0], sz[1], sz[2])
;al5 = md5
;for i=0,sz[2]-1 do begin
;	md5[*,*,i] = modscales[*,*,i,5]*mask
;	al5[*,*,i] = alpscales[*,*,i,5]*mask
;endfor
restore, 'md5.sav'
restore, 'al5.sav'

; Use James' codes for the WTMM and pixel chaining on my contoured im_decomps.
wtmm = fltarr(sz[0], sz[1], sz[2])
chains = wtmm
linked_wtmm = wtmm
bin_ch = wtmm
for i=0,sz[2]-1 do begin
	calc_wtmm2, reform(md5[*,*,i]), reform(al5[*,*,i]), wtmm5
	chain_wtmm, wtmm5, md5, al5, chains5, linked_wtmm5
	wtmm[*,*,i] = wtmm5
	chains[*,*,i] = chains5
	linked_wtmm[*,*,i] = linked_wtmm5	
	bin_ch5 = binary_mask(chains5)
	plot_image, bin_ch5
	bin_ch[*,*,i] = bin_ch5
endfor
save, chains, f='chains.sav'
save, linked_wtmm, f='linked_wtmm.sav'
save, bin_ch, f='bin_ch.sav'

END
