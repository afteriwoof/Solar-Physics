; Routine called by wave_statistics to produce plot of distance data with linear fit.


pro simulation_data_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin, $
		std_dev_171_lin, mean_x_171_lin

	set_line_color

; Time calculations

	tim171 = time171 - time171[0]

; Plot 171A data

;	utplot, tim171, grt_dist_171, time171[0], title = '!6Actual Data - STEREO-A 171 !6!sA!r!u!9 %!6!n', $
;		timerange = [min(time171) - 120, max(time171) + 120], ytitle = '!6Distance (!6Mm)', $
;		yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 2, /xs, /ys, $
;		color = 0, background = 1, thick = 2
	
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

;	oplot, xf, dist_fit_171_lin, linestyle = 0, thick = 2, color = 0
	
; Statistics of linear fit to 171A data

	residuals_171_lin = grt_dist_171 - dist_fit_171_lin_res
	
	print, 'De-trended data (171 Linear fit) = ', residuals_171_lin
	
	mean_x_171_lin = total(residuals_171_lin)/(dist_arr_171)
	
	print, 'Calculated mean value of de-trended data (171 Linear fit) = ', mean_x_171_lin
	
	mean_171_lin = mean(residuals_171_lin)

	print, 'IDL mean value of de-trended data (171 Linear fit) = ', mean_171_lin

; Built-in check for mean

	IF (mean_171_lin NE mean_x_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (mean_171_lin EQ mean_x_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_171_lin = total((residuals_171_lin - mean_x_171_lin)^2.)/(dist_arr_171 - 1)

	print, 'Calculated variance of de-trended data (171 Linear fit) = ', var_171_lin

	std_dev_171_lin = sqrt(var_171_lin)
	
	print, 'Standard deviation of de-trended data (171 Linear fit) = ', std_dev_171_lin

	stddev_171_lin = stddev(residuals_171_lin)

	print, 'IDL standard deviation of de-trended data (171 Linear fit) = ', stddev_171_lin

; Built-in check for mean

	IF (stddev_171_lin NE std_dev_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (stddev_171_lin EQ std_dev_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	h_err_171_lin = replicate(std_dev_171_lin, dist_arr_171)

;	uterrplot, tim171, grt_dist_171 + h_err_171_lin, grt_dist_171 - h_err_171_lin, color = 0

end