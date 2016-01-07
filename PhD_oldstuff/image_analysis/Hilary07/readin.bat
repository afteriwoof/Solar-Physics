fls = file_search('../18-apr-2000/*')

mreadfits, fls, in, da

da = float(da)

sz = size(da, /dim)

seg = fltarr(200, 200, sz[2])

for i=0,sz[2]-1 do begin & $

	seg(*,*,i) = da(10:209, 400:599, i) & $

endfor

mn = fltarr(sz[2])

for i=0,sz[2]-1 do begin & $

	mn(i) = mean(da(*,*,i)) & $

endfor

;sample one image
;plot_hist, da(*,*,0), xr=[0,6000], yr=[0,1000] & plots, [mn(0),mn(0)], [0,1000]
;print, mn(0)

;(subtract pedestal but it's 0 here anyway) and divide by max(im)

mx = max(da(*,*,0))

;da_new = da(*,*,0) / mx
;plot_hist, da_new

;NORMALISE FOR EXPOSURE TIME

da_norm = da

for i=0,sz[2]-1 do begin & $

	da_norm(*,*,i) = da(*,*,i) / in[i].exptime & $

endfor

; So da_norm is the normalised data for image processing

;Try to display / create movie without blinking

da_disp = da

for i=0,sz[2]-1 do begin & $

	da_disp(*,*,i) = bytscl(da_norm(*,*,i), 75, 135) & $

endfor

;looking at display of segment

da3 = da(*,*,3)
da4 = da(*,*,4)

seg3 = da3(10:209, 400:599)
seg4 = da4(10:209, 400:599)

;Normalise for exposure
seg3_norm = seg3 / in[3].exptime
seg4_norm = seg4 / in[4].exptime

seg3nb = bytscl(seg3_norm, 75, 135)
seg4nb = bytscl(seg4_norm, 75, 135)

barr34 = fltarr(200,200,2)
barr34(*,*,0) = seg3nb
barr34(*,*,1) = seg4nb

