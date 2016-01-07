; Routine to test the forward difference technique

pro num_diff_tester

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
; Centre-difference
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
		title = 'Reverse difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
		psym = 2, charsize = 2, /xs, /ys, color = 0, background = 1, thick = 2

; Plot noisy data

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

; Plot line fitted to noisy data

	oplot, t, lin_fit_dist, psym = 3, color = 2, thick = 2

;***********************
; Velocity Calculations
;***********************

; Define normalised time array for Taylor series analysis.

	t_norm = dindgen(time)/time

	t_cad = t_norm[0:*:cadence]

; Define ideal distance equation using normalised time array
	
	d = r0 + v0*t_cad

; Calculate numerically differentiated data for ideal noiseless data

	c_upper = d[2:max(n)-1] - d[0:max(n)-3] 				; Upper line (y-difference)
	
	c_lower = t_cad[2:max(n)-1] - t_cad[0:max(n)-3]			; Lower line (x-difference)

	c_velocity = (c_upper)/(c_lower)						; Combine upper and lower lines

; Define noisy distance equation using normalised time arrays

	d_noisy = r0 + v0*t_cad + noise

; Calculate numerically differentiated data for noisy data

	c_upper_noisy = d_noisy[2:max(n)-1] - d_noisy[0:max(n)-3]		; Upper line (y-difference)

	c_lower_noisy = t_cad[2:max(n)-1] - t_cad[0:max(n)-3]			; Lower line (x-difference)

	c_velocity_noisy = (c_upper_noisy)/(c_lower_noisy)				; Combine upper and lower lines

;***************************
; Acceleration Calculations
;***************************

; Calculate numerically differentiated data for ideal noiseless data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	c_a_upper = c_velocity[2:max(m)-1] - c_velocity[0:max(m)-3]

	c_a_lower = t_cadence[2:max(m)-1] - t_cadence[0:max(m)-3]

	c_accel = (c_a_upper)/(c_a_lower)

; Calculate numerically differentiated data for noisy data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	c_a_upper_noisy = c_velocity_noisy[2:max(m)-1] - c_velocity_noisy[0:max(m)-3]

	c_a_lower_noisy = t_cadence[2:max(m)-1] - t_cadence[0:max(m)-3]

	c_accel_noisy = (c_a_upper_noisy)/(c_a_lower_noisy)

;*************************
; Velocity Error Analysis
;*************************

; Calculate errors for ideal noiseless data

	t_c = t_cadence[1:max(m)-2]

	m = size(t_c, /n_elements)

	c_err_upper = c_accel[2:max(m)-1] - c_accel[0:max(m)-3]

	c_err_lower = t_c[2:max(m)-1] - t_c[0:max(m)-3]

	c_err = (c_err_upper)/(c_err_lower)

	c_error_vel = 1000.0d*(c_err/6.0d)*(c_err_lower)^2.

; Calculate errors for noisy data

	c_err_upper_noisy = c_accel_noisy[1:max(m)-1] - c_accel_noisy[0:max(m)-2]

	c_err_lower_noisy = t_c[1:max(m)-1] - t_c[0:max(m)-2]

	c_err_noisy = (c_err_upper_noisy)/(c_err_lower_noisy)
	
	c_error_vel_noisy = 1000.0d*(c_err_noisy/6.0d)*(c_err_lower_noisy)^2.
	
; Fit equation to noisy data
	
	x = findgen(time)

	h_error = c_error_vel_noisy

	vel_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_lin_vel = mpfitexpr(vel_fit_195, t_norm[0:*:cadence], c_velocity_noisy, h_error, [1000*v0], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm, /quiet)

	t_size = size(x, /n_elements)

	lin_fit_vel = replicate(f_lin_vel[0], t_size)

	y_r_vel = 1000.0d*c_velocity_noisy

;*****************************
; Acceleration Error Analysis
;*****************************

; Calculate errors for ideal noiseless data

	t_cad = t_c[1:max(m)-2]

	c = size(t_cad, /n_elements)

	jerk_upper = c_err[2:max(c)-1] - c_err[0:max(c)-3]

	jerk_lower = t_cad[2:max(c)-1] - t_cad[0:max(c)-3]

	jerk_total = (jerk_upper)/(jerk_lower)

	c_error_acc = 1000.0d*(jerk_total/6.0d)*jerk_lower

; Calculate errors for noisy data

	jerk_upper_noisy = c_err_noisy[2:max(c)-1] - c_err_noisy[0:max(c)-3]

	jerk_lower_noisy = t_cad[2:max(c)-1] - t_cad[0:max(c)-3]

	jerk_total_noisy = (jerk_upper_noisy)/(jerk_lower_noisy)

	c_error_acc_noisy = 1000.0d*(jerk_total_noisy/6.0d)*(jerk_lower_noisy)^2.
	
; Fit equation to noisy data
	
	x = findgen(time)

	h_error = c_error_acc_noisy

	acc_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -100
	pi(0).limited(1) = 1
	pi(0).limits(1) = 100

    f_lin_acc = mpfitexpr(acc_fit_195, t_cadence[1:max(m)-2], c_accel_noisy, h_error, [0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_acc = replicate(f_lin_acc[0], t_size)

;****************
; Velocity Plots
;****************

	t_plot = t_norm[0:*:cadence]*time

	plot, t_plot[1:max(n)-2], 1000.0d*c_velocity, xr = [0, max(t)], /xs, color = 0, $
		yr = [1.1*min(y_r_vel), 1.1*max(y_r_vel)], /ys, $
		ytit = 'Velocity (km/s)', psym = 2, charsize = 2, background = 1, thick = 2

	oplot, t_plot[1:max(n)-2], 1000.0d*c_velocity_noisy, psym = 2, color = 3, thick = 2

	oplot, x, lin_fit_vel, psym = 3, color = 2, thick = 2

	oploterr, t_plot[1:max(n)-2], 1000.0d*c_velocity, c_error_vel, /nohat, /noconnect, errthick = 2, $
		errcolor= 0

	oploterr, t_plot[1:max(n)-2], 1000.0d*c_velocity_noisy, c_error_vel_noisy, /nohat, /noconnect, $
		errthick = 2, errcolor= 3

	legend, ['Ideal: v!D0!N = ' + num2str(1000.0d*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
			'Mean error (noisy data) = ' + num2str(mean(abs(c_error_vel_noisy)))], $
			textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	noise_level_c_vel = mean(abs(c_error_vel_noisy))

;********************
; Acceleration Plots
;********************

	y_r_acc = 1000.0d*c_accel_noisy

	t_plotting = t_cadence*time

	plot, t_plotting[1:max(m)-2], 1000.0d*c_accel, xr = [0, max(t)], xtit = 'Time (s)', $
		yr = [1.1*min(y_r_acc), 1.1*max(y_r_acc)], /xs, /ys, thick = 2, $
		ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 2

	oplot, t_plotting[1:max(m)-2], 1000.0d*c_accel_noisy, psym = 2, color = 3, thick = 2

	oplot, x, lin_fit_acc, psym = 3, color = 2, thick = 2

	oploterr, t_plotting[1:max(m)-2], 1000.0d*c_accel, c_error_acc, /nohat, /noconnect, errthick = 2, $
		errcolor= 0

	oploterr, t_plotting[1:max(m)-2], 1000.0d*c_accel_noisy, c_error_acc_noisy, /nohat, /noconnect, $
		errthick = 2, errcolor= 3

	legend, ['Ideal: a!D0!N = ' + num2str(0) + ' m/s/s', 'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
			'Mean error (noisy data) = ' + num2str(mean(abs(c_error_acc_noisy)))], $
			textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	noise_level_f_acc = mean(abs(c_error_acc_noisy))


stop

end