; Routine to calculate the velocity plots for the wave statistics routines.

pro velocity_171_linear, date, time171, grt_dist_171, f_171_lin, std_dev_171_lin, dist_arr_171, $
			residuals_171_lin, mean_x_171_lin
			
	set_line_color
	
; Time calculations

	tim171 = time171 - time171[0]

; Plot of residuals

	x = findgen(std_dev_171_lin*300.) / 10. - std_dev_171_lin*3.

	res_171_lin = histogram( residuals_171_lin, loc = loc, binsize = 1 )

	plot, loc, res_171_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_171_lin) + 0.25*max(res_171_lin)], $
			xr = [-3.*std_dev_171_lin, 3.*std_dev_171_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', charsize = 2, $
			ytitle = 'De-trended data probability', title = 'Normalised Probability distribution function of de-trended data'

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_lin ) * exp(-(x - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_lin ) * exp(-(std_dev_171_lin - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, [std_dev_171_lin, std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_lin, -std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

; Plot of velocity

	x = findgen(max(tim171))

	v_171_ideal_lin = 1000.*f_171_lin[1]

	v_171_deriv_lin = deriv(tim171, grt_dist_171*1000.)
	deltav_171_deriv = derivsig(time171, grt_dist_171*1000., 0.0, (std_dev_171_lin*1000.))

	utplot, tim171, v_171_deriv_lin, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '171A Linear fit velocity plot ' + num2str(date)
	uterrplot, tim171, v_171_deriv_lin + deltav_171_deriv, v_171_deriv_lin - deltav_171_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	v_171_ideal_lin = replicate(v_171_ideal_lin, max(tim171))

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




end
