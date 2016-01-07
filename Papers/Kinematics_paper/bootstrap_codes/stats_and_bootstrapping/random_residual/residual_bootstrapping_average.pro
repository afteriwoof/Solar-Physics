; Routine that calls all bootstrapping routines and produces the estimated Confidence Intervals.
; Comparable to residual_bootstrapping but adapted to calculate kinematics using great-distances
; averaged over arc rather than along individual lines.

pro residual_bootstrapping_average, date, event_num, plot_on = plot_on

	ans = ' '
	
; Restore data

	if (date EQ '20070519') THEN BEGIN
		amount = 5
		for i = 0, 5 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor
	
		grt_dist_195 = fltarr(4)
		grt_dist_171 = fltarr(6)
	
		for i = 0, 3 do begin
			x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
				grt_dist_195_4[i], grt_dist_195_5[i]]

			grt_dist_195[i] = mean(x_195)
		endfor
		
		for i = 0, 5 do begin
			x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
				grt_dist_171_4[i], grt_dist_171_5[i]]

			grt_dist_171[i] = mean(x_171)
		endfor

	endif

	if (date EQ '20071207') THEN BEGIN
		amount = 20
		for i = 0, 20 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(5)
		grt_dist_171 = fltarr(8)

		for i = 0, 4 do begin
			x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
				grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i], $
				grt_dist_195_8[i], grt_dist_195_9[i], grt_dist_195_10[i], grt_dist_195_11[i], $
				grt_dist_195_12[i], grt_dist_195_13[i], grt_dist_195_14[i], grt_dist_195_15[i], $
				grt_dist_195_16[i], grt_dist_195_17[i], grt_dist_195_18[i], grt_dist_195_19[i], $
				grt_dist_195_20[i]]

			grt_dist_195[i] = mean(x_195)
		endfor
		
		for i = 0, 7 do begin
			x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
				grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i], $
				grt_dist_171_8[i], grt_dist_171_9[i], grt_dist_171_10[i], grt_dist_171_11[i], $
				grt_dist_171_12[i], grt_dist_171_13[i], grt_dist_171_14[i], grt_dist_171_15[i], $
				grt_dist_171_16[i], grt_dist_171_17[i], grt_dist_171_18[i], grt_dist_171_19[i], $
				grt_dist_171_20[i]]

			grt_dist_171[i] = mean(x_171)
		endfor

	endif

	if (date EQ '20080107') THEN BEGIN
		amount = 36
		for i = 0, 36 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(4)
		grt_dist_171 = fltarr(9)

		for i = 0, 3 do begin
			x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
				grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i], $
				grt_dist_195_8[i], grt_dist_195_9[i], grt_dist_195_10[i], grt_dist_195_11[i], $
				grt_dist_195_12[i], grt_dist_195_13[i], grt_dist_195_14[i], grt_dist_195_15[i], $
				grt_dist_195_16[i], grt_dist_195_17[i], grt_dist_195_18[i], grt_dist_195_19[i], $
				grt_dist_195_20[i], grt_dist_195_21[i], grt_dist_195_22[i], grt_dist_195_23[i], $
				grt_dist_195_24[i], grt_dist_195_25[i], grt_dist_195_26[i], grt_dist_195_27[i], $
				grt_dist_195_28[i], grt_dist_195_29[i], grt_dist_195_30[i], grt_dist_195_31[i], $
				grt_dist_195_32[i], grt_dist_195_33[i], grt_dist_195_34[i], grt_dist_195_35[i], $
				grt_dist_195_36[i]]

			grt_dist_195[i] = mean(x_195)
		endfor
		
		for i = 0, 8 do begin
			x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
				grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i], $
				grt_dist_171_8[i], grt_dist_171_9[i], grt_dist_171_10[i], grt_dist_171_11[i], $
				grt_dist_171_12[i], grt_dist_171_13[i], grt_dist_171_14[i], grt_dist_171_15[i], $
				grt_dist_171_16[i], grt_dist_171_17[i], grt_dist_171_18[i], grt_dist_171_19[i], $
				grt_dist_171_20[i], grt_dist_171_21[i], grt_dist_171_22[i], grt_dist_171_23[i], $
				grt_dist_171_24[i], grt_dist_171_25[i], grt_dist_171_26[i], grt_dist_171_27[i], $
				grt_dist_171_28[i], grt_dist_171_29[i], grt_dist_171_30[i], grt_dist_171_31[i], $
				grt_dist_171_32[i], grt_dist_171_33[i], grt_dist_171_34[i], grt_dist_171_35[i], $
				grt_dist_171_36[i]]

			grt_dist_171[i] = mean(x_171)
		endfor

	endif

	if (date EQ '20080426') THEN BEGIN
		amount = 9
		for i = 0, 9 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(5)
		grt_dist_171 = fltarr(6)

		for i = 0, 4 do begin
			x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
				grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i], $
				grt_dist_195_8[i], grt_dist_195_9[i]]

			grt_dist_195[i] = mean(x_195)
		endfor
		
		for i = 0, 5 do begin
			x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
				grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i], $
				grt_dist_171_8[i], grt_dist_171_9[i]]

			grt_dist_171[i] = mean(x_171)
		endfor

	endif

	if (date EQ '20090212') THEN BEGIN
		amount = 7
		for i = 0, 7 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(4)
		grt_dist_171 = fltarr(8)

		for i = 0, 3 do begin
			x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
				grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i]]

			grt_dist_195[i] = mean(x_195)
		endfor
		
		for i = 0, 7 do begin
			x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
				grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i]]

			grt_dist_171[i] = mean(x_171)
		endfor

	endif

	if (date EQ '20090213') THEN BEGIN
		restore, num2str(date) + '_dist.sav'

		gdist_195 = fltarr(5)
		gdist_171 = fltarr(6)

		for i = 0, 4 do begin
			gdist_195[i] = mean(grt_dist_195[i,*])
		endfor
		
		for i = 0, 5 do begin
			gdist_171[i] = mean(grt_dist_171_300[i,*])
		endfor

		grt_dist_195 = gdist_195
		grt_dist_171 = gdist_171
		
		time171 = t171_300
		time195 = t195
stop
	endif

	if (date EQ '20070806') THEN BEGIN
		if (event_num EQ '1') THEN BEGIN
			amount = 10
			for i = 0, 10 do begin
				restore, num2str(date) + '_' + num2str(event) + '_dist_' + num2str(i) + '.sav'
			endfor

			grt_dist_195 = fltarr(4)
			grt_dist_171 = fltarr(6)

			for i = 0, 3 do begin
				x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
					grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i], $
					grt_dist_195_8[i], grt_dist_195_9[i], grt_dist_195_10[i]]

				grt_dist_195[i] = mean(x_195)
			endfor
		
			for i = 0, 5 do begin
				x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
					grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i], $
					grt_dist_171_8[i], grt_dist_171_9[i], grt_dist_171_10[i]]

				grt_dist_171[i] = mean(x_171)
			endfor
		endif

		if (event_num EQ '2') THEN BEGIN
			amount = 11
			for i = 0, 11 do begin
				restore, num2str(date) + '_' + num2str(event_num) + '_dist_' + num2str(i) + '.sav'
			endfor

			grt_dist_195 = fltarr(4)
			grt_dist_171 = fltarr(4)

			for i = 0, 3 do begin
				x_195 = [grt_dist_195_0[i], grt_dist_195_1[i], grt_dist_195_2[i], grt_dist_195_3[i], $
					grt_dist_195_4[i], grt_dist_195_5[i], grt_dist_195_6[i], grt_dist_195_7[i], $
					grt_dist_195_8[i], grt_dist_195_9[i], grt_dist_195_10[i]]

				grt_dist_195[i] = mean(x_195)
			endfor
		
			for i = 0, 3 do begin
				x_171 = [grt_dist_171_0[i], grt_dist_171_1[i], grt_dist_171_2[i], grt_dist_171_3[i], $
					grt_dist_171_4[i], grt_dist_171_5[i], grt_dist_171_6[i], grt_dist_171_7[i], $
					grt_dist_171_8[i], grt_dist_171_9[i], grt_dist_171_10[i]]

				grt_dist_171[i] = mean(x_171)
			endfor
		endif
	endif

; Restore correct time

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195_0, /n_elements)
	dist_arr_171 = size(grt_dist_171_0, /n_elements)

; Initial estimated errors for each event

;	IF (date EQ '20070516') THEN h_err = 31. $
;		ELSE $
;	IF (date EQ '20070519') THEN h_err = 39. $
;		ELSE $
;	IF (date EQ '20070806_1') THEN h_err = 37. $
;		ELSE $
;	IF (date EQ '20070806_2') THEN h_err = 42. $
;		ELSE $
;	IF (date EQ '20071207') THEN h_err = 30. $
;		ELSE $
;	IF (date EQ '20080107') THEN h_err = 32. $
;		ELSE $
;	IF (date EQ '20080426') THEN h_err = 36. $
;		ELSE $
;	IF (date EQ '20090212') THEN h_err = 35.

	h_err = 15.0d

	h_error_195 = replicate(h_err, dist_arr_195)
	h_error_171 = replicate(h_err, dist_arr_171)
	
; Ensure that any changes in the bootstrapping routines are accounted for

	resolve_routine, 'resample_residual_195_lin'
	resolve_routine, 'resample_residual_195_quad'
	resolve_routine, 'resample_residual_171_lin'
	resolve_routine, 'resample_residual_171_quad'

	resample_residual_195_lin, date, grt_dist_195, time195, h_err, dist_arr_195, $
		f_195_lin, perror_195_lin, p1_195_lin, s1_195_lin, p2_195_lin, s2_195_lin, $
		conf_range_r_195_lin, conf_range_v_195_lin

	if (date EQ '20070806') then begin 
		x2png, 'resampled_residuals_average_195_lin_' + num2str(date) + '_' + num2str(event_num) + '.png'
	endif else begin
		x2png, 'resampled_residuals_average_195_lin_' + num2str(date) + '.png'
	endelse
	
	resample_residual_195_quad, date, grt_dist_195, time195, h_err, dist_arr_195, $
		f_195_quad, perror_195_quad, p1_195_quad, s1_195_quad, p2_195_quad, s2_195_quad, $
		p3_195_quad, s3_195_quad, conf_range_r_195_quad, conf_range_v_195_quad, $
		conf_range_a_195_quad

	if (date EQ '20070806') then begin 
		x2png, 'resampled_residuals_average_195_quad_' + num2str(date) + '_' + num2str(event_num) + '.png'
	endif else begin
		x2png, 'resampled_residuals_average_195_quad_' + num2str(date) + '.png'
	endelse

	resample_residual_171_lin, date, grt_dist_171, time171, h_err, dist_arr_171, $
		f_171_lin, perror_171_lin, p1_171_lin, s1_171_lin, p2_171_lin, s2_171_lin, $
		conf_range_r_171_lin, conf_range_v_171_lin

	if (date EQ '20070806') then begin 
		x2png, 'resampled_residuals_average_171_lin_' + num2str(date) + '_' + num2str(event_num) + '.png'
	endif else begin
		x2png, 'resampled_residuals_average_171_lin_' + num2str(date) + '.png'
	endelse

	resample_residual_171_quad, date, grt_dist_171, time171, h_err, dist_arr_171, $
		f_171_quad, perror_171_quad, p1_171_quad, s1_171_quad, p2_171_quad, s2_171_quad, $
		p3_171_quad, s3_171_quad, conf_range_r_171_quad, conf_range_v_171_quad, $
		conf_range_a_171_quad

	if (date EQ '20070806') then begin 
		x2png, 'resampled_residuals_average_171_quad_' + num2str(date) + '_' + num2str(event_num) + '.png'
	endif else begin
		x2png, 'resampled_residuals_average_171_quad_' + num2str(date) + '.png'
	endelse
	
	if (date EQ '20070806') then begin 
		openw, lun, /get_lun, 'residual_resampling_average_info' + num2str(date) + '_' + $
			num2str(event_num) + '.txt', error=err
	endif else begin
		openw, lun, /get_lun, 'residual_resampling_average_info' + num2str(date) + '.txt', error=err
	endelse

	free_lun, lun

	if (date EQ '20070806') then begin 
		openu, lun, 'residual_resampling_average_info' + num2str(date) + '_' + $
			num2str(event_num) + '.txt', /append
	endif else begin
		openu, lun, 'residual_resampling_average_info' + num2str(date) + '.txt', /append
	endelse
	printf, lun, '# Residual Resampling data for ' + num2str(date) + ' event'
	printf, lun, ' '
	printf, lun, '# Original fit Information'
	printf, lun, ' '
	printf, lun, '#195 Linear fit original equation'
	printf, lun, 'y = ' + num2str(f_195_lin[1]) + '*x + ' + num2str(f_195_lin[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(f_195_lin[0]) + ' err = ' + num2str(perror_195_lin[0])
	Printf, lun, 'V0 = ' + num2str(f_195_lin[1]) + ' err = ' + num2str(perror_195_lin[1])
	printf, lun, ' '
	printf, lun, '#171 Linear fit original equation'
	printf, lun, 'y = ' + num2str(f_171_lin[1]) + '*x + ' + num2str(f_171_lin[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(f_171_lin[0]) + ' err = ' + num2str(perror_171_lin[0])
	Printf, lun, 'V0 = ' + num2str(f_171_lin[1]) + ' err = ' + num2str(perror_171_lin[1])
	printf, lun, ' '
	printf, lun, '#195 Quadratic fit original equation'
	printf, lun, 'y = (1/2)' + num2str(f_195_quad[2]) + 'x^2 + ' + num2str(f_195_quad[1]) + $
			'*x + ' + num2str(f_195_quad[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(f_195_quad[0]) + ' err = ' + num2str(perror_195_quad[0])
	Printf, lun, 'V0 = ' + num2str(f_195_quad[1]) + ' err = ' + num2str(perror_195_quad[1])
	Printf, lun, 'A0 = ' + num2str(f_195_quad[2]) + ' err = ' + num2str(perror_195_quad[2])
	printf, lun, ' '
	printf, lun, '#171 Quadratic fit original equation'
	printf, lun, 'y = (1/2)' + num2str(f_171_quad[2]) + 'x^2 + ' + num2str(f_171_quad[1]) + $
			'*x + ' + num2str(f_171_quad[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(f_171_quad[0]) + ' err = ' + num2str(perror_171_quad[0])
	Printf, lun, 'V0 = ' + num2str(f_171_quad[1]) + ' err = ' + num2str(perror_171_quad[1])
	Printf, lun, 'A0 = ' + num2str(f_171_quad[2]) + ' err = ' + num2str(perror_171_quad[2])
	printf, lun, ' '
	printf, lun, '# Bootstrapping Information'
	printf, lun, ' '
	printf, lun, '#195 Linear fit Residuals resampled equation'
	printf, lun, 'y = ' + num2str(p2_195_lin[0]) + '*x + ' + num2str(p1_195_lin[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(p1_195_lin[0]) + ' err = ' + num2str(s1_195_lin)
	Printf, lun, 'V0 = ' + num2str(p2_195_lin[0]) + ' err = ' + num2str(s2_195_lin)
	printf, lun, ' '
	printf, lun, '#171 Linear fit Residuals resampled equation'
	printf, lun, 'y = ' + num2str(p2_171_lin[0]) + '*x + ' + num2str(p1_171_lin[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(p1_171_lin[0]) + ' err = ' + num2str(s1_171_lin)
	Printf, lun, 'V0 = ' + num2str(p2_171_lin[0]) + ' err = ' + num2str(s2_171_lin)
	printf, lun, ' '
	printf, lun, '#195 Quadratic fit Residuals resampled equation'
	printf, lun, 'y = (1/2)' + num2str(p3_195_quad[0]) + 'x^2 + ' + num2str(p2_195_quad[0]) + $
		'*x + ' + num2str(p1_195_quad[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(p1_195_quad[0]) + ' err = ' + num2str(s3_195_quad)
	Printf, lun, 'V0 = ' + num2str(p2_195_quad[0]) + ' err = ' + num2str(s2_195_quad)
	Printf, lun, 'A0 = ' + num2str(p3_195_quad[0]) + ' err = ' + num2str(s1_195_quad)
	printf, lun, ' '
	printf, lun, '#171 Quadratic fit Residuals resampled equation'
	printf, lun, 'y = (1/2)' + num2str(p3_171_quad[0]) + 'x^2 + ' + num2str(p2_171_quad[0]) + $
		'*x + ' + num2str(p1_171_quad[0])
	printf, lun, ' '
	Printf, lun, 'R0 = ' + num2str(p1_171_quad[0]) + ' err = ' + num2str(s3_171_quad)
	Printf, lun, 'V0 = ' + num2str(p2_171_quad[0]) + ' err = ' + num2str(s2_171_quad)
	Printf, lun, 'A0 = ' + num2str(p3_171_quad[0]) + ' err = ' + num2str(s1_171_quad)
	printf, lun, ' '
	printf, lun, '#95% Confidence Interval - Linear fit 195'
	printf, lun, ' '
	printf, lun, 'R0 = ' + arr2str(conf_range_r_195_lin) + ' Mm'
	printf, lun, 'V0 = ' + arr2str(1e3*(conf_range_v_195_lin)) + ' km/s'
	printf, lun, ' '
	printf, lun, '#95% Confidence Interval - Quadratic fit 195'
	printf, lun, ' '
	printf, lun, 'R0 = ' + arr2str(conf_range_r_195_quad) + ' Mm'
	printf, lun, 'V0 = ' + arr2str(1e3*(conf_range_v_195_quad)) + ' km/s'
	printf, lun, 'A0 = ' + arr2str(1e6*(conf_range_a_195_quad)) + ' m/s/s'
	printf, lun, ' '
	printf, lun, '#95% Confidence Interval - Linear fit 171'
	printf, lun, ' '
	printf, lun, 'R0 = ' + arr2str(conf_range_r_171_lin) + ' Mm'
	printf, lun, 'V0 = ' + arr2str(1e3*(conf_range_v_171_lin)) + ' km/s'
	printf, lun, ' '
	printf, lun, '#95% Confidence Interval - Quadratic fit 171'
	printf, lun, ' '
	printf, lun, 'R0 = ' + arr2str(conf_range_r_171_quad) + ' Mm'
	printf, lun, 'V0 = ' + arr2str(1e3*(conf_range_v_171_quad)) + ' km/s'
	printf, lun, 'A0 = ' + arr2str(1e6*(conf_range_a_171_quad)) + ' m/s/s'
	free_lun, lun

	if (date EQ '20070806') then begin 

		save, filename = 'CI_' + num2str(date) + '_' + num2str(event_num) + '_average.sav', conf_range_r_195_lin, $
			conf_range_v_195_lin, conf_range_r_195_quad, conf_range_v_195_quad, conf_range_a_195_quad, $
			conf_range_r_171_lin, conf_range_v_171_lin, conf_range_r_171_quad, conf_range_v_171_quad, $
			conf_range_a_171_quad

	endif else begin
	
		save, filename = 'CI_' + num2str(date) + '_average.sav', conf_range_r_195_lin, $
			conf_range_v_195_lin, conf_range_r_195_quad, conf_range_v_195_quad, conf_range_a_195_quad, $
			conf_range_r_171_lin, conf_range_v_171_lin, conf_range_r_171_quad, conf_range_v_171_quad, $
			conf_range_a_171_quad

	endelse	

end