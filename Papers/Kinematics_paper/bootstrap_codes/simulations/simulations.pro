pro simulations

	!p.multi = [0, 1, 2]
	
	window, 0, xs = 750, ys = 750

	set_line_color

; Restore grt_dist_195, grt_dist_171, t195, time_171

	restore, '20070516_dist.sav'

	n_pts = 6

	mean_0 = fltarr(51)
	mean_1 = fltarr(51)
	mean_2 = fltarr(51)
	mean_3 = fltarr(51)

;	f_195_p_dist = fltarr(51)
;	f_195_p_vel = fltarr(51)
;	f_195_p_acc = fltarr(51)
;
;	f_195_l_dist = fltarr(51)
;	f_195_l_vel = fltarr(51)
;
;	f_171_p_dist = fltarr(51)
;	f_171_p_vel = fltarr(51)
;	f_171_p_acc = fltarr(51)
;
;	f_171_l_dist = fltarr(51)
;	f_171_l_vel = fltarr(51)

; Plot data as UT plot

	for i = 0, 50 do begin

		noise = 20.*randomn( seed, n_pts ) 

		grt_errors_195 = grt_dist_195 + noise

		print, ' '
		print, 'Mean percentage error in heights:', mean( abs( noise / grt_dist_195 ) ) * 100.
		print, ' '

		time195 = anytim('2007/05/16' + ' ' + t195)
		time171 = anytim('2007/05/16' + ' ' + time_171)

		tim195 = time195 - time195[0]
		tim171 = time171 - time195[0]
		t171 = time171 - time171[0]

; Plot plain data

		utplot, tim195, grt_errors_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
			timerange = [time195[0] - 120, max(time195) + 120], pos = [0.1, 0.54, 0.95, 0.95], $
			ytitle = '!6Distance [!6Mm]', yrange = [0, max(grt_errors_195)+50], background = 1, color = 0, $
			psym = 2, charsize = 1.5, xstyle = 1, ystyle = 1, thick = 2, charthick = 1.5, xtitle = '', $
			xtickname = [' ',' ',' ',' ',' ',' ',' ']
		uterrplot, tim195, grt_errors_195 + 31, grt_errors_195 - 31, thick = 2, color = 0

; Blast wave variation fit to data

		xf = findgen( max(tim195) )

		x = findgen( max(tim195) )

		h_err = [24., 24., 24., 24., 24., 24.]
	
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
		pi(3).limits(1) = 2.

	    f_195_0 = mpfitexpr(expr_195_0, tim195, grt_errors_195, h_err, [grt_errors_195[0], 10, 0.5, 0.4], perror=perror, $
	    		parinfo = pi, bestnorm = bestnorm_0)

		oplot, xf, mpevalexpr(expr_195_0, x, f_195_0), linestyle = 0, color = 3, thick = 3

; Test blast wave variation for varying noise

		h_model_0 = f_195_0[0] + f_195_0[1]*tim195 + f_195_0[2]*tim195^f_195_0[3]
		dh_195_0 = abs(grt_errors_195 - h_model_0)

		scatter_195_0 = (dh_195_0/grt_errors_195)*100.

; const a fit to data

		xf = findgen( max(tim195) )

		x = findgen( max(tim195) )

		h_err = [24., 24., 24., 24., 24., 24.]

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

	    f_195_1 = mpfitexpr(expr_195_1, tim195, grt_errors_195, h_err, [grt_errors_195[0], 0.5, 0.05], perror=perror, $
	    		parinfo = pi, bestnorm = bestnorm_1)

		oplot, xf, mpevalexpr(expr_195_1, x, f_195_1), linestyle = 2, color = 0, thick = 3

; Test const a best-fit for varying noise

		h_model_1 = f_195_1[0] + f_195_1[1]*tim195 + f_195_1[2]*tim195^2
		dh_195_1 = abs(grt_errors_195 - h_model_0)

		scatter_195_1 = (dh_195_1/grt_errors_195)*100.

; Legend for plot

		legend,['R(t) = R!D0!N + v!D0!Nt + !7a!6t!U!7b!6!N', 'R(t) = R!D0!N + v!D0!Nt + a!D0!Nt!U2!N'], $
				/bottom, /right, colors = [3, 0], textcolor = [3, 0], thick = 2, charsize = 1.5, $
				linestyle = [0, 2], box = 0

; Plot of velocity

		x = findgen(max(tim195))

		v_model_0 = 1000.*(f_195_0[1] + f_195_0[2]*f_195_0[3]*x^(f_195_0[3]-1.))
	    
		v_model_1 = 1000.*(f_195_1[1] + f_195_1[2]*x)

		v_195 = deriv(tim195, grt_errors_195*1000)
		deltav_195 = derivsig(tim195, grt_errors_195*1000, 0.0, (31.*1000))

		utplot, tim195, v_195, time195[0], timerange = [time195[0] - 120, max(time195) + 120], $
			ytitle = '!6Velocity [!6kms!U-1!N]', yrange = [0, max(v_195)+100], background = 1, color = 0, $
			psym = 2, charsize = 1.5, xstyle = 1, ystyle = 1, pos = [0.1, 0.09, 0.95, 0.5], charthick = 1.5, thick = 2
		uterrplot, tim195, v_195 + deltav_195, v_195 - deltav_195, thick = 2, color = 0

		oplot, xf, v_model_0, linestyle = 0, color = 3, thick = 2

		oplot, xf, v_model_1, linestyle = 2, color = 0, thick = 2

; X-window to png

;		IF i LE 9 THEN BEGIN
;			s = arr2str(i, /trim)
;			x2png, '195_20_00' + s +'.png'
;		ENDIF
;
;		IF (i GT 9) AND (i LE 99) THEN BEGIN
;			s = arr2str(i, /trim)
;			x2png, '195_20_0' + s + '.png'
;		ENDIF
;
;		IF i GT 99 THEN BEGIN
;			s = arr2str(i, /trim)
;			x2png, '195_20_' + s + '.png'
;		ENDIF
;
;		wait, 1.

		toggle

	endfor



end