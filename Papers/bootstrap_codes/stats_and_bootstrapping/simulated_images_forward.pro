; Routine to make postscript images of simulated data plots

pro simulated_images_forward, date, cadence

; Restore data

	IF (date EQ '20070806') THEN BEGIN	
		restore, num2str(date) + '_' + num2str(event) + '_dist.sav'
	ENDIF ELSE BEGIN
		restore, num2str(date) + '_dist.sav' 
	ENDELSE	
	
	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Initial estimated errors for each event

	IF (date EQ '20070516') THEN h_err = 31. $
		ELSE $
	IF (date EQ '20070519') THEN h_err = 39. $
		ELSE $
	IF (date EQ '20070806_1') THEN h_err = 37. $
		ELSE $
	IF (date EQ '20070806_2') THEN h_err = 42. $
		ELSE $
	IF (date EQ '20071207') THEN h_err = 30. $
		ELSE $
	IF (date EQ '20080107') THEN h_err = 32. $
		ELSE $
	IF (date EQ '20080426') THEN h_err = 36.

	h_error_195 = replicate(h_err, dist_arr_195)
	h_error_171 = replicate(h_err, dist_arr_171)

;******************************************
; Calculation of relevant statistical info
;******************************************

	resolve_routine, 'simulation_data_195_linear'

	simulation_data_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, $
		std_dev_195_lin, mean_x_195_lin

	resolve_routine, 'simulation_data_195_quadratic'

	simulation_data_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad, $
		std_dev_195_quad, mean_x_195_quad
	
	resolve_routine, 'simulation_data_171_linear'

	simulation_data_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin, $
		std_dev_171_lin, mean_x_171_lin
	
	resolve_routine, 'simulation_data_171_quadratic'

	simulation_data_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad, $
		std_dev_171_quad, mean_x_171_quad

; Images

	toggle, /portrait, filename = 'stats_sim_f_1.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8

	!p.multi = [0, 1, 2]

	set_line_color

; Calculate scatter in the ideal data

	t = findgen(max(tim195))

	dist_195_quad = f_195_quad[0] + f_195_quad[1]*t + (1./2.)*f_195_quad[2]*t^2.

	n = size(dist_195_quad[0:*:cadence], /n_elements)

	array = randomn(seed, n)
	
	delta_r_195_quad = array * std_dev_195_quad + mean_x_195_quad

; Calculate & plot simulated distance data

	sim_dist_195_quad = f_195_quad[0] + f_195_quad[1]*t[0:*:cadence] + (1./2.)*f_195_quad[2]*t[0:*:cadence]^2. $
		+ delta_r_195_quad

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, n)

	quad_fit_195 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5
	pi(2).limited(0) = 1
	pi(2).limits(0) = -0.00025
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00025

    fit_195_quad = mpfitexpr(quad_fit_195, t[0:*:cadence], sim_dist_195_quad, h_error, [sim_dist_195_quad[0], 0.2, 0.00005], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

	dist_195_fit_quad = fit_195_quad[0] + fit_195_quad[1]*x + (1./2.)*fit_195_quad[2]*x^2.

	res_dist_195_fit_quad = fit_195_quad[0] + fit_195_quad[1]*t[0:*:cadence] + (1./2.)*fit_195_quad[2]*t[0:*:cadence]^2.

	res_d_195_quad = sim_dist_195_quad - res_dist_195_fit_quad
	
	error_d_195_quad = stddev(res_d_195_quad)

	utplot, t[0:*:cadence], sim_dist_195_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(sim_dist_195_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		title = '195A Quadratic fit Kinematics plot', xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	uterrplot, t[0:*:cadence], sim_dist_195_quad + std_dev_195_quad, sim_dist_195_quad - std_dev_195_quad, $
		thick = 2, color = 0

	oplot, t, dist_195_quad, linestyle = 0, thick = 2, color = 0

	oplot, x, dist_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: r(t) = ' + num2str(f_195_quad[0]) + ' + ' + num2str(f_195_quad[1]) + 't + (!U1!N/!D2!N)' + $
				num2str(f_195_quad[2]) + 't!U2!N', 'Fit: r(t) = ' + num2str(fit_195_quad[0]) + ' + ' $
				+ num2str(fit_195_quad[1]) + 't + (!U1!N/!D2!N)'+ num2str(fit_195_quad[2]) + 't!U2!N'], $
				textcolors = [0, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim195))

	v_sim_195_quad = 1000.*(f_195_quad[1] + f_195_quad[2]*x)

	v_195_ideal_quad = v_sim_195_quad

; Calculate numerically differentiated data

	t_cad = t[0:*:cadence]

	d_y_f = sim_dist_195_quad[2:max(n)-1] - sim_dist_195_quad[1:max(n)-2]

	d_x_f = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	v_195_deriv_quad = 1000.*((d_y_f)/(d_x_f))
	
	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f_e = v_195_deriv_quad[2:max(m)-1] - v_195_deriv_quad[1:max(m)-2]

	d_x_f_e = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	v_195_deriv_err = (d_y_f_e)/(d_x_f_e)

	deltav_195_deriv = abs(((d_x_f_e)/2.)*v_195_deriv_err)

; Constant a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, max(tim195))

	v_quad_fit_195 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.25
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.25

    f_195_v_quad = mpfitexpr(v_quad_fit_195, t_cad[1:max(n)-2], v_195_deriv_quad, h_error, $
    		[v_195_ideal_quad[0], 0.05], perror=perror, parinfo = pi, bestnorm = bestnorm_195_v_quad, /quiet)

	v_195_fit_quad = f_195_v_quad[0] + f_195_v_quad[1]*x

; Plot of velocity

	utplot, t_cad[1:max(n)-2], v_195_deriv_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [min(v_195_deriv_quad)-100, max(v_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]
	uterrplot, t_cad[1:max(n)-2], v_195_deriv_quad + mean(deltav_195_deriv), v_195_deriv_quad - mean(deltav_195_deriv), $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_195_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, v_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000*f_195_quad[1]) + ' + ' + num2str(1000*f_195_quad[2]) + 't', $
				'Fit: v(t) = ' + num2str(f_195_v_quad[0]) + ' + ' + num2str(f_195_v_quad[1]) + 't', $
				'Error = ' + num2str(mean(deltav_195_deriv))], $
				textcolors = [0, 3, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

; Use fit parameters as basis for ideal acceleration

	x = findgen(max(tim195))

	a_sim_195_quad = 1e6*f_195_quad[2]

	a_195_ideal_quad = replicate(a_sim_195_quad, max(tim195))

; Calculate numerically differentiated data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f = v_195_deriv_quad[2:max(m)-1] - v_195_deriv_quad[1:max(m)-2]

	d_x_f = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	a_195_deriv_quad = 1000*((d_y_f)/(d_x_f))

	t_cad = t_cadence[1:max(m)-2]

	c = size(t_cad, /n_elements)

	d_y_f_e = a_195_deriv_quad[2:max(c)-1] - a_195_deriv_quad[1:max(c)-2]

	d_x_f_e = t_cad[2:max(c)-1] - t_cad[1:max(c)-2]

	a_195_deriv_err = (d_y_f_e)/(d_x_f_e)

	deltaa_195_deriv = abs(((d_x_f_e)^2./6.)*a_195_deriv_err)

	deltaa_195_deriv = replicate(mean(deltaa_195_deriv), size(t_cad, /n_elements))

; Constant a fit to acceleration data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, max(tim195))

	a_quad_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -250
	pi(0).limited(1) = 1
	pi(0).limits(1) = 250

    f_195_a_quad = mpfitexpr(a_quad_fit_195, t_cadence[1:max(m)-2], a_195_deriv_quad, h_error, $
    		[a_195_ideal_quad[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_195_a_quad, /quiet)

	a_195_fit_quad = replicate(f_195_a_quad[0], max(tim195))

	utplot, t_cadence[1:max(m)-2], a_195_deriv_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_195_deriv_quad)-100, max(a_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, t_cadence[1:max(m)-2], a_195_deriv_quad + deltaa_195_deriv, a_195_deriv_quad - deltaa_195_deriv, $
		thick = 2, color = 0

; Over-plot the ideal acceleration line

	oplot, x, a_195_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, a_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: a(t) = ' + num2str(1e6*f_195_quad[2]), 'Fit: a(t) = ' + num2str(f_195_a_quad[0]), $
				'Error = ' + num2str(mean(deltaa_195_deriv))], $
				textcolors = [0, 3, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

	toggle

; Images

	toggle, /portrait, filename = 'stats_sim_f_2.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8

	!p.multi = [0, 1, 2]

	set_line_color

; Calculate scatter in the ideal data

	t = findgen(max(tim171))

	dist_171_quad = f_171_quad[0] + f_171_quad[1]*t + (1./2.)*f_171_quad[2]*t^2.

	n = size(dist_171_quad[0:*:cadence], /n_elements)

	array = randomn(seed, n)
	
	delta_r_171_quad = array * std_dev_171_quad + mean_x_171_quad

; Calculate & plot simulated distance data

	sim_dist_171_quad = f_171_quad[0] + f_171_quad[1]*t[0:*:cadence] + (1./2.)*f_171_quad[2]*t[0:*:cadence]^2. $
		+ delta_r_171_quad

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, n)

	quad_fit_171 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5
	pi(2).limited(0) = 1
	pi(2).limits(0) = -0.00025
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00025

    fit_171_quad = mpfitexpr(quad_fit_171, t[0:*:cadence], sim_dist_171_quad, h_error, [sim_dist_171_quad[0], 0.2, 0.00005], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)

	dist_171_fit_quad = fit_171_quad[0] + fit_171_quad[1]*x + (1./2.)*fit_171_quad[2]*x^2.

	res_dist_171_fit_quad = fit_171_quad[0] + fit_171_quad[1]*t[0:*:cadence] + (1./2.)*fit_171_quad[2]*t[0:*:cadence]^2.

	res_d_171_quad = sim_dist_171_quad - res_dist_171_fit_quad
	
	error_d_171_quad = stddev(res_d_171_quad)

	utplot, t[0:*:cadence], sim_dist_171_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(sim_dist_171_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		title = '171A Quadratic fit Kinematics plot', xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	uterrplot, t[0:*:cadence], sim_dist_171_quad + std_dev_171_quad, sim_dist_171_quad - std_dev_171_quad, $
		thick = 2, color = 0

	oplot, t, dist_171_quad, linestyle = 0, thick = 2, color = 0

	oplot, x, dist_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: r(t) = ' + num2str(f_171_quad[0]) + ' + ' + num2str(f_171_quad[1]) + 't + (!U1!N/!D2!N)' + $
				num2str(f_171_quad[2]) + 't!U2!N', 'Fit: r(t) = ' + num2str(fit_171_quad[0]) + ' + ' $
				+ num2str(fit_171_quad[1]) + 't + (!U1!N/!D2!N)'+ num2str(fit_171_quad[2]) + 't!U2!N'], $
				textcolors = [0, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	v_sim_171_quad = 1000.*(f_171_quad[1] + f_171_quad[2]*x)

	v_171_ideal_quad = v_sim_171_quad

; Calculate numerically differentiated data

	t_cad = t[0:*:cadence]

	d_y_f = sim_dist_171_quad[2:max(n)-1] - sim_dist_171_quad[1:max(n)-2]

	d_x_f = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	v_171_deriv_quad = 1000.*((d_y_f)/(d_x_f))
	
	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f_e = v_171_deriv_quad[2:max(m)-1] - v_171_deriv_quad[1:max(m)-2]

	d_x_f_e = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	v_171_deriv_err = (d_y_f_e)/(d_x_f_e)

	deltav_171_deriv = abs(((d_x_f_e)/2.)*v_171_deriv_err)

; Constant a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, max(tim171))

	v_quad_fit_171 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.25
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.25

    f_171_v_quad = mpfitexpr(v_quad_fit_171, t_cad[1:max(n)-2], v_171_deriv_quad, h_error, $
    		[v_171_ideal_quad[0], 0.05], perror=perror, parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

	v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1]*x

; Plot of velocity

	utplot, t_cad[1:max(n)-2], v_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [min(v_171_deriv_quad)-100, max(v_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], pos = [0.15, 0.39, 0.95, 0.66]
	uterrplot, t_cad[1:max(n)-2], v_171_deriv_quad + mean(deltav_171_deriv), v_171_deriv_quad - mean(deltav_171_deriv), $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_171_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, v_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000*f_171_quad[1]) + ' + ' + num2str(1000*f_171_quad[2]) + 't', $
				'Fit: v(t) = ' + num2str(f_171_v_quad[0]) + ' + ' + num2str(f_171_v_quad[1]) + 't', $
				'Error = ' + num2str(mean(deltav_171_deriv))], $
				textcolors = [0, 3, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

; Use fit parameters as basis for ideal acceleration

	x = findgen(max(tim171))

	a_sim_171_quad = 1e6*f_171_quad[2]

	a_171_ideal_quad = replicate(a_sim_171_quad, max(tim171))

; Calculate numerically differentiated data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f = v_171_deriv_quad[2:max(m)-1] - v_171_deriv_quad[1:max(m)-2]

	d_x_f = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	a_171_deriv_quad = 1000*((d_y_f)/(d_x_f))

	t_cad = t_cadence[1:max(m)-2]

	c = size(t_cad, /n_elements)

	d_y_f_e = a_171_deriv_quad[2:max(c)-1] - a_171_deriv_quad[1:max(c)-2]

	d_x_f_e = t_cad[2:max(c)-1] - t_cad[1:max(c)-2]

	a_171_deriv_err = (d_y_f_e)/(d_x_f_e)

	deltaa_171_deriv = abs(((d_x_f_e)^2./6.)*a_171_deriv_err)

	deltaa_171_deriv = replicate(mean(deltaa_171_deriv), size(t_cad, /n_elements))

; Constant a fit to acceleration data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, max(tim171))

	a_quad_fit_171 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -250
	pi(0).limited(1) = 1
	pi(0).limits(1) = 250

    f_171_a_quad = mpfitexpr(a_quad_fit_171, t_cadence[1:max(m)-2], a_171_deriv_quad, h_error, $
    		[a_171_ideal_quad[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_171_a_quad, /quiet)

	a_171_fit_quad = replicate(f_171_a_quad[0], max(tim171))

	utplot, t_cadence[1:max(m)-2], a_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_171_deriv_quad)-100, max(a_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, t_cadence[1:max(m)-2], a_171_deriv_quad + deltaa_171_deriv, a_171_deriv_quad - deltaa_171_deriv, $
		thick = 2, color = 0

; Over-plot the ideal acceleration line

	oplot, x, a_171_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, a_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: a(t) = ' + num2str(1e6*f_171_quad[2]), 'Fit: a(t) = ' + num2str(f_171_a_quad[0]), $
				'Error = ' + num2str(mean(deltaa_171_deriv))], $
				textcolors = [0, 3, 3], /bottom, /right, charsize = 0.8, /clear, outline_color = 0

	toggle

end