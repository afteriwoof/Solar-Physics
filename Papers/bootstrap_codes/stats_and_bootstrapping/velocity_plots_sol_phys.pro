; Routine to make the plots of fits to distance data and derived velocity data for the Solar Physics 
; paper. This routine makes the 195A and 171A plots for each event and also the 171A vs 195A velocity
; plots for both fits and the 171A vs CME velocity plots for each fit.

pro velocity_plots_sol_phys

	!p.multi = [0, 1, 2]
	
;	window, 0, xs = 750, ys = 750
	
	set_line_color

	v_0_t_195 = fltarr(7)
	v_0_p_195 = fltarr(7)
	
	v_0_t_171 = fltarr(7)
	v_0_p_171 = fltarr(7)

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20070516_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20070516_dist.sav'

	time195 = anytim('2007/05/16' + ' ' + t195)
	time171 = anytim('2007/05/16' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 31, grt_dist_195 - 31, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [31., 31., 31., 31., 31., 31.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

	f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [31., 31., 31., 31., 31., 31.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2.
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20070516 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 1.183', 'Fit B, !7v!6!U2!N = 1.186'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[0] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[0] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (31.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20070516_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 31, grt_dist_171 - 31, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [31., 31., 31., 31., 31., 31.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [31., 31., 31., 31., 31., 31.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20070516 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 1.2', 'Fit B, !7v!6!U2!N = 1.2'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[0] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[0] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (31.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20070519_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20070519_dist.sav'

	time195 = anytim('2007/05/19' + ' ' + t195)
	time171 = anytim('2007/05/19' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 39, grt_dist_195 - 39, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [39., 39., 39., 39., 39., 39.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [39., 39., 39., 39., 39., 39.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20070519 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 3.2', 'Fit B, !7v!6!U2!N = 3.2'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[1] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[1] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (39.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20070519_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 39, grt_dist_171 - 39, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [39., 39., 39., 39., 39., 39.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [39., 39., 39., 39., 39., 39.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20070519 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.122', 'Fit B, !7v!6!U2!N = 0.126'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[1] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[1] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (39.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20070806_1_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20070806_1_dist.sav'

	time195 = anytim('2007/08/06' + ' ' + t195)
	time171 = anytim('2007/08/06' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 37, grt_dist_195 - 37, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [37., 37., 37., 37., 37., 37.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [37., 37., 37., 37., 37., 37.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20070806_1 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.251', 'Fit B, !7v!6!U2!N = 0.256'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[2] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[2] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (37.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20070806_1_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 37, grt_dist_171 - 37, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [37., 37., 37., 37., 37., 37.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [37., 37., 37., 37., 37., 37.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20070806_1 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.08', 'Fit B, !7v!6!U2!N = 0.08'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[2] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[2] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (37.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20070806_2_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20070806_2_dist.sav'

	time195 = anytim('2007/08/06' + ' ' + t195)
	time171 = anytim('2007/08/06' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 42, grt_dist_195 - 42, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [42., 42., 42., 42., 42., 42.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [42., 42., 42., 42., 42., 42.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20070806_2 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.159', 'Fit B, !7v!6!U2!N = 0.174'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[3] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[3] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (42.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20070806_2_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 42, grt_dist_171 - 42, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [42., 42., 42., 42., 42., 42.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [42., 42., 42., 42., 42., 42.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20070806_2 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.0001', 'Fit B, !7v!6!U2!N = 0.0001'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[3] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[3] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (42.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20071207_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20071207_dist.sav'

	time195 = anytim('2007/12/07' + ' ' + t195)
	time171 = anytim('2007/12/07' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 30, grt_dist_195 - 30, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [30., 30., 30., 30., 30., 30.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

	f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [30., 30., 30., 30., 30., 30.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20071207 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['R(t) = 31 + 0.268t - 0.000014t!U2!N, !7v!6!U2!N = 3.07'], $
			/bottom, /right, colors = [0], textcolor = [0], thick = 2, charsize = 1, $
			linestyle = [2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[4] = mean(v_model_0, /nan)

	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[4] = mean(v_model_1, /nan)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (30.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20071207_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 30, grt_dist_171 - 30, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [30., 30., 30., 30., 30., 30.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

	f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [30., 30., 30., 30., 30., 30.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20071207 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['R(t) = 35 + 0.228t + 0.0000667t!U2!N, !7v!6!U2!N = 1.172'], $
			/bottom, /right, colors = [0], textcolor = [0], thick = 2, charsize = 1, $
			linestyle = [2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[4] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[4] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (30.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20080107_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20080107_dist.sav'

	time195 = anytim('2008/01/07' + ' ' + t195)
	time171 = anytim('2008/01/07' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 32, grt_dist_195 - 32, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [32., 32., 32., 32., 32., 32.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [32., 32., 32., 32., 32., 32.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20080107 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.1804', 'Fit B, !7v!6!U2!N = 0.1866'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[5] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[5] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (32.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20080107_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 32, grt_dist_171 - 32, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [32., 32., 32., 32., 32., 32.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [32., 32., 32., 32., 32., 32.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20080107 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 0.04', 'Fit B, !7v!6!U2!N = 0.04'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[5] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[5] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (32.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; 20070516

; Restore grt_dist_195, grt_dist_171, t195, time_171

	toggle, /landscape, filename = 'data_plots_20080426_195.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	restore, '20080426_dist.sav'

	time195 = anytim('2008/04/26' + ' ' + t195)
	time171 = anytim('2008/04/26' + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time195[0]
	t171 = time171 - time171[0]

; Plot plain data

	utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
		timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_195)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, tim195, grt_dist_195 + 36, grt_dist_195 - 36, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [36., 36., 36., 36., 36., 36.]
	
	expr_195_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
	dh_195_0 = abs(grt_dist_195 - h_model_0)

	scatter_195_0 = (dh_195_0/grt_dist_195)*100.

; const a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_err = [36., 36., 36., 36., 36., 36.]
	
	expr_195_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_dist_195, h_err, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
	dh_195_1 = abs(grt_dist_195 - h_model_0)

	scatter_195_1 = (dh_195_1/grt_dist_195)*100.

	print, ' '
	print, '20080426 event 195A data:'
	print, ' '
	print, 'R0 = ', f_195_0[0]
	print, 'V0 = ', f_195_0[1]
	print, 'alpha = ', f_195_0[2]
	print, 'beta = ', f_195_0[3]
	print, 'R0 = ', f_195_1[0]
	print, 'V0 = ', f_195_1[1]
	print, 'A0 = ', f_195_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 1.78', 'Fit B, !7v!6!U2!N = 1.86'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(tim195))

	v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))

	v_0_p_195[6] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

	v_0_t_195[6] = mean(v_model_1)

	v_195 = deriv(tim195, grt_dist_195*1000)
	deltav_195 = derivsig(tim195, grt_dist_195*1000, 0.0, (36.*1000))

	utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

	toggle, /landscape, filename = 'data_plots_20080426_171.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

; Plot 171A data

	utplot, t171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
		timerange = [time171[0] - 60, max(time171) + 60], pos = [0.1, 0.54, 0.95, 0.95], $
		ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_dist_171)+50], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
		xtickname = [' ',' ',' ',' ',' ',' ',' ']
	uterrplot, t171, grt_dist_171 + 36, grt_dist_171 - 36, thick = 2, color = 0

; Blast wave variation fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [36., 36., 36., 36., 36., 36.]
	
	expr_171_0 = 'p[0] + p[1] * x + p[2]*x^p[3]'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
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
	pi(3).limited(0) = 1
	pi(3).limits(0) = 0.
	pi(3).limited(1) = 1
	pi(3).limits(1) = 4.

    f_171_0 = mpfitexpr(expr_171_0, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005, 2.], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_0, /quiet)

	oplot, xf, mpevalexpr(expr_171_0, x, f_171_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

	h_model_0 = f_171_0[0] + f_171_0[1]*t171 + f_171_0[2]*t171^f_171_0[3]
	dh_171_0 = abs(grt_dist_171 - h_model_0)

	scatter_195_0 = (dh_171_0/grt_dist_171)*100.

; const a fit to data

	xf = findgen( max(t171) )

	x = findgen( max(t171) )

	h_err = [36., 36., 36., 36., 36., 36.]
	
	expr_171_1 = 'p[0] + p[1] * x + p[2] * x^2.'

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

    f_171_1 = mpfitexpr(expr_171_1, t171, grt_dist_171, h_err, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_1, /quiet)

	oplot, xf, mpevalexpr(expr_171_1, x, f_171_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

	h_model_1 = f_171_1[0] + f_171_1[1]*t171 + f_171_1[2]*t171^2
	dh_171_1 = abs(grt_dist_171 - h_model_0)

	scatter_171_1 = (dh_171_1/grt_dist_171)*100.

	print, ' '
	print, '20080426 event 171A data:'
	print, ' '
	print, 'R0 = ', f_171_0[0]
	print, 'V0 = ', f_171_0[1]
	print, 'alpha = ', f_171_0[2]
	print, 'beta = ', f_171_0[3]
	print, 'R0 = ', f_171_1[0]
	print, 'V0 = ', f_171_1[1]
	print, 'A0 = ', f_171_1[2]
	print, ' '
	print, '1st chi-squared = ', bestnorm_0
	print, '2nd chi-squared = ', bestnorm_1
	print, ' '
	ans = ' '
	read, 'ok?', ans

; Legend for plot

	legend,['Fit A, !7v!6!U2!N = 4.3', 'Fit B, !7v!6!U2!N = 4.3'], $
			/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1, $
			linestyle = [0, 2], box = 0

; Plot of velocity

	x = findgen(max(t171))

	v_model_0 = 1000.*(f_171_0[1] + f_171_0[2]*f_171_0[3]*x^(f_171_0[3]-1.))

	v_0_p_171[6] = mean(v_model_0)
	    
	v_model_1 = 1000.*(f_171_1[1] + f_171_1[2]*x)

	v_0_t_171[6] = mean(v_model_1)

	v_171 = deriv(time171, grt_dist_171*1000.)
	deltav_171 = derivsig(time171, grt_dist_171*1000., 0.0, (36.*1000.))

	utplot, t171, v_171, time171[0], timerange = [time171[0] - 60, max(time171) + 60], $
		ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_171)+100], background = 1, color = 0, $
		psym = 2, charsize = 1, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
	uterrplot, t171, v_171 + deltav_171, v_171 - deltav_171, thick = 2, color = 0

	oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

	oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

	toggle

; Different velocity plots

	!p.multi = 0
	
;	toggle, /portrait, xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8, filename = 'velocity_171_195_l.eps'

	av_vel_171_t = (v_0_t_171)
	av_vel_195_t = (v_0_t_195)

	wave_errs = [31., 39., 37., 42., 30., 32., 36.]

	print, av_vel_171_t
	print, av_vel_195_t

	plot, av_vel_171_t, av_vel_195_t, psym = 2, background = 1, color = 0, thick = 2, yr = [0, 600], /ys, $
		title = '!6195 !6!sA!r!u!9 %!6!n <v> vs. 171 !6!sA!r!u!9 %!6!n <v>', charsize = 2, $
		xtitle = '!6171 !6!sA!r!u!9 %!6!n <v> (km s!U-1!N)', ytitle = '!6195 !6!sA!r!u!9 %!6!n <v> (km s!U-1!N)', $
		charthick = 2, xr = [0, 600], /xs
;	oploterr, av_vel_171_t, av_vel_195_t, wave_errs, wave_errs, /noconnect, thick = 2, errcolor = 0

	x2png, 'BUKS_talk_2.png'

;	toggle

;	toggle, /portrait, xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8, filename = 'velocity_171_195_p.eps'
;
;	av_vel_171_p = (v_0_p_171)
;	av_vel_195_p = (v_0_p_195)
;
;	print, av_vel_171_p
;	print, av_vel_195_p
;
;	window, 0, xs = 700, ys = 700
;
;	wave_errs = [31., 39., 37., 42., 30., 32., 36.]
;
;	plot, av_vel_171_p, av_vel_195_p, psym = 2, background = 1, color = 0, thick = 2, yr = [0, 400], /ys, $
;		title = '!6195 !6!sA!r!u!9 %!6!n <v> vs. 171 !6!sA!r!u!9 %!6!n <v>', charsize = 2, $
;		xtitle = '!6171 !6!sA!r!u!9 %!6!n <v> (km s!U-1!N)', ytitle = '!6195 !6!sA!r!u!9 %!6!n <v> (km s!U-1!N)', $
;		charthick = 2, xr = [0, 600], /xs
;	oploterr, av_vel_171_p, av_vel_195_p, wave_errs, wave_errs, /nohat, errcolor = 0
;
;	toggle
;
;	toggle, /portrait, xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8, filename = 'velocity_171t_vs_171p.eps'
;
;
	window, 0, xs = 700, ys = 700

	wave_errs = [31., 39., 37., 42., 30., 32., 36.]

	plot, av_vel_171_p, av_vel_171_t, psym = 2, background = 1, color = 0, thick = 2, yr = [0, 700], /ys, $
		title = '!6171 !6!sA!r!u!9 %!6!n Fit A <v> vs. 171 !6!sA!r!u!9 %!6!n Fit B <v>', charsize = 2, $
		xtitle = '!6171 !6!sA!r!u!9 %!6!n Fit B <v> (km s!U-1!N)', ytitle = '!6171 !6!sA!r!u!9 %!6!n Fit A <v> (km s!U-1!N)', $
		charthick = 2, xr = [0, 700], /xs
	oploterr, av_vel_171_p, av_vel_171_t, wave_errs, wave_errs, /noconnect, thick = 2, errcolor = 0
	
	x2png, 'transfer_talk_3.png'
;	
;	toggle

; CME/wave plots

; 20070516

	readcol, 'expansion_20070516.txt', aw_deg, h, instr, date, time, f='F,F,A,A,A'

	t = anytim(date+' '+time)
	utbasedata = t[0]
	t = anytim(t) - anytim(t[0])

	aw = aw_deg * !pi / 180.

	r_sun_cor1 = 999.67
	RSun = 6.96e8 ;metres
	km_arc_cor1 = RSun / (1000*r_sun_cor1) ; km per arcsec
	h_km = h * km_arc_cor1
	h_rsun = h_km * 1000 / RSun
	h_Mm = h_km * 1e-3

	arc = aw * h_km

	expansion = deriv(t, arc)

	print, 'aw: ', aw
	print, 'h_km: ', h_km
	print, 'arc length: ', arc
	print, 't: ', t
	print, 'expansion: ', expansion

	yf = 'p[0]*x + p[1]'
	f0 = mpfitexpr(yf, t, expansion, perror=perror, /quiet)
	exp_model0 = f0[0]*t + f0[1]

; 20070806

	readcol, 'expansion_20070806.txt', aw_deg, h, instr, date, time, f='F,F,A,A,A'

	t = anytim(date+' '+time)
	utbasedata = t[0]
	t = anytim(t) - anytim(t[0])

	aw = aw_deg * !pi / 180.

	r_sun_cor1 = 999.67
	RSun = 6.96e8 ;metres
	km_arc_cor1 = RSun / (1000*r_sun_cor1) ; km per arcsec
	h_km = h * km_arc_cor1
	h_rsun = h_km * 1000 / RSun
	h_Mm = h_km * 1e-3

	arc = aw * h_km

	expansion = deriv(t, arc)

	print, 'aw: ', aw
	print, 'h_km: ', h_km
	print, 'arc length: ', arc
	print, 't: ', t
	print, 'expansion: ', expansion

	yf = 'p[0]*x + p[1]'
	f1 = mpfitexpr(yf, t, expansion, perror=perror, /quiet)
	exp_model1 = f1[0]*t + f1[1]

; 20071207

	readcol, 'expansion_20071207.txt', aw_deg, h, instr, date, time, f='F,F,A,A,A'

	t = anytim(date+' '+time)
	utbasedata = t[0]
	t = anytim(t) - anytim(t[0])

	aw = aw_deg * !pi / 180.

	r_sun_cor1 = 999.67
	RSun = 6.96e8 ;metres
	km_arc_cor1 = RSun / (1000*r_sun_cor1) ; km per arcsec
	h_km = h * km_arc_cor1
	h_rsun = h_km * 1000 / RSun
	h_Mm = h_km * 1e-3

	arc = aw * h_km

	expansion = deriv(t, arc)

	print, 'aw: ', aw
	print, 'h_km: ', h_km
	print, 'arc length: ', arc
	print, 't: ', t
	print, 'expansion: ', expansion

	yf = 'p[0]*x + p[1]'
	f2 = mpfitexpr(yf, t, expansion, perror=perror, /quiet)
	exp_model2 = f2[0]*t + f2[1]

; 20080426

	readcol, 'expansion_20080426.txt', aw_deg, h, instr, date, time, f='F,F,A,A,A'

	t = anytim(date+' '+time)
	utbasedata = t[0]
	t = anytim(t) - anytim(t[0])

	aw = aw_deg * !pi / 180.

	r_sun_cor1 = 999.67
	RSun = 6.96e8 ;metres
	km_arc_cor1 = RSun / (1000*r_sun_cor1) ; km per arcsec
	h_km = h * km_arc_cor1
	h_rsun = h_km * 1000 / RSun
	h_Mm = h_km * 1e-3

	arc = aw * h_km

	expansion = deriv(t, arc)

	print, 'aw: ', aw
	print, 'h_km: ', h_km
	print, 'arc length: ', arc
	print, 't: ', t
	print, 'expansion: ', expansion

	yf = 'p[0]*x + p[1]'
	f3 = mpfitexpr(yf, t, expansion, perror=perror, /quiet)
	exp_model3 = f3[0]*t + f3[1]


	!p.multi = 0

;	toggle, /portrait, filename = 'peak_cme_wave_l.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8

	window, 0, xs = 700, ys = 700

	CMEpeak070516 = mean(exp_model0)
	CMEpeak070806 = mean(exp_model1)
	CMEpeak080426 = mean(exp_model3)
	CMEpeak071207 = mean(exp_model2)

;	CMEpeak070516 = max([1217.0655,649.49236,466.28428,935.80961,1673.8061]) ; CME 20070516 km/s
;
;	CMEpeak070806 = max([-414.00839,225.15880,435.27355,211.42780,52.196188,204.88408,447.30641])
;
;	CMEpeak080426 = max([106.99976,442.22049,690.09442,737.32392,671.25290])
;
;	CMEpeak071207 = max([651.38478,788.45627,775.04170,611.37066,232.58932,-361.52975]) ;BEHIND

	cdawcmepeak080107 = max([75.972479,150.19219,182.71461,158.86064,147.77799,241.58490,303.26615])
	cdawcmepeak070806 = max([347.38234,340.05485,325.28707])
	cdawcmepeak070519 = max([1473.3561,1096.9849,720.61372])

	cme_peaks = [cmepeak070516, cmepeak070806, cmepeak080426, cmepeak071207]
	cdaw_cme_peaks = [cdawcmepeak080107, cdawcmepeak070806, cdawcmepeak070519]

	wave_peaks_t = ([av_vel_171_t[0], av_vel_171_t[3], av_vel_171_t[6], av_vel_171_t[4], av_vel_171_t[5], $
					av_vel_171_t[2], av_vel_171_t[1]])
	wave_errs = replicate(56., 7)

	plot, cme_peaks[0:2], wave_peaks_t[0:2], xr=[0,1800], /xs, yr=[0,600], /ys, psym=4, thick = 2, charthick = 2, $
		xtit='!6CME expansion (km s!U-1!N)', ytit='Disturbance <v> (km s!U-1!N)', charsize = 2, background = 1, color = 0, $
		tit = '!6CME Expansion vs. 171 !6!sA!r!u!9 %!6!n <v>'
	legend, ['COR1-A', 'COR1-B', 'LASCO/C2'], psym=[4,6,2], charsize=2, thick = 2, /bottom, /right, color = 0, textcolors = 0
	plots, cme_peaks[3], wave_peaks_t[3], psym=6, color = 0, thick = 2
	oploterr, cme_peaks, wave_peaks_t[0:3], wave_errs, /noconnect, thick = 2, errcolor = 0
	oplot, cdaw_cme_peaks, wave_peaks_t[4:6], psym=2, color = 0, thick = 2
	oploterr, cdaw_cme_peaks, wave_peaks_t[4:6], replicate(56.,3), /noconnect, thick = 2, errcolor = 0

	x2png, 'transfer_talk_4.png'

;	toggle

;	toggle, /portrait, filename = 'peak_cme_wave_p.eps', xsize = 7, ysize = 5, /inches, /color, bits_per_pixel = 8
;
;	wave_peaks_p = ([av_vel_171_p[0], av_vel_171_p[3], av_vel_171_p[6], av_vel_171_p[4], av_vel_171_p[5], $
;					av_vel_171_p[2], av_vel_171_p[1]])
;	wave_errs = replicate(56., 7)
;
;	plot, cme_peaks[0:2], wave_peaks_p[0:2], xr=[0,1800], /xs, yr=[0,600], /ys, psym=4, thick = 2, charthick = 1, $
;		xtit='!6CME expansion (km s!U-1!N)', ytit='Wave <v> (km s!U-1!N)', charsize = 1.5, background = 1, color = 0, $
;		tit = '!6CME Expansion vs. 171 !6!sA!r!u!9 %!6!n Fit B <v>'
;	legend, ['COR1-A', 'COR1-B', 'LASCO/C2'], psym=[4,6,2], charsize=1, thick = 1, /bottom, /right, color = 0, textcolors = 0
;	plots, cme_peaks[3], wave_peaks_p[3], psym=6, color = 0, thick = 1
;	oploterr, cme_peaks, wave_peaks_p[0:3], wave_errs, /noconnect, thick = 1, errcolor = 0
;	oplot, cdaw_cme_peaks, wave_peaks_p[4:6], psym=2, color = 0, thick = 1
;	oploterr, cdaw_cme_peaks, wave_peaks_p[4:6], replicate(56.,3), /noconnect, thick = 1, errcolor = 0
;
;	toggle



end