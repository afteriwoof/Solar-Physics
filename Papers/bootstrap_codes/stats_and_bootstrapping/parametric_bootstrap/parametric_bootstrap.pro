; Routine to test the parametric bootstrap method for analysis of the fit parameters for each
; fit to the given data points.

pro parametric_bootstrap, date, event

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

	window, 0, xs = 1000, ys = 1000
	
	!p.multi = [0, 1, 3]

; Fitted equation that we wish to test.

	resolve_routine, 'data_fit_195_linear'

	data_fit_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, perror, /plot_on

; Plot trend line and standard deviation margin

	xf = findgen( max(tim195) )

	dist_fit_195_lin = f_195_lin[0] + f_195_lin[1]*xf

	oplot, xf, dist_fit_195_lin, linestyle = 0, thick = 2, color = 0
	
	legend, ['R0 = ' + num2str(f_195_lin[0]) + ' +/- ' + num2str(perror[0]) + ' Mm', $
			'V0 = ' + num2str(1000*f_195_lin[1]) + ' +/- ' + num2str(1000*perror[1]) + ' km/s'], $
			textcolor = [3, 3], /clear, /bottom, /right, charsize = 1.5, outline_color = 0

;************************************
; Bootstrapping - Distance Parameter
;************************************

; Number of iterations	

	num_iter = 100000
	
; Create array to store data points

	mean_dist_arr = dblarr(num_iter)

; Loop over 50,000 iterations to bootstrap

	for i = 0L, num_iter-1 do begin

; Randomly choose n data points from Gaussian distribution with same mean and standard deviation 
; of fit to original data

		dist_arr = RANDOMN( Seed1, dist_arr_195, /DOUBLE, /NORMAL )*perror[0] + f_195_lin[0]

; Find mean of new data points

		mean_dist_arr[i] = mean(dist_arr)
		
	endfor

; Plot histogram of mean distance parameter values

	dist_hist = histogram( mean_dist_arr, loc = loc_d, binsize = 1 )
	
	arr_info_dist = moment(mean_dist_arr, sdev=sd)

	plot, loc_d, dist_hist, psym = 0, yr = [0, 1.25*max(dist_hist)], $
			xr = [arr_info_dist[0] - 3.*sd, arr_info_dist[0] + 3.*sd], /xs, /ys, color = 0, $
			background = 1, xtitle = 'Distance parameter values', charsize = 2, $
			ytitle = 'Probability', thick = 2, $
			title = 'Bootstrapping analysis of 195A data R!D0!N fit parameter, ' + num2str(date)

	legend, ['R0 = ' + num2str(arr_info_dist[0]) + ' +/- ' + num2str(sd) + ' Mm'], $
		textcolor = [3], /clear, /top, /right, charsize = 1.5, outline_color = 0

;************************************
; Bootstrapping - Velocity Parameter
;************************************

; Create array to store data points

	mean_vel_arr = dblarr(num_iter)

; Loop over 50,000 iterations to bootstrap

	for i = 0L, num_iter-1 do begin

; Randomly choose n data points from Gaussian distribution with same mean and standard deviation 
; of fit to original data

		vel_arr = RANDOMN( Seed2, dist_arr_195, /DOUBLE, /NORMAL )*perror[1] + f_195_lin[1]

; Find mean of new data points

		mean_vel_arr[i] = mean(vel_arr)
		
	endfor

; Plot histogram of mean distance parameter values

	vel_hist = histogram( mean_vel_arr, loc = loc_v, binsize = 0.001 )
	
	arr_info_vel = moment(mean_vel_arr, sdev=sv)

	plot, loc_v, vel_hist, psym = 0, yr = [0, 1.25*max(vel_hist)], $
			xr = [arr_info_vel[0] - 3.*sv, arr_info_vel[0] + 3.*sv], /xs, /ys, color = 0, $
			background = 1, xtitle = 'Velocity parameter values', charsize = 2, $
			ytitle = 'Probability', thick = 2, $
			title = 'Bootstrapping analysis of 195A data V!D0!N fit parameter, ' + num2str(date)

	legend, ['V0 = ' + num2str(1000*arr_info_vel[0]) + ' +/- ' + num2str(1000*sv) + ' km/s'], $
		textcolor = [3], /clear, /top, /right, charsize = 1.5, outline_color = 0

; Copy Graphs

	x2png, 'Bootstrap_plot_' + num2str(date) + '.png'

; Associated Statistics

	openw, lun, /get_lun, 'bootstrap_info_' + num2str(date) + '.txt', error=err
	free_lun, lun

	openu, lun, 'bootstrap_info_' + num2str(date) + '.txt', /append
	Printf, lun,  'Standard fit equation: y = ' + num2str(f_195_lin[1]) + '*x + ' + $
			num2str(f_195_lin[0])
	Printf, lun,  ' '
	Printf, lun,  'Standard fitting  R0 = ' + num2str(f_195_lin[0]) + ' err = ' + num2str(perror[0])
	Printf, lun,  'Standard fitting  V0 = ' + num2str(f_195_lin[1]) + ' err = ' + num2str(perror[1])
	Printf, lun,  ' '
	Printf, lun,  'Boot strapping  R0 = ' + num2str(arr_info_dist[0]) + ' err = ' + num2str(sd)
	Printf, lun,  'Boot strapping  V0 = ' + num2str(arr_info_vel[0]) + ' err = ' + num2str(sv)
	Printf, lun,  ' '
	Printf, lun,  '2 sigma (95%) Confidence Range = '
	Printf, lun,  'R0 = [ ' + num2str(arr_info_dist[0] - 2.0*sd) + ', ' + $
			num2str(arr_info_dist[0] + 2.0*sd) + ']'
	Printf, lun,  'V0 = [ ' + num2str(arr_info_vel[0] - 2.0*sv) + ', ' + $
			num2str(arr_info_vel[0] + 2.0*sv) + ']'
	free_lun, lun

end