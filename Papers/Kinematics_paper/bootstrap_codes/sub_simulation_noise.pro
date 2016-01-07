; Sub-routine called by num_diff_simulation.pro when examining the effects of varying noise-level

pro sub_simulation_noise, max_noise, jump, t, array, r0, v0, time, cadence, tog=tog, $
		images=images, no_images=no_images

	max_noise = 300.0d

; Array for storing values of % noise

	percent_noise = dblarr(max_noise+1)			

; Arrays for storing mean truncation error for velocity and acceleration for each technique

	f_scatter_vel = dblarr(max_noise+1)
	f_scatter_acc = dblarr(max_noise+1)
	r_scatter_vel = dblarr(max_noise+1)
	r_scatter_acc = dblarr(max_noise+1)
	c_scatter_vel = dblarr(max_noise+1)
	c_scatter_acc = dblarr(max_noise+1)
	l_scatter_vel = dblarr(max_noise+1)
	l_scatter_acc = dblarr(max_noise+1)

	f_error_vel = dblarr(max_noise+1)
	f_error_acc = dblarr(max_noise+1)
	r_error_vel = dblarr(max_noise+1)
	r_error_acc = dblarr(max_noise+1)
	c_error_vel = dblarr(max_noise+1)
	c_error_acc = dblarr(max_noise+1)
	l_error_vel = dblarr(max_noise+1)
	l_error_acc = dblarr(max_noise+1)

; Forward differentiation - Linear model

	for j = 0, max_noise, 10 do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy, scatter_v, scatter_a, /tog

		endif 
		
		if (keyword_set(images)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy, scatter_v, scatter_a, /images

		endif	

		if (keyword_set(no_images)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy, scatter_v, scatter_a

		endif	

		percent_noise[j] = mean_percent_noise

		f_scatter_vel[j] = scatter_v
		f_scatter_acc[j] = scatter_a

		f_error_vel[j] = f_error_vel_noisy
		f_error_acc[j] = f_error_acc_noisy

		if (keyword_set(images)) then begin

			IF j LE 9 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'f_diff_vary_noise_00' + s +'.png'
			ENDIF

			IF (j GT 9) AND (j LE 99) THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'f_diff_vary_noise_0' + s + '.png'
			ENDIF

			IF j GT 99 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'f_diff_vary_noise_' + s + '.png'
			ENDIF

		endif
		
	endfor

	if (keyword_set(images)) then begin

		j_fls = file_search('~/IDL/f_diff_vary_noise_*.png')

		s = size(j_fls, /dim)

		for i = 1, s[0]-1 do begin

			read_png, j_fls[i-1], image

			wr_movie, 'f_diff_vary_noise', image, i-1, s[0]-1, $
				title = 'Forward-difference varying noise simulation', /delete

		endfor

	endif

; Reverse differentiation - Linear model

	for j = 0, max_noise, 10 do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy, scatter_v, scatter_a, /tog

		endif 
		
		if (keyword_set(images)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy, scatter_v, scatter_a, /images

		endif	

		if (keyword_set(no_images)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy, scatter_v, scatter_a

		endif	

		r_scatter_vel[j] = scatter_v
		r_scatter_acc[j] = scatter_a

		r_error_vel[j] = r_error_vel_noisy
		r_error_acc[j] = r_error_acc_noisy

		if (keyword_set(images)) then begin

			IF j LE 9 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'r_diff_vary_noise_00' + s +'.png'
			ENDIF
	
			IF (j GT 9) AND (j LE 99) THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'r_diff_vary_noise_0' + s + '.png'
			ENDIF

			IF j GT 99 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'r_diff_vary_noise_' + s + '.png'
			ENDIF

		endif

	endfor

	if (keyword_set(images)) then begin

		j_fls = file_search('~/IDL/r_diff_vary_noise_*.png')
		s = size(j_fls, /dim)

		for i = 1, s[0]-1 do begin

			read_png, j_fls[i-1], image
			wr_movie, 'r_diff_vary_noise', image, i-1, s[0]-1, $
				title = 'Reverse-difference varying noise simulation', /delete

		endfor

	endif
	
; Centre differentiation - Linear model

	for j = 0, max_noise, 10 do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy, scatter_v, scatter_a, /tog

		endif 
		
		if (keyword_set(images)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy, scatter_v, scatter_a, /images

		endif	

		if (keyword_set(no_images)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy, scatter_v, scatter_a

		endif	

		c_scatter_vel[j] = scatter_v
		c_scatter_acc[j] = scatter_a

		c_error_vel[j] = c_error_vel_noisy
		c_error_acc[j] = c_error_acc_noisy

		if (keyword_set(images)) then begin

			IF j LE 9 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'c_diff_vary_noise_00' + s +'.png'
			ENDIF

			IF (j GT 9) AND (j LE 99) THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'c_diff_vary_noise_0' + s + '.png'
			ENDIF

			IF j GT 99 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'c_diff_vary_noise_' + s + '.png'
			ENDIF

		endif

	endfor

	if (keyword_set(images)) then begin

		j_fls = file_search('~/IDL/c_diff_vary_noise_*.png')
		s = size(j_fls, /dim)

		for i = 1, s[0]-1 do begin

			read_png, j_fls[i-1], image
			wr_movie, 'c_diff_vary_noise', image, i-1, s[0]-1, $
				title = 'Centre-difference varying noise simulation', /delete
		endfor

	endif

; Lagrange differentiation - Linear model.

	for j = 0, max_noise, 10 do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, l_lin_dist, $
				mean_error_vel, mean_error_acc, scatter_v, scatter_a, /tog

		endif 
		
		if (keyword_set(images)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, l_lin_dist, $
				mean_error_vel, mean_error_acc, scatter_v, scatter_a, /images

		endif	

		if (keyword_set(no_images)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, l_lin_dist, $
				mean_error_vel, mean_error_acc, scatter_v, scatter_a
				
		endif	

		l_scatter_vel[j] = scatter_v
		l_scatter_acc[j] = scatter_a

		l_error_vel[j] = mean_error_vel
		l_error_acc[j] = mean_error_acc

		if (keyword_set(images)) then begin

			IF j LE 9 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'l_diff_vary_noise_00' + s +'.png'
			ENDIF

			IF (j GT 9) AND (j LE 99) THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'l_diff_vary_noise_0' + s + '.png'
			ENDIF

			IF j GT 99 THEN BEGIN
				s = arr2str(j, /trim)
				x2png, 'l_diff_vary_noise_' + s + '.png'
			ENDIF
	
		endif
	
	endfor

	if (keyword_set(images)) then begin

		j_fls = file_search('~/IDL/l_diff_vary_noise_*.png')
		s = size(j_fls, /dim)

		for i = 1, s[0]-1 do begin

			read_png, j_fls[i-1], image
			wr_movie, 'l_diff_vary_noise', image, i-1, s[0]-1, $
				title = 'Lagrange-difference varying noise simulation', /delete
	
		endfor

	endif

	window, 0, xs = 1000, ys = 1000
	!p.multi = [0, 1, 2]
	set_line_color

	num = size(percent_noise[0:*:jump], /n_elements)

	plot, percent_noise[0:*:jump], 1e3*f_error_vel[0:*:jump], background = 1, color = 0, $
		thick = 2, title = 'Mean truncation error in velocity data'
	oplot, percent_noise[0:*:jump], 1e3*r_error_vel[0:*:jump], color = 3, linestyle = 2, $
		thick = 2
	oplot, percent_noise[0:*:jump], 1e3*c_error_vel[0:*:jump], color = 4, $
		thick = 2
	oplot, percent_noise[0:*:jump], replicate(l_error_vel[0], num), color = 5, linestyle = 2, $
		thick = 2

	plot, percent_noise[0:*:jump], 1e6*f_error_acc[0:*:jump], background = 1, color = 0, $
		thick = 2, title = 'Mean truncation error in acceleration data'
	oplot, percent_noise[0:*:jump], 1e6*r_error_acc[0:*:jump], color = 3, linestyle = 2, $
		thick = 2
	oplot, percent_noise[0:*:jump], 1e6*c_error_acc[0:*:jump], color = 4, $
		thick = 2
	oplot, percent_noise[0:*:jump], replicate(l_error_acc[0], num), color = 5, linestyle = 2, $
		thick = 2

	legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
		textcolors = [0, 3, 4, 5], /clear, outline_color = 0, /top, /right, charsize = 1

ans = ' '
read, 'ok?', ans

	plot, percent_noise[0:*:jump], f_scatter_vel[0:*:jump], background = 1, color = 0, $
		thick = 2, title = 'Mean scatter in velocity data'
	oplot, percent_noise[0:*:jump], r_scatter_vel[0:*:jump], color = 3, linestyle = 2, $
		thick = 2
	oplot, percent_noise[0:*:jump], c_scatter_vel[0:*:jump], color = 4, $
		thick = 2
	oplot, percent_noise[0:*:jump], l_scatter_vel[0:*:jump], color = 5, linestyle = 2, $
		thick = 2

	plot, percent_noise[0:*:jump], f_scatter_acc[0:*:jump], background = 1, color = 0, $
		thick = 2, title = 'Mean scatter in acceleration data'
	oplot, percent_noise[0:*:jump], r_scatter_acc[0:*:jump], color = 3, linestyle = 2, $
		thick = 2
	oplot, percent_noise[0:*:jump], c_scatter_acc[0:*:jump], color = 4, $
		thick = 2
	oplot, percent_noise[0:*:jump], l_scatter_acc[0:*:jump], color = 5, linestyle = 2, $
		thick = 2

	legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
		textcolors = [0, 3, 4, 5], /clear, outline_color = 0, /top, /right, charsize = 1
stop
ans = ' '
read, 'ok?', ans

print, 'f-diff error (v) = ', mean(1e3*f_error_vel)
print, 'r-diff error (v) = ', mean(1e3*r_error_vel)
print, 'c-diff error (v) = ', mean(1e3*c_error_vel)
print, 'l-diff error (v) = ', mean(l_error_vel)

print, 'f-diff error (a) = ', mean(1e6*f_error_acc)
print, 'r-diff error (a) = ', mean(1e6*r_error_acc)
print, 'c-diff error (a) = ', mean(1e6*c_error_acc)
print, 'l-diff error (a) = ', mean(l_error_acc)

print, 'f-diff scatter (v) = ', mean(f_scatter_vel)
print, 'r-diff scatter (v) = ', mean(r_scatter_vel)
print, 'c-diff scatter (v) = ', mean(c_scatter_vel)
print, 'l-diff scatter (v) = ', mean(l_scatter_vel)

print, 'f-diff scatter (a) = ', mean(f_scatter_acc)
print, 'r-diff scatter (a) = ', mean(r_scatter_acc)
print, 'c-diff scatter (a) = ', mean(c_scatter_acc)
print, 'l-diff scatter (a) = ', mean(l_scatter_acc)

	if (keyword_set(tog)) then begin

		toggle, /portrait, filename = 'error_variation_noise.eps', xsize = 6, ysize = 6, /inches, $
			/color, bits_per_pixel = 8
		!p.multi = [0, 1, 2]
		set_line_color

		plot, percent_noise[0:*:jump], 1e3*f_error_vel[0:*:jump], color = 0, $
			title = 'Variation in mean velocity error with noise level', $
			xtitle = ' ', ytitle = 'Mean velocity error (km/s)', /ylog, yr = [1, 1e4], /ys, $
			background = 1, charsize = 1, thick = 2, pos = [0.2, 0.55, 0.9, 0.9]

		oplot, percent_noise[0:*:jump], 1e3*r_error_vel[0:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, percent_noise[0:*:jump], 1e3*c_error_vel[0:*:jump], color = 5, thick = 2
		oplot, percent_noise[0:*:jump], l_error_vel[0:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 0.8

		plot, percent_noise[0:*:jump], 1e6*f_error_acc[0:*:jump], color = 0, $
			title = 'Variation in mean acceleration error with noise level', $
			xtitle = 'Mean percentage noise', ytitle = 'Mean acceleration error (m/s/s)', /ylog, $
			background = 1, charsize = 1, thick = 2, pos = [0.2, 0.1, 0.9, 0.45], yr = [10, 1e5], /ys

		oplot, percent_noise[0:*:jump], 1e6*r_error_acc[0:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, percent_noise[0:*:jump], 1e6*c_error_acc[0:*:jump], color = 5, thick = 2
		oplot, percent_noise[0:*:jump], l_error_acc[0:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 0.8

		toggle

	endif else begin
	
		window, 0, xs = 1000, ys = 1000
		!p.multi = [0, 1, 2]
		set_line_color

		plot, percent_noise[0:*:jump], 1e3*f_error_vel[0:*:jump], color = 0, $
			title = 'Variation in mean velocity error with noise level', $
			xtitle = 'Mean percentage noise', ytitle = 'Mean velocity error (km/s)', /ylog, $
			background = 1, charsize = 1.5, thick = 2, yr = [1, 1e4], /ys

		oplot, percent_noise[0:*:jump], 1e3*r_error_vel[0:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, percent_noise[0:*:jump], 1e3*c_error_vel[0:*:jump], color = 5, thick = 2
		oplot, percent_noise[0:*:jump], l_error_vel[0:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 1

		plot, percent_noise[0:*:jump], 1e6*f_error_acc[0:*:jump], color = 0, $
			title = 'Variation in mean acceleration error with noise level', $
			xtitle = 'Mean percentage noise', ytitle = 'Mean acceleration error (m/s/s)', /ylog, $
			background = 1, charsize = 1.5, thick = 2, yr = [10, 1e5], /ys

		oplot, percent_noise[0:*:jump], 1e6*r_error_acc[0:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, percent_noise[0:*:jump], 1e6*c_error_acc[0:*:jump], color = 5, thick = 2
		oplot, percent_noise[0:*:jump], l_error_acc[0:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 1

		x2png, 'error_variation_noise.png'

	endelse

end