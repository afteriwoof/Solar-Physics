; Sub-routine called by kinematics_simulation that plots the variation from fit for varying cadence 
; at set noise level. 


pro kinematics_simulation_cadence

	!p.multi = [0, 1, 3]
	
	set_line_color

	window, 0, xs = 750, ys = 1000

	t = findgen( 1900 ) + 100.
	
	r_0 = 80.			; Initial distance = 80 Mm
	v_0 = 0.3			; Initial velocity = 300 km/s
	a_0 = 0.00005		; Initial acceleration = 50 m/s^2

	mean_0 = fltarr(601)
	mean_1 = fltarr(601)
	mean_2 = fltarr(601)

	percent_diff_dist = fltarr(201)
	percent_diff_vel = fltarr(201)
	percent_diff_acc = fltarr(201)

	noise_level = 0.01			; Noise level in % (0.1 = 10% noise)

;	j = 150
;	i = 1

	for j = 1, 600 do begin

	cadence = j

	for i = 0, 200 do begin

;*****DISTANCE*****

; Ideal plot - Distance

		r = r_0 + v_0*t + (1./2.)*(a_0)*t^2.

;		plot, t, r, yr = [0, 1000], xtitle = 'Time (s)', ytitle = 'Distance (Mm)', $
;				color = 0, background = 1, title = 'Kinematics simulation', xr = [0, 2100], /xs, $
;				thick = 2, charsize = 3.5, charthick = 2

; Obtain 'real' data by applying noise to cadence-affected ideal equation

		n = size(r[0:*:cadence], /n_elements)

		sig_h = r[0:*:cadence] * noise_level * randomn( seed, n ) 		; Noise level is given in % (0.1 = 10%)

		h_obs = r[0:*:cadence] + sig_h

		t_cad = t[0:*:cadence]
	
		y_err = sig_h + replicate(31., n)								; errors for oplotting
		t_err = replicate(0., n)
	
;		oplot, t_cad, h_obs, color = 3, psym = -2, thick = 2			; plot 'data'
;		oploterr, t_cad, h_obs, t_err, y_err, /nohat, errcolor = 3		; plot errors

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		h_err = y_err

		expr_dist_fit = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2'			; apply fit to 'data'

		pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
		pi(0).limited(0) = 1
		pi(0).limits(0) = 0.
		pi(1).limited(0) = 1
		pi(1).limits(0) = 0.01
		pi(1).limited(1) = 1
		pi(1).limits(1) = 0.5
		pi(2).limited(0) = 1
		pi(2).limits(0) = -0.00015
		pi(2).limited(1) = 1
		pi(2).limits(1) = 0.00015
	
		f_dist_fit = mpfitexpr(expr_dist_fit, t_cad, h_obs, h_err, [r_0, v_0, a_0], perror=perror, $
			parinfo = pi, bestnorm = bestnorm_0, /quiet)

		dist_fit = f_dist_fit[0] + f_dist_fit[1]*x + (1./2.)*f_dist_fit[2]*x^2.

;		oplot, xf, dist_fit, linestyle = 0, color = 4, thick = 3

		diff_dist = abs(r - dist_fit)
	
		percent_diff_dist[i] = mean((diff_dist/r)*100.)

; Print different relevant parameters

;		print, ' '
;		print, 'Initial distance (Mm) = ', r_0
;		print, 'Fitted distance (Mm) = ', f_dist_fit[0]
;		print, 'Initial velocity (km/s) = ', v_0*1000.
;		print, 'Fitted velocity (km/s) = ', f_dist_fit[1]*1000.
;		print, 'Initial acceleration (m/s/s) = ', a_0*1000000.
;		print, 'Fitted acceleration (m/s/s) = ', f_dist_fit[2]*1000000.
;		print, 'Amount of noise added to data (%) = ', noise_level*100.
;		print, 'Cadence of observed data (s) = ', cadence
;		print, 'Chi-squared of fit to data = ', bestnorm_0
;		print, ' '
;		print, '************'
;		print, 'Percentage difference between distance data fit and actual = ', percent_diff_dist[i]
;		print, '************'
;		print, ' '


;*****VELOCITY*****

; Ideal plot - Velocity
	
		v = 1000*(v_0 + a_0*t)											; Ideal velocity

; Cadence-affected data - derived from distance data

		vel = deriv(t_cad, h_obs*1000)									; obtain velocity from 'data'
	
		deltav = derivsig(t_cad, h_obs*1000, 0.0, (h_err*1000.))
	
;		plot, t, v, yr = [min(vel)-100, max(vel)+100], xtitle = 'Time (s)', ytitle = 'Velocity (kms!U-1!D)', $
;				color = 0, background = 1, xr = [0, 2100], /xs, /ys, $
;				thick = 2, charsize = 3.5, charthick = 2
;
;		oplot, t_cad, vel, color = 3, psym = -2, thick = 2
;		oploterr, t_cad, vel, t_err, deltav, /nohat, errcolor = 3

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		expr_vel_fit = 1000*(f_dist_fit[1] + f_dist_fit[2]*x)			; plot fit from distance data

;		oplot, xf, expr_vel_fit, linestyle = 0, color = 4, thick = 3

		vel_fit = 1000*(f_dist_fit[1] + f_dist_fit[2]*x)
	
		diff_vel = abs(v - vel_fit)
	
		percent_diff_vel[i] = mean((diff_vel/v)*100.)

;		print, '************'
;		print, 'Percentage difference between velocity data fit and actual = ', percent_diff_vel[i]
;		print, '************'
;		print, ' '

;*****ACCELERATION*****

; Ideal plot - Acceleration

		a = 1e6*(a_0)					; known ideal acceleration

		a = replicate(a, 1900)

; Cadence-affected data - derived from velocity data

		acc = deriv(t_cad, vel*1000)								; obtain acceleration from velocity data
		deltaa = derivsig(t_cad, vel*1000, 0.0, (deltav*1000.))
	
;		plot, t, a, yr = [min(acc)-150, max(acc)+150], xtitle = 'Time (s)', ytitle = 'Acceleration (ms!U-2!D)', $
;				color = 0, background = 1, xr = [0, 2100], /xs, /ys, $
;				thick = 2, charsize = 3.5, charthick = 2
;
;		oplot, t_cad, acc, color = 3, psym = -2, thick = 2
;		oploterr, t_cad, acc, t_err, deltaa, /nohat, errcolor = 3

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		acc_fit = 1e6*(f_dist_fit[2])					; apply fit to data

		expr_acc_fit = replicate(acc_fit, 1900)

;		oplot, xf, expr_acc_fit, linestyle = 0, color = 4, thick = 3

		diff_acc = abs(a - expr_acc_fit)
	
		percent_diff_acc[i] = mean((diff_acc/a)*100.)

;		print, '************'
;		print, 'Percentage difference between acceleration data fit and actual = ', percent_diff_acc[i]
;		print, '************'
;		print, ' '

		endfor

;	iterations = findgen(101)
;	
;	!p.multi = [0, 1, 3]
;
;	window, 0, xs = 1000, ys = 1000
;
;	plot, iterations, percent_diff_dist, xtitle = 'Iterations', ytitle = 'Percentage difference from fit', $
;			title = 'Variation of fit to distance data with iterations', charsize = 2.5
;	plot, iterations, percent_diff_vel, xtitle = 'Iterations', ytitle = 'Percentage difference from fit', $
;			title = 'Variation of fit to velocity data with iterations', charsize = 2.5
;	plot, iterations, percent_diff_acc, xtitle = 'Iterations', ytitle = 'Percentage difference from fit', $
;			title = 'Variation of fit to acceleration data with iterations', charsize = 2.5

	mean_0[j] = mean(percent_diff_dist)
	mean_1[j] = mean(percent_diff_vel)
	mean_2[j] = mean(percent_diff_acc)

	endfor

	iterations = findgen(601)
	
	!p.multi = [0, 1, 3]

	window, 0, xs = 750, ys = 1000

	plot, iterations, mean_0, xtitle = '!6Cadence', ytitle = '!6Mean percentage difference from fit', $
			title = '!6Variation of fit to distance data with iterations (Noise = 1%)', charsize = 2.5
	plot, iterations, mean_1, xtitle = '!6Cadence', ytitle = '!6Mean percentage difference from fit', $
			title = '!6Variation of fit to velocity data with iterations', charsize = 2.5
	plot, iterations, mean_2, xtitle = '!6Cadence', ytitle = '!6Mean percentage difference from fit', $
			title = '!6Variation of fit to acceleration data with iterations', charsize = 2.5

end