; Routine calculating the statistics for the different wave statistics routines.

pro stats_195_quadratic, grt_dist_195, dist_fit_195_quad_res, dist_arr_195, mean_x_195_quad, std_dev_195_quad, residuals_195_quad

; Statistics of quadratic fit to 195A data

	residuals_195_quad = grt_dist_195 - dist_fit_195_quad_res
	
	print, 'De-trended data (195 Quadratic fit) = ', residuals_195_quad
	
	mean_x_195_quad = total(residuals_195_quad)/(dist_arr_195)
	
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

	var_195_quad = total((residuals_195_quad - mean_x_195_quad)^2.)/(dist_arr_195 - 1)

	print, 'Calculated variance of de-trended data (195 Quadratic fit) = ', var_195_quad

	std_dev_195_quad = sqrt(var_195_quad)
	
	print, 'Standard deviation of de-trended data (195 Quadratic fit) = ', std_dev_195_quad

	stddev_195_quad = stddev(residuals_195_quad)

	print, 'IDL standard deviation of de-trended data (195 Quadratic fit) = ', stddev_195_quad

; Built-in check for mean

	IF (stddev_195_quad NE std_dev_195_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_195_quad EQ std_dev_195_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF


end