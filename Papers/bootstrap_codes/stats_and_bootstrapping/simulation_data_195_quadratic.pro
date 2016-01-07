; Routine called by wave_statistics to produce plot of distance data with quadratic fit.


pro simulation_data_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad, $
		std_dev_195_quad, mean_x_195_quad

	set_line_color

; Time calculations

	tim195 = time195 - time195[0]

; Plot 195A data

;	utplot, tim195, grt_dist_195, time195[0], title = '!6Actual Data - STEREO-A 195 !6!sA!r!u!9 %!6!n', $
;		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
;		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 2, /xs, /ys, $
;		color = 0, background = 1, thick = 2
	
; Constant a fit to data

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
	pi(2).limits(0) = -0.00015
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00015

    f_195_quad = mpfitexpr(quad_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_quad = f_195_quad[0] + f_195_quad[1]*xf + (1./2.)*f_195_quad[2]*xf^2.

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

;	oplot, xf, dist_fit_195_quad, linestyle = 0, thick = 2, color = 0
	
; Statistics of quadratic fit to 195A data

	residuals_195_quad = grt_dist_195 - dist_fit_195_quad_res
	
	print, 'De-trended data (195 quadratic fit) = ', residuals_195_quad
	
	mean_x_195_quad = total(residuals_195_quad)/(dist_arr_195)
	
	print, 'Calculated mean value of de-trended data (195 quadratic fit) = ', mean_x_195_quad
	
	mean_195_quad = mean(residuals_195_quad)

	print, 'IDL mean value of de-trended data (195 quadratic fit) = ', mean_195_quad

; Built-in check for mean

	IF (mean_195_quad NE mean_x_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (mean_195_quad EQ mean_x_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED MEAN AND IDL MEAN ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	var_195_quad = total((residuals_195_quad - mean_x_195_quad)^2.)/(dist_arr_195 - 1)

	print, 'Calculated variance of de-trended data (195 quadratic fit) = ', var_195_quad

	std_dev_195_quad = sqrt(var_195_quad)
	
	print, 'Standard deviation of de-trended data (195 quadratic fit) = ', std_dev_195_quad

	stddev_195_quad = stddev(residuals_195_quad)

	print, 'IDL standard deviation of de-trended data (195 quadratic fit) = ', stddev_195_quad

; Built-in check for mean

	IF (stddev_195_quad NE std_dev_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE NOT EQUIVALENT!' 
		print, 'STOPPING ROUTINE NOW!!!' 
		print, ' ' 
		stop 
	ENDIF
	
	IF (stddev_195_quad EQ std_dev_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF

	h_err_195_quad = replicate(std_dev_195_quad, dist_arr_195)

;	uterrplot, tim195, grt_dist_195 + h_err_195_quad, grt_dist_195 - h_err_195_quad, color = 0

end