; Sub-routine called by num_diff_simulation.pro when examining the effects of varying cadence

pro sub_simulation_cadence, cad_array, jump, t, array, r0, v0, time, cadence, tog=tog, $
		images=images, no_images=no_images

; Array for storing values of cadence

	cadence = dblarr(cad_array+1)			

; Arrays for storing mean truncation error for velocity and acceleration for each technique

	f_error_vel = dblarr(cad_array+1)
	f_error_acc = dblarr(cad_array+1)
	r_error_vel = dblarr(cad_array+1)
	r_error_acc = dblarr(cad_array+1)
	c_error_vel = dblarr(cad_array+1)
	c_error_acc = dblarr(cad_array+1)
	l_error_vel = dblarr(cad_array+1)
	l_error_acc = dblarr(cad_array+1)

; Forward differentiation - Linear model

	for j = 0, cad_array, jump do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy, /tog

		endif 
		
		if (keyword_set(images)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy, /images

		endif	

		if (keyword_set(no_images)) then begin

			forward_diff, cadence, r0, v0, time, n, noise, j, mean_percent_noise, f_lin_dist, $
				f_error_vel_noisy, f_error_acc_noisy

		endif	

		percent_noise[j] = mean_percent_noise

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

	for j = 0, cad_array, jump do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, percent_noise, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy, /tog

		endif 
		
		if (keyword_set(images)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, percent_noise, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy, /images

		endif	

		if (keyword_set(no_images)) then begin

			reverse_diff, cadence, r0, v0, time, n, noise, j, percent_noise, r_lin_dist, $
				r_error_vel_noisy, r_error_acc_noisy

		endif	

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

	for j = 0, cad_array, jump do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, percent_noise, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy, /tog

		endif 
		
		if (keyword_set(images)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, percent_noise, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy, /images

		endif	

		if (keyword_set(no_images)) then begin

			centre_diff, cadence, r0, v0, time, n, noise, j, percent_noise, c_lin_dist, $
				c_error_vel_noisy, c_error_acc_noisy

		endif	

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

	for j = 0, cad_array, jump do begin
	
		n = size(t[0:*:cadence], /n_elements)
	
		noise = array * j

		if (keyword_set(tog)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, percent_noise, l_lin_dist, $
				mean_error_vel, mean_error_acc, /tog

		endif 
		
		if (keyword_set(images)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, percent_noise, l_lin_dist, $
				mean_error_vel, mean_error_acc, /images

		endif	

		if (keyword_set(no_images)) then begin

			lagrange_diff, cadence, r0, v0, time, n, noise, j, percent_noise, l_lin_dist, $
				mean_error_vel, mean_error_acc
				
		endif	

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

	if (keyword_set(tog)) then begin

		toggle, /portrait, filename = 'error_variation_cadence.eps', xsize = 6, ysize = 6, $
			/inches, /color, bits_per_pixel = 8
		!p.multi = [0, 1, 2]
		set_line_color

		x = findgen(cad_array+1)

		plot, x[10:*:jump], 1e3*f_error_vel[10:*:jump], color = 0, $
			title = 'Variation in mean velocity error with cadence', $
			xtitle = ' ', ytitle = 'Mean velocity error (km/s)', $
			background = 1, charsize = 1, thick = 2, /ys, $
			pos = [0.2, 0.55, 0.9, 0.9]

		oplot, x[10:*:jump], 1e3*r_error_vel[10:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, x[10:*:jump], 1e3*c_error_vel[10:*:jump], color = 5, thick = 2
		oplot, x[10:*:jump], l_error_vel[10:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 0.8

		plot, x[10:*:jump], 1e6*f_error_acc[10:*:jump], color = 0, $
			title = 'Variation in mean acceleration error with cadence', $
			xtitle = 'Cadence (s)', ytitle = 'Mean acceleration error (m/s/s)', $
			background = 1, charsize = 1, thick = 2, /ys, $
			pos = [0.2, 0.1, 0.9, 0.45]

		oplot, x[10:*:jump], 1e6*r_error_acc[10:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, x[10:*:jump], 1e6*c_error_acc[10:*:jump], color = 5, thick = 2
		oplot, x[10:*:jump], l_error_acc[10:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /right, charsize = 0.8

		toggle

	endif else begin
	
		window, 0, xs = 1000, ys = 1000
		!p.multi = [0, 1, 2]
		set_line_color

		x = findgen(cad_array+1)

		plot, x[10:*:jump], 1e3*f_error_vel[10:*:jump], color = 0, $
			title = 'Variation in mean velocity error with cadence', $
			xtitle = 'Cadence (s)', ytitle = 'Mean velocity error (km/s)', $
			background = 1, charsize = 1, thick = 2, /ys

		oplot, x[10:*:jump], 1e3*r_error_vel[10:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, x[10:*:jump], 1e3*c_error_vel[10:*:jump], color = 5, thick = 2
		oplot, x[10:*:jump], l_error_vel[10:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /left, charsize = 1.5

		plot, x[10:*:jump], 1e6*f_error_acc[10:*:jump], color = 0, $
			title = 'Variation in mean acceleration error with cadence', $
			xtitle = 'Cadence (s)', ytitle = 'Mean acceleration error (m/s/s)', $
			background = 1, charsize = 1, thick = 2, /ys

		oplot, x[10:*:jump], 1e6*r_error_acc[10:*:jump], color = 3, thick = 2, linestyle = 2
		oplot, x[10:*:jump], 1e6*c_error_acc[10:*:jump], color = 5, thick = 2
		oplot, x[10:*:jump], l_error_acc[10:*:jump], color = 4, thick = 2

		legend, ['Forward diff.', 'Reverse diff.', 'Centre diff.', 'Lagrange diff.'], $
			textcolors = [0, 3, 5, 4], /clear, outline_color = 0, /top, /left, charsize = 1.5

		x2png, 'error_variation_cadence.png'

	endelse

end
