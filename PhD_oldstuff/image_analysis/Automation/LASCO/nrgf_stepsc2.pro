; Code for radial filtereing steps from Huw Morgan for Lasco

; Last Edited: 02-10-07

PRO nrgf_stepsC2, in, da, filt

sz = size(da, /dim)

filt = fltarr(sz[0], sz[1], sz[2])

for i=0,sz[2]-1 do begin

	pre_make_pos, in[i], da[*,*,i], x, y

	r = make_pos(x,y)

	index = where( r gt 2.2 and r lt 7., comp=nindex )

	im2 = nrgf(da[*,*,i], r, index)

	im2[nindex] = avg(im2[index])

	filt[*,*,i] = im2

endfor




END
