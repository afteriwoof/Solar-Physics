; Created:	2014-08-27	to interpolate across the ellipse fits for the parameter info for intermediate frames, overcoming cadence offsets between images.

; t	is the time of the ellipse fit.
; ei	is the ell_info containing 1)semimajor 2)semiminor 3)angle_mj 4)aw 5)height_centre 6)height_apex
; re	is the r_err, error on the height.
; xe	is the x_ellipse, x-coords of the ellipse.
; ye	is the y_ellipse, y-coords of the ellipse.
; pe	is the perror, error on the parameters from the mpfitellipse.
; mhf	is the max_h_front, maximum height along the front.
; mhe	is the max_h_ell, maximum height along the ellipse.
; aa	is the apex_a, the angle of the apex of the ellipse.


pro interp_ell_info, path, test_time, tog=tog

path = '~/Postdoc/SWAP/20130726'
;test_time = '2013-07-26T18:18:15'

ell_fls = file_search(path+'/ell_arcsec*sav')

times = strarr(n_elements(ell_fls))
centers = fltarr(2,n_elements(ell_fls))
smjs = fltarr(n_elements(ell_fls))
smns = fltarr(n_elements(ell_fls))
tilts = fltarr(n_elements(ell_fls))

for i=0,n_elements(ell_fls)-1 do begin & $
        restore, ell_fls[i] & $
	times[i] = t & $
        centers[0,i] = ave(xe) & $
        centers[1,i] = ave(ye) & $
        smjs[i] = ei[0] & $
        smns[i] = ei[1] & $
        tilts[i] = ei[2] & $
endfor

base = anytim(times[0])
atimes = anytim(times) - base
itimes = findgen(atimes[n_elements(atimes)-1])
t = findgen(max(itimes))*((n_elements(atimes)-1)/max(itimes))
x = indgen(n_elements(ell_fls))

if keyword_set(tog) then begin
	set_plot, 'ps'
	device, /encapsul, bits=8, language=2, /portrait, /color, filename='interp_ell_info_'+strmid(times[0],0,10)+'.eps', xs=20, ys=20
	!p.charsize=1.2
	!p.thick=4
	!p.charthick=4
	!x.thick=4
	!y.thick=4
endif else begin
	window, 1, xs=600, ys=600
	!p.charsize=1
	!p.thick=1
        !p.charthick=1
        !x.thick=1
        !y.thick=1
endelse

!p.multi = 0
set_line_color

test = anytim(test_time)-base
; add a time-range of 5% to edge of plot.
range_edge = (anytim(times[n_elements(times)-1])-anytim(times[0]))*0.05

utplot, atimes, centers[0,*], base, psym=1, color=7, tit='Ellipse parameters', $
	ytit='Arcseconds', ystyle=8, yr=[min(centers[*,*]),max(centers[*,*])+max(centers[*,*])*0.35], $
	xr=[anytim(times[0])-base-range_edge,$
	anytim(times[n_elements(times)-1])-base+range_edge],/xs, $
	pos=[0.15,0.1,0.85,0.9]
fit = spline(x,centers[0,*],t)
xc = fit[round(test)]
outplot, itimes, fit, line=0, color=7

outplot, atimes, centers[1,*], psym=7, color=3
fit = spline(x,centers[1,*],t)
yc = fit[round(test)]
outplot, itimes, fit, line=0, color=3

outplot, atimes, smjs, psym=4, color=4
fit = spline(x,smjs,t)
smj = fit[round(test)]
outplot, itimes, fit, line=0, color=4

outplot, atimes, smns, psym=5, color=5
fit = spline(x,smns,t)
smn = fit[round(test)]
outplot, itimes, fit, line=0, color=5

axis, yaxis=1, yrange=[0,180], ytit='Degrees', /ys, color=6, /save
outplot, atimes, tilts, psym=6, color=6
fit = spline(x,tilts,t)
tilt = fit[round(test)]
outplot, itimes, fit, line=0, color=6

verline, test, line=2

legend, ['x center','y center','semimajor','semiminor','tilt angle'], $
	psym=[1,7,4,5,6], color=[7,3,4,5,6]

legend,test_time,line=2,/right

if keyword_set(tog) then begin
	device, /close
	set_plot, 'x'
endif

end
