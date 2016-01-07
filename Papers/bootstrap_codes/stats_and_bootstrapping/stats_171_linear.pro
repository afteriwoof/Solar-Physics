; Routine calculating the statistics for the different wave statistics routines.

pro stats_171_linear, grt_dist_171, dist_fit_171_lin_res, dist_arr_171, mean_x_171_lin, std_dev_171_lin, residuals_171_lin

; Statistics of linear fit to 171A data

	residuals_171_lin = grt_dist_171 - dist_fit_171_lin_res
	
	print, 'De-trended data (171 Linear fit) = ', residuals_171_lin
	
	mean_x_171_lin = total(residuals_171_lin)/(dist_arr_171)
	
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

	var_171_lin = total((residuals_171_lin - mean_x_171_lin)^2.)/(dist_arr_171 - 1)

	print, 'Calculated variance of de-trended data (171 Linear fit) = ', var_171_lin

	std_dev_171_lin = sqrt(var_171_lin)
	
	print, 'Standard deviation of de-trended data (171 Linear fit) = ', std_dev_171_lin

	stddev_171_lin = stddev(residuals_171_lin)

	print, 'IDL standard deviation of de-trended data (171 Linear fit) = ', stddev_171_lin

; Built-in check for mean

	IF (stddev_171_lin NE std_dev_171_lin) THEN BEGIN 
		stop 
	ENDIF
	
	IF (stddev_171_lin EQ std_dev_171_lin) THEN BEGIN 
		print, ' ' 
		print, 'CALCULATED STANDARD DEVIATION AND IDL STANDARD DEVIATION ARE EQUIVALENT' 
		print, ' ' 
	ENDIF


end