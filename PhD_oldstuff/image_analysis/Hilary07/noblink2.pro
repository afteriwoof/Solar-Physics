; Code which produces normalised exposure time data array and byte-scaling of same from Alex's data 18-apr-2000.
; Also removes disk surrounding Solar disk.


; This code uses fmedian after it applies the normalisation.


pro noblink, da_norm, danb

;fls = file_search('../18-apr-2000/*')

;mreadfits, fls, in, da

restore, '~/PhD/18apr2000.sav'

restore, '~/PhD/in.sav'

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

	da_norm(*,*,i) = im / in[i].exptime

	da_norm(*,*,i) = fmedian(da_norm(*,*,i), 5, 3)
	
	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225)
endfor



end

