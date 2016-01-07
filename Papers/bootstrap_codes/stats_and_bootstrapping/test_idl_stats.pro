; Routine to test availability of IDL statistics package

pro test_idl_stats

	date = 20070519

	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)


	x = time195
	y = grt_dist_195

	degree = 2 
	coefs = IMSL_POLYREGRESS(x, y, degree, $ 
		Anova_Table    = anova_table, predict_info   = predict_info)
		

; Call IMSL_POLYREGRESS to compute the fit.

	predicted = IMSL_POLYPREDICT(predict_info, x, $ 
	   Ci_Scheffe = ci_scheffe, Y = y, Dffits = dffits)  

; Call IMSL_POLYPREDICT.  

	PLOT, x, ci_scheffe(1, *), Yrange = [0, max(y) + 100], Linestyle = 2  

; Plot the results; confidence bands are dashed lines.  

	OPLOT, x, ci_scheffe(0, *), Linestyle = 2  
	OPLOT, x, y, Psym = 4  

;	x2 = 7 * FINDGEN(100)/99  

;	OPLOT, x2, IMSL_POLYPREDICT(predict_info, x2)  

	print_results, anova_table  






end