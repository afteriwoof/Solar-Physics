; Routine called by wave_statistics to produce plot of distance data with quadratic fit.


pro data_fit_171_quadratic, grt_dist_171, time171, h_err, dist_arr_171, f_171_quad, perror, plot_on=plot_on

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

; Constant a fit to data

	xf = findgen( max(tim171) )

	x = findgen( max(tim171) )

	h_error = replicate(h_err, dist_arr_171)

	quad_fit_171 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

	pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
	pi(0).limited(0) = 1
	pi(0).limits(0) = 0.
	pi(1).limited(0) = 1
	pi(1).limits(0) = 0.01
	pi(1).limited(1) = 1
	pi(1).limits(1) = 0.5
	pi(2).limited(0) = 1
	pi(2).limits(0) = -0.00025
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00025

    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)


end