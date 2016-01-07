pro para_boot_tester

set_line_color

mu = 20.0d
err = 5.0d

range = 40

a = 1.0d/(err*sqrt(2.0d*!dpi))

;print, a

x = dindgen(2.0d*range) - (range/2.0d)

b = (x - mu)^2.0

;print, b

c = 2.0d*err^2.

y = b/c

z = exp(-y)

plot, x, z, xr = [0, 40], /xs, yr = [0, 1.1*max(z)], /ys

array = dblarr(1000)

for i = 0, 1000-1 do begin

	ran = RANDOMN( seed, 10.0d, /DOUBLE, /normal)*2.0d*range - (range/2.0d) + mu
	
;	print, ran
	
;	print, z[ran]
	
;	print, mean(z[ran])
	
	array[i] = mean(z[ran])
	
endfor

;print, array

hist = histogram(array, loc = loc, binsize = 0.01)

plot, loc, hist, xr = [-1, 1]

stop








;ranx = randomn(seed, 1000, /double, /normal)*err + mu

;hist_1 = histogram(ranx, loc=loc1, binsize=1)

;plot, loc1, hist_1;, xr = [0, 40], /xs, yr = [0, 1.1*max(z)], /ys

;oplot, x, z, color = 3

;stop





;ranx = randomn(seed, 10000, /double, /normal)*sigma + mean

; used the random point to sample N(mean, sigma) dist

;x = dindgen(100000) - 50000.0

newdist = dblarr(101)
; output array

for i =0, 99 do begin

;	random = ((1.0d)/(sqrt(2.0d*!dpi)))*(exp(-(x^2.0)/(2.0d)))


;	random = 1.0/(sigma*sqrt(!dpi*2.0d))*exp( -((x-mean)^2.0)/(2.0*(sigma^2.0))) ; N(mean, sigam) dist
;stop
	ran = floor(RANDOMU( seed , 10.0d, /DOUBLE, /uniform)*1000.0d)


	newdist[i] = mean(z[ran])  ; if there were 4 data points

endfor



hist_0 = histogram(newdist, loc=loc0, binsize=1)
hist_1 = histogram(ranx, loc=loc1, binsize=1)

;plot, loc1, hist_1, xr = [0, 50], /xs

plot, loc0, hist_0



stop

end