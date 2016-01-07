pro para_boot_test

mean = 20.0d
sigma = 5.0d

ranx = randomn(seed, 10000, /double, /normal)*sigma + mean

; used the random point to sample N(mean, sigma) dist

x = dindgen(10000)/250.0d

; output array

;for i =0, 2498 do begin

	random = 1.0/(sigma*sqrt(!dpi*2.0d))*exp( -((x-mean)^2.0)/(2.0*(sigma^2.0))) ; N(mean, sigam) dist

;	ran = floor(RANDOMU( seed , 100.0d, /DOUBLE, /uniform)*100.0d)


;	newdist[i] = mean( rany[i*4:i*4+4])  ; if there were 4 data points

;endfor



hist_0 = histogram(random, loc=loc0, binsize=1)
hist_1 = histogram(ranx, loc=loc1, binsize=1)

plot, loc1, hist_1, xr = [0, 50], /xs

plot, loc0, hist_0



stop

end