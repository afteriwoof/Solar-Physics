; Routine that calls all bootstrapping routines and produces the estimated Confidence Intervals.

pro bootstrapping, date, event

	ans = ' '
	
; Restore data

	if (date EQ '20070519') THEN BEGIN
		amount = 5
		for i = 0, 5 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor
		
		grt_dist_195 = fltarr(6, 4)
		grt_dist_171 = fltarr(6, 6)

		for i = 0, 3 do begin
			grt_dist_195[0, i] = grt_dist_195_0[i]
			grt_dist_195[1, i] = grt_dist_195_1[i]
			grt_dist_195[2, i] = grt_dist_195_2[i]
			grt_dist_195[3, i] = grt_dist_195_3[i]
			grt_dist_195[4, i] = grt_dist_195_4[i]
			grt_dist_195[5, i] = grt_dist_195_5[i]
		endfor
		
		for i = 0, 5 do begin
			grt_dist_171[0, i] = grt_dist_171_0[i]
			grt_dist_171[1, i] = grt_dist_171_1[i]
			grt_dist_171[2, i] = grt_dist_171_2[i]
			grt_dist_171[3, i] = grt_dist_171_3[i]
			grt_dist_171[4, i] = grt_dist_171_4[i]
			grt_dist_171[5, i] = grt_dist_171_5[i]
		endfor

	endif

	if (date EQ '20071207') THEN BEGIN
		amount = 20
		for i = 0, 20 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(21, 5)
		grt_dist_171 = fltarr(21, 7)

		for i = 0, 4 do begin
			grt_dist_195[0, i] = grt_dist_195_0[i]
			grt_dist_195[1, i] = grt_dist_195_1[i]
			grt_dist_195[2, i] = grt_dist_195_2[i]
			grt_dist_195[3, i] = grt_dist_195_3[i]
			grt_dist_195[4, i] = grt_dist_195_4[i]
			grt_dist_195[5, i] = grt_dist_195_5[i]
			grt_dist_195[6, i] = grt_dist_195_6[i]
			grt_dist_195[7, i] = grt_dist_195_7[i]
			grt_dist_195[8, i] = grt_dist_195_8[i]
			grt_dist_195[9, i] = grt_dist_195_9[i]
			grt_dist_195[10, i] = grt_dist_195_10[i]
			grt_dist_195[11, i] = grt_dist_195_11[i]
			grt_dist_195[12, i] = grt_dist_195_12[i]
			grt_dist_195[13, i] = grt_dist_195_13[i]
			grt_dist_195[14, i] = grt_dist_195_14[i]
			grt_dist_195[15, i] = grt_dist_195_15[i]
			grt_dist_195[16, i] = grt_dist_195_16[i]
			grt_dist_195[17, i] = grt_dist_195_17[i]
			grt_dist_195[18, i] = grt_dist_195_18[i]
			grt_dist_195[19, i] = grt_dist_195_19[i]
			grt_dist_195[20, i] = grt_dist_195_20[i]
		endfor
		
		for i = 0, 6 do begin
			grt_dist_171[0, i] = grt_dist_171_0[i]
			grt_dist_171[1, i] = grt_dist_171_1[i]
			grt_dist_171[2, i] = grt_dist_171_2[i]
			grt_dist_171[3, i] = grt_dist_171_3[i]
			grt_dist_171[4, i] = grt_dist_171_4[i]
			grt_dist_171[5, i] = grt_dist_171_5[i]
			grt_dist_171[6, i] = grt_dist_171_6[i]
			grt_dist_171[7, i] = grt_dist_171_7[i]
			grt_dist_171[8, i] = grt_dist_171_8[i]
			grt_dist_171[9, i] = grt_dist_171_9[i]
			grt_dist_171[10, i] = grt_dist_171_10[i]
			grt_dist_171[11, i] = grt_dist_171_11[i]
			grt_dist_171[12, i] = grt_dist_171_12[i]
			grt_dist_171[13, i] = grt_dist_171_13[i]
			grt_dist_171[14, i] = grt_dist_171_14[i]
			grt_dist_171[15, i] = grt_dist_171_15[i]
			grt_dist_171[16, i] = grt_dist_171_16[i]
			grt_dist_171[17, i] = grt_dist_171_17[i]
			grt_dist_171[18, i] = grt_dist_171_18[i]
			grt_dist_171[19, i] = grt_dist_171_19[i]
			grt_dist_171[20, i] = grt_dist_171_20[i]
		endfor

	endif

	if (date EQ '20080107') THEN BEGIN
		amount = 36
		for i = 0, 36 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(37, 4)
		grt_dist_171 = fltarr(37, 9)

		for i = 0, 3 do begin
			grt_dist_195[0, i] = grt_dist_195_0[i]
			grt_dist_195[1, i] = grt_dist_195_1[i]
			grt_dist_195[2, i] = grt_dist_195_2[i]
			grt_dist_195[3, i] = grt_dist_195_3[i]
			grt_dist_195[4, i] = grt_dist_195_4[i]
			grt_dist_195[5, i] = grt_dist_195_5[i]
			grt_dist_195[6, i] = grt_dist_195_6[i]
			grt_dist_195[7, i] = grt_dist_195_7[i]
			grt_dist_195[8, i] = grt_dist_195_8[i]
			grt_dist_195[9, i] = grt_dist_195_9[i]
			grt_dist_195[10, i] = grt_dist_195_10[i]
			grt_dist_195[11, i] = grt_dist_195_11[i]
			grt_dist_195[12, i] = grt_dist_195_12[i]
			grt_dist_195[13, i] = grt_dist_195_13[i]
			grt_dist_195[14, i] = grt_dist_195_14[i]
			grt_dist_195[15, i] = grt_dist_195_15[i]
			grt_dist_195[16, i] = grt_dist_195_16[i]
			grt_dist_195[17, i] = grt_dist_195_17[i]
			grt_dist_195[18, i] = grt_dist_195_18[i]
			grt_dist_195[19, i] = grt_dist_195_19[i]
			grt_dist_195[20, i] = grt_dist_195_20[i]
			grt_dist_195[21, i] = grt_dist_195_21[i]
			grt_dist_195[22, i] = grt_dist_195_22[i]
			grt_dist_195[23, i] = grt_dist_195_23[i]
			grt_dist_195[24, i] = grt_dist_195_24[i]
			grt_dist_195[25, i] = grt_dist_195_25[i]
			grt_dist_195[26, i] = grt_dist_195_26[i]
			grt_dist_195[27, i] = grt_dist_195_27[i]
			grt_dist_195[28, i] = grt_dist_195_28[i]
			grt_dist_195[29, i] = grt_dist_195_29[i]
			grt_dist_195[30, i] = grt_dist_195_30[i]
			grt_dist_195[31, i] = grt_dist_195_31[i]
			grt_dist_195[32, i] = grt_dist_195_32[i]
			grt_dist_195[33, i] = grt_dist_195_33[i]
			grt_dist_195[34, i] = grt_dist_195_34[i]
			grt_dist_195[35, i] = grt_dist_195_35[i]
			grt_dist_195[36, i] = grt_dist_195_36[i]
		endfor
		
		for i = 0, 8 do begin
			grt_dist_171[0, i] = grt_dist_171_0[i]
			grt_dist_171[1, i] = grt_dist_171_1[i]
			grt_dist_171[2, i] = grt_dist_171_2[i]
			grt_dist_171[3, i] = grt_dist_171_3[i]
			grt_dist_171[4, i] = grt_dist_171_4[i]
			grt_dist_171[5, i] = grt_dist_171_5[i]
			grt_dist_171[6, i] = grt_dist_171_6[i]
			grt_dist_171[7, i] = grt_dist_171_7[i]
			grt_dist_171[8, i] = grt_dist_171_8[i]
			grt_dist_171[9, i] = grt_dist_171_9[i]
			grt_dist_171[10, i] = grt_dist_171_10[i]
			grt_dist_171[11, i] = grt_dist_171_11[i]
			grt_dist_171[12, i] = grt_dist_171_12[i]
			grt_dist_171[13, i] = grt_dist_171_13[i]
			grt_dist_171[14, i] = grt_dist_171_14[i]
			grt_dist_171[15, i] = grt_dist_171_15[i]
			grt_dist_171[16, i] = grt_dist_171_16[i]
			grt_dist_171[17, i] = grt_dist_171_17[i]
			grt_dist_171[18, i] = grt_dist_171_18[i]
			grt_dist_171[19, i] = grt_dist_171_19[i]
			grt_dist_171[20, i] = grt_dist_171_20[i]
			grt_dist_171[21, i] = grt_dist_171_21[i]
			grt_dist_171[22, i] = grt_dist_171_22[i]
			grt_dist_171[23, i] = grt_dist_171_23[i]
			grt_dist_171[24, i] = grt_dist_171_24[i]
			grt_dist_171[25, i] = grt_dist_171_25[i]
			grt_dist_171[26, i] = grt_dist_171_26[i]
			grt_dist_171[27, i] = grt_dist_171_27[i]
			grt_dist_171[28, i] = grt_dist_171_28[i]
			grt_dist_171[29, i] = grt_dist_171_29[i]
			grt_dist_171[30, i] = grt_dist_171_30[i]
			grt_dist_171[31, i] = grt_dist_171_31[i]
			grt_dist_171[32, i] = grt_dist_171_32[i]
			grt_dist_171[33, i] = grt_dist_171_33[i]
			grt_dist_171[34, i] = grt_dist_171_34[i]
			grt_dist_171[35, i] = grt_dist_171_35[i]
			grt_dist_171[36, i] = grt_dist_171_36[i]
		endfor

	endif

	if (date EQ '20080426') THEN BEGIN
		amount = 9
		for i = 0, 9 do begin
			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
		endfor

		grt_dist_195 = fltarr(10, 5)
		grt_dist_171 = fltarr(10, 6)

		for i = 0, 4 do begin
			grt_dist_195[0, i] = grt_dist_195_0[i]
			grt_dist_195[1, i] = grt_dist_195_1[i]
			grt_dist_195[2, i] = grt_dist_195_2[i]
			grt_dist_195[3, i] = grt_dist_195_3[i]
			grt_dist_195[4, i] = grt_dist_195_4[i]
			grt_dist_195[5, i] = grt_dist_195_5[i]
			grt_dist_195[6, i] = grt_dist_195_6[i]
			grt_dist_195[7, i] = grt_dist_195_7[i]
			grt_dist_195[8, i] = grt_dist_195_8[i]
			grt_dist_195[9, i] = grt_dist_195_9[i]
		endfor
		
		for i = 0, 5 do begin
			grt_dist_171[0, i] = grt_dist_171_0[i]
			grt_dist_171[1, i] = grt_dist_171_1[i]
			grt_dist_171[2, i] = grt_dist_171_2[i]
			grt_dist_171[3, i] = grt_dist_171_3[i]
			grt_dist_171[4, i] = grt_dist_171_4[i]
			grt_dist_171[5, i] = grt_dist_171_5[i]
			grt_dist_171[6, i] = grt_dist_171_6[i]
			grt_dist_171[7, i] = grt_dist_171_7[i]
			grt_dist_171[8, i] = grt_dist_171_8[i]
			grt_dist_171[9, i] = grt_dist_171_9[i]
		endfor

	endif

;	if (date EQ '20090212') THEN BEGIN
;		amount = 7
;		for i = 0, 7 do begin
;			restore, num2str(date) + '_dist_' + num2str(i) + '.sav'
;		endfor
;
;		grt_dist_195 = fltarr(21, 5)
;		grt_dist_171 = fltarr(21, 8)
;
;		for i = 0, 4 do begin
;			grt_dist_195[0, i] = grt_dist_195_0[i]
;			grt_dist_195[1, i] = grt_dist_195_1[i]
;			grt_dist_195[2, i] = grt_dist_195_2[i]
;			grt_dist_195[3, i] = grt_dist_195_3[i]
;			grt_dist_195[4, i] = grt_dist_195_4[i]
;			grt_dist_195[5, i] = grt_dist_195_5[i]
;			grt_dist_195[6, i] = grt_dist_195_6[i]
;			grt_dist_195[7, i] = grt_dist_195_7[i]
;			grt_dist_195[8, i] = grt_dist_195_8[i]
;			grt_dist_195[9, i] = grt_dist_195_9[i]
;			grt_dist_195[10, i] = grt_dist_195_10[i]
;			grt_dist_195[11, i] = grt_dist_195_11[i]
;			grt_dist_195[12, i] = grt_dist_195_12[i]
;			grt_dist_195[13, i] = grt_dist_195_13[i]
;			grt_dist_195[14, i] = grt_dist_195_14[i]
;			grt_dist_195[15, i] = grt_dist_195_15[i]
;			grt_dist_195[16, i] = grt_dist_195_16[i]
;			grt_dist_195[17, i] = grt_dist_195_17[i]
;			grt_dist_195[18, i] = grt_dist_195_18[i]
;			grt_dist_195[19, i] = grt_dist_195_19[i]
;			grt_dist_195[20, i] = grt_dist_195_20[i]
;		endfor
;		
;		for i = 0, 7 do begin
;			grt_dist_171[0, i] = grt_dist_171_0[i]
;			grt_dist_171[1, i] = grt_dist_171_1[i]
;			grt_dist_171[2, i] = grt_dist_171_2[i]
;			grt_dist_171[3, i] = grt_dist_171_3[i]
;			grt_dist_171[4, i] = grt_dist_171_4[i]
;			grt_dist_171[5, i] = grt_dist_171_5[i]
;			grt_dist_171[6, i] = grt_dist_171_6[i]
;			grt_dist_171[7, i] = grt_dist_171_7[i]
;			grt_dist_171[8, i] = grt_dist_171_8[i]
;			grt_dist_171[9, i] = grt_dist_171_9[i]
;			grt_dist_171[10, i] = grt_dist_171_10[i]
;			grt_dist_171[11, i] = grt_dist_171_11[i]
;			grt_dist_171[12, i] = grt_dist_171_12[i]
;			grt_dist_171[13, i] = grt_dist_171_13[i]
;			grt_dist_171[14, i] = grt_dist_171_14[i]
;			grt_dist_171[15, i] = grt_dist_171_15[i]
;			grt_dist_171[16, i] = grt_dist_171_16[i]
;			grt_dist_171[17, i] = grt_dist_171_17[i]
;			grt_dist_171[18, i] = grt_dist_171_18[i]
;			grt_dist_171[19, i] = grt_dist_171_19[i]
;			grt_dist_171[20, i] = grt_dist_171_20[i]
;		endfor
;
;	endif

	if (date EQ '20070806') THEN BEGIN
		if (event EQ '1') THEN BEGIN
			amount = 10
			for i = 0, 10 do begin
				restore, num2str(date) + '_' + num2str(event) + '_dist_' + num2str(i) + '.sav'
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
	IF (date EQ '20080426') THEN h_err = 36. $
		ELSE $
	IF (date EQ '20090212') THEN h_err = 35.

	h_error_195 = replicate(h_err, dist_arr_195)
	h_error_171 = replicate(h_err, dist_arr_171)
	
; Ensure that any changes in the bootstrapping routines are accounted for

	resolve_routine, 'bootstrap_lin_195'
	resolve_routine, 'bootstrap_quad_195'
	resolve_routine, 'bootstrap_lin_171'
	resolve_routine, 'bootstrap_quad_171'

	for i = 0, amount do begin

		bootstrap_lin_195, date, grt_dist_195[i, *], time195, h_err, dist_arr_195, f_195_lin, lin_195_conf_range_r, $
				lin_195_conf_range_v

		bootstrap_quad_195, date, grt_dist_195[i, *], time195, h_err, dist_arr_195, f_195_quad, quad_195_conf_range_r, $
				quad_195_conf_range_v, quad_195_conf_range_a

		bootstrap_lin_171, date, grt_dist_171[i, *], time171, h_err, dist_arr_171, f_171_lin, lin_171_conf_range_r, $
				lin_171_conf_range_v

		bootstrap_quad_171, date, grt_dist_171[i, *], time171, h_err, dist_arr_171, f_171_quad, quad_171_conf_range_r, $
				quad_171_conf_range_v, quad_171_conf_range_a

		openw, lun, /get_lun, 'bootstrapping_info' + num2str(date) + '_' + num2str(i) + '.txt', error=err
		free_lun, lun

		openu, lun, 'bootstrapping_info' + num2str(date) + '_' + num2str(i) + '.txt', /append
		printf, lun, '#Confidence interval data for ' + num2str(date) + ' event'
		printf, lun, ' '
		printf, lun, '#195 Linear fit original equation'
		printf, lun, 'y = ' + num2str(f_195_lin[1]) + '*x + ' + num2str(f_195_lin[0])
		printf, lun, ' '
		printf, lun, '#171 Linear fit original equation'
		printf, lun, 'y = ' + num2str(f_171_lin[1]) + '*x + ' + num2str(f_171_lin[0])
		printf, lun, ' '
		printf, lun, '#195 Quadratic fit original equation'
		printf, lun, 'y = (1/2)' + num2str(f_195_quad[2]) + 'x^2 + ' + num2str(f_195_quad[1]) + $
				'*x + ' + num2str(f_195_quad[0])
		printf, lun, ' '
		printf, lun, '#171 Quadratic fit original equation'
		printf, lun, 'y = (1/2)' + num2str(f_171_quad[2]) + 'x^2 + ' + num2str(f_171_quad[1]) + $
				'*x + ' + num2str(f_171_quad[0])
		printf, lun, ' '
		printf, lun, '#95% Confidence Interval - Linear fit 195'
		printf, lun, ' '
		printf, lun, 'R0 = ' + arr2str(lin_195_conf_range_r) + ' Mm'
		printf, lun, 'V0 = ' + arr2str(1000*lin_195_conf_range_v) + ' km/s'
		printf, lun, ' '
		printf, lun, '#95% Confidence Interval - Quadratic fit 195'
		printf, lun, ' '
		printf, lun, 'R0 = ' + arr2str(quad_195_conf_range_r) + ' Mm'
		printf, lun, 'V0 = ' + arr2str(1000*quad_195_conf_range_v) + ' km/s'
		printf, lun, 'A0 = ' + arr2str(1e6*quad_195_conf_range_a) + ' m/s/s'
		printf, lun, ' '
		printf, lun, '#95% Confidence Interval - Linear fit 171'
		printf, lun, ' '
		printf, lun, 'R0 = ' + arr2str(lin_171_conf_range_r) + ' Mm'
		printf, lun, 'V0 = ' + arr2str(1000*lin_171_conf_range_v) + ' km/s'
		printf, lun, ' '
		printf, lun, '#95% Confidence Interval - Quadratic fit 171'
		printf, lun, ' '
		printf, lun, 'R0 = ' + arr2str(quad_171_conf_range_r) + ' Mm'
		printf, lun, 'V0 = ' + arr2str(1000*quad_171_conf_range_v) + ' km/s'
		printf, lun, 'A0 = ' + arr2str(1e6*quad_171_conf_range_a) + ' m/s/s'
		free_lun, lun

	endfor
	
	
end