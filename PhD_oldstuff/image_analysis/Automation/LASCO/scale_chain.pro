; Code to de-noise an image by chaining only the maxima points through scale.

; Last Edited: 03-10-07

PRO scale_chain, da, mask

ans = ''

sz = size(da, /dim)
mask = fltarr(sz[0],sz[1],sz[2])

for k=0,sz[2]-1 do begin

	im = da[*,*,k]
	
	canny_atrous2d, im, modgrad, alpgrad;, rows=rows, columns=cols
			
	for m=1,6 do begin
		
		mu = moment(modgrad[*,*,m], sdev=sdev)
		thr = mu[0] + 0.01*sdev
		thrmod = modgrad[*,*,m]
		;plot_image, modgrad[*,*,m]^0.4
		;read, 'ok?', ans
		thrmod[where(thrmod lt thr)] = 0
		thrmod[where(thrmod ne 0)] = 1
		;plot_image, thrmod
		;read, 'ok?', ans
		;if m eq 1 then mask[*,*,k] = thrmod
		;if m ne 1 then mask[*,*,k] = mask[*,*,k]*thrmod
		if m eq 1 then mask[*,*,k] = thrmod
		if m ne 1 then mask[*,*,k] = (mask[*,*,k]+thrmod)
	endfor

endfor


END
