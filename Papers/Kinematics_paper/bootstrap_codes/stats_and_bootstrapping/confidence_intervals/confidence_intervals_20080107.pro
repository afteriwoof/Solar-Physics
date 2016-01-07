; Routine to plot confidence intervals from residual resampling bootstrapping analysis.

pro confidence_intervals_20080107

	date = 20080107
	
	j = 36

	set_line_color

;***********
; 195A data
;***********

	!p.multi = [0, 1, 2]

; Restore confidence interval data - R0 195 Lin

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [conf_range_r_195_lin[0], conf_range_r_195_lin[1]], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [conf_range_r_195_lin[0] - 200, conf_range_r_195_lin[1] + 200], $
		/xs, charsize = 2, title = 'R0 195 Linear - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'R0 (Mm)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [conf_range_r_195_lin[0], conf_range_r_195_lin[1]], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [conf_range_r_195_lin[0], conf_range_r_195_lin[1]], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - V0 195 Lin

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e3*(conf_range_v_195_lin[0]), 1e3*(conf_range_v_195_lin[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e3*(conf_range_v_195_lin[0]) - 200, 1e3*(conf_range_v_195_lin[1]) + 200], $
		/xs, charsize = 2, title = 'V0 195 Linear - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'V0 (km/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e3*(conf_range_v_195_lin[0]), 1e3*(conf_range_v_195_lin[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e3*(conf_range_v_195_lin[0]), 1e3*(conf_range_v_195_lin[1])], [j+1, j+1], color = 3

	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

	x2png, 'confidence_interval_195_lin_' + num2str(date) + '.png'
	
	!p.multi = [0, 1, 3]

; Restore confidence interval data - R0 195 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [conf_range_r_195_quad[0], conf_range_r_195_quad[1]], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [conf_range_r_195_quad[0] - 200, conf_range_r_195_quad[1] + 200], $
		/xs, charsize = 2, title = 'R0 195 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'R0 (Mm)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [conf_range_r_195_quad[0], conf_range_r_195_quad[1]], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [conf_range_r_195_quad[0], conf_range_r_195_quad[1]], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - V0 195 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e3*(conf_range_v_195_quad[0]), 1e3*(conf_range_v_195_quad[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e3*(conf_range_v_195_quad[0]) - 200, 1e3*(conf_range_v_195_quad[1]) + 200], $
		/xs, charsize = 2, title = 'V0 195 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'V0 (km/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e3*(conf_range_v_195_quad[0]), 1e3*(conf_range_v_195_quad[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e3*(conf_range_v_195_quad[0]), 1e3*(conf_range_v_195_quad[1])], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - A0 195 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e6*(conf_range_a_195_quad[0]), 1e6*(conf_range_a_195_quad[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e6*(conf_range_a_195_quad[0]) - 200, 1e6*(conf_range_a_195_quad[1]) + 200], $
		/xs, charsize = 2, title = 'A0 195 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'A0 (m/s/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e6*(conf_range_a_195_quad[0]), 1e6*(conf_range_a_195_quad[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e6*(conf_range_a_195_quad[0]), 1e6*(conf_range_a_195_quad[1])], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

	x2png, 'confidence_interval_195_quad_' + num2str(date) + '.png'
	
;***********
; 171A data
;***********

	!p.multi = [0, 1, 2]

; Restore confidence interval data - R0 171 Lin

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [conf_range_r_171_lin[0], conf_range_r_171_lin[1]], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [conf_range_r_171_lin[0] - 200, conf_range_r_171_lin[1] + 200], $
		/xs, charsize = 2, title = 'R0 171 Linear - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'R0 (Mm)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [conf_range_r_171_lin[0], conf_range_r_171_lin[1]], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [conf_range_r_171_lin[0], conf_range_r_171_lin[1]], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - V0 171 Lin

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e3*(conf_range_v_171_lin[0]), 1e3*(conf_range_v_171_lin[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e3*(conf_range_v_171_lin[0]) - 200, 1e3*(conf_range_v_171_lin[1]) + 200], $
		/xs, charsize = 2, title = 'V0 171 Linear - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'V0 (km/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e3*(conf_range_v_171_lin[0]), 1e3*(conf_range_v_171_lin[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e3*(conf_range_v_171_lin[0]), 1e3*(conf_range_v_171_lin[1])], [j+1, j+1], color = 3

	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

	x2png, 'confidence_interval_171_lin_' + num2str(date) + '.png'
	
	!p.multi = [0, 1, 3]

; Restore confidence interval data - R0 171 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [conf_range_r_171_quad[0], conf_range_r_171_quad[1]], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [conf_range_r_171_quad[0] - 200, conf_range_r_171_quad[1] + 200], $
		/xs, charsize = 2, title = 'R0 171 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'R0 (Mm)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [conf_range_r_171_quad[0], conf_range_r_171_quad[1]], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [conf_range_r_171_quad[0], conf_range_r_171_quad[1]], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - V0 171 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e3*(conf_range_v_171_quad[0]), 1e3*(conf_range_v_171_quad[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e3*(conf_range_v_171_quad[0]) - 200, 1e3*(conf_range_v_171_quad[1]) + 200], $
		/xs, charsize = 2, title = 'V0 171 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'V0 (km/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e3*(conf_range_v_171_quad[0]), 1e3*(conf_range_v_171_quad[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e3*(conf_range_v_171_quad[0]), 1e3*(conf_range_v_171_quad[1])], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

; Restore confidence interval data - A0 171 Quad

	restore, 'CI_' + num2str(date) + '_0.sav'

	plot, [1e6*(conf_range_a_171_quad[0]), 1e6*(conf_range_a_171_quad[1])], [0, 0], color = 0, background = 1, $
		yr = [-1, j+2], /ys, xr = [1e6*(conf_range_a_171_quad[0]) - 200, 1e6*(conf_range_a_171_quad[1]) + 200], $
		/xs, charsize = 2, title = 'A0 171 Quadratic - 95% Confidence intervals', $
		ytitle = 'Arc-line number', xtitle = 'A0 (m/s/s)'

	for i = 1, j do begin
		restore, 'CI_' + num2str(date) + '_' + num2str(i) + '.sav'

		oplot, [1e6*(conf_range_a_171_quad[0]), 1e6*(conf_range_a_171_quad[1])], [i, i], color = 0
	
	endfor

	restore, 'CI_' + num2str(date) + '_average.sav'
	oplot, [1e6*(conf_range_a_171_quad[0]), 1e6*(conf_range_a_171_quad[1])], [j+1, j+1], color = 3
	
	legend, ['Arc-lines', 'Averaged Arcs'], textcolor = [0, 3], /clear, charsize = 1.5, outline_color = 0

	x2png, 'confidence_interval_171_quad_' + num2str(date) + '.png'

end