; Code taken from James' canny_atrous.pro and changed to be called by fwt_canny2d.pro written by Jason but with the filters from Alex's codes fwt2_mallet.m

; Last Edited: 26-09-07

PRO fwt_canny, image, decomposition=decomp, filter=filter, n_scales=n_scales, $
	check=check, mirror_padded=mirror_padded

; based on atrous.pro

if n_elements(filter) eq 0 then begin
	filter = [0, 0, 1, 3, 3, 1, 0]*(sqrt(2)/4.)
	grad = [0, 0, 0, -2, 2, 0, 0]*(sqrt(2)/4.)
endif

sz = size(image)
if keyword_set(mirror_padded) then fac=3. else fac=1.

n_scales = floor(alog((sz[1])/(n_elements(filter)*fac))/alog(2))

if keyword_set(check) then return
decomp = fltarr(sz[1], n_scales+1)

im = image
for k=0,n_scales-1 do begin
	; smooth image with a convolution by a filter
	smoothed = convolve(im, filter)
	coeffs = convolve(smoothed, grad)
	decomp[*, n_scales-k] = coeffs
	im = smoothed
	; Generate new filter










END
