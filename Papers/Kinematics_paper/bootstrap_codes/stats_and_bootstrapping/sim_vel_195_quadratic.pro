; Routine to calculate the velocity plots for the wave statistics routines.

pro sim_vel_195_quadratic, date, time195, f_195_quad, std_dev_195_quad, dist_arr_195, mean_x_195_quad, iterations
			
	set_line_color
	
; Time calculations

	tim195 = time195 - time195[0]
	
; Calculate scatter in the ideal data

	array = randomn(seed, dist_arr_195)
	
	delta_r_195_quad = array * std_dev_195_quad + mean_x_195_quad

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim195))

	sim_dist_195_quad = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2. + delta_r_195_quad

	v_sim_195_quad = 1000.*(f_195_quad[1] + f_195_quad[2]*x)

; Plot of velocity

	v_195_deriv_quad = deriv(tim195, sim_dist_195_quad*1000.)
	deltav_195_deriv = derivsig(tim195, sim_dist_195_quad*1000., 0.0, (std_dev_195_quad*1000.))

	utplot, tim195, v_195_deriv_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Quadratic fit Sim. vel. plot ' + num2str(date) + ' , Std. Dev. = ' + num2str(std_dev_195_quad)
	uterrplot, tim195, v_195_deriv_quad + deltav_195_deriv, v_195_deriv_quad - deltav_195_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	v_195_ideal_quad = v_sim_195_quad

	oplot, x, v_195_ideal_quad, linestyle = 2, color = 0, thick = 2

; Constant a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, dist_arr_195)

	v_quad_fit_195 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.15
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.15

    f_195_v_quad = mpfitexpr(v_quad_fit_195, tim195, v_195_deriv_quad, h_error, [v_195_ideal_quad[0], 0.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_v_quad, /quiet)

	v_195_fit_quad = f_195_v_quad[0] + f_195_v_quad[1] * x

	oplot, x, v_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

; Plot showing the variation between fit and ideal with decreasing standard deviation

	scatter = fltarr(51) - 1.

	scatter_iterations = fltarr(iterations + 1.)

	FOR j = 1, 50, 1 DO BEGIN
	
		FOR i = 0, iterations DO BEGIN

			array = randomn(seed, dist_arr_195)
	
			delta_r_195_quad = array * j + mean_x_195_quad

			x = findgen(max(tim195))

			sim_dist_195_quad = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2. + delta_r_195_quad
	
			sim_v_195_quad = 1000.*(f_195_quad[1] + f_195_quad[2]*x)
			
			deriv_v_195_quad = deriv(tim195, sim_dist_195_quad*1000.)

			h_error = replicate(j, dist_arr_195)

			v_quad_fit_195 = 'p[0] + p[1]*x'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 10
			pi(0).limited(1) = 1
			pi(0).limits(1) = 500
			pi(1).limited(0) = 1
			pi(1).limits(0) = -0.15
			pi(1).limited(1) = 1
			pi(1).limits(1) = 0.15

		    f_195_v_quad = mpfitexpr(v_quad_fit_195, tim195, deriv_v_195_quad, h_error, [v_195_ideal_quad[0], 0.], perror=perror, $
		    		parinfo = pi, bestnorm = bestnorm_195_v_quad, /quiet)

			v_195_fit_quad = f_195_v_quad[0] + f_195_v_quad[1] * x
			
			scatter_iterations[i] = mean(abs(sim_v_195_quad - v_195_fit_quad))
			
		ENDFOR
			
		scatter[j] = mean(scatter_iterations)
		
	ENDFOR

	standard_dev = findgen(51)

	plot, standard_dev, scatter, background = 1, color = 0, psym = 2, charsize = 2, /ys, $
		xtitle = 'Standard deviation of the data (Mm)', ytitle = 'Mean difference of fit from ideal (km/s)', $
		title = 'Variation of diff between ideal and fit with Std. Dev. (195A)', yr = [0, max(scatter) + 10.], $
		xr = [0, max(standard_dev)], /xs

	x = findgen(51)

	v_stddev_fit_195 = 'p[0] + p[1] * x + p[2]*x^2.'
	
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
	pi(2).limited(0) = 1
	pi(2).limits(0) = 0.
	pi(2).limited(1) = 1
	pi(2).limits(1) = 500.

    f_195_v_stddev = mpfitexpr(v_stddev_fit_195, standard_dev, scatter, error, [1., 1., 1.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_stddev, /quiet)
	
	std_dev_fit = f_195_v_stddev[0] + f_195_v_stddev[1] * x + f_195_v_stddev[2] * x^2.

	oplot, x, std_dev_fit, linestyle = 2, color = 0, thick = 2

	std_dev_fit_line = f_195_v_stddev[0] + f_195_v_stddev[1] * max(std_dev_195_quad) + f_195_v_stddev[2] * max(std_dev_195_quad)^2.

	oplot, [max(std_dev_195_quad), max(std_dev_195_quad)], [0, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	oplot, [0, max(std_dev_195_quad)], [std_dev_fit_line, std_dev_fit_line], linestyle = 0, thick = 2, color = 3
	
	print, 'A = ', f_195_v_stddev[0]
	print, 'B = ', f_195_v_stddev[1]
	print, 'C = ', f_195_v_stddev[2]

	legend, ['Y = A + BX + CX!U2!N', 'A = ' + num2str(f_195_v_stddev[0]), 'B = ' + num2str(f_195_v_stddev[1]), $
		'C = ' + num2str(f_195_v_stddev[2])], textcolors = [0, 0, 0, 0], /bottom, /right, charsize = 1.5, $
		/clear, outline_color = 0


end
