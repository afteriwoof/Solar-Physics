; Routine called by wave_statistics to produce plot of distance data with quadratic fit.


pro simulation_data_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad, $
		std_dev_171_quad, mean_x_171_quad

	set_line_color

; Time calculations

	tim171 = time171 - time171[0]

; Plot 171A data

;	utplot, tim171, grt_dist_171, time171[0], title = '!6Actual Data - STEREO-A 171 !6!sA!r!u!9 %!6!n', $
;		timerange = [min(time171) - 120, max(time171) + 120], ytitle = '!6Distance (!6Mm)', $
;		yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 2, /xs, /ys, $
;		color = 0, background = 1, thick = 2
	
; Constant a fit to data

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
	pi(2).limits(0) = -0.00015
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00015

    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)

; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_quad = f_171_quad[0] + f_171_quad[1]*xf + (1./2.)*f_171_quad[2]*xf^2.

	dist_fit_171_quad_res = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

;	oplot, xf, dist_fit_171_quad, linestyle = 0, thick = 2, color = 0
	
; Statistics of quadratic fit to 171A data

	residuals_171_quad = grt_dist_171 - dist_fit_171_quad_res
	
	print, 'De-trended data (171 quadratic fit) = ', residuals_171_quad
	
	mean_x_171_quad = total(residuals_171_quad)/(dist_arr_171)
	
	print, 'Calculated mean value of de-trended data (171 quadratic fit) = ', mean_x_171_quad
	
	mean_171_quad = mean(residuals_171_quad)

	print, 'IDL mean value of de-trended data (171 quadratic fit) = ', mean_171_quad

; Built-in check for mean

	IF (mean_171_quad NE mean_x_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (mean_171_quad EQ mean_x_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_171_quad = total((residuals_171_quad - mean_x_171_quad)^2.)/(dist_arr_171 - 1)

	print, 'Calculated variance of de-trended data (171 quadratic fit) = ', var_171_quad

	std_dev_171_quad = sqrt(var_171_quad)
	
	print, 'Standard deviation of de-trended data (171 quadratic fit) = ', std_dev_171_quad

	stddev_171_quad = stddev(residuals_171_quad)

	print, 'IDL standard deviation of de-trended data (171 quadratic fit) = ', stddev_171_quad

; Built-in check for mean

	IF (stddev_171_quad NE std_dev_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (stddev_171_quad EQ std_dev_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	h_err_171_quad = replicate(std_dev_171_quad, dist_arr_171)

;	uterrplot, tim171, grt_dist_171 + h_err_171_quad, grt_dist_171 - h_err_171_quad, color = 0

end