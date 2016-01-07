; Routine to calculate the velocity plots for the wave statistics routines.

pro sim_vel_171_linear, date, time171, f_171_lin, std_dev_171_lin, dist_arr_171, mean_x_171_lin, iterations
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]
	
; Calculate scatter in the ideal data

	array = randomn(seed, dist_arr_171)
	
	delta_r_171_lin = array * std_dev_171_lin + mean_x_171_lin

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	sim_dist_171_lin = f_171_lin[0] + f_171_lin[1]*tim171 + delta_r_171_lin

	v_sim_171_lin = 1000.*f_171_lin[1]

; Plot of velocity

	v_171_deriv_lin = deriv(tim171, sim_dist_171_lin*1000.)
	deltav_171_deriv = derivsig(tim171, sim_dist_171_lin*1000., 0.0, (std_dev_171_lin*1000.))

	utplot, tim171, v_171_deriv_lin, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Linear fit Sim. vel. plot ' + num2str(date) + ' , Std. Dev. = ' + num2str(std_dev_171_lin)
	uterrplot, tim171, v_171_deriv_lin + deltav_171_deriv, v_171_deriv_lin - deltav_171_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	v_171_ideal_lin = replicate(v_sim_171_lin, max(tim171))

	oplot, x, v_171_ideal_lin, linestyle = 2, color = 0, thick = 2

; Zero a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_lin, dist_arr_171)

	v_lin_fit_171 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_171_v_lin = mpfitexpr(v_lin_fit_171, tim171, v_171_deriv_lin, h_error, [v_171_ideal_lin[0]], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_v_lin, /quiet)

	v_171_fit_lin = replicate(f_171_v_lin[0], max(tim171))

	oplot, x, v_171_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

; Plot showing the variation between fit and ideal with decreasing standard deviation

	scatter = fltarr(31) - 1.

	scatter_iterations = fltarr(iterations + 1.)

	FOR j = 1, 30, 1 DO BEGIN
	
		FOR i = 0, iterations DO BEGIN

			array = randomn(seed, dist_arr_171)
	
			delta_r_171_lin = array * j + mean_x_171_lin

			x = findgen(max(tim171))

			sim_dist_171_lin = f_171_lin[0] + f_171_lin[1]*tim171 + delta_r_171_lin
	
			sim_v_171_lin = 1000.*f_171_lin[1]
			
			deriv_v_171_lin = deriv(tim171, sim_dist_171_lin*1000.)

			h_error = replicate(j, dist_arr_171)

			v_lin_fit_171 = 'p[0]'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 10
			pi(0).limited(1) = 1
			pi(0).limits(1) = 500

		    f_171_v_lin = mpfitexpr(v_lin_fit_171, tim171, deriv_v_171_lin , h_error, [sim_v_171_lin], perror=perror, $
    			parinfo = pi, bestnorm = bestnorm_171_v_lin, /quiet)

			v_171_fit_lin = f_171_v_lin[0]
			
			scatter_iterations[i] = abs(sim_v_171_lin - v_171_fit_lin)
			
		ENDFOR
			
		scatter[j] = mean(scatter_iterations)
		
	ENDFOR

	standard_dev = findgen(31)

	plot, standard_dev, scatter, background = 1, color = 0, psym = 2, charsize = 2, /ys, $
		xtitle = 'Standard deviation of the data (Mm)', ytitle = 'Mean difference of fit from ideal (km/s)', $
		title = 'Variation of diff between ideal and fit with Std. Dev. (171A)', yr = [0, max(scatter) + 10.]

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

	std_dev_fit_line = f_171_v_stddev[0] + f_171_v_stddev[1] * max(std_dev_171_lin) + f_171_v_stddev[2] * max(std_dev_171_lin)^2.

	oplot, [max(std_dev_171_lin), max(std_dev_171_lin)], [0, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	oplot, [0, max(std_dev_171_lin)], [std_dev_fit_line, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	
	print, 'A = ', f_171_v_stddev[0]
	print, 'B = ', f_171_v_stddev[1]
	print, 'C = ', f_171_v_stddev[2]

	legend, ['Y = A + BX + CX!U2!N', 'A = ' + num2str(f_171_v_stddev[0]), 'B = ' + num2str(f_171_v_stddev[1]), $
		'C = ' + num2str(f_171_v_stddev[2])], textcolors = [0, 0, 0, 0], /bottom, /right, charsize = 1.5, $
		/clear, outline_color = 0


end
