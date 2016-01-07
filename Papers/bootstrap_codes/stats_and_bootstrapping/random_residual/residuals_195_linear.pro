; Routine to plot the residuals of a linear fit to the 195A data

pro residuals_195_linear, time195, residuals_195_lin, dist_arr_195, date, h_err_195_lin, std_dev_195_lin, $
		mean_x_195_lin

	set_line_color

; Time calculations

	tim195 = time195 - time195[0]

	h_error_195 = h_err_195_lin

	print, std_dev_195_lin

	plot, tim195, residuals_195_lin, xr = [min(tim195) - 100, max(tim195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-std_dev_195_lin - 5, std_dev_195_lin + 5], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 2, $
			title = 'Linear fit ' + num2str(date) + ', Std Dev = ' + num2str(std_dev_195_lin)

	IF (h_error_195[0] LE 2.*std_dev_195_lin) THEN BEGIN
		oploterr, tim195, residuals_195_lin, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 100, max(tim195) + 100], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 100, max(tim195) + 100], [std_dev_195_lin, std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 100, max(tim195) + 100], [-std_dev_195_lin, -std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/top, charsize = 1.5, /clear, outline_color = 0

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

end