; Routine that re-calculates the forward differencing technique. This is intended to replace 
; f_num_diff_lin.pro

pro lagrange_diff, cadence, r0, v0, time, n, noise, i, f_lin_dist, mean_error_vel, $
	mean_error_acc, scatter_v, scatter_a, images=images, tog=tog

	error = 10.0d

	if (keyword_set(tog)) then begin

		toggle, /portrait, filename = 'l_diff_lin.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
		!p.multi = [0, 1, 2]
		set_line_color

	endif
	
	if (keyword_set(images)) then begin
	
		window, 0, xs = 800, ys = 1000
		!p.multi = [0, 1, 3]
		set_line_color

	endif

; Define time array
	
	t = dindgen(time)
	
; Define ideal distance equation
	
	dist = r0 + v0*t[0:*:cadence]

; Define noisy distance equation

	dist_noisy = r0 + v0*t[0:*:cadence] + noise[0:*:cadence]

; Calculate % noise

	percent_noise = (abs(dist_noisy - dist)/dist)*100.0d
	
	mean_percent_noise = mean(percent_noise)
	
; Fit equation to noisy data
	
	x = dindgen(time)

	h_error = replicate(error, n)

	dist_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.6

    f_lin_dist = mpfitexpr(dist_fit_195, t[0:*:cadence], dist_noisy, h_error, [r0, v0], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm, /quiet)

	lin_fit_dist = f_lin_dist[0] + f_lin_dist[1]*t

	ideal_line = r0 + v0*t

; Plot distance-time data from plain equation

	if (keyword_set(tog)) then begin
	
		plot, t[0:*:cadence], dist, xr = [-50, max(t) + 50], yr = [0, 1.1*max(dist_noisy)], $
			title = 'Lagrange difference plots, Cadence = ' + num2str(cadence) + 's', $
			ytit = 'Distance (Mm)', psym = 2, charsize = 1, /xs, /ys, color = 0, background = 1, $
			thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.68, 0.95, 0.94]

		oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2
		oplot, t, ideal_line, psym = 3, color = 0, thick = 2
		oploterr, t[0:*:cadence], dist, replicate(error, n), /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], dist_noisy, replicate(error, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	endif
	
	if (keyword_set(images)) then begin
	
		plot, t[0:*:cadence], dist, xr = [-50, max(t) + 50], yr = [0, 1.1*max(dist_noisy)], $
			title = 'Lagrange difference plots, Std. Dev. = ' + num2str(i) + ', Cadence = ' + num2str(cadence) + 's', $
			ytit = 'Distance (Mm)', psym = 2, charsize = 2, /xs, /ys, color = 0, background = 1, $
			thick = 2
	
		oplot, t[0:*:cadence], dist_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_dist, psym = 3, color = 3, thick = 2
		oplot, t, ideal_line, psym = 3, color = 0, thick = 2
		oploterr, t[0:*:cadence], dist, replicate(error, n), /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], dist_noisy, replicate(error, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	endif

	if (keyword_set(tog)) then begin

		legend, ['Min % noise = ' + num2str(min(percent_noise)), 'Mean % noise = ' + num2str(mean(percent_noise)), $
			'Max % noise = ' + num2str(max(percent_noise))], textcolors = [0, 0, 0], charsize = 0.8, /top, $
			/left, /clear, outline_color = 0
	
		legend, ['Ideal: r!D0!N = ' + num2str(r0) + ' Mm, v!D0!N = ' + num2str(1000*v0) + ' km/s', $
			'Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [0, 3], charsize = 0.8, /bottom, /right, /clear, outline_color = 0

	endif
	
	if (keyword_set(images)) then begin
	
		legend, ['Min % noise = ' + num2str(min(percent_noise)), 'Mean % noise = ' + num2str(mean(percent_noise)), $
			'Max % noise = ' + num2str(max(percent_noise))], textcolors = [0, 0, 0], charsize = 1.5, /top, $
			/left, /clear, outline_color = 0

		legend, ['Ideal: r!D0!N = ' + num2str(r0) + ' Mm, v!D0!N = ' + num2str(1000*v0) + ' km/s', $
			'Fit: r!D0!N = ' + num2str(f_lin_dist[0]) + ' Mm, v!D0!N = ' + num2str(1000*f_lin_dist[1]) + ' km/s'], $
			textcolors = [0, 3], charsize = 1.5, /bottom, /right, /clear, outline_color = 0

	endif
	
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

	l_error_vel = derivsig(t[0:*:cadence], dist*1000.0d, 0.0, (error*1000.0d))

	l_error_vel_noisy = derivsig(t[0:*:cadence], dist_noisy*1000.0d, 0.0, (error*1000.0d))

	mean_error_vel = mean(abs(l_error_vel_noisy))
	
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

	vel_diff_lower = mean(l_velocity_noisy) - min(l_velocity_noisy)
	vel_diff_upper = max(l_velocity_noisy) - mean(l_velocity_noisy)

	scatter_v = abs(vel_diff_upper) + abs(vel_diff_lower)

	if (keyword_set(tog)) then begin
	
		plot, t[0:*:cadence], l_velocity, xr = [-50, max(t) + 50], /xs, color = 0, $
			yr = [mean(l_velocity_noisy) - 1.1*vel_diff_lower, $
			mean(l_velocity_noisy) + 1.1*vel_diff_upper], $
			/ys, ytit = 'Velocity (km/s)', psym = 2, charsize = 1, background = 1, thick = 2, $
			xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]

		oplot, t[0:*:cadence], l_velocity_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_vel, psym = 3, color = 3, thick = 2
		oploterr, t[0:*:cadence], l_velocity, l_error_vel, /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], l_velocity_noisy, l_error_vel_noisy, /nohat, /noconnect, errthick = 2, $
			errcolor= 3

	endif
	
	if (keyword_set(images)) then begin
	
		if (i EQ 0) then begin
		
			plot, t[0:*:cadence], l_velocity, xr = [-50, max(t) + 50], /xs, color = 0, $
				yr = [mean(l_velocity_noisy) - 50., mean(l_velocity_noisy) + 50.], /ys, $
				ytit = 'Velocity (km/s)', psym = 2, charsize = 2, background = 1, thick = 2

		endif else begin
		
			plot, t[0:*:cadence], l_velocity, xr = [-50, max(t) + 50], /xs, color = 0, $
				yr = [mean(l_velocity_noisy) - 1.1*vel_diff_lower, $
				mean(l_velocity_noisy) + 1.1*vel_diff_upper], /ys, ytit = 'Velocity (km/s)', $
				psym = 2, charsize = 2, background = 1, thick = 2
		
		endelse

		oplot, t[0:*:cadence], l_velocity_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_vel, psym = 3, color = 3, thick = 2
		oploterr, t[0:*:cadence], l_velocity, l_error_vel, /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], l_velocity_noisy, l_error_vel_noisy, /nohat, /noconnect, errthick = 2, $
			errcolor= 3

	endif

	if (keyword_set(tog)) then begin

		legend, ['No noise: v!D0!N = ' + num2str(mean(l_velocity)) + ' km/s', 'Fit: v!D0!N = ' + $
			num2str(f_lin_vel[0]) + ' km/s', 'Mean error = ' + num2str(abs(mean(l_error_vel_noisy)))], $
			textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear, outline_color = 0

	endif
	
	if (keyword_set(images)) then begin
	
		legend, ['No noise: v!D0!N = ' + num2str(mean(l_velocity)) + ' km/s', 'Fit: v!D0!N = ' + $
			num2str(f_lin_vel[0]) + ' km/s', 'Mean error = ' + num2str(abs(mean(l_error_vel_noisy)))], $
			textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear, outline_color = 0

	endif

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

;	print, l_error_acc_noisy

	mean_error_acc = mean(abs(l_error_acc_noisy))
	
;	print, mean_error_acc
	
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

	scatter_a = abs(min(l_accel_noisy)) + abs(max(l_accel_noisy))

	if (keyword_set(tog)) then begin

		plot, t[0:*:cadence], l_accel, xr = [-50, max(t) + 50], xtit = 'Time (s)', $
			yr = [1.1*min(l_accel_noisy), 1.1*max(l_accel_noisy)], /xs, /ys, thick = 2, $
			ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 1, $
			pos = [0.15, 0.1, 0.95, 0.37]

		oplot, t[0:*:cadence], l_accel_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_acc, psym = 3, color = 3, thick = 2
		oploterr, t[0:*:cadence], l_accel, l_error_acc, /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], l_accel_noisy, l_error_acc_noisy, /nohat, /noconnect, errthick = 2, $
			errcolor= 3

	endif
	
	if (keyword_set(images)) then begin
	
		if (i EQ 0) then begin
		
			plot, t[0:*:cadence], l_accel, xr = [-50, max(t) + 50], xtit = 'Time (s)', $
				yr = [-50, 50], /xs, /ys, thick = 2, $
				ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 2

		endif else begin
		
			plot, t[0:*:cadence], l_accel, xr = [-50, max(t) + 50], xtit = 'Time (s)', $
				yr = [1.1*min(l_accel_noisy), 1.1*max(l_accel_noisy)], /xs, /ys, thick = 2, $
				ytit = 'Acceleration (m/s/s)', background = 1, color = 0, psym = 2, charsize = 2

		endelse

		oplot, t[0:*:cadence], l_accel_noisy, psym = 2, color = 3, thick = 2
		oplot, t, lin_fit_acc, psym = 3, color = 3, thick = 2
		oploterr, t[0:*:cadence], l_accel, l_error_acc, /nohat, /noconnect, errthick = 2, errcolor= 0
		oploterr, t[0:*:cadence], l_accel_noisy, l_error_acc_noisy, /nohat, /noconnect, errthick = 2, $
			errcolor= 3

	endif

	if (keyword_set(tog)) then begin

		legend, ['No noise: a!D0!N = ' + num2str(mean(l_accel)) + ' m/s/s', $
			'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
			'Mean error = ' + num2str(abs(mean(l_error_acc_noisy)))], $
			textcolors = [0, 3, 3], charsize = 0.8, /bottom, /right, /clear, outline_color = 0

		toggle

	endif
	
	if (keyword_set(images)) then begin
	
		legend, ['No noise: a!D0!N = ' + num2str(mean(l_accel)) + ' m/s/s', $
			'Fit: a!D0!N = ' + num2str(f_lin_acc[0]) + ' m/s/s', $
			'Mean error = ' + num2str(abs(mean(l_error_acc_noisy)))], $
			textcolors = [0, 3, 3], charsize = 1.5, /bottom, /right, /clear, outline_color = 0

	endif

end