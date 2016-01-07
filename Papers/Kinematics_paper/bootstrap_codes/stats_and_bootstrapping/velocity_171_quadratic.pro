; Routine to calculate the velocity plots for the wave statistics routines.

pro velocity_171_quadratic, date, time171, grt_dist_171, f_171_quad, std_dev_171_quad, dist_arr_171, $
			residuals_171_quad, mean_x_171_quad
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]

; Plot of residuals

	x = findgen(std_dev_171_quad*300.) / 10. - std_dev_171_quad*3.

	res_171_quad = histogram( residuals_171_quad, loc = loc, binsize = 1 )

	plot, loc, res_171_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_171_quad) + 0.25*max(res_171_quad)], $
			xr = [-3.*std_dev_171_quad, 3.*std_dev_171_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', charsize = 2, $
			ytitle = 'De-trended data probability', title = 'Normalised Probability distribution function of de-trended data'

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_quad ) * exp(-(x - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_quad ) * exp(-(std_dev_171_quad - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, [std_dev_171_quad, std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_quad, -std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

; Plot of velocity

	x = findgen(max(tim171))

	v_171_ideal_quad = 1000.*(f_171_quad[1] + f_171_quad[2] * x)

	v_171_deriv_quad = deriv(tim171, grt_dist_171*1000.)
	deltav_171_deriv = derivsig(time171, grt_dist_171*1000., 0.0, (std_dev_171_quad*1000.))

	utplot, tim171, v_171_deriv_quad, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Quadratic fit velocity plot ' + num2str(date)
	uterrplot, tim171, v_171_deriv_quad + deltav_171_deriv, v_171_deriv_quad - deltav_171_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_171_ideal_quad, linestyle = 2, color = 0, thick = 2

; Constant a fit to data

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

    f_171_v_quad = mpfitexpr(v_quad_fit_171, tim171, v_171_deriv_quad, h_error, [v_171_ideal_quad[0], 0.05], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

	v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1] * x

	oplot, x, v_171_fit_quad, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0

end
