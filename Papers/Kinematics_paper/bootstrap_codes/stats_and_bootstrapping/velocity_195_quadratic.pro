; Routine to calculate the velocity plots for the wave statistics routines.

pro velocity_195_quadratic, date, time195, grt_dist_195, f_195_quad, std_dev_195_quad, dist_arr_195, $
			residuals_195_quad, mean_x_195_quad
			
	set_line_color
	
; Time calculations

	tim195 = time195 - time195[0]

; Plot of residuals

	x = findgen(std_dev_195_quad*300.) / 10. - std_dev_195_quad*3.

	res_195_quad = histogram( residuals_195_quad, loc = loc, binsize = 1 )

	plot, loc, res_195_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_195_quad) + 0.25*max(res_195_quad)], $
			xr = [-3.*std_dev_195_quad, 3.*std_dev_195_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', charsize = 2, $
			ytitle = 'De-trended data probability', title = 'Normalised Probability distribution function of de-trended data'

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_quad ) * exp(-(x - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_quad ) * exp(-(std_dev_195_quad - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, [std_dev_195_quad, std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_quad, -std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_195_ideal_quad = 1000.*(f_195_quad[1] + f_195_quad[2] * x)

	v_195_deriv_quad = deriv(tim195, grt_dist_195*1000.)
	deltav_195_deriv = derivsig(time195, grt_dist_195*1000., 0.0, (std_dev_195_quad*1000.))

	utplot, tim195, v_195_deriv_quad, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Quadratic fit velocity plot ' + num2str(date)
	uterrplot, tim195, v_195_deriv_quad + deltav_195_deriv, v_195_deriv_quad - deltav_195_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_195_ideal_quad, linestyle = 2, color = 0, thick = 2

; Constant a fit to data

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

    f_195_v_quad = mpfitexpr(v_quad_fit_195, tim195, v_195_deriv_quad, h_error, [v_195_ideal_quad[0], 0.05], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_v_quad, /quiet)

	v_195_fit_quad = f_195_v_quad[0] + f_195_v_quad[1] * x

	oplot, x, v_195_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

end
