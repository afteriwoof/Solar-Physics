; routine to tes the resampled residual bootstrapping method.

pro resample_residual_test, date

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

	arr_size = factorial(dist_arr_195)
	
	print, arr_size

	res = dblarr(2, arr_size)
	
; original fit to data

	yfit = f_195_lin[1]*tim195 + f_195_lin[0]

; Loop over n! iterations to bootstrap

	for i =0, arr_size-1 do begin

; Calculate residuals

		e = grt_dist_195 - yfit
		
; Generate number of data points random numbers between 0 and 100 from uniform distribution 

		ran = floor(RANDOMU( seed , dist_arr_195, /DOUBLE, /uniform)*(dist_arr_195-1.))
		
; Randomly reassign the residuals

		er = e[ran]	
		
; Make new data with random residuals

		yr = grt_dist_195 + er
		
; New fit and store the results

		res[*,i] = poly_fit(x, yr, 1)
		
	endfor
	
; Calculate the moments of the results arrays for m and c

	p1 = moment(res[0,*], sdev=s1)
	p2 = moment(res[1,*], sdev=s2)
	
	window, 0, xs = 750, ys = 1000
	!p.multi = [0, 1, 3]
	set_line_color

; Plot original data with fitted line

	plot, x_arr, y_line, Title ='Original and noisy data', xtit='X', ytit='Y', charsize=2.0, background = 1, color = 0
	oplot, tim195, grt_dist_195, color=3, psym = 2
	legend,['Actual','Noisy'],linestyle=[0,0], colors=[0, 3], chars=1.2, /right, /bottom, /clear, textcolor = [0, 3]

; Plot histogram of intercept parameter bootstrapping data

	plot_hist, res[0,*], bin = 1, color = 0, charsize = 2, title = 'Intercept Parameter', $
			xr = [p1[0] - 3*s1, p1[0] + 3*s1], /xs, yr = [0, 1.1*max(histogram(res[0,*]))], /ys
	
; Plot of Probability Distribution function with same mean and standard deviation as data
;
;	x = findgen(s1*300.) / 10. - s1*3.
;	
;	gaussian = max(histogram(res[0,*])) * exp(-(x - p1[0])^2./(2.*s1^2.))
;
;	oplot, x, gaussian, color = 0
;
;	gaussian_std_dev = max(histogram(res[0,*])) * exp(-(s1 - p1[0])^2./(2.*s1^2.))
;
;	oplot, [s1, s1], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 3
;	oplot, [-s1, -s1], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 3

	legend, ['Mean c = ' + num2str(p1[0]), 'Std Dev = ' + num2str(s1)], textcolors = [3, 3], /top, /right, chars = 1.2

; Plot histogram of slope parameter bootstrapping data

	plot_hist, res[1,*], bin = 0.001, color = 0, charsize = 2, title = 'Slope Parameter', $
			xr = [p2[0] - 3*s2, p2[0] + 3*s2], /xs, yr = [0, 1.1*max(histogram(res[1,*], binsize = 0.001))], /ys

; Plot of Probability Distribution function with same mean and standard deviation as data
;
;	x_0 = findgen(s2*3000.) / 1000. - s2*3.
;	
;	gaussian_0 = max(histogram(res[1,*], binsize = 0.001)) * exp(-(x - p2[0])^2./(2.*s2^2.))
;
;	oplot, x_0, gaussian_0, color = 0
;
;	gaussian_std_dev = max(histogram(res[1,*], binsize = 0.001)) * exp(-(s2 - p2[0])^2./(2.*s2^2.))
;
;	oplot, [s2, s2], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0
;	oplot, [-s2, -s2], [0, gaussian_std_dev], linestyle = 2, thick = 2, color = 0

	legend, ['Mean m = ' + num2str(p2[0]), 'Std Dev = ' + num2str(s2)], textcolors = [3, 3], /top, /right, chars = 1.2

	x2png, 'resampled_residuals_' + num2str(date) + '_195.png'


stop


end