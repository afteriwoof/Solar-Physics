; Routine to test the forward difference numerical differentiation technique for future use

pro f_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy, i, y_r_vel, y_r_acc, $
		percent_noise, f_lin_dist, tog=tog

	if (keyword_set(tog)) then begin

		toggle, /portrait, filename = 'f_diff_lin.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8

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

; Plot distance-time data from plain equation

	if (keyword_set(tog)) then begin
	
		plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy)], $
			title = 'Forward difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
			psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, thick = 2, xtitle = ' ', $
			xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.68, 0.95, 0.94]

	endif else begin
	
		plot, t[0:*:cadence], dist, xr = [0, max(t)], yr = [0, 1.1*max(dist_noisy)], $
			title = 'Forward difference plots, Std.Dev = ' + num2str(i), ytit = 'Distance (Mm)', $
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

; Define normalised time array for Taylor series analysis.

	t_norm = dindgen(time)/time

	t_cad = t_norm[0:*:cadence]

; Define ideal distance equation using normalised time array
	
	d = r0 + v0*t_cad

; Calculate numerically differentiated data for ideal noiseless data

	f_upper = d[2:max(n)-1] - d[1:max(n)-2]					; Upper line (y-difference)
	
	f_lower = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]			; Lower line (x-difference)

	f_velocity = (f_upper)/(f_lower)						; Combine upper and lower lines

; Define noisy distance equation using normalised time arrays

	d_noisy = r0 + v0*t_cad + noise

; Calculate numerically differentiated data for noisy data

	f_upper_noisy = d_noisy[2:max(n)-1] - d_noisy[1:max(n)-2]		; Upper line (y-difference)

	f_lower_noisy = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]			; Lower line (x-difference)

	f_velocity_noisy = (f_upper_noisy)/(f_lower_noisy)				; Combine upper and lower lines

;*************************
; Velocity Error Analysis
;*************************

; Calculate errors for ideal noiseless data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	f_err_upper = f_velocity[2:max(m)-1] - f_velocity[1:max(m)-2]

	f_err_lower = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	f_err = (f_err_upper)/(f_err_lower)

	f_error_vel = 1000.0d*(f_err/2.0d)*f_err_lower

; Calculate errors for noisy data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	f_err_upper_noisy = f_velocity_noisy[2:max(m)-1] - f_velocity_noisy[1:max(m)-2]

	f_err_lower_noisy = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	f_err_noisy = (f_err_upper_noisy)/(f_err_lower_noisy)
	
	f_error_vel_noisy = 1000.0d*(f_err_noisy/2.0d)*f_err_lower_noisy
	
; Fit equation to noisy data
	
	x = findgen(time)

	h_error = f_error_vel_noisy

	vel_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_lin_vel = mpfitexpr(vel_fit_195, t_norm[0:*:cadence], f_velocity_noisy, h_error, [1000*v0], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm, /quiet)

	t_size = size(x, /n_elements)

	lin_fit_vel = replicate(f_lin_vel[0], t_size)

;***************************
; Acceleration Calculations
;***************************

; Calculate numerically differentiated data for ideal noiseless data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	f_a_upper = f_velocity[2:max(m)-1] - f_velocity[1:max(m)-2]

	f_a_lower = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	f_accel = (f_a_upper)/(f_a_lower)

; Calculate numerically differentiated data for noisy data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	f_a_upper_noisy = f_velocity_noisy[2:max(m)-1] - f_velocity_noisy[1:max(m)-2]

	f_a_lower_noisy = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	f_accel_noisy = (f_a_upper_noisy)/(f_a_lower_noisy)

;*****************************
; Acceleration Error Analysis
;*****************************

; Calculate errors for ideal noiseless data

	t_c = t_cadence[1:max(m)-2]

	c = size(t_c, /n_elements)

	jerk_upper = f_accel[2:max(c)-1] - f_accel[1:max(c)-2]

	jerk_lower = t_c[2:max(c)-1] - t_c[1:max(c)-2]

	jerk_total = (jerk_upper)/(jerk_lower)

	f_error_acc = 1000.0d*(jerk_total/2.0d)*jerk_lower

; Calculate errors for noisy data

	jerk_upper_noisy = f_accel_noisy[2:max(c)-1] - f_accel_noisy[1:max(c)-2]

	jerk_lower_noisy = t_c[2:max(c)-1] - t_c[1:max(c)-2]

	jerk_total_noisy = (jerk_upper_noisy)/(jerk_lower_noisy)

	f_error_acc_noisy = 1000.0d*(jerk_total_noisy/2.0d)*jerk_lower_noisy
	
; Fit equation to noisy data
	
	x = findgen(time)

	h_error = f_error_acc_noisy

	acc_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -100
	pi(0).limited(1) = 1
	pi(0).limits(1) = 100

    f_lin_acc = mpfitexpr(acc_fit_195, t_cadence[1:max(m)-2], f_accel_noisy, h_error, [0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_acc = replicate(f_lin_acc[0], t_size)

;****************
; Velocity Plots
;****************

	t_plot = t_cad*time

	if (keyword_set(tog)) then begin
	
		plot, t_plot[1:max(n)-2], 1000.0d*f_velocity, xr = [0, max(t)], /xs, color = 0, $
			yr = [1.1*min(y_r_vel), 1.1*max(y_r_vel)], /ys, $
			ytit = 'Velocity (km/s)', psym = 2, charsize = 1, background = 1, thick = 2, $
			xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]

	endif else begin
	
		plot, t_plot[1:max(n)-2], 1000.0d*f_velocity, xr = [0, max(t)], /xs, color = 0, $
			yr = [1.1*min(y_r_vel), 1.1*max(y_r_vel)], /ys, $
			ytit = 'Velocity (km/s)', psym = 2, charsize = 2, background = 1, thick = 2

	endelse

	oplot, t_plot[1:max(n)-2], 1000.0d*f_velocity_noisy, psym = 2, color = 3, thick = 2

	oplot, x, lin_fit_vel, psym = 3, color = 5, thick = 2

	oploterr, t_plot[1:max(n)-2], 1000.0d*f_velocity, f_error_vel, /nohat, /noconnect, errthick = 2, $
		errcolor= 0

	oploterr, t_plot[1:max(n)-2], 1000.0d*f_velocity_noisy, f_error_vel_noisy, /nohat, /noconnect, $
		errthick = 2, errcolor= 3

	if (keyword_set(tog)) then begin

		legend, ['Ideal: v!D0!N = ' + num2str(1000.0d*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
				'Mean error (noisy data) = ' + num2str(mean(abs(f_error_vel_noisy)))], $
				textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear

	endif else begin

		legend, ['Ideal: v!D0!N = ' + num2str(1000.0d*v0) + ' km/s', 'Fit: v!D0!N = ' + num2str(f_lin_vel[0]) + ' km/s', $
				'Mean error (noisy data) = ' + num2str(mean(abs(f_error_vel_noisy)))], $
				textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	endelse

;********************
; Acceleration Plots
;********************

	t_plotting = t_cadence*time

	if (keyword_set(tog)) then begin

		plot, t_plotting[1:max(m)-2], 1000.0d*f_accel, xr = [0, max(t)], xtit = 'Time (s)', $
			yr = [1.1*min(y_r_acc), 1.1*max(y_r_acc)], /xs, /ys, thick = 2, $
			ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 1, $
			pos = [0.15, 0.1, 0.95, 0.37]

	endif else begin
	
		plot, t_plotting[1:max(m)-2], 1000.0d*f_accel, xr = [0, max(t)], xtit = 'Time (s)', $
			yr = [1.1*min(y_r_acc), 1.1*max(y_r_acc)], /xs, /ys, thick = 2, $
			ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 2

	endelse

	oplot, t_plotting[1:max(m)-2], 1000.0d*f_accel_noisy, psym = 2, color = 3, thick = 2

	oplot, x, lin_fit_acc, psym = 3, color = 5, thick = 2

	oploterr, t_plotting[1:max(m)-2], 1000.0d*f_accel, f_error_acc, /nohat, /noconnect, errthick = 2, $
		errcolor= 0

	oploterr, t_plotting[1:max(m)-2], 1000.0d*f_accel_noisy, f_error_acc_noisy, /nohat, /noconnect, $
		errthick = 2, errcolor= 3

	if (keyword_set(tog)) then begin

		legend, ['Ideal: a!D0!N = ' + num2str(0) + ' m/s/s', 'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
				'Mean error (noisy data) = ' + num2str(mean(abs(f_error_acc_noisy)))], $
				textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear

		toggle

	endif else begin

		legend, ['Ideal: a!D0!N = ' + num2str(0) + ' m/s/s', 'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
				'Mean error (noisy data) = ' + num2str(mean(abs(f_error_acc_noisy)))], $
				textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear

	endelse

end