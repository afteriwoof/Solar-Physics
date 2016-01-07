; Using the jason_lasco.bat file made by James to see how my atrous wavelet decomposition works against my previous difference imaging.

; Last Edited: 29-03-07

pro CME_atrous

;fls = file_search('~/PhD/Data_from_Alex/18-apr-00/*.fts')

;mreadfits, fls, in, da

restore, '~/PhD/Data_sav_files/da.sav'
restore, '~/PhD/Data_sav_files/in.sav'

sz_da = size(da, /dim)

im8 = da[*,*,8]
im8 = rm_inner(im8, in[8], dr_px, thr=2.3, plot=plot, fill=fill)
atrous, im8, decomp=decomp
;xstepper, decomp, xs=500, ys=500

seg = decomp[200:1000, 60:500, *]


;for i=0,sz_da[2] do begin
;	im = da[*,*,i]
;	atrous, im, decomp=decomp
;endfor









end
