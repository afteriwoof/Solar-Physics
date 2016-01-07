; Routine to examine the statistics of the different wave events. Here looking at the 20070519 event.
; This routine has been replaced by wave_statistics, which has been designed to be as general as possible.

pro wave_statistics_20090526

	!p.multi = [0, 2, 2]

	window, 0, xs = 1000, ys = 1000

	restore, '20070519_dist.sav'

	time195 = anytim('2007/05/19' + ' ' + t195)
	time171 = anytim('2007/05/19' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]
	t195 = time195 - time171[0]

	g_d_195 = size(grt_dist_195, /n_elements)
	g_d_171 = size(grt_dist_171, /n_elements)

; Root mean squared calculation

	rms_a_0 = grt_dist_195^2.
	rms_a = total(rms_a_0)
	
	rms = sqrt(rms_a/g_d_195)
	
	print, rms

; Plot 195A data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n, RMS = ' + num2str(rms), $
		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 1.5, /xs, /ys
	uterrplot, tim195, grt_dist_195 + 39, grt_dist_195 - 39
	
; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = replicate(39., g_d_195)

	expr_195_1 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195, /quiet)

	dist_fit_195_1 = f_195_1[0] + f_195_1[1]*x + (1./2.)*f_195_1[2]*x^2.

	oplot, xf, dist_fit_195_1, linestyle = 2, thick = 1

	dist_fit_195_t = f_195_1[0] + f_195_1[1]*tim195 + (1./2.)*f_195_1[2]*tim195^2.

	residuals_a_195 = dist_fit_195_t - grt_dist_195

; blast fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	expr_195_2 = 'p[0] + p[1] * x + p[2] * x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = -3
	pi(3).limited(1) = 1
	pi(3).limits(1) = 3

    f_195_2 = mpfitexpr(expr_195_2, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195, /quiet)

	dist_fit_195_2 = f_195_2[0] + f_195_2[1]*x + f_195_2[2]*x^f_195_2[3]

	oplot, xf, dist_fit_195_2, linestyle = 3, thick = 1

	dist_fit_195_s = f_195_2[0] + f_195_2[1]*tim195 + f_195_2[2]*tim195^f_195_2[3]

	residuals_b_195 = dist_fit_195_s - grt_dist_195

	legend, ['Constant a', 'Varying a'], linestyle = [2, 3], charsize = 1.5

; Root mean squared calculation (residuals)

	rms_a_res = residuals_a_195^2.
	rms_res_a = total(rms_a_res)

	rms_b_res = residuals_b_195^2.
	rms_res_b = total(rms_b_res)
	
	res_a_195 = sqrt(rms_res_a/g_d_195)
	res_b_195 = sqrt(rms_res_b/g_d_195)
	
	print, res_a_195
	print, res_b_195

	plot, tim195, residuals_a_195, xr = [min(tim195) - 100, max(tim195) + 100], /xs, psym = 2, charsize = 1.5, $
			ytitle = 'Residuals (Mm)', xtitle = 'Time range (s)', title = 'Detrended data - 20070519', /ys, $
			yr = [min(residuals_a_195) - 5, max(residuals_a_195) + 5]

	oplot, tim195, residuals_b_195, psym = 4

	legend, ['Constant a, RMS = ' + num2str(res_a_195), 'Varying a, RMS = ' + num2str(res_b_195)], $
			psym = [2, 4], /right, charsize = 1.5

; Root mean squared calculation

	rms_a_0 = grt_dist_171^2.
	rms_a = total(rms_a_0)
	
	rms = sqrt(rms_a/g_d_171)
	
	print, rms

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n, RMS = ' + num2str(rms), $
		timerange = [min(time171) - 60, max(time171) + 60], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 1.5, /xs, /ys
	uterrplot, t171, grt_dist_171 + 39, grt_dist_171 - 39

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = replicate(39., g_d_171)
	
	expr_171_1 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171, /quiet)

	dist_fit_171_1 = f_171_1[0] + f_171_1[1]*x + (1./2.)*f_171_1[2]*x^2.

	oplot, xf, dist_fit_171_1, linestyle = 2, thick = 1

	dist_fit_171_t = f_171_1[0] + f_171_1[1]*t171 + (1./2.)*f_171_1[2]*t171^2.

	residuals_a_171 = dist_fit_171_t - grt_dist_171

; blast fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	expr_171_2 = 'p[0] + p[1] * x + p[2] * x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = -3
	pi(3).limited(1) = 1
	pi(3).limits(1) = 3

    f_171_2 = mpfitexpr(expr_171_2, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171, /quiet)

	dist_fit_171_2 = f_171_2[0] + f_171_2[1]*x + f_171_2[2]*x^f_171_2[3]

	oplot, xf, dist_fit_171_2, linestyle = 3, thick = 1

	dist_fit_171_s = f_171_2[0] + f_171_2[1]*t171 + f_171_2[2]*t171^f_171_2[3]

	residuals_b_171 = dist_fit_171_s - grt_dist_171

	legend, ['Constant a', 'Varying a'], linestyle = [2, 3], charsize = 1.5

; Root mean squared calculation (residuals)

	rms_a_res = residuals_a_171^2.
	rms_res_a = total(rms_a_res)

	rms_b_res = residuals_b_171^2.
	rms_res_b = total(rms_b_res)
	
	res_a_171 = sqrt(rms_res_a/g_d_171)
	res_b_171 = sqrt(rms_res_b/g_d_171)
	
	print, res_a_171
	print, res_b_171

	plot, t171, residuals_a_171, xr = [min(t171) - 50, max(t171) + 50], /xs, psym = 2, charsize = 1.5, ytitle = 'Residuals (Mm)', $
			xtitle = 'Time range (s)', title = 'Detrended data - 20070519', $
			yr = [min(residuals_a_171) - 5, max(residuals_a_171) + 5], /ys

	oplot, t171, residuals_b_171, psym = 4

	legend, ['Constant a, RMS = ' + num2str(res_a_171), 'Varying a, RMS = ' + num2str(res_b_171)], $
			psym = [2, 4], /right, charsize = 1.5

	x2png, 'wave_stats_20070519.png'

; One-plot -> both 171 and 195 data on same plot.

	!p.multi = 0

	set_line_color

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n and 171 !6!sA!r!u!9 %!6!n data', $
		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', background = 1, color = 0, $
		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 1.5, /xs, /ys, thick = 2
	uterrplot, tim195, grt_dist_195 + 39, grt_dist_195 - 39, thick = 2, color = 0
	
	outplot, tim171, grt_dist_171, psym = 4, color = 2, thick = 2
	uterrplot, tim171, grt_dist_171 + 39, grt_dist_171 - 39, color = 2, thick = 2

	xf = findgen( 2000 )
	x = findgen( 2000 )


	dist_fit_195_1 = f_195_1[0] + f_195_1[1]*x + (1./2.)*f_195_1[2]*x^2.
	dist_fit_195_2 = f_195_2[0] + f_195_2[1]*x + f_195_2[2]*x^f_171_2[3]

	dist_fit_171_1 = f_171_1[0] + f_171_1[1]*x + (1./2.)*f_171_1[2]*x^2.
	dist_fit_171_2 = f_171_2[0] + f_171_2[1]*x + f_171_2[2]*x^f_171_2[3]

	oplot, xf, dist_fit_195_1, linestyle = 2, thick = 2, color = 3
	oplot, xf, dist_fit_195_2, linestyle = 3, thick = 2, color = 4
	oplot, xf, dist_fit_171_1, linestyle = 4, thick = 2, color = 5
	oplot, xf, dist_fit_171_2, linestyle = 5, thick = 2, color = 6

	legend, ['Constant a 195', 'Varying a 195', 'Constant a 171', 'Varying a 171'], $
			textcolor = [3, 4, 5, 6], /right, charsize = 1.5, /bottom


;	ans = ' '
;
;	read, 'ok?', ans

; Simulation part 1

; Define time array

;	t = findgen( 1900 ) + 100.

; Define initial conditions
;	
;	r_0 = 80.			; Initial distance = 80 Mm
;	v_0 = 0.3			; Initial velocity = 300 km/s
;	a_0 = 0.00005		; Initial acceleration = 50 m/s^2

; Noise_level (for code-testing) and cadence in seconds

;	noise_level = 1			; Noise level 
;	cadence = 150			; Cadence in seconds

; Ideal plot - Distance. Using constant acceleration model.

;	r = r_0 + v_0*t + (0.5)*(a_0)*t^2.

; Plot ideal model

;	plot, t, r, yr = [0, 1000], xtitle = 'Time (s)', ytitle = 'Distance (Mm)', $
;			title = 'Kinematics simulation', xr = [0, 2100], /xs, charsize = 2

; Obtain 'real' data by applying noise to cadence-affected ideal equation

;	n = size(r[0:*:cadence], /n_elements)

; Noise in data

;	sig_h = noise_level * randomn( seed, n ) 		; Noise level is given in % (0.1 = 10%)

; Model added to noise in data to give pseudo-real data

;	h_obs = r[0:*:cadence] + sig_h
;
;	t_cad = t[0:*:cadence]

; Error in 'noisy' data
	
;	y_err = sig_h + replicate(31., n)								; errors for oplotting
;	t_err = replicate(0., n)

; Plot of 'real' data
	
;	plot, t_cad, h_obs, psym = 2, thick = 2, yr = [0, 1000], xtitle = 'Time (s)', $
;			ytitle = 'Distance (Mm)', title = 'Kinematics simulation', xr = [0, 2100], /xs, $
;			charsize = 2
;	oploterr, t_cad, h_obs, t_err, y_err, /nohat, errcolor = 3		; plot errors

; Apply fit to noisy data

;	x = findgen( 1900 ) + 100.
;	xf = findgen( 1900 ) + 100.
;
;	h_err = y_err

; Constant acceleration model

;	expr_dist_fit = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2'			; apply fit to 'data'
;
;	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
;	pi(0).limited(0) = 1
;	pi(0).limits(0) = 0.
;	pi(1).limited(0) = 1
;	pi(1).limits(0) = 0.01
;	pi(1).limited(1) = 1
;	pi(1).limits(1) = 0.5
;	pi(2).limited(0) = 1
;	pi(2).limits(0) = -0.00015
;	pi(2).limited(1) = 1
;	pi(2).limits(1) = 0.00015
;	
;	f_sim_fit = mpfitexpr(expr_dist_fit, t_cad, h_obs, h_err, [r_0, v_0, a_0], perror=perror, $
;		parinfo = pi, bestnorm = bestnorm_0, /quiet)

; Best-fit to data

;	dist_fit_sim = f_sim_fit[0] + f_sim_fit[1]*x + (1./2.)*f_sim_fit[2]*x^2.
;
;	oplot, xf, dist_fit_sim, linestyle = 2, thick = 1
;
;	dist_fit_sim_t = f_sim_fit[0] + f_sim_fit[1]*t_cad + (1./2.)*f_sim_fit[2]*t_cad^2.
;
;	residuals = dist_fit_sim_t - h_obs
;
;	plot, t_cad, residuals, xr = [-100, 2000], /xs, psym = 2, charsize = 2, xtitle = 'Residuals', $
;			ytitle = 'Time range', title = 'Detrended data - 20070519'
		
; Simulation part 2

; Define time array

;	t = findgen( 1900 ) + 100.

; Define initial conditions
;	
;	r_0 = 80.			; Initial distance = 80 Mm
;	v_0 = 0.3			; Initial velocity = 300 km/s
;	a_0 = 0.00005		; Initial acceleration = 50 m/s^2

; Noise_level (for code-testing) and cadence in seconds

;	noise_level = 10			; Noise level 
;	cadence = 150			; Cadence in seconds

; Ideal plot - Distance. Using constant acceleration model.

;	r = r_0 + v_0*t + (0.5)*(a_0)*t^2.

; Plot ideal model

;	plot, t, r, yr = [0, 1000], xtitle = 'Time (s)', ytitle = 'Distance (Mm)', $
;			title = 'Kinematics simulation', xr = [0, 2100], /xs, charsize = 2

; Obtain 'real' data by applying noise to cadence-affected ideal equation

;	n = size(r[0:*:cadence], /n_elements)

; Noise in data

;	sig_h = noise_level * randomn( seed, n ) 		; Noise level is given in % (0.1 = 10%)

; Model added to noise in data to give pseudo-real data

;	h_obs = r[0:*:cadence] + sig_h
;
;	t_cad = t[0:*:cadence]

; Error in 'noisy' data
	
;	y_err = sig_h + replicate(31., n)								; errors for oplotting
;	t_err = replicate(0., n)

; Plot of 'real' data
	
;	plot, t_cad, h_obs, psym = 2, thick = 2, yr = [0, 1000], xtitle = 'Time (s)', $
;			ytitle = 'Distance (Mm)', title = 'Kinematics simulation', xr = [0, 2100], /xs, $
;			charsize = 2
;	oploterr, t_cad, h_obs, t_err, y_err, /nohat, errcolor = 3		; plot errors

; Apply fit to noisy data

;	x = findgen( 1900 ) + 100.
;	xf = findgen( 1900 ) + 100.
;
;	h_err = y_err

; Constant acceleration model

;	expr_dist_fit = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2'			; apply fit to 'data'
;
;	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
;	pi(0).limited(0) = 1
;	pi(0).limits(0) = 0.
;	pi(1).limited(0) = 1
;	pi(1).limits(0) = 0.01
;	pi(1).limited(1) = 1
;	pi(1).limits(1) = 0.5
;	pi(2).limited(0) = 1
;	pi(2).limits(0) = -0.00015
;	pi(2).limited(1) = 1
;	pi(2).limits(1) = 0.00015
;	
;	f_sim_fit = mpfitexpr(expr_dist_fit, t_cad, h_obs, h_err, [r_0, v_0, a_0], perror=perror, $
;		parinfo = pi, bestnorm = bestnorm_0, /quiet)

; Best-fit to data

;	dist_fit_sim = f_sim_fit[0] + f_sim_fit[1]*x + (1./2.)*f_sim_fit[2]*x^2.
;
;	oplot, xf, dist_fit_sim, linestyle = 2, thick = 1
;
;	dist_fit_sim_t = f_sim_fit[0] + f_sim_fit[1]*t_cad + (1./2.)*f_sim_fit[2]*t_cad^2.
;
;	residuals = dist_fit_sim_t - h_obs
;
;	plot, t_cad, residuals, xr = [-100, 2000], /xs, psym = 2, charsize = 2, xtitle = 'Residuals', $
;			ytitle = 'Time range', title = 'Detrended data - 20070519'


stop

end