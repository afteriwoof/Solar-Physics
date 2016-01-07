pro plot_res

; Change 1000 to 10 or 100000 to see how distribution changes

r = randomn(seed,4) * 5.
!p.charsize = 2
!p.multi = [ 0, 1, 2 ]

plot, r, psym = 1, title = 'random residuals', /xs, $
	xr = [min(r) - 0.25*min(r), max(r) + 0.25*max(r)]

; Calculate statistical distribution of residuals

rh = histogram( r, loc = loc )
plot, loc, rh, psym = 10, xr = [min(loc) - 0.25*min(loc), max(loc) + 0.25*max(loc)], $
		yr = [0, max(rh) + 0.25*max(rh)], /ys, /xs

mean_r = mean( r )
std_r  = stddev( r )	; Could also use moment()

print,mean_r
print,std_r

; General model with same mean and variance as data
;if ( mean_r lt 0 ) then mean_px = n_elements( loc ) / 2. + mean_r $
;                 else mean_px = n_elements( loc ) / 2. - mean_r

x = findgen(std_r*300.) / 10. - std_r*3.

gaussian = max( rh ) * exp(-(x - mean_r)^2./(2.*std_r^2.))

oplot, x, gaussian

;mean_px = mean_r
help,loc
;p_x = gauss_put( n_elements( loc ), 0, max( rh ), mean_px, std_r )

;oplot, loc, p_x

stop
end
    
