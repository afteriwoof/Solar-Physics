pro testnorm, mu_seg, diff3, sigdiff3, diff3norm, sigdiff3norm

loadct, 0

files = file_search('../18-apr-2000/*')

mreadfits, files, index, data

sz = size(data, /dim)

diff = fltarr(sz[0], sz[1], sz[2]-1)
sigdiff = diff

for i = 1, sz[2]-1 do begin

	diff(*, *, i-1) = data(*, *, i) - data(*, *, i-1)
	sigdiff(*,*,i-1) = smooth( sigrange( diff(*,*,i-1)), 5, /ed) 

endfor

szd = size(diff, /dim)

diff3 = diff(*,*,3)
sigdiff3 = sigdiff(*,*,3)

;plot_image, diff3
;window, /free
;plot_image, sigdiff3

plot_hist, diff3

;segment of background of image
seg = diff3(50:200, 200:950)

mu_seg = moment( diff3(50:200, 200:950), sdev=sdev)
print, 'mu_seg:' & print, mu_seg

window, /free
shade_surf, sigdiff3

print, 'Pixel Max, Min:'
pmm, diff3

;Trying to normalise by subtracting the mean (of the segment) to bring centre of histogram to the zero point
diff3norm = diff3 - mu_seg[0]
sigdiff3norm = smooth( sigrange( diff3norm), 5, /ed)

window, /free, title='diff3norm'
plot_hist, diff3norm

window, /free, title='sigdiff3norm'
plot_hist, sigdiff3norm

window, /free, title='diff3norm'
shade_surf, diff3norm

window, /free, title='sigdiff3norm'
shade_surf, sigdiff3norm





end
