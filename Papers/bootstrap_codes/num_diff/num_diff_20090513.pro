pro num_diff_20090513

	set_line_color

	!p.multi = [0, 1, 1]

	window, 0, xs = 750, ys = 450

; Define time array

	t = findgen( 1900 ) + 100.

; Define initial conditions
	
	r_0 = 80.			; Initial distance = 80 Mm
	v_0 = 0.3			; Initial velocity = 300 km/s
	a_0 = 0.00005		; Initial acceleration = 50 m/s^2

; Array to hold numbers for mean of chi-squared

	mean_chi_squared = fltarr(201)
	
	fit = fltarr(201)
	mean_fit = fltarr(201)

; Mean percentage difference of the fit from the model for each iteration for the distance, 
; velocity and acceleration

	chi_squared_0 = fltarr(201)

; Noise_level (for code-testing) and cadence in seconds

;	noise_level = 0.01			; Noise level in % (0.1 = 10% noise)
	cadence = 150				; Cadence in seconds

; Start of the FOR loop defining the noise levels to be tested.

	for j = 1, 200 do begin

; Noise_level corrected for the code

	noise_level = j/1000.

; FOR loop defining the number of iterations required.

	for i = 0, 200 do begin

;*****DISTANCE*****

; Ideal plot - Distance. Using constant acceleration model.

		r = r_0 + v_0*t + (0.5)*(a_0)*t^2.

; Plot ideal model

		plot, t, r, yr = [0, 1000], xtitle = 'Time (s)', ytitle = 'Distance (Mm)', $
				color = 0, background = 1, title = 'Kinematics simulation', xr = [0, 2100], /xs, $
				thick = 1, charsize = 1.5, charthick = 1

; Obtain 'real' data by applying noise to cadence-affected ideal equation

		n = size(r[0:*:cadence], /n_elements)

; Noise in data - slight increase in noise with distance from source due to increased dispersion

		sig_h = r[0:*:cadence] * noise_level * randomn( seed, n ) 		; Noise level is given in % (0.1 = 10%)

; Model added to noise in data to give pseudo-real data

		h_obs = r[0:*:cadence] + sig_h

		t_cad = t[0:*:cadence]

; Error in 'noisy' data
	
		y_err = sig_h + replicate(31., n)								; errors for oplotting
		t_err = replicate(0., n)

; Plot of 'real' data
	
		oplot, t_cad, h_obs, color = 3, psym = -2, thick = 2			; plot 'data'
;		oploterr, t_cad, h_obs, t_err, y_err, /nohat, errcolor = 3		; plot errors

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		h_err = y_err

; Constant acceleration model

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

; Best-fit to data

		dist_fit = f_dist_fit[0] + f_dist_fit[1]*x + (1./2.)*f_dist_fit[2]*x^2.

		oplot, xf, dist_fit, linestyle = 0, color = 4, thick = 3

; Percentage mean of difference between model and fit
	
		chi_squared_0[i] = bestnorm_0

; Percentage difference from model

		fit[i] = mean(abs(dist_fit - r)/(r))

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
;		print, 'Percentage difference between distance data fit and actual = ', percent_diff_dist[noise_level]
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

;		oplot, t_cad, vel, color = 3, psym = -2, thick = 2
;		oploterr, t_cad, vel, t_err, deltav, /nohat, errcolor = 3

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		expr_vel_fit = 1000*(f_dist_fit[1] + f_dist_fit[2]*x)			; plot fit from distance data

;		print, '************'
;		print, 'Percentage difference between velocity data fit and actual = ', percent_diff_vel[noise_level]
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

;		oplot, t_cad, acc, color = 3, psym = -2, thick = 2
;		oploterr, t_cad, acc, t_err, deltaa, /nohat, errcolor = 3

; Apply fit to noisy data

		x = findgen( 1900 ) + 100.
		xf = findgen( 1900 ) + 100.

		acc_fit = 1e6*(f_dist_fit[2])					; apply fit to data

		expr_acc_fit = replicate(acc_fit, 1900)

;		oplot, xf, expr_acc_fit, linestyle = 0, color = 4, thick = 3

		wait, 0.1

		endfor
	
		mean_chi_squared[j] = mean(chi_squared_0)

		mean_fit[j] = mean(fit)

	endfor

	iterations = findgen(201)/10.
	
	!p.multi = [0, 1, 2]

	window, 0, xs = 750, ys = 900

	plot, iterations, mean_chi_squared, xtitle = '!6% Noise level', ytitle = '!6 Mean chi squared of fit', $
			title = '!6Chi squared of fit wrt noise level (Cadence = 150s)', charsize = 1.5
	plot, iterations, mean_fit, xtitle = '!6% Noise level', ytitle = '!6% Mean distance from fit to model', $
			title = '!6Mean distance from fit to model wrt noise level (Cadence = 150s)', charsize = 1.5

	x2png, 'chi_squared_150s.png'	

stop








end