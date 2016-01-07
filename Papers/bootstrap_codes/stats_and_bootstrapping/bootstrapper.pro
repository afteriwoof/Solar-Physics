pro bootstrapper

	x = linspc(10.0d, 50.0d, 100.0d)
	; Known equation we want to recover (100 data points)
	y = 0.5d*x + 10.0d
	
	; result array
	res = dblarr(2, 10000)
	
	; Add Gaussian noise mean=0, sigma =1 of differing amplitudes to m and c params
	cnoise = RANDOMN( Seed1, 100.0d , /DOUBLE, /NORMAL )*2.0d + 10.0d
	mnoise = RANDOMN( Seed2, 100.0d , /DOUBLE, /NORMAL )*0.01 + 0.5d

	; Noisy data
	yp = x*mnoise + cnoise
	
	; Normal fit to data
	origfit = poly_fit(x, yp, 1, sigma = origerrs)
	yfit = origfit[1]*x + origfit[0]
    
    ; Loop over 10,000 iterations to bootstrap
	for i =0, 10000-1 do begin
		; Calculate residuals
		e = yp - yfit
		
		; Generate 100 random numbers between 0 and 100 from uniform distribution 
		ran = floor(RANDOMU( seed , 100.0d, /DOUBLE, /uniform)*100.0d)
		
		; Randomly reassign the residuals
		er = e[ran]	
		
		; Make new data with random residuals
		yr = yfit + er
		
		; New fit and store the results
		res[*,i] = poly_fit(x, yr, 1)
		
	endfor
	
	; Calculate the moments of the results arrays for m and c
	p1 = moment(res[0,*], sdev=s1)
	p2 = moment(res[1,*], sdev=s2)
	
	!p.multi = [0, 1, 3]
	set_line_color
	
	;!p.charsize=1.2
	; All plotting and printing from here down
	
	; Plot original data and noisy data
	plot, x, y, Title ='Original and noisy data', xtit='X', ytit='Y', charsize=2.0, background = 1, color = 0
	oplot, x, yp, color=3
	legend,['Actual','Noisy'],linestyle=[0,0], colors=[0, 3], chars=1.2, /right, /bottom, /clear, textcolor = [0, 3]
	
	; Plot histograms and over plot Gaussian with mean and sigma just calculated
	plot_hist, res[0,*], bin=0.01, /xs, xr=[7, 13], charsize=2.0, color = 0
;	verline, 10.0d, color=4
;	verline, p1[0], color=5, lines=2
	legend,['Actual','Calculated'],linestyle=[0,2], colors=[4, 5], /right, chars=1.2, textcolor = [4, 5]

	j = linspc(7.0d, 13.0d, 100)
	
	; ***** Still have to work out where the extra factor of 100.0d come from
	; ***** I think its to to with binning, but this is only for display any way
	oplot, j, (1.0d/(s1*sqrt(2.0d*!dpi)))*exp(-((j-p1[0])/s1)^2.0/2.0d)*100.0d, color=3
	xyouts, 7.1, 90, 'Mean: '+string(p1[0])+', Sigma: '+string(s1), chars=1.2
	
	plot_hist, res[1,*], bin=0.001, /xs, xr=[0.40, 0.60], charsize=2.0, color = 0
;	verline, 0.5d, color=4
;	verline, p2[0], color=5, lines=2
	legend,['Actual','Calculated'],linestyle=[0,2], colors=[4, 5], /right, chars=1.2, textcolor = [4, 5]
	k = linspc(0.40, 0.60, 100)
	
	; ***** Same here but factor of 10.0d here (bin size changed by factor of 10?!?)
	oplot, k, (1.0d/(s2*sqrt(2.0d*!dpi)))*exp(-((k-p2[0])/s2)^2.0/2.0d)*10.0d, color=3
	xyouts, 0.405, 280, 'Mean: '+string(p2[0])+', Sigma: '+string(s2), chars=1.2
	
	; Print out some comparisons 
	Print, 'Original line def y =0.5*x + 10, m=0.5 and c=10.0'
	Print, 'Standard fitting  m = '+string(origfit[1])+' err = '+string(origerrs[1])
	Print, 'Standard fitting  c = '+string(origfit[0])+' err = '+string(origerrs[0])
	Print, 'Boot strapping  m = '+string(p2[0])+' err = '+string(s2)
	Print, 'Boot strapping  c = '+string(p1[0])+' err = '+string(s1)
	Print, 'm = [ '+string(p2[0]-2.0*s2)+', '+string(p2[0]+2.0d*s2)+'] @ 95% Confidence'
	Print, 'c = [ '+string(p1[0]-2.0*s1)+', '+string(p1[0]+2.0d*s1)+'] @ 95% Confidence'
	
end