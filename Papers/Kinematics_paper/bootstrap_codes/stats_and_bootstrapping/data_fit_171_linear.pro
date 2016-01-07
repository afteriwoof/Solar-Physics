; Routine called by wave_statistics to produce plot of distance data with linear fit.


pro data_fit_171_linear, grt_dist_171, time171, h_err, dist_arr_171, f_171_lin, perror, plot_on=plot_on

	set_line_color

; Time calculations

	tim171 = time171 - time171[0]

; Plot 171A data

	if (keyword_set(plot_on)) then begin

		utplot, tim171, grt_dist_171, time171[0], title = '!6STEREO-A 171 !6!sA!r!u!9 %!6!n', $
			timerange = [min(time171) - 120, max(time171) + 120], ytitle = '!6Distance (!6Mm)', $
			yrange = [0, max(grt_dist_171)+50], psym = 2, charsize = 2, /xs, /ys, $
			color = 0, background = 1, thick = 2

	endif
	
; Zero a fit to data

	x = findgen( max(tim171) )

	h_error = replicate(h_err, dist_arr_171)

	lin_fit_171 = 'p[0] + p[1] * x'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5

    f_171_lin = mpfitexpr(lin_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_lin, /quiet)



end