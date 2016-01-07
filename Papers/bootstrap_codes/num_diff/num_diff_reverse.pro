; Routine to test the reverse difference technique

pro num_diff_reverse

; Define routine parameters

	r0 = 150.0d		; Mm

	v0 = 0.4d		; 400 km/s
	
	a0 = -0.00005d	; -50 m/s/s

	time = 2000.0d	; s
	
	cadence = 10	; s
	
	i = 30			; Width of standard deviation

; Define time array

	t = findgen(time)

; Calculate noise to add to equations

	n = size(t[0:*:cadence], /n_elements)

	array = randomn(seed, n)

	noise = array * i

;*******************
; Reverse-difference
;*******************

; Define viewing window

	window, 0, xs = 800, ys = 1000
	
	!p.multi = [0, 1, 3]
	
	set_line_color

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

; Plot ideal equation data

	plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy)], $
		title = 'Forward difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
		psym = 2, charsize = 2, /xs, /ys, color = 0, background = 1, thick = 2

; Plot noisy data

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

; Plot line fitted to noisy data

	oplot, t, lin_fit_dist, psym = 3, color = 2, thick = 2













end