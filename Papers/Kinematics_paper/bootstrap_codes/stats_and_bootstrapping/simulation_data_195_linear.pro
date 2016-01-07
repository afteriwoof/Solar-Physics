; Routine called by wave_statistics to produce plot of distance data with linear fit.


pro simulation_data_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, $
		std_dev_195_lin, mean_x_195_lin

	set_line_color

; Time calculations

	tim195 = time195 - time195[0]

; Plot 195A data

;	utplot, tim195, grt_dist_195, time195[0], title = '!6Actual Data - STEREO-A 195 !6!sA!r!u!9 %!6!n', $
;		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
;		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 2, /xs, /ys, $
;		color = 0, background = 1, thick = 2
	
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

;	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0
	
; Statistics of linear fit to 195A data

	residuals_195_lin = grt_dist_195 - dist_fit_195_lin_res
	
	print, 'De-trended data (195 Linear fit) = ', residuals_195_lin
	
	mean_x_195_lin = total(residuals_195_lin)/(dist_arr_195)
	
	print, 'Calculated mean value of de-trended data (195 Linear fit) = ', mean_x_195_lin
	
	mean_195_lin = mean(residuals_195_lin)

	print, 'IDL mean value of de-trended data (195 Linear fit) = ', mean_195_lin

; Built-in check for mean

	IF (mean_195_lin NE mean_x_195_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
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
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (stddev_195_lin EQ std_dev_195_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

;	uterrplot, tim195, grt_dist_195 + h_err_195_lin, grt_dist_195 - h_err_195_lin, color = 0

end