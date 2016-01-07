; Routine to calculate wave statistics for each event.

pro wave_stats_20070516, tim195, tim171, residuals_195_lin, residuals_195_quad, residuals_171_lin, residuals_171_quad

; Restore data

	date = 20070516
	
	h_err = 31.
	
	restore, num2str(date) + '_dist.sav'

	event = anytim(str2utc(arr2str(date)), /date_only, /hxrbs)

	time195 = anytim(event + ' ' + t195)
	time171 = anytim(event + ' ' + time_171)

	tim195 = time195 - time195[0]
	tim171 = time171 - time171[0]

	dist_arr_195 = size(grt_dist_195, /n_elements)
	dist_arr_171 = size(grt_dist_171, /n_elements)

; 195A

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

	dist_fit_195_lin = f_195_lin[0] + f_195_lin[1]*x

	dist_fit_195_lin_res = f_195_lin[0] + f_195_lin[1]*tim195

	residuals_195_lin = grt_dist_195 - dist_fit_195_lin_res

; Constant a fit to data

	xf = findgen( max(tim195) )

	x = findgen( max(tim195) )

	h_error = replicate(h_err, dist_arr_195)

	quad_fit_195 = 'p[0] + p[1] * x + (1./2.)*p[2]*x^2.'

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

    f_195_quad = mpfitexpr(quad_fit_195, tim195, grt_dist_195, h_error, [grt_dist_195[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_195_quad, /quiet)

	dist_fit_195_quad = f_195_quad[0] + f_195_quad[1]*x + (1./2.)*f_195_quad[2]*x^2.

	dist_fit_195_quad_res = f_195_quad[0] + f_195_quad[1]*tim195 + (1./2.)*f_195_quad[2]*tim195^2.

	residuals_195_quad = grt_dist_195 - dist_fit_195_quad_res

; 171A

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

	dist_fit_171_lin = f_171_lin[0] + f_171_lin[1]*x

	dist_fit_171_lin_res = f_171_lin[0] + f_171_lin[1]*tim171

	residuals_171_lin = grt_dist_171 - dist_fit_171_lin_res

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
	pi(2).limits(0) = -0.00015
	pi(2).limited(1) = 1
	pi(2).limits(1) = 0.00015

    f_171_quad = mpfitexpr(quad_fit_171, tim171, grt_dist_171, h_error, [grt_dist_171[0], 0.2, 0.00005], perror=perror, $
    		parinfo = pi, bestnorm = bestnorm_171_quad, /quiet)

	dist_fit_171_quad = f_171_quad[0] + f_171_quad[1]*x + (1./2.)*f_171_quad[2]*x^2.

	dist_fit_171_quad_res = f_171_quad[0] + f_171_quad[1]*tim171 + (1./2.)*f_171_quad[2]*tim171^2.

	residuals_171_quad = grt_dist_171 - dist_fit_171_quad_res

end