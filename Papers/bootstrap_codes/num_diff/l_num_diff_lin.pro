; Routine to test the Lagrangian difference numerical differentiation technique for future use

pro l_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, i, y_r_vel, y_r_acc, $
		percent_noise, f_lin_dist, tog=tog

	if (keyword_set(tog)) then begin

		toggle, /portrait, filename = 'l_diff_lin.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
	
		!p.multi = [0, 1, 2]

	endif else begin
	
		window, 0, xs = 800, ys = 1000
	
		!p.multi = [0, 1, 3]

	endelse

	set_line_color

; Define time array
	
	t = dindgen(time)
	
; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise

; Calculate % noise

	percent_noise = (abs(dist_noisy - dist)/dist)*100.0d

; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(30., n)

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
	
	if (keyword_set(tog)) then begin
	
		plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy_f_lin)], $
			title = 'Lagrange difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
			psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, thick = 2, xtitle = ' ', $
			xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.68, 0.95, 0.94]

	endif else begin
	
		plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy_f_lin)], $
			title = 'Lagrange difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
			psym = 2, charsize = 2, /xs, /ys, color = 0, background = 1, thick = 2
	
	endelse

	oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_dist, psym = 3, color = 5, thick = 2

	oploterr, t[0:*:cadence], dist, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], dist_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	if (keyword_set(tog)) then begin

		legend, ['Ideal: r!D0!N = ' + num2str(r0) + ' Mm, v!D0!N = ' + num2str(1000*v0) + ' km/s', $
				'Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
				textcolors = [0, 3], charsize = 0.8, /bottom, /right, /clear

	endif else begin

		legend, ['Ideal: r!D0!N = ' + num2str(r0) + ' Mm, v!D0!N = ' + num2str(1000*v0) + ' km/s', $
				'Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
				textcolors = [0, 3], charsize = 1.5, /bottom, /right, /clear

	endelse

;***********************
; Velocity Calculations
;***********************

; Calculate numerically differentiated data for ideal noiseless data

	l_velocity = deriv(t[0:*:cadence], dist*1000.0d)

; Calculate numerically differentiated data for noisy data

	l_velocity_noisy = deriv(t[0:*:cadence], dist_noisy*1000.0d)

;*************************
; Velocity Error Analysis
;*************************

	l_error_vel = derivsig(t[0:*:cadence], dist*1000.0d, 0.0, (30.0d*1000.0d))

	l_error_vel_noisy = derivsig(t[0:*:cadence], dist_noisy*1000.0d, 0.0, (30.0d*1000.0d))
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = l_error_vel_noisy

	vel_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_lin_vel = mpfitexpr(vel_fit_195, t[0:*:cadence], l_velocity_noisy, h_error, [1000*v0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	t_size = size(x, /n_elements)

	lin_fit_vel = replicate(f_lin_vel[0], t_size)

;****************
; Velocity Plots
;****************

	if (keyword_set(tog)) then begin
	
		plot, t[0:*:cadence], l_error_vel, xr = [0, max(t)], /xs, color = 0, $
			yr = [1.1*min(y_r_vel), 1.1*max(y_r_vel)], /ys, $
			ytit = 'Velocity (km/s)', psym = 2, charsize = 1, background = 1, thick = 2, $
			xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]

	endif else begin
	
		plot, t[0:*:cadence], l_error_vel, xr = [0, max(t)], /xs, color = 0, $
			yr = [1.1*min(y_r_vel), 1.1*max(y_r_vel)], /ys, $
			ytit = 'Velocity (km/s)', psym = 2, charsize = 2, background = 1, thick = 2

	endelse

	oplot, t[0:*:cadence], l_velocity_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_vel, psym = 3, color = 5, thick = 2

	oploterr, t[0:*:cadence], l_velocity, l_error_vel, /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], l_velocity_noisy, l_error_vel_noisy, /nohat, /noconnect, errthick = 2, $
		errcolor= 3

	if (keyword_set(tog)) then begin

		legend, ['Ideal: v!D0!N = ' + num2str(1000.0d*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
				'Mean error (noisy data) = ' + num2str(abs(mean(l_error_vel_noisy)))], $
				textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear

	endif else begin

		legend, ['Ideal: v!D0!N = ' + num2str(1000.0d*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
				'Mean error (noisy data) = ' + num2str(abs(mean(l_error_vel_noisy)))], $
				textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	endelse

;***************************
; Acceleration Calculations
;***************************

; Calculate numerically differentiated data for ideal noiseless data

	l_accel = deriv(t[0:*:cadence], l_velocity*1000.0d)

; Calculate numerically differentiated data for noisy data

	l_accel_noisy = deriv(t[0:*:cadence], l_velocity_noisy*1000.0d)

;*****************************
; Acceleration Error Analysis
;*****************************

	l_error_acc = derivsig(t[0:*:cadence], l_velocity*1000.0d, 0.0, (l_error_vel*1000.0d))

	l_error_acc_noisy = derivsig(t[0:*:cadence], l_velocity_noisy*1000.0d, 0.0, (l_error_vel_noisy*1000.0d))

; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = l_error_acc_noisy

	acc_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -100
	pi(0).limited(1) = 1
	pi(0).limits(1) = 100

    f_lin_acc = mpfitexpr(acc_fit_195, t[0:*:cadence], l_accel_noisy, h_error, [0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_acc = replicate(f_lin_acc[0], t_size)

;********************
; Acceleration Plots
;********************

	if (keyword_set(tog)) then begin

		plot, t[0:*:cadence], l_accel, xr = [0, max(t)], xtit = 'Time (s)', $
			yr = [1.1*min(y_r_acc), 1.1*max(y_r_acc)], /xs, /ys, thick = 2, $
			ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 1, $
			pos = [0.15, 0.1, 0.95, 0.37]

	endif else begin
	
		plot, t[0:*:cadence], l_accel, xr = [0, max(t)], xtit = 'Time (s)', $
			yr = [1.1*min(y_r_acc), 1.1*max(y_r_acc)], /xs, /ys, thick = 2, $
			ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 2

	endelse

	oplot, t[0:*:cadence], l_accel_noisy, psym = 2, color = 3, thick = 2

	oplot, t, lin_fit_acc, psym = 3, color = 5, thick = 2

	oploterr, t[0:*:cadence], l_accel, l_error_acc, /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], l_accel_noisy, l_error_acc_noisy, /nohat, /noconnect, errthick = 2, $
		errcolor= 3

	if (keyword_set(tog)) then begin

		legend, ['Ideal: a!D0!N = ' + num2str(0) + ' m/s/s', 'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
				'Mean error (noisy data) = ' + num2str(abs(mean(l_error_acc_noisy)))], $
				textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear

		toggle

	endif else begin

		legend, ['Ideal: a!D0!N = ' + num2str(0) + ' m/s/s', 'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
				'Mean error (noisy data) = ' + num2str(abs(mean(l_error_acc_noisy)))], $
				textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	endelse

end