; Routine to examine the statistics of the different wave events. Here looking at the 20070519 event.

pro wave_stats, date

; Restore data

	restore, num2str(date) + '_dist.sav'

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
	IF (date EQ '20080426') THEN h_err = 36.

	h_error_195 = replicate(h_err, dist_arr_195)
	h_error_171 = replicate(h_err, dist_arr_171)

	angstrom = '!6!sA!r!u!9 %!6!n'

	toggle, /portrait, filename = 'event_hist_1.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

;***********
; 195A data
;***********


;************
; Linear Fit
;************


; Plot 195A data with Linear fit (a = 0) and plot of residuals

; Zero a fit to data

	x = findgen( max(tim195) )

	h_error = replicate(h_err, dist_arr_195)

	lin_fit_195 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_195_lin = mpfitexpr(lin_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_lin, /quiet)

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_lin = f_195_lin[0] + f_195_lin[1]*xf

	dist_fit_195_lin_res = f_195_lin[0] + f_195_lin[1]*tim195

; Calculate statistics

	residuals_195_lin = grt_dist_195 - dist_fit_195_lin_res
	
	mean_x_195_lin = total(residuals_195_lin)/(dist_arr_195)
	
	var_195_lin = total((residuals_195_lin - mean_x_195_lin)^2.)/(dist_arr_195 - 1)

	std_dev_195_lin = sqrt(var_195_lin)
	
	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

; Plot de-trended data

	plot, tim195, residuals_195_lin, xr = [min(tim195) - 100, max(tim195) + 100], /xs, psym = 2, $
			ytitle = '!6Residuals (Mm)', /ys, yr = [-3*std_dev_195_lin, 3*std_dev_195_lin], $
			xtitle = '!6Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '!6195' + angstrom + ' Linear fit ' + num2str(date) + ', Std Dev = ' + num2str(std_dev_195_lin), $
			pos = [0.2, 0.55, 0.9, 0.9]

	IF (h_error_195[0] LE 2.*std_dev_195_lin) THEN BEGIN
		oploterr, tim195, residuals_195_lin, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 100, max(tim195) + 100], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 100, max(tim195) + 100], [std_dev_195_lin, std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 100, max(tim195) + 100], [-std_dev_195_lin, -std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_lin*300.) / 10. - std_dev_195_lin*3.

	res_195_lin = histogram( residuals_195_lin, loc = loc, binsize = 1 )

	plot, loc, res_195_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_195_lin) + 0.25*max(res_195_lin)], $
			xr = [-3.*std_dev_195_lin, 3.*std_dev_195_lin], /xs, /ys, xtitle = '!6De-trended data values (Mm)', $
			ytitle = '!6De-trended data probability', title = 'Normalised PDF of de-trended data', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_lin ) * exp(-(x - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_lin ) * exp(-(std_dev_195_lin - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, [std_dev_195_lin, std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_lin, -std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


	toggle


	toggle, /portrait, filename = 'event_hist_2.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8


;***************
; Quadratic Fit
;***************


; Plot 195A data with Quadratic fit (a = 0) and plot of residuals

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_error = replicate(h_err, dist_arr_195)

	quad_fit_195 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5
	pi(2).limited(0) = 1
	pi(2).limits(0) = -0.00025
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00025

    f_195_quad = mpfitexpr(quad_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

	
; Calculate and print statistics for the fit and residuals
	
	residuals_195_quad = grt_dist_195 - dist_fit_195_quad_res
	
	mean_x_195_quad = total(residuals_195_quad)/(dist_arr_195)
	
	var_195_quad = total((residuals_195_quad - mean_x_195_quad)^2.)/(dist_arr_195 - 1)

	std_dev_195_quad = sqrt(var_195_quad)
	
	h_err_195_quad = replicate(std_dev_195_quad, dist_arr_195)

; Plot de-trended data

	plot, tim195, residuals_195_quad, xr = [min(tim195) - 100, max(tim195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_195_quad, 3*std_dev_195_quad], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '195' + angstrom + ' Quadratic fit, Std Dev = ' + num2str(std_dev_195_quad), $
			pos = [0.2, 0.55, 0.9, 0.9]

	IF (h_error_195[0] LE 2.*std_dev_195_quad) THEN BEGIN
		oploterr, tim195, residuals_195_quad, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 100, max(tim195) + 100], [mean_x_195_quad,mean_x_195_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 100, max(tim195) + 100], [std_dev_195_quad, std_dev_195_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 100, max(tim195) + 100], [-std_dev_195_quad, -std_dev_195_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_quad), 'Standard Deviation = ' + num2str(std_dev_195_quad)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_quad*300.) / 10. - std_dev_195_quad*3.

	res_195_quad = histogram( residuals_195_quad, loc = loc, binsize = 1 )

	plot, loc, res_195_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_195_quad) + 0.25*max(res_195_quad)], $
			xr = [-3.*std_dev_195_quad, 3.*std_dev_195_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_quad ) * exp(-(x - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_quad ) * exp(-(std_dev_195_quad - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, [std_dev_195_quad, std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_quad, -std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


	toggle
	
	
	toggle, /portrait, filename = 'event_hist_3.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

;***********
; 171A data
;***********


;************
; Linear Fit
;************


; Plot 171A data with Linear fit (a = 0) and plot of residuals

; Zero a fit to data

	x = findgen( max(tim171) )

	h_error = replicate(h_err, dist_arr_171)

	lin_fit_171 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_171_lin = mpfitexpr(lin_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_lin, /quiet)

; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_lin = f_171_lin[0] + f_171_lin[1]*xf

	dist_fit_171_lin_res = f_171_lin[0] + f_171_lin[1]*tim171

; Calculate statistics

	residuals_171_lin = grt_dist_171 - dist_fit_171_lin_res
	
	mean_x_171_lin = total(residuals_171_lin)/(dist_arr_171)
	
	var_171_lin = total((residuals_171_lin - mean_x_171_lin)^2.)/(dist_arr_171 - 1)

	std_dev_171_lin = sqrt(var_171_lin)
	
	h_err_171_lin = replicate(std_dev_171_lin, dist_arr_171)

; Plot de-trended data

	plot, tim171, residuals_171_lin, xr = [min(tim171) - 100, max(tim171) + 100], /xs, psym = 2, $
			ytitle = '!6Residuals (Mm)', /ys, yr = [-3*std_dev_171_lin, 3*std_dev_171_lin], $
			xtitle = '!6Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '!6171' + angstrom + ' Linear fit ' + num2str(date) + ', Std Dev = ' + num2str(std_dev_171_lin), $
			pos = [0.2, 0.55, 0.9, 0.9]

	IF (h_error_171[0] LE 2.*std_dev_171_lin) THEN BEGIN
		oploterr, tim171, residuals_171_lin, h_error_171, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim171) - 100, max(tim171) + 100], [mean_x_171_lin,mean_x_171_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim171) - 100, max(tim171) + 100], [std_dev_171_lin, std_dev_171_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim171) - 100, max(tim171) + 100], [-std_dev_171_lin, -std_dev_171_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_lin), 'Standard Deviation = ' + num2str(std_dev_171_lin)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_lin*300.) / 10. - std_dev_171_lin*3.

	res_171_lin = histogram( residuals_171_lin, loc = loc, binsize = 1 )

	plot, loc, res_171_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_171_lin) + 0.25*max(res_171_lin)], $
			xr = [-3.*std_dev_171_lin, 3.*std_dev_171_lin], /xs, /ys, xtitle = '!6De-trended data values (Mm)', $
			ytitle = '!6De-trended data probability', title = 'Normalised PDF of de-trended data', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_lin ) * exp(-(x - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_lin ) * exp(-(std_dev_171_lin - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, [std_dev_171_lin, std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_lin, -std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


	toggle


	toggle, /portrait, filename = 'event_hist_4.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8


;***************
; Quadratic Fit
;***************


; Plot 171A data with Quadratic fit (a = 0) and plot of residuals

	xf = findgen( max(tim171) )

	x = findgen( max(tim171) )

	h_error = replicate(h_err, dist_arr_171)

	quad_fit_171 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5
	pi(2).limited(0) = 1
	pi(2).limits(0) = -0.00025
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00025

    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)

	dist_fit_171_quad_res = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

	
; Calculate and print statistics for the fit and residuals
	
	residuals_171_quad = grt_dist_171 - dist_fit_171_quad_res
	
	mean_x_171_quad = total(residuals_171_quad)/(dist_arr_171)
	
	var_171_quad = total((residuals_171_quad - mean_x_171_quad)^2.)/(dist_arr_171 - 1)

	std_dev_171_quad = sqrt(var_171_quad)
	
	h_err_171_quad = replicate(std_dev_171_quad, dist_arr_171)

; Plot de-trended data

	plot, tim171, residuals_171_quad, xr = [min(tim171) - 100, max(tim171) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_171_quad, 3*std_dev_171_quad], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '171' + angstrom + ' Quadratic fit, Std Dev = ' + num2str(std_dev_171_quad), $
			pos = [0.2, 0.55, 0.9, 0.9]

	IF (h_error_171[0] LE 2.*std_dev_171_quad) THEN BEGIN
		oploterr, tim171, residuals_171_quad, h_error_171, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim171) - 100, max(tim171) + 100], [mean_x_171_quad,mean_x_171_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim171) - 100, max(tim171) + 100], [std_dev_171_quad, std_dev_171_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim171) - 100, max(tim171) + 100], [-std_dev_171_quad, -std_dev_171_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_quad), 'Standard Deviation = ' + num2str(std_dev_171_quad)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_quad*300.) / 10. - std_dev_171_quad*3.

	res_171_quad = histogram( residuals_171_quad, loc = loc, binsize = 1 )

	plot, loc, res_171_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_171_quad) + 0.25*max(res_171_quad)], $
			xr = [-3.*std_dev_171_quad, 3.*std_dev_171_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_quad ) * exp(-(x - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_quad ) * exp(-(std_dev_171_quad - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, [std_dev_171_quad, std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_quad, -std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0


	toggle



end