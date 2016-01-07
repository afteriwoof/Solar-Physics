pro bootstrap_quad, date, event
    	
	!p.multi = [0, 1, 3]

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
	
	num_data=100

; Calculate the step-size
	
	x = linspc(10.0d, 1800.0d, num_data)

; Known equation we want to recover (100 data points)

	resolve_routine, 'data_fit_195_quadratic'

	data_fit_195_quadratic, grt_dist_195, time195, h_err, dist_arr_195, f_195_quad, perror

	y = f_195_quad[0] + f_195_quad[1]*x + (1./2.)*f_195_quad[2]*x^2.
	
; Number of iterations	
	num_iter=50000

; result array

	res = dblarr(3, num_iter)
	
; Add Gaussian noise mean=0, sigma =1 of differing amplitudes to m and c params

	rnoise = RANDOMN( Seed1, 100.0d , /DOUBLE, /NORMAL )*perror[0] + f_195_quad[0]
	vnoise = RANDOMN( Seed2, 100.0d , /DOUBLE, /NORMAL )*perror[1] + f_195_quad[1]
	anoise = RANDOMN( Seed3, 100.0d , /DOUBLE, /NORMAL )*perror[2] + f_195_quad[2]

; Noisy data

	yp = rnoise + x*vnoise + (x^2.)*(1./2.)*anoise
	
;	rms = 0.1
;	yp = y +randomn(seed,num_data) * rms	
;	sn = ROUND(100*rms/ MEAN(y))
	
; Normal fit to data

	origfit = poly_fit(x, yp, 2, sigma = origerrs)
	yfit = origfit[0] + origfit[1]*x + origfit[2]*(x^2.)*(1./2.)  

; Loop over 10,000 iterations to bootstrap

	for i =0L, num_iter-1 do begin

; Calculate residuals

		e = yp - yfit
		
; Generate num_data random numbers between 0 and num_data from uniform distribution 

		ran = floor(RANDOMU( seed , num_data, /DOUBLE, /uniform)*num_data)
		
; Randomly reassign the residuals

		er = e[ran]	
		
; Make new data with random residuals

		yr = yp + er
		
; New fit and store the results

		res[*,i] = poly_fit(x, yr, 2)
		
	endfor
	
; Calculate the moments of the results arrays for m and c

	p1 = moment(res[0,*], sdev=s1)
	p2 = moment(res[1,*], sdev=s2)
	p3 = moment(res[2,*], sdev=s3)

	set_line_color
	!p.multi = [0, 1, 4]

;	!p.charsize=1.2

; All plotting and printing from here down
	
; Plot original data and noisy data

	plot, x, y, Title ='Original and noisy data - ' + num2str(date) + ' event', xtit='X', ytit='Y', charsize=2.0, $
			background = 1, color = 0, thick = 2, xr = [0, max(x)], /xs
	oplot, x, yp, color=3, thick = 2
	legend,['Actual','Noisy Data @ '+arr2str(100,/trim)+'% of original error'],linestyle=[0,0], colors=[0, 3], $
			chars=1.2, /right, /bottom, /clear, textcolor = [0,3]

; Plot histograms and over plot Gaussian with mean and sigma just calculated

	plot_hist2, res[0,*], xr,hr, bin=0.01, /xs, xr=[p1[0] - 3*s1, p1[0] + 3*s1], charsize=2.0,/density,tit='R0', color = 0
	plots, [f_195_quad[0], f_195_quad[0]], [0, max(hr)], color=3
	plots, [p1[0], p1[0]], [0, max(hr)], color=5
;	verline, 10.0d, color=3
;	verline, p1[0], color=5, lines=2
	legend,['Actual value: '+num2str(f_195_quad[0]) + ', error: '+num2str(perror[0]), $
			'Calculated - mean: '+num2str(p1[0]) + ', sigma: '+num2str(s1)],colors=[3, 0], /right, $
			chars=1.2, textcolor = [3, 0], /clear

	j = linspc(p1[0] - 3*s1, p1[0] + 3*s1, 100)
	
; ***** Still have to work out where the extra factor of 100.0d come from
; ***** I think its to to with binning, but this is only for display any way

	oplot, j, (1./100.)*(1.0d/(s1*sqrt(2.0d*!dpi)))*exp(-((j-p1[0])/s1)^2.0/2.0d), color=3, thick = 2
;	xyouts, 7.1, 90, 'Mean: '+string(p1[0])+', Sigma: '+string(s1), chars=1.2, color = 0
	
	plot_hist2, res[1,*], xv, hv, bin=0.00001, /xs, xr=[p2[0] - 3*s2, p2[0] + 3*s2], $
			charsize=2.0,/density,tit='V0', color = 0
	plots, [f_195_quad[1], f_195_quad[1]], [0, max(hv)], color=3
	plots, [p2[0], p2[0]], [0, max(hv)], color=5
;	verline, 0.5d, color=3
;	verline, p2[0], color=5, lines=2
	legend,['Actual value: '+num2str(f_195_quad[1]) + ', error: '+num2str(perror[1]), $
			'Calculated - mean: '+num2str(p2[0]) + ', sigma: '+num2str(s2)],colors=[3, 0], /right, $
			chars=1.2, textcolor = [3, 0], /clear
			
	k = linspc(p2[0] - 3*s2, p2[0] + 3*s2, 100)
	
; ***** Same here but factor of 10.0d here (bin size changed by factor of 10?!?)

	oplot, k, (1./100000.)*(1.0d/(s2*sqrt(2.0d*!dpi)))*exp(-((k-p2[0])/s2)^2.0/2.0d), color=3, thick = 2
;	xyouts, 0.405, 280, 'Mean: '+string(p2[0])+', Sigma: '+string(s2), chars=1.2, color = 0


	plot_hist2, res[2,*], xa, ha, bin=0.0000001, /xs, xr=[p3[0] - 3*s3, p3[0] + 3*s3], $
			charsize=2.0,/density,tit='V0', color = 0
	plots, [f_195_quad[2], f_195_quad[2]], [0, max(ha)], color=3
	plots, [p3[0], p3[0]], [0, max(ha)], color=5
;	verline, 0.5d, color=3
;	verline, p2[0], color=5, lines=2
	legend,['Actual value: '+num2str(f_195_quad[2]) + ', error: '+num2str(perror[2]), $
			'Calculated - mean: '+num2str(p3[0]) + ', sigma: '+num2str(s3)],colors=[3, 0], /right, $
			chars=1.2, textcolor = [3, 0], /clear
			
	k = linspc(p3[0] - 3*s3, p3[0] + 3*s3, 100)
	
; ***** Same here but factor of 10.0d here (bin size changed by factor of 10?!?)

	oplot, k, (1./10000000.)*(1.0d/(s3*sqrt(2.0d*!dpi)))*exp(-((k-p3[0])/s3)^2.0/2.0d), color=3, thick = 2
;	xyouts, 0.405, 280, 'Mean: '+string(p2[0])+', Sigma: '+string(s2), chars=1.2, color = 0
	
	
;calculate the confidence interval without trying to make the distribution gaussian
	
	average_r = [average(res[0,*]),median(res[0,*]),xr[where(hr EQ max(hr))] ]
	alpha_r = 0.05
	q1_r = num_iter * alpha_r / 2.
	q2_r = num_iter - q1_r +1
	sort_r = (res[0,*])[SORT(res[0,*])]
	conf_range_r = [sort_r[q1_r],sort_r[q2_r]]
	
	
	average_v = [average(res[1,*]),median(res[1,*]),xv[where(hv EQ max(hv))] ]
	alpha_v = 0.05
	q1_v = num_iter * alpha_v / 2.
	q2_v = num_iter - q1_v +1
	sort_v = (res[1,*])[SORT(res[1,*])]
	conf_range_v = [sort_v[q1_v],sort_v[q2_v]]

	average_a = [average(res[2,*]),median(res[2,*]),xa[where(ha EQ max(ha))] ]
	alpha_a = 0.05
	q1_a = num_iter * alpha_a / 2.
	q2_a = num_iter - q1_a +1
	sort_a = (res[2,*])[SORT(res[2,*])]
	conf_range_a = [sort_a[q1_a],sort_a[q2_a]]
	
	
	print,'     	Mean,       Median, 	Mode'
	print,'R0',average_r
   	print,'V0',average_v	
   	print,'A0',average_a	
	
	print,'****'
	print,''
	
; Print out some comparisons 

	Print, 'Original line def y = (!U1!N/!D2!N)' + num2str(f_195_quad[2]) + 'x!U2!N + ' + num2str(f_195_quad[1]) + $
			'*x + ' + num2str(f_195_quad[0])
	print, 'R0 = ' + num2str(f_195_quad[0]) + ' Mm, v0 = ' + num2str(1000*f_195_quad[1]) + ' km/s, a0 = ' + $
			 num2str(1e6*f_195_quad[2]) + ' m/s/s
	Print, 'Standard fitting  a0 = '+string(origfit[2])+' err = '+string(origerrs[2])
	Print, 'Standard fitting  v0 = '+string(origfit[1])+' err = '+string(origerrs[1])
	Print, 'Standard fitting  r0 = '+string(origfit[0])+' err = '+string(origerrs[0])
	print, ' '
	Print, 'Boot strapping  a0 = '+string(p3[0])+' err = '+string(s3)
	Print, 'Boot strapping  v0 = '+string(p2[0])+' err = '+string(s2)
	Print, 'Boot strapping  r0 = '+string(p1[0])+' err = '+string(s1)
	print, ' '
	Print, 'a0 = [ '+string(p3[0]-2.0*s3)+', '+string(p3[0]+2.0d*s3)+'] @ 2 sigma (95%) Confidence'
	Print, 'v0 = [ '+string(p2[0]-2.0*s2)+', '+string(p2[0]+2.0d*s2)+'] @ 2 sigma (95%) Confidence'
	Print, 'r0 = [ '+string(p1[0]-2.0*s1)+', '+string(p1[0]+2.0d*s1)+'] @ 2 sigma (95%) Confidence'
	
	print,''
	print,'**In the limit of the spread of the distribution being purely Gaussian**'
	print,'**The mean, mode and median will be equal**'
	print,'** and the 2 sigma confidence will be equal to the 95% confidence range'
	print,''
	
	print,'     	Mean,       Median, 	Mode'
	print,'r0',average_r
   	print,'v0',average_v	
   	print,'a0',average_a	
	
	
	print,'The ',arr2str(100*(1.-alpha_a),/trim),'% confidence range of a0 is [',arr2str(conf_range_a),' ]'
	print,'The ',arr2str(100*(1.-alpha_v),/trim),'% confidence range of v0 is [',arr2str(conf_range_v),' ]'
	print,'The ',arr2str(100*(1.-alpha_r),/trim),'% confidence range of r0 is [',arr2str(conf_range_r),' ]'
	print, ' '
	print, 'These results imply that for the linear fit to the ' + num2str(date) + ' event:'
	print, ' '
	print,'The ',arr2str(100*(1.-alpha_a),/trim),'% confidence range of A0 is [',arr2str(1e6*conf_range_a),' ] in m/s/s'
	print,'The ',arr2str(100*(1.-alpha_v),/trim),'% confidence range of V0 is [',arr2str(1000*conf_range_v),' ] in km/s'
	print,'The ',arr2str(100*(1.-alpha_r),/trim),'% confidence range of R0 is [',arr2str(conf_range_r),' ] in Mm'
	
	
	
	
	
	
end
