; Routine to test problems with the taylor expansion coding

pro taylor_forward_test, cadence

	!p.multi = [0, 1, 3]

	set_line_color
	
	v0 = 0.4d
	r0 = 150.0d
	time = 2000.0d
	
; Define time array
	
	t = dindgen(time)

	n = size(t[0:*:cadence], /n_elements)
	array = randomn(seed, n)
	noise = array * 2.d

; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(30.d, n)

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

; Plot distance-time data from plain equation
	
	plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy)], $
		title = 'Forward difference plots', ytit = 'Distance (Mm)', psym = 2, $
		charsize = 2, /xs, /ys, color = 0, background = 1, thick = 2, xtitle = 'Time'

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2

	oploterr, t[0:*:cadence], dist, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], dist_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	legend, ['Ideal: r!D0!N = ' + num2str(r0) + ' Mm, v!D0!N = ' + num2str(1000*v0) + ' km/s', $
			'Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [0, 3], charsize = 1.5, /bottom, /right, /clear

;***********************
; Velocity Calculations
;***********************

; Define normalised time array for Taylor series analysis.

	t_norm = dindgen(time)/time

	t_cad = t_norm[0:*:cadence]

; Define ideal distance equation using normalised time array
	
	d = r0 + v0*t_cad

; Define noisy distance equation using normalised time arrays

	d_noisy = r0 + v0*t_cad + noise

; Calculate numerically differentiated data for ideal noiseless data

	num_diff_upper = d[2:max(n)-1] - d[1:max(n)-2]

	num_diff_lower = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	vel_num_diff = 1000.*((num_diff_upper)/(num_diff_lower))

	vel_num_diff_cad = 1000.*((num_diff_upper)/(num_diff_lower))

; Calculate numerically differentiated data for noisy data

	num_diff_upper_noisy = d_noisy[2:max(n)-1] - d_noisy[1:max(n)-2]

	num_diff_lower_noisy = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	vel_num_diff_noisy = 1000.*((num_diff_upper_noisy)/(num_diff_lower_noisy))

	vel_num_diff_noisy_cad = 1000.*((num_diff_upper_noisy)/(num_diff_lower_noisy))

;****************
; Velocity Plots
;****************

	t_plot = t_cad*time

	plot, t_plot[1:max(n)-2], vel_num_diff_cad, xr = [0, max(t)], /xs, color = 0, $
		yr = [1.1*min(vel_num_diff_noisy_cad), 1.1*max(vel_num_diff_noisy_cad)], /ys, $
		ytit = 'Velocity (km/s)', psym = 2, charsize = 2, background = 1, thick = 2, $
		xtitle = 'Time'

	oplot, t_plot[1:max(n)-2], vel_num_diff_noisy_cad, psym = 2, color = 3, thick = 2

;	oplot, t_plot, lin_fit_vel, psym = 3, color = 3, thick = 2
;
;	oploterr, t_plot[1:max(n)-2], vel_num_diff_cad, error_vel_cad, /nohat, /noconnect, errthick = 2, errcolor= 0
;
;	oploterr, t_plot[1:max(n)-2], vel_num_diff_noisy_cad, error_vel_noisy_cad, /nohat, /noconnect, errthick = 2, errcolor= 3

;	legend, ['Ideal: v!D0!N = ' + num2str(1000*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
;			'Mean error (noisy data) = ' + num2str(mean(error_vel_noisy_cad))], $
;			textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear
stop








end