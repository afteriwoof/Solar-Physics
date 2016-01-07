; Routine to calculate the velocity plots for the wave statistics routines.

pro sim_acc_195_quadratic, date, time195, f_195_quad, std_dev_195_quad, dist_arr_195, mean_x_195_quad, iterations
			
	set_line_color
	
; Time calculations

	tim195 = time195 - time195[0]
	
; Calculate scatter in the ideal data

	array = randomn(seed, dist_arr_195)
	
	delta_r_195_quad = array * std_dev_195_quad + mean_x_195_quad

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim195))

	sim_dist_195_quad = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2. + delta_r_195_quad

	a_sim_195_quad = 1e6*f_195_quad[2]

; Plot of velocity

	v_195_deriv_quad = deriv(tim195, sim_dist_195_quad*1000.)
	deltav_195_deriv = derivsig(tim195, sim_dist_195_quad*1000., 0.0, (std_dev_195_quad*1000.))

	a_195_deriv_quad = deriv(tim195, v_195_deriv_quad*1000.)
	deltaa_195_deriv = derivsig(tim195, v_195_deriv_quad*1000., 0.0, (deltav_195_deriv*1000.))

	utplot, tim195, a_195_deriv_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Acceleration [!6ms!U-2!N]', yrange = [min(a_195_deriv_quad)-100, max(a_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Quadratic fit Sim. acc. plot ' + num2str(date) + ' , Std. Dev. = ' + num2str(std_dev_195_quad)
	uterrplot, tim195, a_195_deriv_quad + deltaa_195_deriv, a_195_deriv_quad - deltaa_195_deriv, thick = 2, color = 0

; Over-plot the ideal acceleration line

	a_195_ideal_quad = replicate(a_sim_195_quad, max(tim195))

	oplot, x, a_195_ideal_quad, linestyle = 2, color = 0, thick = 2

; Zero a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, dist_arr_195)

	a_quad_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = -150
	pi(0).limited(1) = 1
	pi(0).limits(1) = 150

	f_195_a_quad = mpfitexpr(a_quad_fit_195, tim195, a_195_deriv_quad, h_error, [a_195_ideal_quad[0]], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_195_a_quad, /quiet)

	a_195_fit_quad = replicate(f_195_a_quad[0], max(tim195))

	oplot, x, a_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

; Plot showing the variation between fit and ideal with decreasing standard deviation

	scatter = fltarr(51)

	scatter_iterations = fltarr(iterations + 1.)

	FOR j = 1, 50, 1 DO BEGIN
	
		FOR i = 0, iterations DO BEGIN

			array = randomn(seed, dist_arr_195)
	
			delta_r_195_quad = array * j + mean_x_195_quad

			x = findgen(max(tim195))

			sim_dist_195_quad = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2. + delta_r_195_quad
	
			sim_a_195_quad = (1e6)*f_195_quad[2]
			
			v_195_deriv_quad = deriv(tim195, sim_dist_195_quad*1000.)
	
			a_195_deriv_quad = deriv(tim195, v_195_deriv_quad*1000.)

			h_error = replicate(j, dist_arr_195)

			a_quad_fit_195 = 'p[0]'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
			pi(0).limited(0) = 1
			pi(0).limits(0) = -150
			pi(0).limited(1) = 1
			pi(0).limits(1) = 150

		    f_195_a_quad = mpfitexpr(a_quad_fit_195, tim195, a_195_deriv_quad, h_error, [sim_a_195_quad], perror=perror, $
    			parinfo = pi, bestnorm = bestnorm_195_a_quad, /quiet)

			a_195_fit_quad = f_195_a_quad[0]
			
			scatter_iterations[i] = abs(sim_a_195_quad - a_195_fit_quad)
			
		ENDFOR
			
		scatter[j] = mean(scatter_iterations)
		
	ENDFOR

	standard_dev = findgen(51)

	plot, standard_dev, scatter, background = 1, color = 0, psym = 2, charsize = 1, /ys, $
		xtitle = 'Standard deviation of the data (Mm)', ytitle = 'Mean difference of fit from ideal (m/s!U2!N)', $
		title = 'Variation of diff between ideal and fit with Std. Dev. (195A)', yr = [0, max(scatter) + 10.]

	x = findgen(51)

	a_stddev_fit_195 = 'p[0] + p[1] * x + p[2] * x^2.'
	
	error = replicate(10., 51.)

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(0).limited(1) = 1
	pi(0).limits(1) = 10.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.
	pi(1).limited(1) = 1
	pi(1).limits(1) = 500.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.
	pi(1).limited(1) = 1
	pi(1).limits(1) = 500.

    f_195_a_stddev = mpfitexpr(a_stddev_fit_195, standard_dev, scatter, error, [1., 1., 1.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_stddev, /quiet)
	
	std_dev_fit = f_195_a_stddev[0] + f_195_a_stddev[1] * x + f_195_a_stddev[2] * x^2.

	oplot, x, std_dev_fit, linestyle = 2, color = 0, thick = 2

	std_dev_fit_line = f_195_a_stddev[0] + f_195_a_stddev[1] * max(std_dev_195_quad) + $
				f_195_a_stddev[2] * max(std_dev_195_quad)^2.

	oplot, [max(std_dev_195_quad), max(std_dev_195_quad)], [0, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	oplot, [0, max(std_dev_195_quad)], [std_dev_fit_line, std_dev_fit_line], linestyle = 0, thick = 2, color = 3

	print, 'A = ', f_195_a_stddev[0]
	print, 'B = ', f_195_a_stddev[1]
	print, 'C = ', f_195_a_stddev[2]

	legend, ['Y = A + BX + CX!U2!N', 'A = ' + num2str(f_195_a_stddev[0]), 'B = ' + num2str(f_195_a_stddev[1]), $
			'C = ' + num2str(f_195_a_stddev[2])], textcolors = [0, 0, 0, 0], /bottom, /right, charsize = 1.5, $
			/clear, outline_color = 0

end
