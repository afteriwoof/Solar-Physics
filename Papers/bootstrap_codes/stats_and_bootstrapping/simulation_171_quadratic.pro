; Routine to simulate event data for a given event, allowing variation of cadence and std. dev. of error

pro simulation_171_quadratic, date, time171, f_171_quad, cadence, std_dev_171_quad, mean_x_171_quad
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]
	
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
		ytitle = '!6Simulated distance [!6Mm]', yrange = [0, max(sim_dist_171_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit Sim. dist. plot ' + num2str(date) + ' , Standard Deviation = ' + num2str(std_dev_171_quad) + $
		' , Data spread = ' + num2str(error_d_171_quad)
	uterrplot, t[0:*:cadence], sim_dist_171_quad + std_dev_171_quad, sim_dist_171_quad - std_dev_171_quad, $
		thick = 2, color = 0

	oplot, t, dist_171_quad, linestyle = 0, thick = 2, color = 0

	oplot, x, dist_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: r(t) = ' + num2str(f_171_quad[0]) + ' + ' + num2str(f_171_quad[1]) + 't + ' + $
				num2str(f_171_quad[2]) + 't!U2!N', 'Fit: r(t) = ' + num2str(fit_171_quad[0]) + ' + ' $
				+ num2str(fit_171_quad[1]) + 't + '+ num2str(fit_171_quad[2]) + 't!U2!N'], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	v_sim_171_quad = 1000.*(f_171_quad[1] + f_171_quad[2]*x)

	v_171_ideal_quad = v_sim_171_quad

	v_171_deriv_quad = deriv(t[0:*:cadence], sim_dist_171_quad*1000.)
	deltav_171_deriv = derivsig(t[0:*:cadence], sim_dist_171_quad*1000., 0.0, (std_dev_171_quad*1000.))

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

    f_171_v_quad = mpfitexpr(v_quad_fit_171, t[0:*:cadence], v_171_deriv_quad, h_error, $
    		[v_171_ideal_quad[0], 0.05], perror=perror, parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

	v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1]*x

	res_v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1]*t[0:*:cadence]

	res_v_171_quad = v_171_deriv_quad - res_v_171_fit_quad

	error_v_171_quad = stddev(res_v_171_quad)

; Plot of velocity

	utplot, t[0:*:cadence], v_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit Sim. vel. plot ' + num2str(date) + ' , Deriv error = ' + num2str(mean(deltav_171_deriv)) + $
		' , Data spread = ' + num2str(error_v_171_quad)
	uterrplot, t[0:*:cadence], v_171_deriv_quad + deltav_171_deriv, v_171_deriv_quad - deltav_171_deriv, $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_171_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, v_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000*f_171_quad[1]) + ' + ' + num2str(1000*f_171_quad[2]) + 't', $
				'Fit: v(t) = ' + num2str(f_171_v_quad[0]) + ' + ' + num2str(f_171_v_quad[1]) + 't'], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0

; Use fit parameters as basis for ideal acceleration

	x = findgen(max(tim171))

	a_sim_171_quad = 1e6*f_171_quad[2]

	a_171_ideal_quad = replicate(a_sim_171_quad, max(tim171))

; Plot of acceleration

	a_171_deriv_quad = deriv(t[0:*:cadence], v_171_deriv_quad*1000.)
	deltaa_171_deriv = derivsig(t[0:*:cadence], v_171_deriv_quad*1000., 0.0, (deltav_171_deriv*1000.))

; Constant a fit to acceleration data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, max(tim171))

	a_quad_fit_171 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -250
	pi(0).limited(1) = 1
	pi(0).limits(1) = 250

    f_171_a_quad = mpfitexpr(a_quad_fit_171, t[0:*:cadence], a_171_deriv_quad, h_error, $
    		[a_171_ideal_quad[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_171_a_quad, /quiet)

	a_171_fit_quad = replicate(f_171_a_quad[0], max(tim171))

	res_a_171_fit_quad = replicate(f_171_a_quad[0], n)

	res_a_171_quad = a_171_deriv_quad - res_a_171_fit_quad

	error_a_171_quad = stddev(res_a_171_quad)

	utplot, t[0:*:cadence], a_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_171_deriv_quad)-100, max(a_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit Sim. acc. plot ' + num2str(date) + ' , Deriv error = ' + num2str(mean(deltaa_171_deriv)) + $
		' , Data spread = ' + num2str(error_a_171_quad)
	uterrplot, t[0:*:cadence], a_171_deriv_quad + deltaa_171_deriv, a_171_deriv_quad - deltaa_171_deriv, $
		thick = 2, color = 0

; Over-plot the ideal acceleration line

	oplot, x, a_171_ideal_quad, linestyle = 2, color = 0, thick = 2

	oplot, x, a_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal: a(t) = ' + num2str(1e6*f_171_quad[2]), 'Fit: a(t) = ' + num2str(f_171_a_quad[0])], $
				textcolors = [0, 3], /bottom, /right, charsize = 1.5, /clear, outline_color = 0







end
