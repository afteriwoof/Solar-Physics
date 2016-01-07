pro test_bootstrapper
    	
	num_data=100
	x = linspc(10.0d, 50.0d, num_data)

; Known equation we want to recover (100 data points)

	y = 0.5d*x + 10.0d
	
	
	num_iter=50000

; result array

	res = dblarr(2, num_iter)
	
; Add Gaussian noise mean=0, sigma =1 of differing amplitudes to m and c params

	;cnoise = RANDOMN( Seed1, 100.0d , /DOUBLE, /NORMAL )*2.0d + 10.0d
	;mnoise = RANDOMN( Seed2, 100.0d , /DOUBLE, /NORMAL )*0.01 + 0.5d

; Noisy data

	;yp = x*mnoise + cnoise
	
	rms = 2.5
	yp = y +randomn(seed,num_data) * rms	
	sn = ROUND(100*rms/ MEAN(y))
	
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
	;!p.charsize=1.2

; All plotting and printing from here down

; Plot original data and noisy data

	plot, x, y, Title ='Original and noisy data', xtit='X', ytit='Y', charsize=2.0, background = 1, color = 0
	oplot, x, yp, color=3
	legend,['Actual','Noisy '+arr2str(sn,/trim)+'%'],linestyle=[0,0], colors=[0, 3], chars=1.2, /right, /bottom, textcolor = [0,3]
	
; Plot histograms and over plot Gaussian with mean and sigma just calculated

	j = linspc(7.0d, 13.0d, 100)

	plot_hist2, res[0,*], xc,hc, bin=0.01, /xs, xr=[7, 13], charsize=2.0,/density,tit='C', color = 0
	plots, [10.0d, 10.0d], [0, 0.008], color=3
	plots, [p1[0], p1[0]], [0, 0.008], color=5
;	verline, 10.0d, color=3
;	verline, p1[0], color=5, lines=2
	legend,['Actual','Calculated'],linestyle=[0,2], colors=[3, 5], /right, chars=1.2, textcolor = [3,5]

	
; ***** Still have to work out where the extra factor of 100.0d comes from
; ***** I think its to to with binning, but this is only for display any way

	oplot, j, (1./100.)*(1.0d/(s1*sqrt(2.0d*!dpi)))*exp(-((j-p1[0])/s1)^2.0/2.0d), color=4
	xyouts, 7.1, 90, 'Mean: '+string(p1[0])+', Sigma: '+string(s1), chars=1.2
	
	plot_hist2, res[1,*], xm, hm, bin=0.001, /xs, xr=[0.40, 0.60], charsize=2.0,/density,tit='M', color = 0
	plots, [0.5d, 0.5d], [0, 0.02], color=3
	plots, [p2[0], p2[0]], [0, 0.02], color=5
;	verline, 0.5d, color=3
;	verline, p2[0], color=5, lines=2
	legend,['Actual','Calculated'],linestyle=[0,2], colors=[3, 5], /right, chars=1.2, textcolor = [3,5]
	k = linspc(0.40, 0.60, 100)
	
; ***** Same here but factor of 10.0d here (bin size changed by factor of 10?!?)

	oplot, k, (1./1000.)*(1.0d/(s2*sqrt(2.0d*!dpi)))*exp(-((k-p2[0])/s2)^2.0/2.0d), color=4
	xyouts, 0.405, 280, 'Mean: '+string(p2[0])+', Sigma: '+string(s2), chars=1.2
	
	
;calculate the confidence interval without trying to make the distribution gaussian
	
	average_c = [average(res[0,*]),median(res[0,*]),xc[where(hc EQ max(hc))] ]
	alpha_c = 0.05
	q1_c = num_iter * alpha_c / 2.
	q2_c = num_iter - q1_c +1
	sort_c = (res[0,*])[SORT(res[0,*])]
	conf_range_c = [sort_c[q1_c],sort_c[q2_c]]
	
	
	average_m = [average(res[1,*]),median(res[1,*]),xm[where(hm EQ max(hm))] ]
	alpha_m = 0.05
	q1_m = num_iter * alpha_c / 2.
	q2_m = num_iter - q1_m +1
	sort_m = (res[1,*])[SORT(res[1,*])]
	conf_range_m = [sort_m[q1_m],sort_m[q2_m]]
	
	
	print,'     	Mean,       Median, 	Mode'
	print,'C',average_c
   	print,'M',average_m	
	
	print,'****'
	print,''
	
	; Print out some comparisons 
	Print, 'Original line def y =0.5*x + 10, m=0.5 and c=10.0'
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
	print,'C',average_c
  	print,'M',average_m	
	
	
	print,'The ',arr2str(100*(1.-alpha_m),/trim),'% confidence range of M is [',arr2str(conf_range_m),' ]'
	print,'The ',arr2str(100*(1.-alpha_c),/trim),'% confidence range of C is [',arr2str(conf_range_c),' ]'
	
	
	
	
	
	
end
