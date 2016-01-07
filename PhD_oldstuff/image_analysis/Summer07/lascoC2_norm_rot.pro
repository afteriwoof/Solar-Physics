; Performs background subtraction and normalisation on data.

; Last edited: 31-07-07

PRO lascoC2_norm_rot, path, dafn, in

fls = file_search(path)
mreadfits, fls, in

; Subtract background
bkgrd, path, da

; C2 data only
;c2da = where(in.detector eq 'C2') ;and in.naxis1 eq 1024)
;mreadfits, fls[c2da], in, c2da
ssw_fill_cube2, da, da

; Convert int to float
da = float(da)
dafn = da
sz = size(da, /dim)

; Remove inner disk and perform fmedian filter (slow!)
for i=0,sz[2]-1 do begin
	da[*,*,i] = rm_inner(da[*,*,i], in[i], dr_px, thr=2.2)
	da[*,*,i] = rm_outer(da[*,*,i], in[i], dr_px, thr=7.)
	dafn[*,*,i] = fmedian( (da[*,*,i]/in[i].exptime), 5, 3)
	dafn[*,*,i] = rot(dafn[*,*,i], 180, 1., in[i].crpix1, in[i].crpix2)
	writefits, 'norm_rot_'+time2file(in[i].date_d$0bs+'_'+in[i].time_d$obs,/sec)+'.fts', dafn[*,*,i], in[i]
endfor

; Computer running difference
;diffn = fltarr(sz[0], sz[1], sz[2]-1)
;for i=0,sz[2]-2 do begin
;	diffn[*,*,i] = dafn[*,*,i+1] - dafn[*,*,i]
;endfor



END
