; Routine to plot the variation in Distance-time data with varying std. dev. of noise.

pro image_varying_noise, cadence

	toggle, /portrait, filename = 'varying_noise.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8

	!p.multi = [0, 1, 2]

	set_line_color

; Define routine parameters

	r0 = 150.0d		; Mm

	v0 = 0.4d		; 400 km/s
	
	time = 2000.0d	; s

; Define time array

	t = dindgen(time)

; Calculate noise to add to equations

	n = size(t[0:*:cadence], /n_elements)

;	array = randomn(seed, n)

	restore, 'noise_array.sav'

; First Go - Zero Noise

	i = 0

	noise = array * i

; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(30.0d, n)

	dist_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_lin_dist = mpfitexpr(dist_fit_195, t[0:*:cadence], dist_noisy, h_error, [r0, v0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_dist = f_lin_dist[0] + f_lin_dist[1]*t

; Calculate % noise

	percent_noise = (abs(dist_noisy - dist)/dist)*100.0d

; Plot distance-time data from plain equation

	plot, t[0:*:cadence], dist, xr = [-50, max(t) + 50], yr = [0, 1.1*max(dist_noisy)], $
		title = 'Distance-time plots, Cadence = ' + num2str(cadence) + 's', ytit = 'Distance (Mm)', $
		psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, thick = 2, xtitle = ' ', $
		xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.68, 0.95, 0.94]

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2

	oploterr, t[0:*:cadence], dist, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], dist_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	legend, ['Min % noise = ' + num2str(min(percent_noise)), 'Max % noise = ' + num2str(max(percent_noise)), $
		'Mean % noise = ' + num2str(mean(percent_noise))], textcolors = [0, 0, 0], charsize = 0.8, /top, $
		/left, /clear

	legend, ['Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [3], charsize = 0.8, /bottom, /right, /clear

; Second Go - Standard Deviation = 30

	i = 150

	noise = array * i

; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(30.0d, n)

	dist_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_lin_dist = mpfitexpr(dist_fit_195, t[0:*:cadence], dist_noisy, h_error, [r0, v0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_dist = f_lin_dist[0] + f_lin_dist[1]*t

; Calculate % noise

	percent_noise = (abs(dist_noisy - dist)/dist)*100.0d

; Plot distance-time data from plain equation

	plot, t[0:*:cadence], dist, xr = [-50, max(t) + 50], yr = [0, 1.1*max(dist_noisy)], $
		title = ' ', ytit = 'Distance (Mm)', $
		psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, thick = 2, xtitle = ' ', $
		xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2

	oploterr, t[0:*:cadence], dist, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], dist_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	legend, ['Min % noise = ' + num2str(min(percent_noise)), 'Max % noise = ' + num2str(max(percent_noise)), $
		'Mean % noise = ' + num2str(mean(percent_noise))], textcolors = [0, 0, 0], charsize = 0.8, /top, $
		/left, /clear

	legend, ['Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [3], charsize = 0.8, /bottom, /right, /clear
	

; Third Go - Standard Deviation = 60

	i = 300

	noise = array * i

; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(30.0d, n)

	dist_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_lin_dist = mpfitexpr(dist_fit_195, t[0:*:cadence], dist_noisy, h_error, [r0, v0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_dist = f_lin_dist[0] + f_lin_dist[1]*t

; Calculate % noise

	percent_noise = (abs(dist_noisy - dist)/dist)*100.0d

; Plot distance-time data from plain equation

	plot, t[0:*:cadence], dist, xr = [-50, max(t) + 50], yr = [0, 1.1*max(dist_noisy)], $
		title = ' ', ytit = 'Distance (Mm)', $
		psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, thick = 2, xtit = 'Time (s)', $
		pos = [0.15, 0.1, 0.95, 0.37]

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2

	oploterr, t[0:*:cadence], dist, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], dist_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	legend, ['Min % noise = ' + num2str(min(percent_noise)), 'Max % noise = ' + num2str(max(percent_noise)), $
		'Mean % noise = ' + num2str(mean(percent_noise))], textcolors = [0, 0, 0], charsize = 0.8, /top, $
		/left, /clear

	legend, ['Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [3], charsize = 0.8, /bottom, /right, /clear

	toggle


end