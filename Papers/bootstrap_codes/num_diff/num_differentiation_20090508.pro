; Routine to examine different numerical differentiation techniques for the SGM on 08/05/2009

pro num_differentiation_20090508

	!p.multi = [0, 1, 3]
	
	window, 0, xs = 800, ys = 1000

; Define time array

	t = findgen( 1900 ) + 100.

; Define initial conditions
	
	r_0 = 80.			; Initial distance = 80 Mm
	v_0 = 0.3			; Initial velocity = 300 km/s
	a_0 = 0.00005		; Initial acceleration = 50 m/s^2

; Defdine Noise-level

	noise_level = 0.01			; Noise level in % (0.1 = 10% noise)

; Ideal plot - Distance. Using constant acceleration model.

	r = r_0 + v_0*t + (0.5)*(a_0)*t^2.

;	cadence = 10

; FOR loop to account for varying cadence of observations - 1 second to 600 seconds

	for cadence = 1, 600, 5 do begin

;*****DISTANCE*****


; Plot ideal model

		plot, t, r, yr = [0, 1000], xtitle = 'Time (s)', ytitle = 'Distance (Mm)', $
				xr = [0, 2100], color = 0, title = 'Kinematics simulation - 1% noise', $
				/xs, thick = 1, charsize = 3.5, charthick = 1, background = 1

		set_line_color

; Obtain 'real' data by applying noise to cadence-affected ideal equation

		n = size(r[0:*:cadence], /n_elements)

; Noise in data

		sig_h = r[0:*:cadence] * noise_level * randomn( seed, n ) 		; Noise level is given in % (0.1 = 10%)

; Model added to noise in data to give pseudo-real data

		h_obs = r[0:*:cadence] + sig_h

		t_cad = t[0:*:cadence]

; Error in 'noisy' data
	
;		y_err = sig_h + replicate(31., n)								; errors for oplotting
;		t_err = replicate(0., n)

; Plot of 'real' data
	
		oplot, t_cad, h_obs, color = 7, psym = 2, thick = 2				; plot 'data'
;		oploterr, t_cad, h_obs, t_err, y_err, /nohat, errcolor = 3		; plot errors

		legend,['Model', 'Cadence-affected data', 'Using DERIV', 'Forward-differentiation', 'Reverse-differentiation'], $
				/bottom, /right, colors = [0, 7, 3, 6, 5], textcolor = [0, 7, 3, 6, 5], thick = 2, charsize = 1.5


;*****VELOCITY*****

; Ideal plot - Velocity
	
		v = 1000*(v_0 + a_0*t)											; Ideal velocity

; Cadence-affected data - derived from distance data

		vel = deriv(t_cad, h_obs*1000)									; obtain velocity from 'data' using DERIV

		d_x_f = t_cad[1:n-1] - t_cad[0:n-2]
		
		d_y_f = h_obs[1:n-1] - h_obs[0:n-2]

		v_forward = 1000.*((d_y_f)/(d_x_f))

		v_forward_err = 1000.*((d_x_f)/2.)*a_0


		d_y_r = h_obs[1:n-1] - h_obs[0:n-2]

		d_x_r = t_cad[1:n-1] - t_cad[0:n-2]

		v_reverse = 1000.*((d_y_r)/(d_x_r))


		d_y_c = h_obs[2:n-1] - h_obs[0:n-3]

		d_x_c = t_cad[2:n-1] - t_cad[0:n-3]

		v_centre = 1000.*((d_y_c)/(d_x_c))
		
; Plot Data points

		plot, t, v, yr = [0, 500], xtitle = 'Time (s)', ytitle = 'Velocity (kms!U-1!D)', $
				color = 0, background = 1, xr = [0, 2100], /xs, /ys, $
				thick = 1, charsize = 3.5, charthick = 1
	
;		deltav = derivsig(t_cad, h_obs*1000, 0.0, (h_err*1000.))

;		oplot, t_cad, vel, color = 3, psym = 2, thick = 2

		t_diff_fr = t_cad[0:n-2] + (t_cad[1:n-1] - t_cad[0:n-2])/2.

		t_diff_c = t_cad[0:n-3] + (t_cad[2:n-1] - t_cad[0:n-3])/2.

		oplot, t_diff_fr, v_forward, color = 6, psym = 2, thick = 2
;		oploterr, t_cad, v_forward, 0, v_forward_err, errcolor = 6, errthick = 2
;
		oplot, t_diff_fr, v_reverse, color = 5, psym = 2, thick = 2

		oplot, t_diff_c, v_centre, color = 2, psym = 2, thick = 2
	


;*****ACCELERATION*****

; Ideal plot - Acceleration

		a = 1e6*(a_0)					; known ideal acceleration

		a = replicate(a, 1900)

; Cadence-affected data - derived from velocity data

		acc = deriv(t_cad, vel*1000)								; obtain acceleration from velocity data using DERIV
;		deltaa = derivsig(t_cad, vel*1000, 0.0, (deltav*1000.))

		a_forward = 1000*((2./(d_x_f)^2.)*(d_y_f)); - (2./(d_x_f))*v_forward)

		a_reverse = 1000*((2./(d_x_r)^2.)*(d_y_r)); + (2./(d_x_f))*v_reverse )

		a_centre = 1000*((h_obs[2:n-1] - 2.*h_obs[1:n-2] + h_obs[0:n-3])/(d_x_c))

;		a_forward = 1000*((v_forward[1:n-4] - v_forward[0:n-5])/(t_cad[1:n-4] - t_cad[0:n-5]))

;		a_reverse = 1000*((v_reverse[2:n-3] - v_reverse[1:n-4])/(t_cad[2:n-3] - t_cad[1:n-4]))

; Plot Data points

		plot, t, a, yr = [-500, 500], xtitle = 'Time (s)', ytitle = 'Acceleration (ms!U-2!D)', $
				color = 0, background = 1, xr = [0, 2100], /xs, /ys, $
				thick = 1, charsize = 3.5, charthick = 1

;		oplot, t_cad, acc, color = 3, psym = 2, thick = 2

		oplot, t_diff_fr, a_forward, color = 6, psym = 2, thick = 2

		oplot, t_diff_fr, a_reverse, color = 5, psym = 2, thick = 2

		oplot, t_diff_c, a_centre, color = 2, psym = 2, thick = 2

; X-window to png

;		IF cadence LE 9 THEN BEGIN
;			s = arr2str(cadence, /trim)
;			x2png, 'SGM_20090508_fr_diff_00' + s +'.png'
;		ENDIF
;
;		IF (cadence GT 9) AND (cadence LE 99) THEN BEGIN
;			s = arr2str(cadence, /trim)
;			x2png, 'SGM_20090508_fr_diff_0' + s + '.png'
;		ENDIF
;
;		IF cadence GT 99 THEN BEGIN
;			s = arr2str(cadence, /trim)
;			x2png, 'SGM_20090508_fr_diff_' + s + '.png'
;		ENDIF

		wait, 0.1

	endfor
	

stop


end