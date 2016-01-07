; Routine to produce more postscript images for the report.

pro stats_histogram_image

	toggle, /portrait, filename = 'stats_1.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

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

	set_line_color

; Plot 195A data

	utplot, tim195, grt_dist_195, time195[0], title = '!6Distance-time plot, 195 !6!sA!r!u!9 %!6!n', $
		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 1, /xs, /ys, $
		color = 0, background = 1, thick = 2, pos = [0.2, 0.55, 0.9, 0.9]
	
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

	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0

; Calculate and print statistics for the fit and residuals

	residuals_195_lin = grt_dist_195 - dist_fit_195_lin_res
	
	print, 'De-trended data (195 Linear fit) = ', residuals_195_lin
	
	mean_x_195_lin = total(residuals_195_lin)/(dist_arr_195)
	
	print, 'Calculated mean value of de-trended data (195 Linear fit) = ', mean_x_195_lin
	
	mean_195_lin = mean(residuals_195_lin)

	print, 'IDL mean value of de-trended data (195 Linear fit) = ', mean_195_lin

; Built-in check for mean

	IF (mean_195_lin NE mean_x_195_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (mean_195_lin EQ mean_x_195_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_195_lin = total((residuals_195_lin - mean_x_195_lin)^2.)/(dist_arr_195 - 1)

	print, 'Calculated variance of de-trended data (195 Linear fit) = ', var_195_lin

	std_dev_195_lin = sqrt(var_195_lin)
	
	print, 'Standard deviation of de-trended data (195 Linear fit) = ', std_dev_195_lin

	stddev_195_lin = stddev(residuals_195_lin)

	print, 'IDL standard deviation of de-trended data (195 Linear fit) = ', stddev_195_lin

; Built-in check for mean

	IF (stddev_195_lin NE std_dev_195_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_195_lin EQ std_dev_195_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	stats_195_linear, grt_dist_195, dist_fit_195_lin_res, dist_arr_195, mean_x_195_lin, std_dev_195_lin, residuals_195_lin

	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_lin, grt_dist_195 - h_err_195_lin, color = 0

	h_error_195 = h_err_195_lin

	print, std_dev_195_lin

	plot, tim195, residuals_195_lin, xr = [min(tim195) - 100, max(tim195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-std_dev_195_lin - 5, std_dev_195_lin + 5], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = 'Linear fit ' + num2str(date) + ', Std Dev = ' + num2str(std_dev_195_lin), $
			pos = [0.2, 0.1, 0.9, 0.45]

	IF (h_error_195[0] LE 2.*std_dev_195_lin) THEN BEGIN
		oploterr, tim195, residuals_195_lin, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 100, max(tim195) + 100], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 100, max(tim195) + 100], [std_dev_195_lin, std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 100, max(tim195) + 100], [-std_dev_195_lin, -std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/top, charsize = 1, /clear, outline_color = 0

	toggle






end