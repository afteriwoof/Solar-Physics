; Routine to simulate event data for a given event, allowing variation of cadence and std. dev. of error

pro c_diff_simulation_195_linear, date, time195, f_195_lin, cadence, std_dev_195_lin, mean_x_195_lin, errors
			
	set_line_color
	
; Time calculations

	tim195 = time195 - time195[0]
	
; Calculate scatter in the ideal data

	t = findgen((max(tim195))/cadence)

	cad = 1

	dist_195_lin = f_195_lin[0] + f_195_lin[1]*t

	n = size(dist_195_lin[0:*:cad], /n_elements)

	array = randomn(seed, n)
	
	delta_r_195_lin = array * std_dev_195_lin + mean_x_195_lin

; Calculate & plot simulated distance data

	sim_dist_195_lin = f_195_lin[0] + f_195_lin[1]*t[0:*:cad] + delta_r_195_lin

	x = findgen((max(tim195))/cadence)

	h_error = replicate(std_dev_195_lin, n)

	lin_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    fit_195_lin = mpfitexpr(lin_fit_195, t[0:*:cad], sim_dist_195_lin, h_error, [sim_dist_195_lin[0], 0.2], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm_195_lin, /quiet)

	dist_195_fit_lin = fit_195_lin[0] + fit_195_lin[1]*x
	
	res_dist_195_fit_lin = fit_195_lin[0] + fit_195_lin[1]*t[0:*:cad]
	
	res_d_195_lin = sim_dist_195_lin - res_dist_195_fit_lin
	
	error_d_195_lin = stddev(res_d_195_lin)

	plot, t[0:*:cad], sim_dist_195_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Simulated distance [!6Mm]', yrange = [0, max(sim_dist_195_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Linear fit Sim. dist. plot ' + num2str(date) + ' , Standard Deviation = ' + $
		num2str(std_dev_195_lin) + ' , Data spread = ' + num2str(error_d_195_lin)

	error_195_lin = replicate(std_dev_195_lin, n)

	oploterr, t[0:*:cad], sim_dist_195_lin, error_195_lin, /nohat, /noconnect, errthick = 2, errcolor = 0

	oplot, t, dist_195_lin, linestyle = 0, thick = 2, color = 0

	oplot, x, dist_195_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: r(t) = ' + num2str(f_195_lin[0]) + ' + ' + num2str(f_195_lin[1]) + 't', $
				'Fit: r(t) = ' + num2str(fit_195_lin[0]) + ' + ' + num2str(fit_195_lin[1]) + 't'], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen((max(tim195))/cadence)

	v_sim_195_lin = 1000.*f_195_lin[1]

; Calculate numerically differentiated data

	t_cad = t[0:*:cad]

	d_y_f = sim_dist_195_lin[2:max(n)-1] - sim_dist_195_lin[0:max(n)-3]

	d_x_f = t_cad[2:max(n)-1] - t_cad[0:max(n)-3]

	v_195_deriv_lin = 1000.*((d_y_f)/(d_x_f))
	
	deltav_195_deriv = abs(v_sim_195_lin - v_195_deriv_lin)

; Zero a fit to velocity data

	x = findgen((max(tim195))/cadence)

	h_error = replicate(std_dev_195_lin, max(tim195))

	v_lin_fit_195 = 'p[0]'

	v_195_ideal_lin = replicate(v_sim_195_lin, max(tim195))

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_195_v_lin = mpfitexpr(v_lin_fit_195, t_cad[1:max(n)-2], v_195_deriv_lin, h_error, $
    		[v_195_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_195_v_lin, /quiet)

	v_195_fit_lin = replicate(f_195_v_lin[0], max(tim195))

	res_v_195_fit_lin = replicate(f_195_v_lin[0], n)

	res_v_195_lin = v_195_deriv_lin - res_v_195_fit_lin

	error_v_195_lin = stddev(res_v_195_lin)

; Plot of velocity

	plot, t_cad[1:max(n)-2], v_195_deriv_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [min(v_195_deriv_lin)-100, max(v_195_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Linear fit Sim. vel. plot ' + num2str(date) + ' , Deriv error = ' + $
		num2str(mean(deltav_195_deriv)) + ' , Data spread = ' + num2str(error_v_195_lin)

	error_v_195 = replicate(mean(deltav_195_deriv), size(v_195_deriv_lin, /n_elements))

	oploterr, t_cad[1:max(n)-2], v_195_deriv_lin, error_v_195, /nohat, /noconnect, errthick = 2, errcolor = 0

; Over-plot the ideal velocity line

	oplot, x, v_195_ideal_lin, linestyle = 2, color = 0, thick = 2

	oplot, x, v_195_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000.*f_195_lin[1]), 'Fit: v(t) = ' + num2str(f_195_v_lin[0])], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal acceleration

	x = findgen((max(tim195))/cadence)

	a_sim_195_lin = 0.

; Calculate numerically differentiated data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f = v_195_deriv_lin[2:max(m)-1] - v_195_deriv_lin[0:max(m)-3]

	d_x_f = t_cadence[2:max(m)-1] - t_cadence[0:max(m)-3]

	a_195_deriv_lin = 1000.*((d_y_f)/(d_x_f))
	
	deltaa_195_deriv = abs(a_sim_195_lin - a_195_deriv_lin)

; Zero a fit to acceleration data

	x = findgen((max(tim195))/cadence)

	h_error = replicate(std_dev_195_lin, max(tim195))

	a_lin_fit_195 = 'p[0]'

	a_195_ideal_lin = replicate(a_sim_195_lin, max(tim195))

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_195_a_lin = mpfitexpr(a_lin_fit_195, t_cadence[1:max(m)-2], a_195_deriv_lin, h_error, $
    		[a_195_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_195_a_lin, /quiet)

	a_195_fit_lin = replicate(f_195_a_lin[0], max(tim195))

	res_a_195_fit_lin = replicate(f_195_a_lin[0], m)

	res_a_195_lin = a_195_deriv_lin - res_a_195_fit_lin

	error_a_195_lin = stddev(res_a_195_lin)

; Plot of acceleration

	plot, t_cadence[1:max(m)-2], a_195_deriv_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_195_deriv_lin)-100, max(a_195_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Linear fit Sim. acc. plot ' + num2str(date) + ' , Deriv error = ' + $
		num2str(mean(deltaa_195_deriv)) + ' , Data spread = ' + num2str(error_a_195_lin)

	error_a_195 = replicate(mean(deltaa_195_deriv), size(a_195_deriv_lin, /n_elements))

	oploterr, t_cadence[1:max(m)-2], a_195_deriv_lin, error_a_195, /nohat, /noconnect, errthick = 2, errcolor = 0

; Over-plot the ideal acceleration line

	oplot, x, a_195_ideal_lin, linestyle = 2, color = 0, thick = 2

	oplot, x, a_195_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(0), 'Fit: v(t) = ' + num2str(f_195_a_lin[0])], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

	errors = [mean(deltav_195_deriv), mean(deltaa_195_deriv)]

end
