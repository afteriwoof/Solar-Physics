; Routine used to produce randomised residuals plots for SGM July 09

pro ran_res_sgm, date

;	window, 0, xs = 1000, ys = 600
	
	set_line_color
	
;	!p.multi = [0, 1, 1]
	
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

	grt_dist_195 = grt_dist_195[2, *]

	tim195 = time195 - time195[0]

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

	x = tim195

	x_arr = findgen(max(tim195))
	
	y_line = f_195_lin[1]*x_arr + f_195_lin[0]

; result array

	arr_size = 100000.
	
	print, arr_size

	res = dblarr(2, arr_size)
	
; original fit to data

	yfit = f_195_lin[1]*tim195 + f_195_lin[0]

; Loop over n! iterations to bootstrap

	for i =0L, arr_size-1 do begin

; Calculate residuals

		e = grt_dist_195 - yfit
		
; Generate number of data points random numbers between 0 and 100 from uniform distribution 

		ran = floor(RANDOMU( seed , dist_arr_195, /DOUBLE, /uniform)*(dist_arr_195-1.))
		
; Create array of 1 and -1 to multiply ran array by to fill gaps in resulting array

		unit_array = randomn(seed, dist_arr_195, /normal)
		
		unit_arr = unit_array/abs(unit_array)
		
; Randomly reassign the residuals

		er = e[ran]	* unit_arr
		
; Make new data with random residuals

		yr = grt_dist_195 + er
		
; New fit and store the results

		res[*,i] = poly_fit(x, yr, 1)

	endfor
	
; Calculate the moments of the results arrays for m and c

	p1 = moment(res[0,*], sdev=s1)
	p2 = moment((res[1,*]*1e3), sdev=s2)
	
	window, 0, xs = 1000, ys = 1000
	!p.multi = [0, 1, 3]
	set_line_color

; Without line

; Plot original data with fitted line

	plot, x_arr, y_line, Title ='195A Linear - Original data and Fit', xtit='Time (s)', $
		ytit='Distance (Mm)', charsize = 2, background = 1, color = 0, xr = [-50, max(x_arr) + 50], $
		/xs, thick = 2, charthick = 1.5, yr = [0, 900], /ys

	oplot, tim195, grt_dist_195, color=3, psym = 2, thick = 2

	legend,['Original Data', 'Original fit: r = '+ num2str(f_195_lin[0]) + ' + ' + num2str(f_195_lin[1]) + '*x'], $
		colors=[3, 0], chars = 2, /right, /bottom, /clear, textcolor = [3, 0], charthick = 1.5

; Plot randomised residual data with fitted line

;	x_arr = findgen(max(tim195))
;	
;	y_line = res[1, 1]*x_arr + res[0, 1]
;
;	plot, x_arr, y_line, Title ='195A Linear - Randomised data and Fit', xtit='Time (s)', $
;		ytit='Distance (Mm)', charsize = 2, background = 1, color = 0, xr = [-50, max(x_arr) + 50], $
;		/xs, thick = 2, charthick = 1.5, yr = [0, 600.], /ys
;
;	oplot, tim195, yr[*, 1], color=3, psym = 2, thick = 2
;
;	legend,['New Data', 'New fit: r = '+ num2str(res[0, 1]) + ' + ' + num2str(res[1, 1]) + '*x'], $
;		colors=[3, 0], chars = 2, /right, /bottom, /clear, textcolor = [3, 0], charthick = 1.5

; Plot histogram of intercept parameter bootstrapping data

	plot_hist, res[0,*], bin = 3, color = 0, charsize = 2.5, title = 'R0', xtit = 'R0 (Mm)', $
			xr = [p1[0] - 3*s1, p1[0] + 3*s1], /xs, yr = [0, 1.1*max(histogram(res[0,*], binsize = 3))], /ys
	
	h_0 = histogram(res[0, *], binsize = 3)
	
	x_0 = findgen(10000)/10
	
	y_0 = max(h_0)*exp(-(x_0-p1[0])^2/(2.*s1^2))

;	oplot, x_0, y_0, color = 3, thick = 2

	legend, ['Mean V0 = ' + num2str(p1[0]), 'Std Dev = ' + num2str(s1)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

; Plot histogram of slope parameter bootstrapping data

	plot_hist, (res[1,*]*1e3), bin = 3, color = 0, charsize = 2.5, title = 'V0', $
			xr = [p2[0] - 3*s2, p2[0] + 3*s2], /xs, yr = [0, 1.1*max(histogram((res[1,*]*1e3), $
			binsize = 3))], /ys, xtit = 'V0 (km/s)'
			
	h_1 = histogram((res[1,*]*1e3), binsize = 3)
	
	x_1 = findgen(108000)/10
	
	y_1 = max(h_1)*exp(-(x_1-p2[0])^2/(2.0D*s2^2))
	
;	oplot, x_1, y_1, color = 3, thick = 2

	legend, ['Mean R0 = ' + num2str(p2[0]), 'Std Dev = ' + num2str(s2)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

	x2png, 'SGM_histogram_1_0.png'

; With line

; Plot original data with fitted line

	plot, x_arr, y_line, Title ='195A Linear - Original data and Fit', xtit='Time (s)', $
		ytit='Distance (Mm)', charsize = 2, background = 1, color = 0, xr = [-50, max(x_arr) + 50], $
		/xs, thick = 2, charthick = 1.5, yr = [0, 900], /ys

	oplot, tim195, grt_dist_195, color=3, psym = 2, thick = 2

	legend,['Original Data', 'Original fit: r = '+ num2str(f_195_lin[0]) + ' + ' + num2str(f_195_lin[1]) + '*x'], $
		colors=[3, 0], chars = 2, /right, /bottom, /clear, textcolor = [3, 0], charthick = 1.5

; Plot randomised residual data with fitted line

;	x_arr = findgen(max(tim195))
;	
;	y_line = res[1, 1]*x_arr + res[0, 1]
;
;	plot, x_arr, y_line, Title ='195A Linear - Randomised data and Fit', xtit='Time (s)', $
;		ytit='Distance (Mm)', charsize = 2, background = 1, color = 0, xr = [-50, max(x_arr) + 50], $
;		/xs, thick = 2, charthick = 1.5, yr = [0, 600.], /ys
;
;	oplot, tim195, yr[*, 1], color=3, psym = 2, thick = 2
;
;	legend,['New Data', 'New fit: r = '+ num2str(res[0, 1]) + ' + ' + num2str(res[1, 1]) + '*x'], $
;		colors=[3, 0], chars = 2, /right, /bottom, /clear, textcolor = [3, 0], charthick = 1.5

; Plot histogram of intercept parameter bootstrapping data

	plot_hist, res[0,*], bin = 2, color = 0, charsize = 2.5, title = 'R0', xtit = 'R0 (Mm)', $
			xr = [p1[0] - 3*s1, p1[0] + 3*s1], /xs, yr = [0, 1.1*max(histogram(res[0,*], binsize = 2))], /ys
	
	h_0 = histogram(res[0, *], binsize = 2)
	
	x_0 = findgen(10000)/10
	
	y_0 = max(h_0)*exp(-(x_0-p1[0])^2/(2.*s1^2))

	oplot, x_0, y_0, color = 3, thick = 2

	legend, ['Mean R0 = ' + num2str(p1[0]), 'Std Dev = ' + num2str(s1)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

; Plot histogram of slope parameter bootstrapping data

	plot_hist, (res[1,*]*1e3), bin = 2, color = 0, charsize = 2.5, title = 'V0', $
			xr = [p2[0] - 3*s2, p2[0] + 3*s2], /xs, yr = [0, 1.1*max(histogram((res[1,*]*1e3), $
			binsize = 2))], /ys, xtit = 'V0 (km/s)'
			
	h_1 = histogram((res[1,*]*1e3), binsize = 2)
	
	x_1 = findgen(108000)/10
	
	y_1 = max(h_1)*exp(-(x_1-p2[0])^2/(2.0D*s2^2))
	
	oplot, x_1, y_1, color = 3, thick = 2

	legend, ['Mean V0 = ' + num2str(p2[0]), 'Std Dev = ' + num2str(s2)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

	x2png, 'SGM_histogram_1_1.png'



end