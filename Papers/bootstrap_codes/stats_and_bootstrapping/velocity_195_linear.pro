; Routine to calculate the velocity plots for the wave statistics routines.

pro velocity_195_linear, date, time195, grt_dist_195, f_195_lin, std_dev_195_lin, dist_arr_195, $
			residuals_195_lin, mean_x_195_lin
			
	set_line_color
	
; Time calculations

	tim195 = time195 - time195[0]

; Plot of residuals

	x = findgen(std_dev_195_lin*300.) / 10. - std_dev_195_lin*3.

	res_195_lin = histogram( residuals_195_lin, loc = loc, binsize = 1 )

	plot, loc, res_195_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_195_lin) + 0.25*max(res_195_lin)], $
			xr = [-3.*std_dev_195_lin, 3.*std_dev_195_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', charsize = 2, $
			ytitle = 'De-trended data probability', title = 'Normalised Probability distribution function of de-trended data'

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_lin ) * exp(-(x - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_lin ) * exp(-(std_dev_195_lin - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, [std_dev_195_lin, std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_lin, -std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_195_ideal_lin = 1000.*f_195_lin[1]

	v_195_deriv_lin = deriv(tim195, grt_dist_195*1000.)
	deltav_195_deriv = derivsig(time195, grt_dist_195*1000., 0.0, (std_dev_195_lin*1000.))

	utplot, tim195, v_195_deriv_lin, time195[0], timerange = [time195[0] - 60, max(time195) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 2, xstyle = 1, ystyle = 1, thick = 2, $
		title = '195A Linear fit velocity plot ' + num2str(date)
	uterrplot, tim195, v_195_deriv_lin + deltav_195_deriv, v_195_deriv_lin - deltav_195_deriv, thick = 2, color = 0

; Over-plot the ideal velocity line

	v_195_ideal_lin = replicate(v_195_ideal_lin, max(tim195))

	oplot, x, v_195_ideal_lin, linestyle = 2, color = 0, thick = 2

; Zero a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_lin, dist_arr_195)

	v_lin_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_195_v_lin = mpfitexpr(v_lin_fit_195, tim195, v_195_deriv_lin, h_error, [v_195_ideal_lin[0]], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_v_lin, /quiet)

	v_195_fit_lin = replicate(f_195_v_lin[0], max(tim195))

	oplot, x, v_195_fit_lin, linestyle = 4, color = 3, thick = 2

	legend, ['Ideal', 'Fit'], textcolors = [0, 3], /bottom, charsize = 1.5, /clear, outline_color = 0


end
