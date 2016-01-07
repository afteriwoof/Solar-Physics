; Using running difference technique to specify a Mask from the intensity changes.
; Using methods outlined in SEEDS Oledo paper (see rundiff_seeds.pro)

;Last Edited: 08-08-08

pro rdiff_window, da, diff

sz = size(da, /dim)

diff = fltarr(sz[0], sz[1], sz[2]-1)

for k=0,sz[2]-2 do begin
	mean0 = (moment(da[*,*,k]))[0]
	mean1 = (moment(da[*,*,k+1]))[0]
	div = mean1 / mean0
	im = da[*,*,k] * div
	diff[*,*,k] = da[*,*,k+1] - im

	
endfor



end
