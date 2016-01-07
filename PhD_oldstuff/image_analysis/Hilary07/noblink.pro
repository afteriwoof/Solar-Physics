; Code which produces normalised exposure time data array and byte-scaling of same from Alex's data 18-apr-2000.
; Also removes disk surrounding Solar disk.


; This code uses fmedian before it applies the normalisation or bytscl.
; fmedian calls fmedian_slow which takes a long time to run!!!

pro noblink, danb, diffnb

fls = file_search('../18-apr-2000/*')

mreadfits, fls, in, da

;restore, '~/PhD/18apr2000.sav'

;restore, '~/PhD/in.sav'

; Convert INT array to FLOAT
da = float(da)

da_norm = da

danb = da

sz = size(da, /dim)

; Remove inner disk
for i=0,sz[2]-1 do begin
	im = da(*,*,i)
	rm_inner, im, in[i], dr, thr=1.8
	
	;plot_image, im	
	;stop

	da(*,*,i) = fmedian(im, 5, 3)

	da_norm(*,*,i) = da(*,*,i) / in[i].exptime

	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225)
endfor

; Now computing Running Difference

diffn = fltarr(sz[0],sz[1],sz[2]-1)

diffnb = diffn

for i=0,sz[2]-2 do begin

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i)

	diffnb(*,*,i) = bytscl( diffn(*,*,i), -10, 18)

endfor


end

