; Routine to make histogram all-data postscript image for report

pro hist_image

	resolve_routine, 'wave_stats_20070516'
	
	wave_stats_20070516, tim195_20070516, tim171_20070516, residuals_195_lin_20070516, residuals_195_quad_20070516, $
			residuals_171_lin_20070516, residuals_171_quad_20070516

	resolve_routine, 'wave_stats_20070519'
	
	wave_stats_20070519, tim195_20070519, tim171_20070519, residuals_195_lin_20070519, residuals_195_quad_20070519, $
			residuals_171_lin_20070519, residuals_171_quad_20070519

	resolve_routine, 'wave_stats_20070806_1'
	
	wave_stats_20070806_1, tim195_20070806_1, tim171_20070806_1, residuals_195_lin_20070806_1, residuals_195_quad_20070806_1, $
			residuals_171_lin_20070806_1, residuals_171_quad_20070806_1

	resolve_routine, 'wave_stats_20070806_2'
	
	wave_stats_20070806_2, tim195_20070806_2, tim171_20070806_2, residuals_195_lin_20070806_2, residuals_195_quad_20070806_2, $
			residuals_171_lin_20070806_2, residuals_171_quad_20070806_2

	resolve_routine, 'wave_stats_20071207'
	
	wave_stats_20071207, tim195_20071207, tim171_20071207, residuals_195_lin_20071207, residuals_195_quad_20071207, $
			residuals_171_lin_20071207, residuals_171_quad_20071207

	resolve_routine, 'wave_stats_20080107'
	
	wave_stats_20080107, tim195_20080107, tim171_20080107, residuals_195_lin_20080107, residuals_195_quad_20080107, $
			residuals_171_lin_20080107, residuals_171_quad_20080107
		
	resolve_routine, 'wave_stats_20080426'
	
	wave_stats_20080426, tim195_20080426, tim171_20080426, residuals_195_lin_20080426, residuals_195_quad_20080426, $
			residuals_171_lin_20080426, residuals_171_quad_20080426
			
; Make arrays of residuals and time			
	
	residuals_195_lin = [residuals_195_lin_20070516, residuals_195_lin_20070519, residuals_195_lin_20070806_1, $
			residuals_195_lin_20070806_2, residuals_195_lin_20071207, residuals_195_lin_20080107, $
			residuals_195_lin_20080426]
	
	residuals_195_quad = [residuals_195_quad_20070516, residuals_195_quad_20070519, residuals_195_quad_20070806_1, $
			residuals_195_quad_20070806_2, residuals_195_quad_20071207, residuals_195_quad_20080107, $
			residuals_195_quad_20080426]
	
	residuals_171_lin = [residuals_171_lin_20070516, residuals_171_lin_20070519, residuals_171_lin_20070806_1, $
			residuals_171_lin_20070806_2, residuals_171_lin_20071207, residuals_171_lin_20080107, $
			residuals_171_lin_20080426]
	
	residuals_171_quad = [residuals_171_quad_20070516, residuals_171_quad_20070519, residuals_171_quad_20070806_1, $
			residuals_171_quad_20070806_2, residuals_171_quad_20071207, residuals_171_quad_20080107, $
			residuals_171_quad_20080426]

	time_195 = [tim195_20070516, tim195_20070519, tim195_20070806_1, tim195_20070806_2, tim195_20071207, $
			tim195_20080107, tim195_20080426]

	time_171 = [tim171_20070516, tim171_20070519, tim171_20070806_1, tim171_20070806_2, tim171_20071207, $
			tim171_20080107, tim171_20080426]
	
	arr_195_lin = size(residuals_195_lin, /n_elements)
	arr_195_quad = size(residuals_195_quad, /n_elements)
	arr_171_lin = size(residuals_171_lin, /n_elements)
	arr_171_quad = size(residuals_171_quad, /n_elements)

	toggle, /portrait, filename = 'stats_hist_1.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

	angstrom = '!6!sA!r!u!9 %!6!n'

	set_line_color

;**********************
; STATISTICAL ANALYSIS
;**********************


; Linear fit to 195A data

	mean_x_195_lin = total(residuals_195_lin)/(arr_195_lin)
	
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

	var_195_lin = total((residuals_195_lin - mean_x_195_lin)^2.)/(arr_195_lin - 1)

	print, 'Calculated variance of de-trended data (195 Linear fit) = ', var_195_lin

	std_dev_195_lin = sqrt(var_195_lin)
	
	print, 'Standard deviation of de-trended data (195 Linear fit) = ', std_dev_195_lin

	stddev_195_lin = stddev(residuals_195_lin)

	print, 'IDL standard deviation of de-trended data (195 Linear fit) = ', stddev_195_lin

; Built-in check for standard deviation

	IF (stddev_195_lin NE std_dev_195_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_195_lin EQ std_dev_195_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF
	
	plot, time_195, residuals_195_lin, xr = [min(time_195) - 100, max(time_195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_195_lin, 3*std_dev_195_lin], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '195' + angstrom + ' Linear fit, Std Dev = ' + num2str(std_dev_195_lin), $
			pos = [0.2, 0.55, 0.9, 0.9]

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_195) - 100, max(time_195) + 100], [std_dev_195_lin, std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_195) - 100, max(time_195) + 100], [-std_dev_195_lin, -std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_lin*300.) / 10. - std_dev_195_lin*3.

; Calculate optimal binsize

	bin_size = (3.5 * std_dev_195_lin) / arr_195_lin^(0.3333)
	
	print, '195 Linear fit binsize = ', bin_size

	res_195_lin = histogram( residuals_195_lin, loc = loc, binsize = 5 )

	plot, loc, res_195_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_195_lin) + 0.25*max(res_195_lin)], $
			xr = [-3.*std_dev_195_lin, 3.*std_dev_195_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_lin ) * exp(-(x - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_lin ) * exp(-(std_dev_195_lin - mean_x_195_lin)^2./(2.*std_dev_195_lin^2.))

	oplot, [std_dev_195_lin, std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_lin, -std_dev_195_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

	toggle


	toggle, /portrait, filename = 'stats_hist_2.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

	angstrom = '!6!sA!r!u!9 %!6!n'

	set_line_color

;**********************
; STATISTICAL ANALYSIS
;**********************

; Quadratic fit to 195A data

	mean_x_195_quad = total(residuals_195_quad)/(arr_195_quad)
	
	print, 'Calculated mean value of de-trended data (195 Quadratic fit) = ', mean_x_195_quad
	
	mean_195_quad = mean(residuals_195_quad)

	print, 'IDL mean value of de-trended data (195 Quadratic fit) = ', mean_195_quad

; Built-in check for mean

	IF (mean_195_quad NE mean_x_195_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (mean_195_quad EQ mean_x_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_195_quad = total((residuals_195_quad - mean_x_195_quad)^2.)/(arr_195_quad - 1)

	print, 'Calculated variance of de-trended data (195 Quadratic fit) = ', var_195_quad

	std_dev_195_quad = sqrt(var_195_quad)
	
	print, 'Standard deviation of de-trended data (195 Quadratic fit) = ', std_dev_195_quad

	stddev_195_quad = stddev(residuals_195_quad)

	print, 'IDL standard deviation of de-trended data (195 Quadratic fit) = ', stddev_195_quad

; Built-in check for standard deviation

	IF (stddev_195_quad NE std_dev_195_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_195_quad EQ std_dev_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF
	
	plot, time_195, residuals_195_quad, xr = [min(time_195) - 100, max(time_195) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_195_quad, 3*std_dev_195_quad], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '195' + angstrom + ' Quadratic fit, Std Dev = ' + num2str(std_dev_195_quad), $
			pos = [0.2, 0.55, 0.9, 0.9]

	oplot, [min(time_195) - 100, max(time_195) + 100], [mean_x_195_quad,mean_x_195_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_195) - 100, max(time_195) + 100], [std_dev_195_quad, std_dev_195_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_195) - 100, max(time_195) + 100], [-std_dev_195_quad, -std_dev_195_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_quad), 'Standard Deviation = ' + num2str(std_dev_195_quad)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_195_quad*300.) / 10. - std_dev_195_quad*3.

; Calculate optimal binsize

	bin_size = (3.5 * std_dev_195_quad) / arr_195_quad^(0.3333)
	
	print, '195 Quadratic fit binsize = ', bin_size

	res_195_quad = histogram( residuals_195_quad, loc = loc, binsize = 5 )

	plot, loc, res_195_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_195_quad) + 0.25*max(res_195_quad)], $
			xr = [-3.*std_dev_195_quad, 3.*std_dev_195_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_195_quad ) * exp(-(x - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_195_quad ) * exp(-(std_dev_195_quad - mean_x_195_quad)^2./(2.*std_dev_195_quad^2.))

	oplot, [std_dev_195_quad, std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_195_quad, -std_dev_195_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

	toggle
	
	
	toggle, /portrait, filename = 'stats_hist_3.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

	angstrom = '!6!sA!r!u!9 %!6!n'

	set_line_color

;**********************
; STATISTICAL ANALYSIS
;**********************
	
; Linear fit to 171A data

	mean_x_171_lin = total(residuals_171_lin)/(arr_171_lin)
	
	print, 'Calculated mean value of de-trended data (171 Linear fit) = ', mean_x_171_lin
	
	mean_171_lin = mean(residuals_171_lin)

	print, 'IDL mean value of de-trended data (171 Linear fit) = ', mean_171_lin

; Built-in check for mean

	IF (mean_171_lin NE mean_x_171_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (mean_171_lin EQ mean_x_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_171_lin = total((residuals_171_lin - mean_x_171_lin)^2.)/(arr_171_lin - 1)

	print, 'Calculated variance of de-trended data (171 Linear fit) = ', var_171_lin

	std_dev_171_lin = sqrt(var_171_lin)
	
	print, 'Standard deviation of de-trended data (171 Linear fit) = ', std_dev_171_lin

	stddev_171_lin = stddev(residuals_171_lin)

	print, 'IDL standard deviation of de-trended data (171 Linear fit) = ', stddev_171_lin

; Built-in check for standard deviation

	IF (stddev_171_lin NE std_dev_171_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_171_lin EQ std_dev_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF
	
	plot, time_171, residuals_171_lin, xr = [min(time_171) - 100, max(time_171) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_171_lin, 3*std_dev_171_lin], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '171' + angstrom + ' Linear fit , Std Dev = ' + num2str(std_dev_171_lin), $
			pos = [0.2, 0.55, 0.9, 0.9]

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_lin,mean_x_171_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_171) - 100, max(time_171) + 100], [std_dev_171_lin, std_dev_171_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_171) - 100, max(time_171) + 100], [-std_dev_171_lin, -std_dev_171_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_lin), 'Standard Deviation = ' + num2str(std_dev_171_lin)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_lin*300.) / 10. - std_dev_171_lin*3.

; Calculate optimal binsize

	bin_size = (3.5 * std_dev_171_lin) / arr_171_lin^(0.3333)
	
	print, '171 Linear fit binsize = ', bin_size

	res_171_lin = histogram( residuals_171_lin, loc = loc, binsize = 5 )

	plot, loc, res_171_lin, psym = 10, color = 0, background = 1, yr = [0, max(res_171_lin) + 0.25*max(res_171_lin)], $
			xr = [-3.*std_dev_171_lin, 3.*std_dev_171_lin], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_lin ) * exp(-(x - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_lin ) * exp(-(std_dev_171_lin - mean_x_171_lin)^2./(2.*std_dev_171_lin^2.))

	oplot, [std_dev_171_lin, std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_lin, -std_dev_171_lin], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

	toggle


	toggle, /portrait, filename = 'stats_hist_4.eps', xsize = 8, ysize = 7, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

	angstrom = '!6!sA!r!u!9 %!6!n'

	set_line_color

;**********************
; STATISTICAL ANALYSIS
;**********************
	
; Quadratic fit to 171A data

	mean_x_171_quad = total(residuals_171_quad)/(arr_171_quad)
	
	print, 'Calculated mean value of de-trended data (171 Quadratic fit) = ', mean_x_171_quad
	
	mean_171_quad = mean(residuals_171_quad)

	print, 'IDL mean value of de-trended data (171 Quadratic fit) = ', mean_171_quad

; Built-in check for mean

	IF (mean_171_quad NE mean_x_171_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (mean_171_quad EQ mean_x_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_171_quad = total((residuals_171_quad - mean_x_171_quad)^2.)/(arr_171_quad - 1)

	print, 'Calculated variance of de-trended data (171 Quadratic fit) = ', var_171_quad

	std_dev_171_quad = sqrt(var_171_quad)
	
	print, 'Standard deviation of de-trended data (171 Quadratic fit) = ', std_dev_171_quad

	stddev_171_quad = stddev(residuals_171_quad)

	print, 'IDL standard deviation of de-trended data (171 Quadratic fit) = ', stddev_171_quad

; Built-in check for standard deviation

	IF (stddev_171_quad NE std_dev_171_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_171_quad EQ std_dev_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF
	
	plot, time_171, residuals_171_quad, xr = [min(time_171) - 100, max(time_171) + 100], /xs, psym = 2, $
			ytitle = 'Residuals (Mm)', /ys, yr = [-3*std_dev_171_quad, 3*std_dev_171_quad], $
			xtitle = 'Time range (s)', color = 0, background = 1, charsize = 1, $
			title = '171' + angstrom + ' Quadratic fit , Std Dev = ' + num2str(std_dev_171_quad), $
			pos = [0.2, 0.55, 0.9, 0.9]

	oplot, [min(time_171) - 100, max(time_171) + 100], [mean_x_171_quad,mean_x_171_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(time_171) - 100, max(time_171) + 100], [std_dev_171_quad, std_dev_171_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(time_171) - 100, max(time_171) + 100], [-std_dev_171_quad, -std_dev_171_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_quad), 'Standard Deviation = ' + num2str(std_dev_171_quad)], textcolors = [3, 3], $
				/bottom, /right, charsize = 1.2, /clear, outline_color = 0

; Plot of residuals

	x = findgen(std_dev_171_quad*300.) / 10. - std_dev_171_quad*3.

; Calculate optimal binsize

	bin_size = (3.5 * std_dev_171_quad) / arr_171_quad^(0.3333)
	
	print, '171 Quadratic fit binsize = ', bin_size

	res_171_quad = histogram( residuals_171_quad, loc = loc, binsize = 5 )

	plot, loc, res_171_quad, psym = 10, color = 0, background = 1, yr = [0, max(res_171_quad) + 0.25*max(res_171_quad)], $
			xr = [-3.*std_dev_171_quad, 3.*std_dev_171_quad], /xs, /ys, xtitle = 'De-trended data values (Mm)', $
			ytitle = 'De-trended data probability', title = 'Normalised PDF of de-trended data, Bin-size = 5', $
			pos = [0.2, 0.1, 0.9, 0.45], charsize = 1

; Plot of Probability Distribution function with same mean and standard deviation as data

	gaussian = max( res_171_quad ) * exp(-(x - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, x, gaussian, color = 0

	gaussian_std_dev = max( res_171_quad ) * exp(-(std_dev_171_quad - mean_x_171_quad)^2./(2.*std_dev_171_quad^2.))

	oplot, [std_dev_171_quad, std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
	oplot, [-std_dev_171_quad, -std_dev_171_quad], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

	toggle

end