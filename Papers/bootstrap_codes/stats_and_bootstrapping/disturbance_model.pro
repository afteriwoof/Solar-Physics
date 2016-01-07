; Routine to fit model to general distances and measure subsequent statistics

pro disturbance_model, date

	!p.multi = [0, 3, 2]
	window, 0, xs = 1500, ys = 1000

	angstrom = '!6!sA!r!u!9 %!6!n'

; Restore data

	restore, num2str(date) + '_dist_0.sav'
	restore, num2str(date) + '_dist_1.sav'
	restore, num2str(date) + '_dist_2.sav'
	restore, num2str(date) + '_dist_3.sav'
	restore, num2str(date) + '_dist_4.sav'
	restore, num2str(date) + '_dist_5.sav'
	restore, num2str(date) + '_dist_6.sav'
	restore, num2str(date) + '_dist_7.sav'

	dist_arr_195 = size(grt_dist_195_0, /n_elements)
	dist_arr_171 = size(grt_dist_171_0, /n_elements)

; Calculate average distance for each arc

	grt_dist_195 = fltarr(4)

	grt_dist_171 = fltarr(8)

	for i = 0, 3 do begin

		x = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], grt_dist_195_4[i], $
				grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i]]

		grt_dist_195[i] = mean(x)

	endfor

	for i = 0, 7 do begin

		x = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], grt_dist_171_4[i], $
				grt_dist_171[i], grt_dist_171_6[i], grt_dist_171_7[i]]

		grt_dist_171[i] = mean(x)

	endfor

; Find parameters for fitting routine

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Errors for each event

	IF (date EQ '20070516') THEN h_err = 31. $
		ELSE $
	IF (date EQ '20070519') THEN h_err = 39. $
		ELSE $
	IF (date EQ '20070806_1') THEN h_err = 37. $
		ELSE $
	IF (date EQ '20070806_2') THEN h_err = 42. $
		ELSE $
	IF (date EQ '20071207') THEN h_err = 30. $
		ELSE $
	IF (date EQ '20080107') THEN h_err = 32. $
		ELSE $
	IF (date EQ '20080426') THEN h_err = 36. $
		ELSE $
	IF (date EQ '20090212') THEN h_err = 36.


	h_error_195 = replicate(h_err, dist_arr_195)
	h_error_171 = replicate(h_err, dist_arr_171)


;************
; Linear Fit
;************


; Find and plot best-fit linear fit (a = 0) to 195A data

	resolve_routine, 'data_fit_195_linear'

	data_fit_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, perror_195_lin

	print, 'Coefficient error = '
	print, perror_195_lin

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_lin = f_195_lin[0] + f_195_lin[1]*xf

	dist_fit_195_lin_res = f_195_lin[0] + f_195_lin[1]*tim195

	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0

; Statistics of linear fit to averaged 195A data

	res_195_lin = grt_dist_195 - dist_fit_195_lin_res
	
	mean_x_195_lin = total(res_195_lin)/(dist_arr_195)
	
	var_195_lin = total((res_195_lin - mean_x_195_lin)^2.)/(dist_arr_195 - 1)

	std_dev_195_lin = sqrt(var_195_lin)
	
; Plot error bars using Standard Deviation of data

	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_lin, grt_dist_195 - h_err_195_lin, color = 0

	legend, ['r!D0!N = ' + num2str(f_195_lin[0]) + ' Mm +/- ' + num2str(perror_195_lin[0]), $
				'v!D0!N = ' + num2str(1000*f_195_lin[1]) + ' km/s +/- ' + num2str(1000*perror_195_lin[1])], $
				textcolors = [3, 3], charsize = 1.5, /bottom, /right

; Get residuals for all data points

	residuals_195_lin_0 = grt_dist_195_0 - dist_fit_195_lin_res
	residuals_195_lin_1 = grt_dist_195_1 - dist_fit_195_lin_res
	residuals_195_lin_2 = grt_dist_195_2 - dist_fit_195_lin_res
	residuals_195_lin_3 = grt_dist_195_3 - dist_fit_195_lin_res
	residuals_195_lin_4 = grt_dist_195_4 - dist_fit_195_lin_res
	residuals_195_lin_5 = grt_dist_195_5 - dist_fit_195_lin_res
	residuals_195_lin_6 = grt_dist_195_6 - dist_fit_195_lin_res
	residuals_195_lin_7 = grt_dist_195_7 - dist_fit_195_lin_res

	residuals_195_lin = [residuals_195_lin_0, residuals_195_lin_1, residuals_195_lin_2, residuals_195_lin_3, $
			residuals_195_lin_4, residuals_195_lin_5, residuals_195_lin_6, residuals_195_lin_7]

	arr_195_lin = size(residuals_195_lin, /n_elements)

	time_195 = [tim195, tim195, tim195, tim195, tim195, tim195, tim195, tim195]

; Linear fit to all 195A data

	mean_x_195_lin = total(residuals_195_lin)/(arr_195_lin)
	
	var_195_lin = total((residuals_195_lin - mean_x_195_lin)^2.)/(arr_195_lin - 1)

	std_dev_195_lin = sqrt(var_195_lin)
	
	plot, time_195, residuals_195_lin, xr = [min(time_195) - 100, max(time_195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [mean_x_195_lin - std_dev_195_lin - 20, mean_x_195_lin + std_dev_195_lin + 20], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 2, $
			title = '195' + angstrom + ' Linear fit , Std Dev = ' + num2str(std_dev_195_lin)

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_lin + std_dev_195_lin, $
			mean_x_195_lin + std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_lin - std_dev_195_lin, $
			mean_x_195_lin - std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/top, charsize = 1.5, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_lin*300.) / 10. - std_dev_195_lin*3.

	hist_195_lin = histogram( residuals_195_lin, loc = loc, binsize = 5 )

	plot, loc, hist_195_lin, psym = 10, color = 0, background = 1, yr = [0, max(hist_195_lin) + 0.25*max(hist_195_lin)], $
			xr = [-3.*std_dev_195_lin, 3.*std_dev_195_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			charsize = 2

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( hist_195_lin ) * exp(-(x - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( hist_195_lin ) * exp(-(std_dev_195_lin - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, [std_dev_195_lin, std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_lin, -std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


; Plot 195A data with Quadratic fit (a = 0) and plot of residuals

	resolve_routine, 'data_fit_195_quadratic'

	data_fit_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad, perror_195_quad

	print, 'Coefficient error = '
	print, perror_195_quad


; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_quad = f_195_quad[0] + f_195_quad[1]*xf + (1./2.)*f_195_quad[2]*xf^2.

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

	oplot, xf, dist_fit_195_quad, linestyle = 0, thick = 2, color = 0

; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_195_quadratic'

	stats_195_quadratic, grt_dist_195, dist_fit_195_quad_res, dist_arr_195, mean_x_195_quad, std_dev_195_quad, residuals_195_quad

	h_err_195_quad = replicate(std_dev_195_quad, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_quad, grt_dist_195 - h_err_195_quad, color = 0

	legend, ['r!D0!N = ' + num2str(f_195_quad[0]) + ' Mm +/- ' + num2str(perror_195_quad[0]), $
				'v!D0!N = ' + num2str(1000*f_195_quad[1]) + ' km/s +/- ' + num2str(1000*perror_195_quad[1]), $
				'a!D0!N = ' + num2str(1e6*f_195_quad[2]) + ' m/s!U2!N +/- ' + num2str(1e6*perror_195_quad[2])], $
				textcolors = [3, 3, 3], charsize = 1.5, /bottom, /right

; Get residuals for all data points

	residuals_195_quad_0 = grt_dist_195_0 - dist_fit_195_quad_res
	residuals_195_quad_1 = grt_dist_195_1 - dist_fit_195_quad_res
	residuals_195_quad_2 = grt_dist_195_2 - dist_fit_195_quad_res
	residuals_195_quad_3 = grt_dist_195_3 - dist_fit_195_quad_res
	residuals_195_quad_4 = grt_dist_195_4 - dist_fit_195_quad_res
	residuals_195_quad_5 = grt_dist_195_5 - dist_fit_195_quad_res
	residuals_195_quad_6 = grt_dist_195_6 - dist_fit_195_quad_res
	residuals_195_quad_7 = grt_dist_195_7 - dist_fit_195_quad_res

	residuals_195_quad = [residuals_195_quad_0, residuals_195_quad_1, residuals_195_quad_2, residuals_195_quad_3, $
			residuals_195_quad_4, residuals_195_quad_5, residuals_195_quad_6, residuals_195_quad_7]

	arr_195_quad = size(residuals_195_quad, /n_elements)

	time_195 = [tim195, tim195, tim195, tim195, tim195, tim195, tim195, tim195]

; Linear fit to all 195A data

	mean_x_195_quad = total(residuals_195_quad)/(arr_195_lin)
	
	var_195_quad = total((residuals_195_quad - mean_x_195_quad)^2.)/(arr_195_quad - 1)

	std_dev_195_quad = sqrt(var_195_quad)
	
	plot, time_195, residuals_195_quad, xr = [min(time_195) - 100, max(time_195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [mean_x_195_quad - std_dev_195_quad - 20, mean_x_195_quad + std_dev_195_quad + 20], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 2, $
			title = '195' + angstrom + ' Linear fit , Std Dev = ' + num2str(std_dev_195_quad)

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_quad,mean_x_195_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_quad + std_dev_195_quad, $
			mean_x_195_quad + std_dev_195_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_quad - std_dev_195_quad, $
			mean_x_195_quad - std_dev_195_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_quad), 'Standard Deviation = ' + num2str(std_dev_195_quad)], textcolors = [3, 3], $
				/top, charsize = 1.5, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_quad*300.) / 10. - std_dev_195_quad*3.

	hist_195_quad = histogram( residuals_195_quad, loc = loc, binsize = 5 )

	plot, loc, hist_195_quad, psym = 10, color = 0, background = 1, yr = [0, max(hist_195_quad) + 0.25*max(hist_195_quad)], $
			xr = [-3.*std_dev_195_quad, 3.*std_dev_195_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			charsize = 2

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( hist_195_quad ) * exp(-(x - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( hist_195_quad ) * exp(-(std_dev_195_quad - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, [std_dev_195_quad, std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_quad, -std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

;stop

	ans = ' '
	read, 'Ok?', ans

;************
; Linear Fit
;************


; Find and plot best-fit linear fit (a = 0) to 171A data

	resolve_routine, 'data_fit_171_linear'

	data_fit_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin, perror_171_lin

	print, 'Coefficient error = '
	print, perror_171_lin

; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_lin = f_171_lin[0] + f_171_lin[1]*xf

	dist_fit_171_lin_res = f_171_lin[0] + f_171_lin[1]*tim171

	oplot, xf, dist_fit_171_lin, linestyle = 0, thick = 2, color = 0

; Statistics of linear fit to averaged 171A data

	res_171_lin = grt_dist_171 - dist_fit_171_lin_res
	
	mean_x_171_lin = total(res_171_lin)/(dist_arr_171)
	
	var_171_lin = total((res_171_lin - mean_x_171_lin)^2.)/(dist_arr_171 - 1)

	std_dev_171_lin = sqrt(var_171_lin)
	
; Plot error bars using Standard Deviation of data

	h_err_171_lin = replicate(std_dev_171_lin, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_lin, grt_dist_171 - h_err_171_lin, color = 0

	legend, ['r!D0!N = ' + num2str(f_171_lin[0]) + ' Mm +/- ' + num2str(perror_171_lin[0]), $
				'v!D0!N = ' + num2str(1000*f_171_lin[1]) + ' km/s +/- ' + num2str(1000*perror_171_lin[1])], $
				textcolors = [3, 3], charsize = 1.5, /bottom, /right

; Get residuals for all data points

	residuals_171_lin_0 = grt_dist_171_0 - dist_fit_171_lin_res
	residuals_171_lin_1 = grt_dist_171_1 - dist_fit_171_lin_res
	residuals_171_lin_2 = grt_dist_171_2 - dist_fit_171_lin_res
	residuals_171_lin_3 = grt_dist_171_3 - dist_fit_171_lin_res
	residuals_171_lin_4 = grt_dist_171_4 - dist_fit_171_lin_res
	residuals_171_lin_5 = grt_dist_171_5 - dist_fit_171_lin_res
	residuals_171_lin_6 = grt_dist_171_6 - dist_fit_171_lin_res
	residuals_171_lin_7 = grt_dist_171_7 - dist_fit_171_lin_res

	residuals_171_lin = [residuals_171_lin_0, residuals_171_lin_1, residuals_171_lin_2, residuals_171_lin_3, $
			residuals_171_lin_4, residuals_171_lin_5, residuals_171_lin_6, residuals_171_lin_7]

	arr_171_lin = size(residuals_171_lin, /n_elements)

	time_171 = [tim171, tim171, tim171, tim171, tim171, tim171, tim171, tim171]

; Linear fit to all 171A data

	mean_x_171_lin = total(residuals_171_lin)/(arr_171_lin)
	
	var_171_lin = total((residuals_171_lin - mean_x_171_lin)^2.)/(arr_171_lin - 1)

	std_dev_171_lin = sqrt(var_171_lin)
	
	plot, time_171, residuals_171_lin, xr = [min(time_171) - 100, max(time_171) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [mean_x_171_lin - std_dev_171_lin - 20, mean_x_171_lin + std_dev_171_lin + 20], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 2, $
			title = '171' + angstrom + ' Linear fit , Std Dev = ' + num2str(std_dev_171_lin)

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_lin,mean_x_171_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_lin + std_dev_171_lin, $
			mean_x_171_lin + std_dev_171_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_lin - std_dev_171_lin, $
			mean_x_171_lin - std_dev_171_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_lin), 'Standard Deviation = ' + num2str(std_dev_171_lin)], textcolors = [3, 3], $
				/top, charsize = 1.5, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_lin*300.) / 10. - std_dev_171_lin*3.

	hist_171_lin = histogram( residuals_171_lin, loc = loc, binsize = 5 )

	plot, loc, hist_171_lin, psym = 10, color = 0, background = 1, yr = [0, max(hist_171_lin) + 0.25*max(hist_171_lin)], $
			xr = [-3.*std_dev_171_lin, 3.*std_dev_171_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			charsize = 2

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( hist_171_lin ) * exp(-(x - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( hist_171_lin ) * exp(-(std_dev_171_lin - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, [std_dev_171_lin, std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_lin, -std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


; Plot 171A data with Quadratic fit (a = 0) and plot of residuals

	resolve_routine, 'data_fit_171_quadratic'

	data_fit_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad, perror_171_quad

	print, 'Coefficient error = '
	print, perror_171_quad


; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_quad = f_171_quad[0] + f_171_quad[1]*xf + (1./2.)*f_171_quad[2]*xf^2.

	dist_fit_171_quad_res = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

	oplot, xf, dist_fit_171_quad, linestyle = 0, thick = 2, color = 0

; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_171_quadratic'

	stats_171_quadratic, grt_dist_171, dist_fit_171_quad_res, dist_arr_171, mean_x_171_quad, std_dev_171_quad, residuals_171_quad

	h_err_171_quad = replicate(std_dev_171_quad, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_quad, grt_dist_171 - h_err_171_quad, color = 0

	legend, ['r!D0!N = ' + num2str(f_171_quad[0]) + ' Mm +/- ' + num2str(perror_171_quad[0]), $
				'v!D0!N = ' + num2str(1000*f_171_quad[1]) + ' km/s +/- ' + num2str(1000*perror_171_quad[1]), $
				'a!D0!N = ' + num2str(1e6*f_171_quad[2]) + ' m/s!U2!N +/- ' + num2str(1e6*perror_171_quad[2])], $
				textcolors = [3, 3, 3], charsize = 1.5, /bottom, /right

; Get residuals for all data points

	residuals_171_quad_0 = grt_dist_171_0 - dist_fit_171_quad_res
	residuals_171_quad_1 = grt_dist_171_1 - dist_fit_171_quad_res
	residuals_171_quad_2 = grt_dist_171_2 - dist_fit_171_quad_res
	residuals_171_quad_3 = grt_dist_171_3 - dist_fit_171_quad_res
	residuals_171_quad_4 = grt_dist_171_4 - dist_fit_171_quad_res
	residuals_171_quad_5 = grt_dist_171_5 - dist_fit_171_quad_res
	residuals_171_quad_6 = grt_dist_171_6 - dist_fit_171_quad_res
	residuals_171_quad_7 = grt_dist_171_7 - dist_fit_171_quad_res

	residuals_171_quad = [residuals_171_quad_0, residuals_171_quad_1, residuals_171_quad_2, residuals_171_quad_3, $
			residuals_171_quad_4, residuals_171_quad_5, residuals_171_quad_6, residuals_171_quad_7]

	arr_171_quad = size(residuals_171_quad, /n_elements)

	time_171 = [tim171, tim171, tim171, tim171, tim171, tim171, tim171, tim171]

; Linear fit to all 171A data

	mean_x_171_quad = total(residuals_171_quad)/(arr_171_lin)
	
	var_171_quad = total((residuals_171_quad - mean_x_171_quad)^2.)/(arr_171_quad - 1)

	std_dev_171_quad = sqrt(var_171_quad)
	
	plot, time_171, residuals_171_quad, xr = [min(time_171) - 100, max(time_171) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [mean_x_171_quad - std_dev_171_quad - 20, mean_x_171_quad + std_dev_171_quad + 20], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 2, $
			title = '171' + angstrom + ' Linear fit , Std Dev = ' + num2str(std_dev_171_quad)

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_quad,mean_x_171_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_quad + std_dev_171_quad, $
			mean_x_171_quad + std_dev_171_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_quad - std_dev_171_quad, $
			mean_x_171_quad - std_dev_171_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_quad), 'Standard Deviation = ' + num2str(std_dev_171_quad)], textcolors = [3, 3], $
				/top, charsize = 1.5, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_quad*300.) / 10. - std_dev_171_quad*3.

	hist_171_quad = histogram( residuals_171_quad, loc = loc, binsize = 5 )

	plot, loc, hist_171_quad, psym = 10, color = 0, background = 1, yr = [0, max(hist_171_quad) + 0.25*max(hist_171_quad)], $
			xr = [-3.*std_dev_171_quad, 3.*std_dev_171_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			charsize = 2

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( hist_171_quad ) * exp(-(x - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( hist_171_quad ) * exp(-(std_dev_171_quad - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, [std_dev_171_quad, std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_quad, -std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

end