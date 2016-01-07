; Routine to examine the statistics of different events and use them to look at the velocities involved

pro wave_stats_velocity, date, event

	!p.multi = [0, 3, 2]
	window, 0, xs = 1500, ys = 1000

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

; 195A Linear fit

	resolve_routine, 'data_fit_195_linear'

	data_fit_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_lin = f_195_lin[0] + f_195_lin[1]*xf

	dist_fit_195_lin_res = f_195_lin[0] + f_195_lin[1]*tim195

	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0
	
; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_195_linear'

	stats_195_linear, grt_dist_195, dist_fit_195_lin_res, dist_arr_195, mean_x_195_lin, std_dev_195_lin, residuals_195_lin

	std_dev_195_lin = std_dev_195_lin

	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_lin, grt_dist_195 - h_err_195_lin, color = 0

; Calculate velocity
	
	resolve_routine, 'velocity_195_linear'
	
	velocity_195_linear, date, time195, grt_dist_195, f_195_lin, std_dev_195_lin, dist_arr_195, $
			residuals_195_lin, mean_x_195_lin

; 195A Quadratic fit

	resolve_routine, 'data_fit_195_quadratic'

	data_fit_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_quad = f_195_quad[0] + f_195_quad[1]*xf + (1./2.)*f_195_quad[2]*xf^2.

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

	oplot, xf, dist_fit_195_quad, linestyle = 0, thick = 2, color = 0
	
; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_195_quadratic'

	stats_195_quadratic, grt_dist_195, dist_fit_195_quad_res, dist_arr_195, mean_x_195_quad, std_dev_195_quad, residuals_195_quad

	std_dev_195_quad = std_dev_195_quad

	h_err_195_quad = replicate(std_dev_195_quad, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_quad, grt_dist_195 - h_err_195_quad, color = 0

; Calculate velocity
	
	resolve_routine, 'velocity_195_quadratic'
	
	velocity_195_quadratic, date, time195, grt_dist_195, f_195_quad, std_dev_195_quad, dist_arr_195, $
			residuals_195_quad, mean_x_195_quad

	x2png, 'wave_vel_stats_195_' + num2str(date) + '.png'

	ans = ' '
	read, 'OK?', ans
	
; 171A Linear fit

	resolve_routine, 'data_fit_171_linear'

	data_fit_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin

; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_lin = f_171_lin[0] + f_171_lin[1]*xf

	dist_fit_171_lin_res = f_171_lin[0] + f_171_lin[1]*tim171

	oplot, xf, dist_fit_171_lin, linestyle = 0, thick = 2, color = 0
	
; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_171_linear'

	stats_171_linear, grt_dist_171, dist_fit_171_lin_res, dist_arr_171, mean_x_171_lin, std_dev_171_lin, residuals_171_lin

	std_dev_171_lin = std_dev_171_lin

	h_err_171_lin = replicate(std_dev_171_lin, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_lin, grt_dist_171 - h_err_171_lin, color = 0

; Calculate velocity
	
	resolve_routine, 'velocity_171_linear'
	
	velocity_171_linear, date, time171, grt_dist_171, f_171_lin, std_dev_171_lin, dist_arr_171, $
			residuals_171_lin, mean_x_171_lin

; 171A Quadratic fit

	resolve_routine, 'data_fit_171_quadratic'

	data_fit_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad

; Plot trend line and standard deviation margin

	xf = findgen( max(tim171) )

	dist_fit_171_quad = f_171_quad[0] + f_171_quad[1]*xf + (1./2.)*f_171_quad[2]*xf^2.

	dist_fit_171_quad_res = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

	oplot, xf, dist_fit_171_quad, linestyle = 0, thick = 2, color = 0
	
; Calculate and print statistics for the fit and residuals
	
	resolve_routine, 'stats_171_quadratic'

	stats_171_quadratic, grt_dist_171, dist_fit_171_quad_res, dist_arr_171, mean_x_171_quad, std_dev_171_quad, residuals_171_quad

	std_dev_171_quad = std_dev_171_quad

	h_err_171_quad = replicate(std_dev_171_quad, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_quad, grt_dist_171 - h_err_171_quad, color = 0

; Calculate velocity
	
	resolve_routine, 'velocity_171_quadratic'
	
	velocity_171_quadratic, date, time171, grt_dist_171, f_171_quad, std_dev_171_quad, dist_arr_171, $
			residuals_171_quad, mean_x_171_quad

	x2png, 'wave_vel_stats_171_' + num2str(date) + '.png'

stop
	











end