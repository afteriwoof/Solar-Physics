; Routine to calculate the velocity plots for the wave statistics routines.

pro sim_vel_171_quadratic, date, time171, f_171_quad, std_dev_171_quad, dist_arr_171, mean_x_171_quad, iterations
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]
	
; Calculate scatter in the ideal data

	array = randomn(seed, dist_arr_171)
	
	delta_r_171_quad = array * std_dev_171_quad + mean_x_171_quad

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	sim_dist_171_quad = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2. + delta_r_171_quad

	v_sim_171_quad = 1000.*(f_171_quad[1] + f_171_quad[2]*x)

; Plot of velocity

	v_171_deriv_quad = deriv(tim171, sim_dist_171_quad*1000.)
	deltav_171_deriv = derivsig(tim171, sim_dist_171_quad*1000., 0.0, (std_dev_171_quad*1000.))

	utplot, tim171, v_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit Sim. vel. plot ' + num2str(date) + ' , Std. Dev. = ' + num2str(std_dev_171_quad)
	uterrplot, tim171, v_171_deriv_quad + deltav_171_deriv, v_171_deriv_quad - deltav_171_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	v_171_ideal_quad = v_sim_171_quad

	oplot, x, v_171_ideal_quad, linestyle = 2, color = 0, thick = 2

; Constant a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, dist_arr_171)

	v_quad_fit_171 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.15
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.15

    f_171_v_quad = mpfitexpr(v_quad_fit_171, tim171, v_171_deriv_quad, h_error, [v_171_ideal_quad[0], 0.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

	v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1] * x

	oplot, x, v_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

; Plot showing the variation between fit and ideal with decreasing standard deviation

	scatter = fltarr(31) - 1.

	scatter_iterations = fltarr(iterations + 1.)

	FOR j = 1, 30, 1 DO BEGIN
	
		FOR i = 0, iterations DO BEGIN

			array = randomn(seed, dist_arr_171)
	
			delta_r_171_quad = array * j + mean_x_171_quad

			x = findgen(max(tim171))

			sim_dist_171_quad = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2. + delta_r_171_quad
	
			sim_v_171_quad = 1000.*(f_171_quad[1] + f_171_quad[2]*x)
			
			deriv_v_171_quad = deriv(tim171, sim_dist_171_quad*1000.)

			h_error = replicate(j, dist_arr_171)

			v_quad_fit_171 = 'p[0] + p[1]*x'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 10
			pi(0).limited(1) = 1
			pi(0).limits(1) = 500
			pi(1).limited(0) = 1
			pi(1).limits(0) = -0.15
			pi(1).limited(1) = 1
			pi(1).limits(1) = 0.15

		    f_171_v_quad = mpfitexpr(v_quad_fit_171, tim171, deriv_v_171_quad, h_error, [v_171_ideal_quad[0], 0.], perror=perror, $
		    		parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

			v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1] * x
			
			scatter_iterations[i] = mean(abs(sim_v_171_quad - v_171_fit_quad))
			
		ENDFOR
			
		scatter[j] = mean(scatter_iterations)
		
	ENDFOR

	standard_dev = findgen(31)

	plot, standard_dev, scatter, background = 1, color = 0, psym = 2, charsize = 2, /ys, $
		xtitle = 'Standard deviation of the data (Mm)', ytitle = 'Mean difference of fit from ideal (km/s)', $
		title = 'Variation of diff between ideal and fit with Std. Dev. (171A)', yr = [0, max(scatter) + 10.], $
		xr = [0, max(standard_dev)], /xs

	x = findgen(31)

	v_stddev_fit_171 = 'p[0] + p[1] * x + p[2]*x^2.'
	
	error = replicate(10., 31.)

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(0).limited(1) = 1
	pi(0).limits(1) = 10.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.
	pi(1).limited(1) = 1
	pi(1).limits(1) = 500.
	pi(2).limited(0) = 1
	pi(2).limits(0) = 0.
	pi(2).limited(1) = 1
	pi(2).limits(1) = 500.

    f_171_v_stddev = mpfitexpr(v_stddev_fit_171, standard_dev, scatter, error, [1., 1., 1.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_stddev, /quiet)
	
	std_dev_fit = f_171_v_stddev[0] + f_171_v_stddev[1] * x + f_171_v_stddev[2] * x^2.

	oplot, x, std_dev_fit, linestyle = 2, color = 0, thick = 2

	std_dev_fit_line = f_171_v_stddev[0] + f_171_v_stddev[1] * max(std_dev_171_quad) + f_171_v_stddev[2] * max(std_dev_171_quad)^2.

	oplot, [max(std_dev_171_quad), max(std_dev_171_quad)], [0, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	oplot, [0, max(std_dev_171_quad)], [std_dev_fit_line, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	
	print, 'A = ', f_171_v_stddev[0]
	print, 'B = ', f_171_v_stddev[1]
	print, 'C = ', f_171_v_stddev[2]

	legend, ['Y = A + BX + CX!U2!N', 'A = ' + num2str(f_171_v_stddev[0]), 'B = ' + num2str(f_171_v_stddev[1]), $
		'C = ' + num2str(f_171_v_stddev[2])], textcolors = [0, 0, 0, 0], /bottom, /right, charsize = 1.5, $
		/clear, outline_color = 0

	

end
