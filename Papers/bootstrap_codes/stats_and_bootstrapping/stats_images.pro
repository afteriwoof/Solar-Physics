; Routine to produce postscript images of de-trended event data for different fits for report

pro stats_images, date

	toggle, /portrait, filename = 'stats_1.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

; Restore data

	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Errors for each event

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

	set_line_color

; Plot 195A data

	utplot, tim195, grt_dist_195, time195[0], title = '!6Distance-time plot, 195 !6!sA!r!u!9 %!6!n', $
		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 1, /xs, /ys, $
		color = 0, background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	
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

;	dist_fit_195_lin_upper = (f_195_lin[0] + perror[0]) + (f_195_lin[1] + perror[1])*xf
;	dist_fit_195_lin_lower = (f_195_lin[0] - perror[0]) + (f_195_lin[1] - perror[1])*xf

	dist_fit_195_lin_res = f_195_lin[0] + f_195_lin[1]*tim195

	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0

;	oplot, xf, dist_fit_195_lin_upper, linestyle = 0, thick = 2, color = 0
;	oplot, xf, dist_fit_195_lin_lower, linestyle = 0, thick = 2, color = 0

	legend, ['r!D0!N = ' + num2str(f_195_lin[0]) + ' Mm +/- ' + num2str(perror[0]), $
				'v!D0!N = ' + num2str(1000*f_195_lin[1]) + ' km/s +/- ' + num2str(1000*perror[1])], $
				textcolors = [3, 3], charsize = 1, /bottom, /right

; Calculate and print statistics for the fit and residuals

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

	stats_195_linear, grt_dist_195, dist_fit_195_lin_res, dist_arr_195, mean_x_195_lin, std_dev_195_lin, residuals_195_lin

	h_err_195_lin = replicate(std_dev_195_lin, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_lin, grt_dist_195 - h_err_195_lin, color = 0

	h_error_195 = h_err_195_lin

	print, std_dev_195_lin

	utplot, tim195, residuals_195_lin, time195[0], ytitle = 'Residuals (Mm)', $
		timerange = [min(time195) - 120, max(time195) + 120], color = 0, /xs, /ys, $
		yr = [-3*std_dev_195_lin, 3*std_dev_195_lin], psym = 2, charsize = 1, $
		background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.39, 0.95, 0.66]

	IF (h_error_195[0] LE 2.*std_dev_195_lin) THEN BEGIN
		oploterr, tim195, residuals_195_lin, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 120, max(tim195) + 120], [mean_x_195_lin,mean_x_195_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 120, max(tim195) + 120], [std_dev_195_lin, std_dev_195_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 120, max(tim195) + 120], [-std_dev_195_lin, -std_dev_195_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_lin), 'Standard Deviation = ' + num2str(std_dev_195_lin)], textcolors = [3, 3], $
				/top, charsize = 1, /clear, outline_color = 0, /bottom, /left

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim195))

	v_195_lin = 1000.*(f_195_lin[1])

	v_195_ideal_lin = replicate(v_195_lin, dist_arr_195)

	v_195_deriv_lin = deriv(tim195, grt_dist_195*1000.)
	deltav_195_deriv = derivsig(tim195, grt_dist_195*1000., 0.0, (std_dev_195_lin*1000.))

; Constant a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_lin, max(tim195))

	v_lin_fit_195 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_195_v_lin = mpfitexpr(v_lin_fit_195, tim195, v_195_deriv_lin, h_error, $
    		[v_195_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_195_v_lin, /quiet)

	v_195_fit_lin = replicate(f_195_v_lin[0], dist_arr_195)

; Plot of velocity

	utplot, tim195, v_195_deriv_lin, time195[0], timerange = [min(time195) - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, tim195, v_195_deriv_lin + deltav_195_deriv, v_195_deriv_lin - deltav_195_deriv, $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, [min(tim195) - 120, max(tim195) + 120], [f_195_v_lin[0],f_195_v_lin[0]], linestyle = 0, thick = 2, color = 3
	oplot, [min(tim195) - 120, max(tim195) + 120], [v_195_lin,v_195_lin], linestyle = 0, thick = 2, color = 0

	legend, ['Ideal: v(t) = ' + num2str(1000*f_195_lin[1]), 'Fit: v(t) = ' + num2str(f_195_v_lin[0])], $
				textcolors = [0, 3], /bottom, /left, charsize = 1, /clear, outline_color = 0

	toggle


	toggle, /portrait, filename = 'stats_2.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

; Restore data

	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Errors for each event

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

	set_line_color

; Plot 195A data

	utplot, tim195, grt_dist_195, time195[0], title = '!6Distance-time plot, 195 !6!sA!r!u!9 %!6!n', $
		timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 1, /xs, /ys, $
		color = 0, background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	
; Zero a fit to data

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

;	dist_fit_195_quad_upper = (f_195_quad[0] + perror[0]) + (f_195_quad[1] + perror[1])*xf + (1./2.)*(f_195_quad[2] + perror[2])*xf^2.
;	dist_fit_195_quad_lower = (f_195_quad[0] - perror[0]) + (f_195_quad[1] - perror[1])*xf + (1./2.)*(f_195_quad[2] - perror[2])*xf^2.

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

	oplot, xf, dist_fit_195_quad, linestyle = 0, thick = 2, color = 0

;	oplot, xf, dist_fit_195_quad_upper, linestyle = 0, thick = 2, color = 0
;	oplot, xf, dist_fit_195_quad_lower, linestyle = 0, thick = 2, color = 0

	legend, ['r!D0!N = ' + num2str(f_195_quad[0]) + ' Mm +/- ' + num2str(perror[0]), $
				'v!D0!N = ' + num2str(1000*f_195_quad[1]) + ' km/s +/- ' + num2str(1000*perror[1]), $
				'a!D0!N = ' + num2str(1e6*f_195_quad[2]) + ' m/s/s +/- ' + num2str(1e6*perror[2])], $
				textcolors = [3, 3, 3], charsize = 1, /bottom, /right

; Calculate and print statistics for the fit and residuals

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

	h_err_195_quad = replicate(std_dev_195_quad, dist_arr_195)

	uterrplot, tim195, grt_dist_195 + h_err_195_quad, grt_dist_195 - h_err_195_quad, color = 0

	h_error_195 = h_err_195_quad

	print, std_dev_195_quad

	utplot, tim195, residuals_195_quad, time195[0], ytitle = 'Residuals (Mm)', $
		timerange = [min(time195) - 120, max(time195) + 120], color = 0, /xs, /ys, $
		yr = [-3*std_dev_195_quad, 3*std_dev_195_quad], psym = 2, charsize = 1, $
		background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.39, 0.95, 0.66]

	IF (h_error_195[0] LE 2.*std_dev_195_quad) THEN BEGIN
		oploterr, tim195, residuals_195_quad, h_error_195, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim195) - 100, max(tim195) + 100], [mean_x_195_quad,mean_x_195_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim195) - 100, max(tim195) + 100], [std_dev_195_quad, std_dev_195_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim195) - 100, max(tim195) + 100], [-std_dev_195_quad, -std_dev_195_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_195_quad), 'Standard Deviation = ' + num2str(std_dev_195_quad)], textcolors = [3, 3], $
				/bottom, /left, charsize = 1, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim195))

	v_sim_195_quad = 1000.*(f_195_quad[1] + f_195_quad[2]*x)

	v_195_ideal_quad = v_sim_195_quad

	v_195_deriv_quad = deriv(tim195, grt_dist_195*1000.)
	deltav_195_deriv = derivsig(tim195, grt_dist_195*1000., 0.0, (std_dev_195_quad*1000.))

; Constant a fit to velocity data

	x = findgen( max(tim195) )

	h_error = replicate(std_dev_195_quad, max(tim195))

	v_quad_fit_195 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.25
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.25

    f_195_v_quad = mpfitexpr(v_quad_fit_195, tim195, v_195_deriv_quad, h_error, $
    		[v_195_ideal_quad[0], 0.05], perror=perror, parinfo = pi, bestnorm = bestnorm_195_v_quad, /quiet)

	v_195_fit_quad = f_195_v_quad[0] + f_195_v_quad[1]*x

; Plot of velocity

	utplot, tim195, v_195_deriv_quad, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, tim195, v_195_deriv_quad + deltav_195_deriv, v_195_deriv_quad - deltav_195_deriv, $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_195_ideal_quad, linestyle = 0, color = 0, thick = 2
	oplot, x, v_195_fit_quad, linestyle = 0, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000*f_195_quad[1]) + ' + ' + num2str(1000*f_195_quad[2]) + 't', $
				'Fit: v(t) = ' + num2str(f_195_v_quad[0]) + ' + ' + num2str(f_195_v_quad[1]) + 't'], $
				textcolors = [0, 3], /bottom, /left, charsize = 1, /clear, outline_color = 0

	toggle


	toggle, /portrait, filename = 'stats_3.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

; Restore data

	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Errors for each event

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

	set_line_color

; Plot 171A data

	utplot, tim171, grt_dist_171, time171[0], title = '!6Distance-time plot, 171 !6!sA!r!u!9 %!6!n', $
		timerange = [min(time171) - 120, max(time171) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 1, /xs, /ys, $
		color = 0, background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	
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

	oplot, xf, dist_fit_171_lin, linestyle = 0, thick = 2, color = 0

	legend, ['r!D0!N = ' + num2str(f_171_lin[0]) + ' Mm +/- ' + num2str(perror[0]), $
				'v!D0!N = ' + num2str(1000*f_171_lin[1]) + ' km/s +/- ' + num2str(1000*perror[1])], $
				textcolors = [3, 3], charsize = 1, /bottom, /right

; Calculate and print statistics for the fit and residuals

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

	stats_171_linear, grt_dist_171, dist_fit_171_lin_res, dist_arr_171, mean_x_171_lin, std_dev_171_lin, residuals_171_lin

	h_err_171_lin = replicate(std_dev_171_lin, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_lin, grt_dist_171 - h_err_171_lin, color = 0

	h_error_171 = h_err_171_lin

	print, std_dev_171_lin

	utplot, tim171, residuals_171_lin, time171[0], ytitle = 'Residuals (Mm)', $
		timerange = [min(time171) - 120, max(time171) + 120], color = 0, /xs, /ys, $
		yr = [-3*std_dev_171_lin, 3*std_dev_171_lin], psym = 2, charsize = 1, $
		background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.39, 0.95, 0.66]

	IF (h_error_171[0] LE 2.*std_dev_171_lin) THEN BEGIN
		oploterr, tim171, residuals_171_lin, h_error_171, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim171) - 120, max(tim171) + 120], [mean_x_171_lin,mean_x_171_lin], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim171) - 120, max(tim171) + 120], [std_dev_171_lin, std_dev_171_lin], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim171) - 120, max(tim171) + 120], [-std_dev_171_lin, -std_dev_171_lin], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_lin), 'Standard Deviation = ' + num2str(std_dev_171_lin)], textcolors = [3, 3], $
				/top, charsize = 1, /clear, outline_color = 0, /bottom, /left

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	v_171_lin = 1000.*(f_171_lin[1])

	v_171_ideal_lin = replicate(v_171_lin, dist_arr_171)

	v_171_deriv_lin = deriv(tim171, grt_dist_171*1000.)
	deltav_171_deriv = derivsig(tim171, grt_dist_171*1000., 0.0, (std_dev_171_lin*1000.))

; Constant a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_lin, max(tim171))

	v_lin_fit_171 = 'p[0]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},1)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500

    f_171_v_lin = mpfitexpr(v_lin_fit_171, tim171, v_171_deriv_lin, h_error, $
    		[v_171_ideal_lin[0]], perror=perror, parinfo = pi, bestnorm = bestnorm_171_v_lin, /quiet)

	v_171_fit_lin = replicate(f_171_v_lin[0], dist_arr_171)

; Plot of velocity

	utplot, tim171, v_171_deriv_lin, time171[0], timerange = [min(time171) - 120, max(time171) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_lin)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, tim171, v_171_deriv_lin + deltav_171_deriv, v_171_deriv_lin - deltav_171_deriv, $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, [min(tim171) - 120, max(tim171) + 120], [f_171_v_lin[0],f_171_v_lin[0]], linestyle = 0, thick = 2, color = 3
	oplot, [min(tim171) - 120, max(tim171) + 120], [v_171_lin,v_171_lin], linestyle = 0, thick = 2, color = 0

	legend, ['Ideal: v(t) = ' + num2str(1000*f_171_lin[1]), 'Fit: v(t) = ' + num2str(f_171_v_lin[0])], $
				textcolors = [0, 3], /bottom, /left, charsize = 1, /clear, outline_color = 0

	toggle


	toggle, /portrait, filename = 'stats_4.eps', xsize = 6, ysize = 6, /inches, /color, bits_per_pixel = 8
	
	!p.multi = [0, 1, 2]

; Restore data

	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; Errors for each event

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

	h_error_171 = replicate(h_err, dist_arr_171)
	h_error_171 = replicate(h_err, dist_arr_171)

	set_line_color

; Plot 171A data

	utplot, tim171, grt_dist_171, time171[0], title = '!6Distance-time plot, 171 !6!sA!r!u!9 %!6!n', $
		timerange = [min(time171) - 120, max(time171) + 120], ytitle = '!6Distance (!6Mm)', $
		yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 1, /xs, /ys, $
		color = 0, background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.68, 0.95, 0.94]
	
; Zero a fit to data

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

	oplot, xf, dist_fit_171_quad, linestyle = 0, thick = 2, color = 0

	legend, ['r!D0!N = ' + num2str(f_171_quad[0]) + ' Mm +/- ' + num2str(perror[0]), $
				'v!D0!N = ' + num2str(1000*f_171_quad[1]) + ' km/s +/- ' + num2str(1000*perror[1]), $
				'a!D0!N = ' + num2str(1e6*f_171_quad[2]) + ' m/s/s +/- ' + num2str(1e6*perror[2])], $
				textcolors = [3, 3, 3], charsize = 1, /bottom, /right

; Calculate and print statistics for the fit and residuals

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

	h_err_171_quad = replicate(std_dev_171_quad, dist_arr_171)

	uterrplot, tim171, grt_dist_171 + h_err_171_quad, grt_dist_171 - h_err_171_quad, color = 0

	h_error_171 = h_err_171_quad

	print, std_dev_171_quad

	utplot, tim171, residuals_171_quad, time171[0], ytitle = 'Residuals (Mm)', $
		timerange = [min(time171) - 120, max(time171) + 120], color = 0, /xs, /ys, $
		yr = [-3*std_dev_171_quad, 3*std_dev_171_quad], psym = 2, charsize = 1, $
		background = 1, thick = 2, xtitle = ' ', xtickname = [' ',' ',' ',' ',' ',' '], $
		pos = [0.15, 0.39, 0.95, 0.66]

	IF (h_error_171[0] LE 2.*std_dev_171_quad) THEN BEGIN
		oploterr, tim171, residuals_171_quad, h_error_171, errcolor = 0, /noconnect, /nohat
	ENDIF

	oplot, [min(tim171) - 100, max(tim171) + 100], [mean_x_171_quad,mean_x_171_quad], linestyle = 0, thick = 2, color = 0

	oplot, [min(tim171) - 100, max(tim171) + 100], [std_dev_171_quad, std_dev_171_quad], linestyle = 2, thick = 2, color = 0
	oplot, [min(tim171) - 100, max(tim171) + 100], [-std_dev_171_quad, -std_dev_171_quad], linestyle = 2, thick = 2, color = 0

	legend, ['Mean = ' + num2str(mean_x_171_quad), 'Standard Deviation = ' + num2str(std_dev_171_quad)], textcolors = [3, 3], $
				/bottom, /left, charsize = 1, /clear, outline_color = 0

; Use fit parameters as basis for ideal velocity

	x = findgen(max(tim171))

	v_sim_171_quad = 1000.*(f_171_quad[1] + f_171_quad[2]*x)

	v_171_ideal_quad = v_sim_171_quad

	v_171_deriv_quad = deriv(tim171, grt_dist_171*1000.)
	deltav_171_deriv = derivsig(tim171, grt_dist_171*1000., 0.0, (std_dev_171_quad*1000.))

; Constant a fit to velocity data

	x = findgen( max(tim171) )

	h_error = replicate(std_dev_171_quad, max(tim171))

	v_quad_fit_171 = 'p[0] + p[1]*x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 10
	pi(0).limited(1) = 1
	pi(0).limits(1) = 500
	pi(1).limited(0) = 1
	pi(1).limits(0) = -0.25
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.25

    f_171_v_quad = mpfitexpr(v_quad_fit_171, tim171, v_171_deriv_quad, h_error, $
    		[v_171_ideal_quad[0], 0.05], perror=perror, parinfo = pi, bestnorm = bestnorm_171_v_quad, /quiet)

	v_171_fit_quad = f_171_v_quad[0] + f_171_v_quad[1]*x

; Plot of velocity

	utplot, tim171, v_171_deriv_quad, time171[0], timerange = [time171[0] - 120, max(time171) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171_deriv_quad)+100], $
		background = 1, color = 0, psym = 2, charsize = 1, /xs, /ys, thick = 2, $
		pos = [0.15, 0.1, 0.95, 0.37]
	uterrplot, tim171, v_171_deriv_quad + deltav_171_deriv, v_171_deriv_quad - deltav_171_deriv, $
		thick = 2, color = 0

; Over-plot the ideal velocity line

	oplot, x, v_171_ideal_quad, linestyle = 0, color = 0, thick = 2
	oplot, x, v_171_fit_quad, linestyle = 0, color = 3, thick = 2

	legend, ['Ideal: v(t) = ' + num2str(1000*f_171_quad[1]) + ' + ' + num2str(1000*f_171_quad[2]) + 't', $
				'Fit: v(t) = ' + num2str(f_171_v_quad[0]) + ' + ' + num2str(f_171_v_quad[1]) + 't'], $
				textcolors = [0, 3], /bottom, /left, charsize = 1, /clear, outline_color = 0

	toggle


end