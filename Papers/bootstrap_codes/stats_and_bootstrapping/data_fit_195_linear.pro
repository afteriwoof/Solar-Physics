; Routine called by wave_statistics to produce plot of distance data with linear fit.


pro data_fit_195_linear, grt_dist_195, time195, h_err, dist_arr_195, f_195_lin, perror, plot_on=plot_on

	set_line_color

; Time calculations

	tim195 = time195 - time195[0]

; Plot 195A data

	if (keyword_set(plot_on)) then begin

		utplot, tim195, grt_dist_195, time195[0], title = '!6STEREO-A 195 !6!sA!r!u!9 %!6!n', $
			timerange = [min(time195) - 120, max(time195) + 120], ytitle = '!6Distance (!6Mm)', $
			yrange = [0, max(grt_dist_195)+50], psym = 2, charsize = 2, /xs, /ys, $
			color = 0, background = 1, thick = 2

	endif
	
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



end