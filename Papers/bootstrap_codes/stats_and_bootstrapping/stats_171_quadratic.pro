; Routine calculating the statistics for the different wave statistics routines.

pro stats_171_quadratic, grt_dist_171, dist_fit_171_quad_res, dist_arr_171, mean_x_171_quad, std_dev_171_quad, residuals_171_quad

; Statistics of quadratic fit to 171A data

	residuals_171_quad = grt_dist_171 - dist_fit_171_quad_res
	
	print, 'De-trended data (171 Quadratic fit) = ', residuals_171_quad
	
	mean_x_171_quad = total(residuals_171_quad)/(dist_arr_171)
	
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

	var_171_quad = total((residuals_171_quad - mean_x_171_quad)^2.)/(dist_arr_171 - 1)

	print, 'Calculated variance of de-trended data (171 Quadratic fit) = ', var_171_quad

	std_dev_171_quad = sqrt(var_171_quad)
	
	print, 'Standard deviation of de-trended data (171 Quadratic fit) = ', std_dev_171_quad

	stddev_171_quad = stddev(residuals_171_quad)

	print, 'IDL standard deviation of de-trended data (171 Quadratic fit) = ', stddev_171_quad

; Built-in check for mean

	IF (stddev_171_quad NE std_dev_171_quad) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_171_quad EQ std_dev_171_quad) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF


end