; Routine to test the forward difference numerical differentiation technique for future use

pro num_diff_report_plots, cadence, tog=tog

	set_line_color
	
	!p.multi = [0, 1, 3]
	
; Define routine parameters

	r0 = 150.0d		; Mm

	v0 = 0.4d		; 400 km/s
	
	a0 = -0.00005d	; -50 m/s/s

	time = 2000.0d	; s
	
	jump = 10.		; Jumps in standard deviation

; Define time array

	t = findgen(time)

; Calculate noise to add to equations

	n = size(t[0:*:cadence], /n_elements)

;	array = randomn(seed, n)

	restore, 'noise.sav'

; Compile routines to ensure smooth operation in case of changes

	resolve_routine, 'f_num_diff_lin'
	resolve_routine, 'r_num_diff_lin'
	resolve_routine, 'c_num_diff_lin'
	resolve_routine, 'l_num_diff_lin'
	resolve_routine, 'first_go'

; Initial run to set scaling for future reference

	j = 300

	noise = array * j

	first_go, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, j, y_r_vel, y_r_acc

; Create array structures to store mean noise levels (both velocity and acceleration)

	percent_noise_f = dblarr(j+1)
	percent_noise_r = dblarr(j+1)
	percent_noise_c = dblarr(j+1)
	percent_noise_l = dblarr(j+1)

	f_distance = dblarr(j+1)
	r_distance = dblarr(j+1)
	c_distance = dblarr(j+1)
	l_distance = dblarr(j+1)

	f_velocity = dblarr(j+1)
	r_velocity = dblarr(j+1)
	c_velocity = dblarr(j+1)
	l_velocity = dblarr(j+1)

; Forward differentiation - Linear model

	for j = 0, 300, jump do begin
	
		noise = array * j

		f_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, j, y_r_vel, y_r_acc, $
			percent_noise, dist_fit_f, tog=tog

		percent_noise_f[j] = percent_noise
		f_distance[j] = dist_fit_f[0]
		f_velocity[j] = dist_fit_f[1]

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

	endfor

	j_fls = file_search('~/IDL/f_diff_vary_noise_*.png')

	s = size(j_fls, /dim)

	for i = 1, s[0]-1 do begin

		read_png, j_fls[i-1], image

		wr_movie, 'f_diff_vary_noise', image, i-1, s[0]-1, $
			title = 'Forward-difference varying noise simulation', /delete

	endfor

; Reverse differentiation - Linear model

	for j = 0, 300, jump do begin
	
		noise = array * j

		r_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, j, y_r_vel, y_r_acc, $
			percent_noise, dist_fit_r, tog=tog

		percent_noise_r[j] = percent_noise
		r_distance[j] = dist_fit_r[0]
		r_velocity[j] = dist_fit_r[1]

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

	endfor

	j_fls = file_search('~/IDL/r_diff_vary_noise_*.png')

	s = size(j_fls, /dim)

	for i = 1, s[0]-1 do begin

		read_png, j_fls[i-1], image

		wr_movie, 'r_diff_vary_noise', image, i-1, s[0]-1, $
			title = 'Reverse-difference varying noise simulation', /delete

	endfor

; Centre differentiation - Linear model

	for j = 0, 300, jump do begin
	
		noise = array * j

		c_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, j, y_r_vel, y_r_acc, $
			percent_noise, dist_fit_c, tog=tog

		percent_noise_c[j] = percent_noise
		c_distance[j] = dist_fit_c[0]
		c_velocity[j] = dist_fit_c[1]

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

	endfor

	j_fls = file_search('~/IDL/c_diff_vary_noise_*.png')

	s = size(j_fls, /dim)

	for i = 1, s[0]-1 do begin

		read_png, j_fls[i-1], image

		wr_movie, 'c_diff_vary_noise', image, i-1, s[0]-1, $
			title = 'Centre-difference varying noise simulation', /delete

	endfor

; Lagrangian differentiation - Linear model

	for j = 0, 300, jump do begin
	
		noise = array * j

		l_num_diff_lin, cadence, r0, v0, time, n, noise, dist_noisy_f_lin, j, y_r_vel, y_r_acc, $
			percent_noise, dist_fit_l, tog=tog

		percent_noise_l[j] = percent_noise
		l_distance[j] = dist_fit_l[0]
		l_velocity[j] = dist_fit_l[1]

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

	endfor

	j_fls = file_search('~/IDL/l_diff_vary_noise_*.png')

	s = size(j_fls, /dim)

	for i = 1, s[0]-1 do begin

		read_png, j_fls[i-1], image

		wr_movie, 'l_diff_vary_noise', image, i-1, s[0]-1, $
			title = 'Lagrangian-difference varying noise simulation', /delete

	endfor

; Plot variation of mean noise level with variation in i_noise

	!p.multi = [0, 1, 2]
	
	window, 0, xs = 1000, ys = 1000
	
	ans = ' '

; Forward-diff

	plot, f_distance[0:*:jump], percent_noise_f[0:*:jump], xr = [-1, j+2], /xs, color = 0, $
		title = 'Variation in R0 with % noise (Forward-difference)', $
		xtitle = '% noise', ytitle = 'R0 (Mm)', , $
		background = 1, charsize = 1, thick = 2

	plot, x[0:*:jump], noise_level_f_acc[0:*:jump], title = ' Variation in acceleration noise level with std. dev. (F-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (m/s/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	x2png, 'f_diff_variation.png'

	read, 'ok?', ans

; Reverse-diff

	plot, x[0:*:jump], noise_level_r_vel[0:*:jump], title = ' Variation in velocity noise level with std. dev. (R-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (km/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	plot, x[0:*:jump], noise_level_r_acc[0:*:jump], title = ' Variation in acceleration noise level with std. dev. (R-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (m/s/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	x2png, 'r_diff_variation.png'

	read, 'ok?', ans

; Centre-diff

	plot, x[0:*:jump], noise_level_c_vel[0:*:jump], title = ' Variation in velocity noise level with std. dev. (C-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (km/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	plot, x[0:*:jump], noise_level_c_acc[0:*:jump], title = ' Variation in acceleration noise level with std. dev. (C-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (m/s/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	x2png, 'c_diff_variation.png'

	read, 'ok?', ans

; Lagrangian-diff

	plot, x[0:*:jump], noise_level_l_vel[0:*:jump], title = ' Variation in velocity noise level with std. dev. (L-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (km/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	plot, x[0:*:jump], noise_level_l_acc[0:*:jump], title = ' Variation in acceleration noise level with std. dev. (L-diff)', $
		xtitle = 'Standard Deviation', ytitle = 'Noise level (m/s/s)', xr = [-1, j+2], /xs, color = 0, $
		background = 1, charsize = 1, thick = 2

	x2png, 'l_diff_variation.png'

;	save, filename = 'noise.sav', array

stop
	
end