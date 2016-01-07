; Routine to compare the different numerical differentiation techniques.


pro num_diff_compare, date, cadence

	!p.multi = [0, 1, 3]
	window, 0, xs = 1100, ys = 1000

	set_line_color

; Restore data

	IF (date EQ '20070806') THEN BEGIN	
		restore, num2str(date) + '_' + num2str(event) + '_dist.sav'
	ENDIF ELSE BEGIN
		restore, num2str(date) + '_dist.sav' 
	ENDELSE	
	
	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Initial estimated errors for each event

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

;******************************************
; Calculation of relevant statistical info
;******************************************

	resolve_routine, 'simulation_data_195_linear'

	simulation_data_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, $
		std_dev_195_lin, mean_x_195_lin

	resolve_routine, 'simulation_data_195_quadratic'

	simulation_data_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad, $
		std_dev_195_quad, mean_x_195_quad
	
	resolve_routine, 'simulation_data_171_linear'

	simulation_data_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin, $
		std_dev_171_lin, mean_x_171_lin
	
	resolve_routine, 'simulation_data_171_quadratic'

	simulation_data_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad, $
		std_dev_171_quad, mean_x_171_quad
	
;***************************************
; Numerical differentiation using DERIV
;***************************************

	print, ' ' 
	print, '*************************************** ' 
	print, ' ' 
	print, 'Numerical differentiation using DERIV' 
	print, ' ' 
	print, '*************************************** ' 
	print, ' ' 

; 195A linear fit

	resolve_routine, 'simulation_195_linear'

	simulation_195_linear, date, time195, f_195_lin, cadence, std_dev_195_lin, mean_x_195_lin

	ans = ' '
	read, 'OK?', ans

; 195A quadratic fit

	resolve_routine, 'simulation_195_quadratic'

	simulation_195_quadratic, date, time195, f_195_quad, cadence, std_dev_195_quad, mean_x_195_quad

	ans = ' '
	read, 'OK?', ans

; 171A linear fit

	resolve_routine, 'simulation_171_linear'

	simulation_171_linear, date, time171, f_171_lin, cadence, std_dev_171_lin, mean_x_171_lin

	ans = ' '
	read, 'OK?', ans

; 171A quadratic fit

	resolve_routine, 'simulation_171_quadratic'

	simulation_171_quadratic, date, time171, f_171_quad, cadence, std_dev_171_quad, mean_x_171_quad

	ans = ' '
	read, 'OK?', ans
;stop
;**********************************************
; Numerical differentiation using Forward diff
;**********************************************

	print, ' ' 
	print, '******************************************************** ' 
	print, ' ' 
	print, 'Numerical differentiation using Forward Differentiation' 
	print, ' ' 
	print, '******************************************************** ' 
	print, ' ' 

; 195A linear fit

	resolve_routine, 'f_diff_simulation_195_linear'

	f_diff_simulation_195_linear, date, time195, f_195_lin, cadence, std_dev_195_lin, mean_x_195_lin, errors_195_f_lin

	x2png, 'f_diff_195_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 195A quadratic fit

	resolve_routine, 'f_diff_simulation_195_quadratic'

	f_diff_simulation_195_quadratic, date, time195, f_195_quad, cadence, std_dev_195_quad, mean_x_195_quad, errors_195_f_quad

	x2png, 'f_diff_195_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A linear fit

	resolve_routine, 'f_diff_simulation_171_linear'

	f_diff_simulation_171_linear, date, time171, f_171_lin, cadence, std_dev_171_lin, mean_x_171_lin, errors_171_f_lin

	x2png, 'f_diff_171_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A quadratic fit

	resolve_routine, 'f_diff_simulation_171_quadratic'

	f_diff_simulation_171_quadratic, date, time171, f_171_quad, cadence, std_dev_171_quad, mean_x_171_quad, errors_171_f_quad

	x2png, 'f_diff_171_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

;**********************************************
; Numerical differentiation using Reverse diff
;**********************************************

	print, ' ' 
	print, '******************************************************** ' 
	print, ' ' 
	print, 'Numerical differentiation using Reverse Differentiation' 
	print, ' ' 
	print, '******************************************************** ' 
	print, ' ' 

; 195A linear fit

	resolve_routine, 'r_diff_simulation_195_linear'

	r_diff_simulation_195_linear, date, time195, f_195_lin, cadence, std_dev_195_lin, mean_x_195_lin, errors_195_r_lin

	x2png, 'r_diff_195_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 195A quadratic fit

	resolve_routine, 'r_diff_simulation_195_quadratic'

	r_diff_simulation_195_quadratic, date, time195, f_195_quad, cadence, std_dev_195_quad, mean_x_195_quad, errors_195_r_quad

	x2png, 'r_diff_195_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A linear fit

	resolve_routine, 'r_diff_simulation_171_linear'

	r_diff_simulation_171_linear, date, time171, f_171_lin, cadence, std_dev_171_lin, mean_x_171_lin, errors_171_r_lin

	x2png, 'r_diff_171_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A quadratic fit

	resolve_routine, 'r_diff_simulation_171_quadratic'

	r_diff_simulation_171_quadratic, date, time171, f_171_quad, cadence, std_dev_171_quad, mean_x_171_quad, errors_171_r_quad

	x2png, 'r_diff_171_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

;*********************************************
; Numerical differentiation using Centre diff
;*********************************************

	print, ' ' 
	print, '******************************************************* ' 
	print, ' ' 
	print, 'Numerical differentiation using Centre Differentiation' 
	print, ' ' 
	print, '******************************************************* ' 
	print, ' ' 

; 195A linear fit

	resolve_routine, 'c_diff_simulation_195_linear'

	c_diff_simulation_195_linear, date, time195, f_195_lin, cadence, std_dev_195_lin, mean_x_195_lin, errors_195_c_lin

	x2png, 'c_diff_195_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 195A quadratic fit

	resolve_routine, 'c_diff_simulation_195_quadratic'

	c_diff_simulation_195_quadratic, date, time195, f_195_quad, cadence, std_dev_195_quad, mean_x_195_quad, errors_195_c_quad

	x2png, 'c_diff_195_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A linear fit

	resolve_routine, 'c_diff_simulation_171_linear'

	c_diff_simulation_171_linear, date, time171, f_171_lin, cadence, std_dev_171_lin, mean_x_171_lin, errors_171_c_lin

	x2png, 'c_diff_171_lin_sim.png'
	
	ans = ' '
	read, 'OK?', ans

; 171A quadratic fit

	resolve_routine, 'c_diff_simulation_171_quadratic'

	c_diff_simulation_171_quadratic, date, time171, f_171_quad, cadence, std_dev_171_quad, mean_x_171_quad, errors_171_c_quad

	x2png, 'c_diff_171_quad_sim.png'
	
	ans = ' '
	read, 'OK?', ans

	print, 'Forward Difference Errors = ', errors_195_f_lin, errors_195_f_quad, errors_171_f_lin, errors_171_f_quad
	print, ' '
	print, 'Reverse Difference Errors = ', errors_195_r_lin, errors_195_r_quad, errors_171_r_lin, errors_171_r_quad
	print, ' '
	print, 'Centre Difference Errors = ', errors_195_c_lin, errors_195_c_quad, errors_171_c_lin, errors_171_c_quad
	print, ' '

end
