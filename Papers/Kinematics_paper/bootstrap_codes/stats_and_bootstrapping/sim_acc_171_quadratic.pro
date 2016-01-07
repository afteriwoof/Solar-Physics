; Routine to calculate the velocity plots for the wave statistics routines.

pro sim_acc_171_quadratic, date, time171, f_171_quad, std_dev_171_quad, dist_arr_171, mean_x_171_quad, iterations
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]
	
; Calculate scatter in the ideal data

	array = randomn(seed, dist_arr_171)
	
	delta_r_171_quad = array * std_dev_171_quad + mean_x_171_quad

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	sim_dist_171_quad = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2. + delta_r_171_quad

	a_sim_171_quad = 1e6*f_171_quad[2]

; Plot of velocity

	v_171_deriv_quad = deriv(tim171, sim_dist_171_quad*1000.)
	deltav_171_deriv = derivsig(tim171, sim_dist_171_quad*1000., 0.0, (std_dev_171_quad*1000.))

	a_171_deriv_quad = deriv(tim171, v_171_deriv_quad*1000.)
	deltaa_171_deriv = derivsig(tim171, v_171_deriv_quad*1000., 0.0, (deltav_171_deriv*1000.))

	utplot, tim171, a_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_171_deriv_quad)-100, max(a_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit Sim. acc. plot ' + num2str(date) + ' , Std. Dev. = ' + num2str(std_dev_171_quad)
	uterrplot, tim171, a_171_deriv_quad + deltaa_171_deriv, a_171_deriv_quad - deltaa_171_deriv, thick = 2, color = 0

; Over-plot the ideal acceleration line

	a_171_ideal_quad = replicate(a_sim_171_quad, max(tim171))

	oplot, x, a_171_ideal_quad, linestyle = 2, color = 0, thick = 2

; Zero a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, dist_arr_171)

	a_quad_fit_171 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -150
	pi(0).limited(1) = 1
	pi(0).limits(1) = 150

	f_171_a_quad = mpfitexpr(a_quad_fit_171, tim171, a_171_deriv_quad, h_error, [a_171_ideal_quad[0]], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_171_a_quad, /quiet)

	a_171_fit_quad = replicate(f_171_a_quad[0], max(tim171))

	oplot, x, a_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

; Plot showing the variation between fit and ideal with decreasing standard deviation

	scatter = fltarr(51)

	scatter_iterations = fltarr(iterations + 1.)

	FOR j = 1, 50, 1 DO BEGIN
	
		FOR i = 0, iterations DO BEGIN

			array = randomn(seed, dist_arr_171)
	
			delta_r_171_quad = array * j + mean_x_171_quad

			x = findgen(max(tim171))

			sim_dist_171_quad = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2. + delta_r_171_quad
	
			sim_a_171_quad = (1e6)*f_171_quad[2]
			
			v_171_deriv_quad = deriv(tim171, sim_dist_171_quad*1000.)
	
			a_171_deriv_quad = deriv(tim171, v_171_deriv_quad*1000.)

			h_error = replicate(j, dist_arr_171)

			a_quad_fit_171 = 'p[0]'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
			pi(0).limited(0) = 1
			pi(0).limits(0) = -250
			pi(0).limited(1) = 1
			pi(0).limits(1) = 250

		    f_171_a_quad = mpfitexpr(a_quad_fit_171, tim171, a_171_deriv_quad, h_error, [sim_a_171_quad], perror=perror, $
    			parinfo = pi, bestnorm = bestnorm_171_a_quad, /quiet)

			a_171_fit_quad = f_171_a_quad[0]
			
			scatter_iterations[i] = abs(sim_a_171_quad - a_171_fit_quad)
			
		ENDFOR
			
		scatter[j] = mean(scatter_iterations)
		
	ENDFOR

	standard_dev = findgen(51)

	plot, standard_dev, scatter, background = 1, color = 0, psym = 2, charsize = 1, /ys, $
		xtitle = 'Standard deviation of the data (Mm)', ytitle = 'Mean difference of fit from ideal (m/s!U2!N)', $
		title = 'Variation of diff between ideal and fit with Std. Dev. (171A)', yr = [0, max(scatter) + 10.]

	x = findgen(51)

	a_stddev_fit_171 = 'p[0] + p[1] * x + p[2] * x^2.'
	
	error = replicate(10., 51.)

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(0).limited(1) = 1
	pi(0).limits(1) = 100.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.
	pi(1).limited(1) = 1
	pi(1).limits(1) = 500.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.
	pi(1).limited(1) = 1
	pi(1).limits(1) = 500.

    f_171_a_stddev = mpfitexpr(a_stddev_fit_171, standard_dev, scatter, error, [1., 1., 1.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_stddev, /quiet)
	
	std_dev_fit = f_171_a_stddev[0] + f_171_a_stddev[1] * x + f_171_a_stddev[2] * x^2.

	oplot, x, std_dev_fit, linestyle = 2, color = 0, thick = 2

	std_dev_fit_line = f_171_a_stddev[0] + f_171_a_stddev[1] * max(std_dev_171_quad) + $
				f_171_a_stddev[2] * max(std_dev_171_quad)^2.

	oplot, [max(std_dev_171_quad), max(std_dev_171_quad)], [0, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	oplot, [0, max(std_dev_171_quad)], [std_dev_fit_line, std_dev_fit_line], linestyle = 0, thick = 2, color = 3

	print, 'A = ', f_171_a_stddev[0]
	print, 'B = ', f_171_a_stddev[1]
	print, 'C = ', f_171_a_stddev[2]

	legend, ['Y = A + BX + CX!U2!N', 'A = ' + num2str(f_171_a_stddev[0]), 'B = ' + num2str(f_171_a_stddev[1]), $
			'C = ' + num2str(f_171_a_stddev[2])], textcolors = [0, 0, 0, 0], /bottom, /right, charsize = 1.5, $
			/clear, outline_color = 0
stop
end
