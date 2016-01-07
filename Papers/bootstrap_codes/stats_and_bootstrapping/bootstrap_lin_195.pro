pro bootstrap_lin_195, date, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, conf_range_r, $
		conf_range_v, plot_on=plot_on, print_on=print_on
		
	!p.multi = [0, 1, 3]

;	window, 0, xs = 1000, ys = 1000
	
	num_data=100

; Calculate the step-size
	
	x = linspc(10.0d, 1800.0d, num_data)

; Known equation we want to recover (100 data points)

	resolve_routine, 'data_fit_195_linear'

	data_fit_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, perror

	y = f_195_lin[0] + f_195_lin[1]*x
	
; Number of iterations	
	num_iter=50000

; result array

	res = dblarr(2, num_iter)
	
; Add Gaussian noise mean=0, sigma =1 of differing amplitudes to m and c params

	cnoise = RANDOMN( Seed1, 100.0d , /DOUBLE, /NORMAL )*perror[0] + f_195_lin[0]
	mnoise = RANDOMN( Seed2, 100.0d , /DOUBLE, /NORMAL )*perror[1] + f_195_lin[1]

; Noisy data

	yp = x*mnoise + cnoise
	
;	rms = 0.1
;	yp = y +randomn(seed,num_data) * rms	
;	sn = ROUND(100*rms/ MEAN(y))
	
; Normal fit to data

	origfit = poly_fit(x, yp, 1, sigma = origerrs)
	yfit = origfit[1]*x + origfit[0]
    
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

		res[*,i] = poly_fit(x, yr, 1)
		
	endfor
	
; Calculate the moments of the results arrays for m and c

	p1 = moment(res[0,*], sdev=s1)
	p2 = moment(res[1,*], sdev=s2)

	set_line_color
	!p.multi = [0, 1, 3]

;	!p.charsize=1.2

; All plotting and printing from here down

	if (keyword_set(plot_on)) then begin

; Plot original data and noisy data

		plot, x, y, Title ='Original and noisy data - ' + num2str(date) + ' event', xtit='X', ytit='Y', charsize=2.0, background = 1, color = 0, thick = 2, $
				xrange = [0, max(x)], /xs
		oplot, x, yp, color=3, thick = 2
		legend,['Actual','Noisy Data @ '+arr2str(100,/trim)+'% of original error'],linestyle=[0,0], colors=[0, 3], chars=1.2, /right, /bottom, /clear, $
				textcolor = [0,3]

	endif

; Plot histograms and over plot Gaussian with mean and sigma just calculated

		plot_hist2, res[0,*], xr,hr, bin=0.01, /xs, xrange=[p1[0] - 3*s1, p1[0] + 3*s1], charsize=2.0,/density,tit='C', color = 0, $
			/nodisp

	if (keyword_set(plot_on)) then begin

		plots, [f_195_lin[0], f_195_lin[0]], [0, max(hr)], color=3
		plots, [p1[0], p1[0]], [0, max(hr)], color=5
;		verline, 10.0d, color=3
;		verline, p1[0], color=5, lines=2
		legend,['Actual - mean: '+num2str(f_195_lin[0]) + ', sigma: '+num2str(perror[0]), $
				'Calculated - mean: '+num2str(p1[0]) + ', sigma: '+num2str(s1)],colors=[3, 0], /right, $
				chars=1.2, textcolor = [3, 0], /clear

	endif

		j = linspc(f_195_lin[0] - 20, f_195_lin[0] + 20, 100)
	
; ***** Still have to work out where the extra factor of 100.0d come from
; ***** I think its to to with binning, but this is only for display any way

	if (keyword_set(plot_on)) then begin

		oplot, j, (1./100.)*(1.0d/(s1*sqrt(2.0d*!dpi)))*exp(-((j-p1[0])/s1)^2.0/2.0d), color=3, thick = 2
;		xyouts, 7.1, 90, 'Mean: '+string(p1[0])+', Sigma: '+string(s1), chars=1.2, color = 0

	endif
	
		plot_hist2, res[1,*], xv, hv, bin=0.00001, /xs, xr=[p2[0] - 3*s2, p2[0] + 3*s2], /nodisp, $
				charsize=2.0,/density,tit='M', color = 0

	if (keyword_set(plot_on)) then begin

		plots, [f_195_lin[1], f_195_lin[1]], [0, max(hv)], color=3
		plots, [p2[0], p2[0]], [0, max(hv)], color=5
;		verline, 0.5d, color=3
;		verline, p2[0], color=5, lines=2
		legend,['Actual - mean: '+num2str(f_195_lin[1]) + ', sigma: '+num2str(perror[1]), $
				'Calculated - mean: '+num2str(p2[0]) + ', sigma: '+num2str(s2)],colors=[3, 0], /right, $
				chars=1.2, textcolor = [3, 0], /clear

	endif
			
		k = linspc(f_195_lin[1] - 20, f_195_lin[1] + 20, 100)
	
; ***** Same here but factor of 10.0d here (bin size changed by factor of 10?!?)

	if (keyword_set(plot_on)) then begin

		oplot, k, (1./1000.)*(1.0d/(s2*sqrt(2.0d*!dpi)))*exp(-((k-p2[0])/s2)^2.0/2.0d), color=3, thick = 2
;		xyouts, 0.405, 280, 'Mean: '+string(p2[0])+', Sigma: '+string(s2), chars=1.2, color = 0

	endif	
	
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
	
	if (keyword_set(print_on)) then begin
	
		print,'     	Mean,       Median, 	Mode'
		print,'C',average_r
    	print,'M',average_v	
	
		print,'****'
		print,''
	
; Print out some comparisons 

		Print, 'Original line def y = ' + num2str(f_195_lin[1]) + '*x + ' + num2str(f_195_lin[0])
		print, 'R0 = ' + num2str(f_195_lin[0]) + ' Mm, v0 = ' + num2str(1000*f_195_lin[1]) + ' km/s'
		Print, 'Standard fitting  m = '+string(origfit[1])+' err = '+string(origerrs[1])
		Print, 'Standard fitting  c = '+string(origfit[0])+' err = '+string(origerrs[0])
		Print, 'Boot strapping  m = '+string(p2[0])+' err = '+string(s2)
		Print, 'Boot strapping  c = '+string(p1[0])+' err = '+string(s1)
		Print, 'm = [ '+string(p2[0]-2.0*s2)+', '+string(p2[0]+2.0d*s2)+'] @ 2 sigma (95%) Confidence'
		Print, 'c = [ '+string(p1[0]-2.0*s1)+', '+string(p1[0]+2.0d*s1)+'] @ 2 sigma (95%) Confidence'
	
		print,''
		print,'**In the limit of the spread of the distribution being purely Gaussian**'
		print,'**The mean, mode and median will be equal**'
		print,'** and the 2 sigma confidence will be equal to the 95% confidence range'
		print,''
	
		print,'     	Mean,       Median, 	Mode'
		print,'C',average_r
	   	print,'M',average_v	
	
	
		print,'The ',arr2str(100*(1.-alpha_v),/trim),'% confidence range of V is [',arr2str(conf_range_v),' ]'
		print,'The ',arr2str(100*(1.-alpha_r),/trim),'% confidence range of R is [',arr2str(conf_range_r),' ]'
		print, ' '
		print, 'These results imply that for the linear fit to the ' + num2str(date) + ' event:'
		print, ' '
		print,'The ',arr2str(100*(1.-alpha_v),/trim),'% confidence range of V0 is [',arr2str(1000*conf_range_v),' ] in km/s'
		print,'The ',arr2str(100*(1.-alpha_r),/trim),'% confidence range of R0 is [',arr2str(conf_range_r),' ] in Mm'
	
	endif	
	
end
