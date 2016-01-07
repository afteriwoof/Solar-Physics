pro plot_gauss

; Change 1000 to 10 or 100000 to see how distribution changes

r = randomn(seed,10) * 5.
!p.charsize = 2
!p.multi = [ 0, 1, 2 ]

plot, r, psym = 1, title = 'Random residuals', xr = [0, size(r, /n_elements)], /xs, $
		yr = [-10, 10], /ys

; Mean & standard deviation of residuals

mean_r = mean( r )
std_r  = stddev( r )	; Could also use moment()

print,mean_r
print,std_r

x = findgen(std_r*500.) / 10. - std_r*5.

; Calculate statistical distribution of residuals

rh = histogram( r, loc = loc )

gaussian = max( rh ) * exp(-(x - mean_r)^2./(2.*std_r^2.))

plot, x, gaussian, psym = 10, xr = [-3.*std_r, 3.*std_r], yr = [0, max( rh ) + 0.25*max( rh )], /xs, /ys


; Plot statistical distribution of residuals

oplot, loc, rh, psym = 10


help,loc

stop
end
    
