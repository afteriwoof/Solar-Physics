; Routine to test the variation in start time of disturbance on the model fitting.

pro model_tester, date, event_num, linear=linear, quadratic=quadratic

;	date = 20070519

	window, 0, xs = 1000, ys = 600
	
	set_line_color
	
	!p.multi = [0, 1, 1]

	resolve_routine, 'data_restore'
	
	data_restore, date, event_num, grt_dist_195, grt_dist_171, t195, time_171, dist_arr_195, dist_arr_171

; Initial estimated errors for each event

	IF (date EQ '20070516') THEN h_err = 31. $
		ELSE $
	IF (date EQ '20070519') THEN h_err = 39. $
		ELSE $
	IF (date EQ '20070806') THEN h_err = 37. $
		ELSE $
	IF (date EQ '20070806') AND (event_num EQ '2') THEN h_err = 42. $
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

; Restore correct time

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	print, t195
	print, time_171

; 195A data - quadratic

	cad_195 = time195[1] - time195[0]

	cad_171 = time171[1] - time171[0]

;	chi_square_195_quad = fltarr(cad + 1)
;	dist_195_quad = fltarr(cad + 1)
;	vel_195_quad = fltarr(cad + 1)
;	acc_195_quad = fltarr(cad + 1)

	arr_size_195 = size(grt_dist_195[2, *], /n_elements)

	arr_size_171 = size(grt_dist_171[2, *], /n_elements)

	great_dist_195 = fltarr(arr_size_195)

	great_dist_171 = fltarr(arr_size_171)
	
	for i = 0, arr_size_195 - 1 do begin
	
		great_dist_195[i] = grt_dist_195[2, i]
		
	endfor

	for i = 0, arr_size_171 - 1 do begin
	
		great_dist_171[i] = grt_dist_171[2, i]
		
	endfor
	
	grt_dist_195 = great_dist_195
	grt_dist_171 = great_dist_171


; Add varying time value to start of time array

	for t = 0, cad_171, 1. do begin

		tim195 = time195 - time171[0] + t
		tim171 = time171 - time171[0] + t

		print, tim195		
		print, grt_dist_195
		print, tim171		
		print, grt_dist_171

		plot, tim195, grt_dist_195, color = 0, background = 1, xr = [-300., 2100.], $
			psym = 2, yr = [0, max(grt_dist_195)*1.1], /ys, /xs

		oplot, tim171, grt_dist_171, psym = 2, color = 3

		if (keyword_set(quadratic)) then begin

; Quadratic fits

; Zero a fit to 195A data

			tim195 = time195 - time171[0] + t

			x = findgen( max(tim195) )

			h_error = replicate(h_err, dist_arr_195)

			quad_fit_195 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

		    f_195_quad = mpfitexpr(quad_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2, 0.00005], $
		    		perror=perror, parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

			x = tim195

			x_arr = findgen(max(tim195))
	
			y_line = f_195_quad[0] + f_195_quad[1]*x_arr + (1./2.)*f_195_quad[2]*x_arr^2.
		
			oplot, x_arr, y_line, color = 0

; Zero a fit to 171A data

			tim171 = time171 - time171[0] + t

			x = findgen( max(tim171) )

			h_error = replicate(h_err, dist_arr_171)

			quad_fit_171 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 0.
			pi(1).limited(0) = 1
			pi(1).limits(0) = 0.01
			pi(1).limited(1) = 1
			pi(1).limits(1) = 0.6
			pi(2).limited(0) = 1
			pi(2).limits(0) = -0.0005
			pi(2).limited(1) = 1
			pi(2).limits(1) = 0.0005

		    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], $
		    		perror=perror, parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

			x = tim171

			x_arr = findgen(max(tim171))
	
			y_line = f_171_quad[0] + f_171_quad[1]*x_arr + (1./2.)*f_171_quad[2]*x_arr^2.
		
			oplot, x_arr, y_line, color = 3

		endif
		
		if (keyword_set(linear)) then begin

; Linear fits

; Zero a fit to 195A data

			tim195 = time195 - time171[0] + t

			x = findgen( max(tim195) )

			h_error = replicate(h_err, dist_arr_195)

			lin_fit_195 = 'p[0] + p[1] * x'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 0.
			pi(1).limited(0) = 1
			pi(1).limits(0) = 0.01
			pi(1).limited(1) = 1
			pi(1).limits(1) = 0.6

		    f_195_lin = mpfitexpr(lin_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2], perror=perror, $
		    		parinfo = pi, bestnorm = bestnorm_195_lin, /quiet)

			x_arr = findgen(max(tim195))
	
			y_line = f_195_lin[1]*x_arr + f_195_lin[0]
		
			oplot, x_arr, y_line, color = 0

; Zero a fit to 171A data

			tim171 = time171 - time171[0] + t

			x = findgen( max(tim171) )

			h_error = replicate(h_err, dist_arr_171)

			lin_fit_171 = 'p[0] + p[1] * x'

			pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
			pi(0).limited(0) = 1
			pi(0).limits(0) = 0.
			pi(1).limited(0) = 1
			pi(1).limits(0) = 0.01
			pi(1).limited(1) = 1
			pi(1).limits(1) = 0.6

		    f_171_lin = mpfitexpr(lin_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2], perror=perror, $
		    		parinfo = pi, bestnorm = bestnorm_171_lin, /quiet)

			x_arr = findgen(max(tim171))
	
			y_line = f_171_lin[1]*x_arr + f_171_lin[0]
		
			oplot, x_arr, y_line, color = 3

		endif

	endfor

;	x_0 = (f_171_lin[0] - f_195_lin[0])/(f_195_lin[1] - f_171_lin[1])
;
;	print, x_0
;		
;	y_0 = f_171_lin[1]*x_0 + f_171_lin[0]
;		
;	print, y_0



stop


	
; Add varying time value to start of time array

	for t = 0, cad, cad/100. do begin

		tim195 = time195 - time195[0] + t

		print, tim195		
		print, grt_dist_195

		start = time195[0] - t
		
		plot, tim195, grt_dist_195, color = 0, background = 1, xr = [-50, max(tim195)+cad*1.1], $
			psym = 2, yr = [0, max(grt_dist_195)*1.1], /ys, /xs


; Zero a fit to data

		tim195 = time195 - time195[0] + t

		x = findgen( max(tim195) )

		h_error = replicate(h_err, dist_arr_195)

		quad_fit_195 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

		x = tim195

		x_arr = findgen(max(tim195))
	
		y_line = f_195_quad[0] + f_195_quad[1]*x_arr + (1./2.)*f_195_quad[2]*x_arr^2.
		
		oplot, x_arr, y_line, color = 3

;		chi_square_195_quad[t] = bestnorm_195_quad
;
;		dist_195_quad[t] = f_195_quad[0]
;		vel_195_quad[t] = f_195_quad[1]
;		acc_195_quad[t] = f_195_quad[2]
		
;		print, 'Chi square = ', chi_square_195_quad[t]
;		print, ' '
;		print, 'Parameters = ', f_195_quad
		
;		ans = ' '
;		
;		read, 'ok?', ans
		
	endfor

	x2png, 'start_time_vary_195_quad.png'

	chi = chi_square_195_quad[0:cad:cad/100.]

	d = dist_195_quad[0:cad:cad/100.]

	v = vel_195_quad[0:cad:cad/100.]
	
	a = acc_195_quad[0:cad:cad/100.]

	v_max = where(v EQ max(v))
	
	print, v_max
	
	time = findgen(cad+1)
	
	t = time[0:cad:cad/100.]

	plot, t, chi, color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', $
		xtit = 'Seconds prior to time of first data point', $
		ytit = 'Chi-squared value'

	plots, [t[v_max], t[v_max]], [0, max(chi)], color = 3

	x2png, 'chi_square_195_quad.png'

	plot, t, d, color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', $
		xtit = 'Seconds prior to time of first data point', $
		ytit = 'Distance value'

	plots, [t[v_max], t[v_max]], [0, max(d)], color = 3

	x2png, 'dist_195_quad.png'

	plot, t, v, color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', $
		xtit = 'Seconds prior to time of first data point', $
		ytit = 'Velocity value'

	plots, [t[v_max], t[v_max]], [0, max(v)], color = 3

	x2png, 'vel_195_quad.png'
	
	plot, t, a, color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', $
		xtit = 'Seconds prior to time of first data point', $
		ytit = 'Acceleration value'

	plots, [t[v_max], t[v_max]], [min(a), max(a)], color = 3

	x2png, 'acc_195_quad.png'

stop
; 195A data - linear

	cad = time195[1] - time195[0]

	chi_square_195_lin = fltarr(cad + 1)

	arr_size = size(grt_dist_195[2, *], /n_elements)

	great_dist_195 = fltarr(arr_size)
	
	for i = 0, arr_size-1 do begin
	
		great_dist_195[i] = grt_dist_195[2, i]
		
	endfor
	
	grt_dist_195 = great_dist_195
	
; Add varying time value to start of time array

	for t = 0, cad, cad/100. do begin

		tim195 = time195 - time195[0] + t

		print, tim195		
		print, grt_dist_195

		start = time195[0] - t
		
;		print, 'Time = ', tim195

;		if (t eq cad) then begin
		
		plot, tim195, grt_dist_195, color = 0, background = 1, xr = [-50, max(tim195)+cad*1.1], $
			psym = 2, yr = [0, max(grt_dist_195)*1.1], /ys, /xs


;			utplot, tim195, grt_dist_195, start, title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
;				timerange = [min(time195) - 700, max(time195) + 700], ytitle = '!6Distance (!6Mm)', $
;				yrange = [0, max(grt_dist_195)+100], psym = 2, charsize = 2, /xs, /ys, $
;				color = 0, background = 1, thick = 2

;		endif
		
; Zero a fit to data

		tim195 = time195 - time195[0] + t

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

		x_arr = findgen(max(tim195))
	
		y_line = f_195_lin[1]*x_arr + f_195_lin[0]
		
;		if (t eq cad) then begin
		
			oplot, x_arr, y_line, color = 3

;		endif

		chi_square_195_lin[t] = bestnorm_195_lin
		
		print, 'Chi square = ', chi_square_195_lin[t]
		print, ' '
		print, 'Parameters = ', f_195_lin
		
		ans = ' '
		
		read, 'ok?', ans
		
	endfor

	x2png, 'start_time_vary_195_lin.png'

	time = findgen(cad+1)
	
;	print, time[0:cad:cad/100.]
;	print, chi_square[0:cad:cad/100.]
	
	plot, time[0:cad:cad/100.], chi_square_195_lin[0:cad:cad/100.], color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', xtit = 'Seconds prior to time of first data point', $
		ytit = 'Chi-squared value'

	x2png, 'chi_square_195_lin.png'
stop	
; 171A data - linear

	cad = time171[1] - time171[0]

	chi_square_171_lin = fltarr(cad + 1)

	grt_dist_171 = grt_dist_171[2, *]

; Add varying time value to start of time array

	for t = 0, cad, cad/100. do begin

		tim171 = time171 - time171[0] + t
		
		start = time171[0] - t
		
;		print, 'Time = ', tim171

;		if (t eq cad) then begin
		
			utplot, tim171, grt_dist_171, start, title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
				timerange = [min(time171) - 700, max(time171) + 700], ytitle = '!6Distance (!6Mm)', $
				yrange = [0, max(grt_dist_171)+100], psym = 2, charsize = 2, /xs, /ys, $
				color = 0, background = 1, thick = 2

;		endif
		
; Zero a fit to data

		tim171 = time171 - time171[0] + t

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

		x_arr = findgen(max(tim171))
	
		y_line = f_171_lin[1]*x_arr + f_171_lin[0]

;		if (t eq cad) then begin
		
			oplot, x_arr, y_line, color = 3

;		endif
		
		chi_square_171_lin[t] = bestnorm_171_lin
		
		print, 'Chi square = ', chi_square_171_lin[t]
		
		ans = ' '
		
		read, 'ok?', ans
		
	endfor

	x2png, 'start_time_vary_171_lin.png'

	time = findgen(cad+1)
	
;	print, time[0:cad:cad/100.]
;	print, chi_square[0:cad:cad/100.]
	
	plot, time[0:cad:cad/100.], chi_square_171_lin[0:cad:cad/100.], color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '171A data', xtit = 'Seconds prior to time of first data point', $
		ytit = 'Chi-squared value'

	x2png, 'chi_square_171_lin.png'

; 195A data - quadratic

	cad = time195[1] - time195[0]

	chi_square_195_quad = fltarr(cad + 1)

;	grt_dist_195 = grt_dist_195[2, *]

; Add varying time value to start of time array

	for t = 0, cad, cad/100. do begin

		tim195 = time195 - time195[0] + t
		
		start = time195[0] - t
		
;		print, 'Time = ', tim195

;		if (t eq cad) then begin
		
			utplot, tim195, grt_dist_195, start, title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
				timerange = [min(time195) - 700, max(time195) + 700], ytitle = '!6Distance (!6Mm)', $
				yrange = [0, max(grt_dist_195)+100], psym = 2, charsize = 2, /xs, /ys, $
				color = 0, background = 1, thick = 2

;		endif

; Zero a fit to data

		tim195 = time195 - time195[0] + t

		x = findgen( max(tim195) )

		h_error = replicate(h_err, dist_arr_195)

		quad_fit_195 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

		x = tim195

		x_arr = findgen(max(tim195))
	
		y_line = f_195_quad[0] + f_195_quad[1]*x_arr + (1./2.)*f_195_quad[2]*x_arr^2.

;		if (t eq cad) then begin
		
			oplot, x_arr, y_line, color = 3

;		endif

		chi_square_195_quad[t] = bestnorm_195_quad
		
;		print, 'Chi square = ', chi_square[t]
;		
;		ans = ' '
;		
;		read, 'ok?', ans
		
	endfor

	x2png, 'start_time_vary_195_quad.png'

	time = findgen(cad+1)
	
;	print, time[0:cad:cad/100.]
;	print, chi_square[0:cad:cad/100.]
	
	plot, time[0:cad:cad/100.], chi_square_195_quad[0:cad:cad/100.], color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '195A data', xtit = 'Seconds prior to time of first data point', $
		ytit = 'Chi-squared value'

	x2png, 'chi_square_195_quad.png'
	
; 171A data - quadratic

	cad = time171[1] - time171[0]

	chi_square_171_quad = fltarr(cad + 1)

;	grt_dist_171 = grt_dist_171[2, *]

; Add varying time value to start of time array

	for t = 0, cad, cad/100. do begin

		tim171 = time171 - time171[0] + t
		
		start = time171[0] - t
		
;		print, 'Time = ', tim171

;		if (t eq cad) then begin
		
			utplot, tim171, grt_dist_171, start, title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
				timerange = [min(time171) - 700, max(time171) + 700], ytitle = '!6Distance (!6Mm)', $
				yrange = [0, max(grt_dist_171)+100], psym = 2, charsize = 2, /xs, /ys, $
				color = 0, background = 1, thick = 2

;		endif

; Zero a fit to data

		tim171 = time171 - time171[0] + t

		x = findgen( max(tim171) )

		h_error = replicate(h_err, dist_arr_171)

		quad_fit_171 = 'p[0] + p[1] * x + (1./2.) * p[2] * x^2.'

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

		x = tim171

		x_arr = findgen(max(tim171))
	
		y_line = f_171_quad[0] + f_171_quad[1]*x_arr + (1./2.)*f_171_quad[2]*x_arr^2.

;		if (t eq cad) then begin
		
			oplot, x_arr, y_line, color = 3

;		endif

		chi_square_171_quad[t] = bestnorm_171_quad
		
;		print, 'Chi square = ', chi_square[t]
;		
;		ans = ' '
;		
;		read, 'ok?', ans
		
	endfor

	x2png, 'start_time_vary_171_quad.png'

	time = findgen(cad+1)
	
;	print, time[0:cad:cad/100.]
;	print, chi_square[0:cad:cad/100.]
	
	plot, time[0:cad:cad/100.], chi_square_171_quad[0:cad:cad/100.], color = 0, background = 1, psym = 2, $
		xr = [time[0] - 50, time[cad] + 50], /xs, title = '171A data', xtit = 'Seconds prior to time of first data point', $
		ytit = 'Chi-squared value'

	x2png, 'chi_square_171_quad.png'

end