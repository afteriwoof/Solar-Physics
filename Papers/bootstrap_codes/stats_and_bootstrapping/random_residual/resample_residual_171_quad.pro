; Routine for the resampling residual bootstrapping method. 171A quadratic fit.

pro resample_residual_171_quad, date, grt_dist_171, time171, h_err, dist_arr_171, $
					f_171_quad, perror, p1, s1, p2, s2, p3, s3, conf_range_r, conf_range_v, $
					conf_range_a

	tim171 = time171 - time171[0]

; Zero a fit to data

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

    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)

	x = tim171

	x_arr = findgen(max(tim171))
	
	y_line = f_171_quad[0] + f_171_quad[1]*x_arr + (1./2.)*f_171_quad[2]*x_arr^2.

; result array

	arr_size = 100000.
	
	print, arr_size

	res = dblarr(3, arr_size)
	
; original fit to data

	yfit = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

; Loop over n! iterations to bootstrap

	for i =0L, arr_size-1 do begin

; Calculate residuals

		e = grt_dist_171 - yfit
		
; Generate number of data points random numbers between 0 and 100 from uniform distribution 

		ran = floor(RANDOMU( seed , dist_arr_171, /DOUBLE, /uniform)*(dist_arr_171-1.))
		
; Create array of 1 and -1 to multiply ran array by to fill gaps in resulting array

		unit_array = randomn(seed, dist_arr_171, /normal)
		
		unit_arr = unit_array/abs(unit_array)
		
; Randomly reassign the residuals

		er = e[ran]	* unit_arr
		
; Make new data with random residuals

		yr = grt_dist_171 + er
		
; New fit and store the results

		res[*,i] = poly_fit(x, yr, 2)
		
	endfor
	
; Calculate the moments of the results arrays for m and c

	p1 = moment(res[0,*], sdev=s1)
	p2 = moment((res[1,*]*1e3), sdev=s2)
	p3 = moment((res[2,*]*1e6), sdev=s3)
	
	window, 0, xs = 1000, ys = 1000
	!p.multi = [0, 1, 4]
	set_line_color

; Plot original data with fitted line

	plot, tim171, grt_dist_171, Title ='Original data and fit - 171 Quadratic', xtit='X', ytit='Y', charsize=2.0, $
		background = 1, color = 0, xr = [-50, max(tim171) + 50], /xs, yr = [0, max(grt_dist_171) + 50], /ys, $
		psym = 2
	oplot, x_arr, y_line, color=3
	legend,['Data', 'Fit: r = '+ num2str(f_171_quad[0]) + ' + ' + num2str(f_171_quad[1]) + '*x + !U1!N/!D2!N ' + $
		num2str(f_171_quad[2]) + '*x!U2!N'], colors=[0, 3], chars=1.2, /right, /bottom, /clear, textcolor = [0, 3]

; Plot histogram of intercept parameter bootstrapping data

	plot_hist2, res[0,*], xr, hr, bin = 3, color = 0, charsize = 2, title = 'R0', xtit = 'R0 - Mm', $
			xr = [p1[0] - 3*s1, p1[0] + 3*s1], /xs, yr = [0, 1.1*max(histogram(res[0,*], binsize = 3))], /ys
	
	h_0 = histogram(res[0, *], binsize = 3)
	
	x_0 = findgen(10000)/10
	
	y_0 = max(h_0)*exp(-(x_0-p1[0])^2/(2.*s1^2))

;	oplot, x_0, y_0, color = 3, thick = 2

	legend, ['Mean R0 = ' + num2str(p1[0]), 'Std Dev = ' + num2str(s1)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

; Plot histogram of slope parameter bootstrapping data

	plot_hist2, (res[1,*]*1e3), xv, hv, bin = 3, color = 0, charsize = 2, title = 'V0', $
			xr = [p2[0] - 3*s2, p2[0] + 3*s2], /xs, yr = [0, 1.1*max(histogram((res[1,*]*1e3), $
			binsize = 3))], /ys, xtit = 'V0 - km/s'
			
	h_1 = histogram((res[1,*]*1e3), binsize = 3)
	
	x_1 = findgen(10000)/10
	
	y_1 = max(h_1)*exp(-(x_1-p2[0])^2/(2.0D*s2^2))
	
;	oplot, x_1, y_1, color = 3, thick = 2

	legend, ['Mean V0 = ' + num2str(p2[0]), 'Std Dev = ' + num2str(s2)], textcolors = [3, 3], $
		/top, /right, chars = 1.2

; Plot histogram of slope parameter bootstrapping data

	plot_hist2, (res[2,*]*1e6), xa, ha, bin = 3, color = 0, charsize = 2, title = 'A0', $
			xr = [p3[0] - 3*s3, p3[0] + 3*s3], /xs, yr = [0, 1.1*max(histogram((res[2,*]*1e6), $
			binsize = 3))], /ys, xtit = 'A0 - m/s/s'
			
	h_2 = histogram((res[2,*]*1e6), binsize = 3)
	
	x_2 = findgen(10000)/10 - 500.
	
	y_2 = max(h_2)*exp(-(x_2-p3[0])^2/(2.0D*s3^2))
	
;	oplot, x_2, y_2, color = 3, thick = 2

	legend, ['Mean A0 = ' + num2str(2.*p3[0]), 'Std Dev = ' + num2str(s3)], textcolors = [3, 3], /top, /right, chars = 1.2

;calculate the confidence interval without trying to make the distribution gaussian
	
	average_r = [average(res[0,*]),median(res[0,*]),xr[where(hr EQ max(hr))] ]
	alpha_r = 0.05
	q1_r = arr_size * alpha_r / 2.
	q2_r = arr_size - q1_r +1
	sort_r = (res[0,*])[SORT(res[0,*])]
	conf_range_r = [sort_r[q1_r],sort_r[q2_r]]
	
	
	average_v = [average(res[1,*]),median(res[1,*]),xv[where(hv EQ max(hv))] ]
	alpha_v = 0.05
	q1_v = arr_size * alpha_v / 2.
	q2_v = arr_size - q1_v +1
	sort_v = (res[1,*])[SORT(res[1,*])]
	conf_range_v = [sort_v[q1_v],sort_v[q2_v]]

	average_a = [average(res[2,*]),median(res[2,*]),xa[where(ha EQ max(ha))] ]
	alpha_a = 0.05
	q1_a = arr_size * alpha_a / 2.
	q2_a = arr_size - q1_a +1
	sort_a = (res[2,*])[SORT(res[2,*])]
	conf_range_a = [sort_a[q1_a],sort_a[q2_a]]

end