; Routine to simulate event data for a given event, allowing variation of cadence and std. dev. of error

pro f_diff_simulation_171_linear, date, time171, f_171_lin, cadence, std_dev_171_lin, mean_x_171_lin, errors
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]
	
; Calculate scatter in the ideal data

	t = findgen((max(tim171))/cadence)

	cad = 1

	dist_171_lin = f_171_lin[0] + f_171_lin[1]*t

	n = size(dist_171_lin[0:*:cad], /n_elements)

	array = randomn(seed, n)
	
	delta_r_171_lin = array * std_dev_171_lin + mean_x_171_lin

; Calculate & plot simulated distance data

	sim_dist_171_lin = f_171_lin[0] + f_171_lin[1]*t[0:*:cad] + delta_r_171_lin

	x = findgen((max(tim171))/cadence)

	h_error = replicate(std_dev_171_lin, n)

	lin_fit_171 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    fit_171_lin = mpfitexpr(lin_fit_171, t[0:*:cad], sim_dist_171_lin, h_error, [sim_dist_171_lin[0], 0.2], $
    		perror=perror, parinfo = pi, bestnorm = bestnorm_171_lin, /quiet)

	dist_171_fit_lin = fit_171_lin[0] + fit_171_lin[1]*x
	
	res_dist_171_fit_lin = fit_171_lin[0] + fit_171_lin[1]*t[0:*:cad]
	
	res_d_171_lin = sim_dist_171_lin - res_dist_171_fit_lin
	
	error_d_171_lin = stddev(res_d_171_lin)

	plot, t[0:*:cad], sim_dist_171_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Simulated distance [!6Mm]', yrange = [0, max(sim_dist_171_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Linear fit Sim. dist. plot ' + num2str(date) + ' , Standard Deviation = ' + $
		num2str(std_dev_171_lin) + ' , Data spread = ' + num2str(error_d_171_lin)

	error_171_lin = replicate(std_dev_171_lin, n)

	oploterr, t[0:*:cad], sim_dist_171_lin, error_171_lin, /nohat, /noconnect, errthick = 2, errcolor = 0

	oplot, t, dist_171_lin, linestyle = 0, thick = 2, color = 0

	oplot, x, dist_171_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: r(t) = ' + num2str(f_171_lin[0]) + ' + ' + num2str(f_171_lin[1]) + 't', $
				'Fit: r(t) = ' + num2str(fit_171_lin[0]) + ' + ' + num2str(fit_171_lin[1]) + 't'], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen((max(tim171))/cadence)

	v_sim_171_lin = 1000.*f_171_lin[1]

; Calculate numerically differentiated data

	t_cad = t[0:*:cad]

	d_y_f = sim_dist_171_lin[2:max(n)-1] - sim_dist_171_lin[1:max(n)-2]

	d_x_f = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	v_171_deriv_lin = 1000.*((d_y_f)/(d_x_f))
	
	deltav_171_deriv = abs(v_sim_171_lin - v_171_deriv_lin)

; Zero a fit to velocity data

	x = findgen((max(tim171))/cadence)

	h_error = replicate(std_dev_171_lin, max(tim171))

	v_lin_fit_171 = 'p[0]'

	v_171_ideal_lin = replicate(v_sim_171_lin, max(tim171))

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_171_v_lin = mpfitexpr(v_lin_fit_171, t_cad[1:max(n)-2], v_171_deriv_lin, h_error, $
    		[v_171_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_171_v_lin, /quiet)

	v_171_fit_lin = replicate(f_171_v_lin[0], max(tim171))

	res_v_171_fit_lin = replicate(f_171_v_lin[0], n)

	res_v_171_lin = v_171_deriv_lin - res_v_171_fit_lin

	error_v_171_lin = stddev(res_v_171_lin)

; Plot of velocity

	plot, t_cad[1:max(n)-2], v_171_deriv_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [min(v_171_deriv_lin)-100, max(v_171_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Linear fit Sim. vel. plot ' + num2str(date) + ' , Deriv error = ' + $
		num2str(mean(deltav_171_deriv)) + ' , Data spread = ' + num2str(error_v_171_lin)

	error_v_171 = replicate(mean(deltav_171_deriv), size(v_171_deriv_lin, /n_elements))

	oploterr, t_cad[1:max(n)-2], v_171_deriv_lin, error_v_171, /nohat, /noconnect, errthick = 2, errcolor = 0

; Over-plot the ideal velocity line

	oplot, x, v_171_ideal_lin, linestyle = 2, color = 0, thick = 2

	oplot, x, v_171_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000.*f_171_lin[1]), 'Fit: v(t) = ' + num2str(f_171_v_lin[0])], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal acceleration

	x = findgen((max(tim171))/cadence)

	a_sim_171_lin = 0.

; Calculate numerically differentiated data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	d_y_f = v_171_deriv_lin[2:max(m)-1] - v_171_deriv_lin[1:max(m)-2]

	d_x_f = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	a_171_deriv_lin = 1000.*((d_y_f)/(d_x_f))
	
	deltaa_171_deriv = abs(a_sim_171_lin - a_171_deriv_lin)

; Zero a fit to acceleration data

	x = findgen((max(tim171))/cadence)

	h_error = replicate(std_dev_171_lin, max(tim171))

	a_lin_fit_171 = 'p[0]'

	a_171_ideal_lin = replicate(a_sim_171_lin, max(tim171))

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_171_a_lin = mpfitexpr(a_lin_fit_171, t_cadence[1:max(m)-2], a_171_deriv_lin, h_error, $
    		[a_171_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_171_a_lin, /quiet)

	a_171_fit_lin = replicate(f_171_a_lin[0], max(tim171))

	res_a_171_fit_lin = replicate(f_171_a_lin[0], m)

	res_a_171_lin = a_171_deriv_lin - res_a_171_fit_lin

	error_a_171_lin = stddev(res_a_171_lin)

; Plot of acceleration

	plot, t_cadence[1:max(m)-2], a_171_deriv_lin, xr = [min(t[0:*:cad]) - 10, max(t[0:*:cad]) + 10], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_171_deriv_lin)-100, max(a_171_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Linear fit Sim. acc. plot ' + num2str(date) + ' , Deriv error = ' + $
		num2str(mean(deltaa_171_deriv)) + ' , Data spread = ' + num2str(error_a_171_lin)

	error_a_171 = replicate(mean(deltaa_171_deriv), size(a_171_deriv_lin, /n_elements))

	oploterr, t_cadence[1:max(m)-2], a_171_deriv_lin, error_a_171, /nohat, /noconnect, errthick = 2, errcolor = 0

; Over-plot the ideal acceleration line

	oplot, x, a_171_ideal_lin, linestyle = 2, color = 0, thick = 2

	oplot, x, a_171_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(0), 'Fit: v(t) = ' + num2str(f_171_a_lin[0])], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

	errors = [mean(deltav_171_deriv), mean(deltaa_171_deriv)]

end
