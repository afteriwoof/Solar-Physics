; Routine calculating the statistics for the different wave statistics routines.

pro stats_195_linear, grt_dist_195, dist_fit_195_lin_res, dist_arr_195, mean_x_195_lin, std_dev_195_lin, residuals_195_lin

; Statistics of linear fit to 195A data

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


end