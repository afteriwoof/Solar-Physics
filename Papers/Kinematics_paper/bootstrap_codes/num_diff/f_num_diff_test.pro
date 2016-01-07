; Routine to test the forward difference numerical differentiation technique for future use

pro f_num_diff_test, cadence

	set_line_color
	
	!p.multi = [0, 1, 3]
	
; Define routine parameters

	r0 = 150.

	v0 = 0.4

	time = 2000.

; Define time array

	t = findgen(time)
	
; Define distance equation
	
	d = v0*t[0:*:cadence] + r0

; Calculate noise to add to equation

	n = size(t[0:*:cadence], /n_elements)

	print, n
	
	array = randomn(seed, n)
	
	noise = array * 1.

; Add noise to data

	d_noisy = noise*v0*t[0:*:cadence] + noise*r0
	
; Plot distance-time data from plain equation
	
	plot, t[0:*:cadence], d, psym = 1, xr = [0, max(t)], /xs, yr = [-1.1*max(d_noisy), 1.1*max(d_noisy)], /ys, $
		title = 'Distance-Time plot', charsize = 2, xtit = 'Time (s)', ytit = 'Distance (Mm)', $
		background = 1, color = 0

	oplot, t[0:*:cadence], d_noisy, psym = 2, color = 3, thick = 2

	oploterr, t[0:*:cadence], d, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t[0:*:cadence], d_noisy, replicate(30, n), /nohat, /noconnect, errthick = 2, errcolor= 3

	legend, ['Known', 'Noisy'], textcolor = [0, 3], charsize = 2, thick = 2, /clear, /bottom, /right, $
		outline_color = 0


;***********************
; Velocity Calculations
;***********************

; Define normalised time array for Taylor series analysis.

	t_norm = findgen(time)/time

; Calculate numerically differentiated data for ideal noiseless data

	t_cad = t_norm[0:*:cadence]

	num_diff_upper = d[2:max(n)-1] - d[1:max(n)-2]

	print, num_diff_upper

	num_diff_lower = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	print, num_diff_lower

	vel_num_diff = 1000.*((num_diff_upper)/(num_diff_lower))

	vel_num_diff_cad = 1000.*((num_diff_upper)/(num_diff_lower))*(cadence/time)

	print, vel_num_diff_cad
	
; Calculate numerically differentiated data for noisy data

	num_diff_upper_noisy = d_noisy[2:max(n)-1] - d_noisy[1:max(n)-2]

	num_diff_lower_noisy = t_cad[2:max(n)-1] - t_cad[1:max(n)-2]

	vel_num_diff_noisy = 1000.*((num_diff_upper_noisy)/(num_diff_lower_noisy))

	vel_num_diff_noisy_cad = 1000.*((num_diff_upper_noisy)/(num_diff_lower_noisy))*(cadence/time)

	print, vel_num_diff_noisy_cad
	
;*************************
; Velocity Error Analysis
;*************************

	error_vel = (2./num_diff_lower^2.)*(num_diff_upper) - (2./num_diff_lower)*(vel_num_diff)
	
	error_vel_cad = error_vel*(cadence/time)
	
	print, error_vel_cad

	error_vel_noisy = (2./num_diff_lower_noisy^2.)*(num_diff_upper_noisy) - (2./num_diff_lower_noisy)*(vel_num_diff_noisy)
	
	error_vel_noisy_cad = error_vel_noisy*(cadence/time)

	print, error_vel_noisy_cad

;****************
; Velocity Plots
;****************

	t_plot = t_cad*time

	plot, t_plot[1:max(n)-2], vel_num_diff_cad, psym = 4, xr = [0, max(t)], /xs, color = 0, $
		yr = [-1.1*max(error_vel_noisy_cad), 1.1*max(error_vel_noisy_cad)], /ys, $
		title = 'Velocity-Time plot', charsize = 2, xtit = 'Time (s)', ytit = 'Velocity (km/s)'

	oplot, t_plot[1:max(n)-2], vel_num_diff_noisy_cad, psym = 2, color = 3, thick = 2

	oploterr, t_plot[1:max(n)-2], vel_num_diff_cad, error_vel_cad, /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t_plot[1:max(n)-2], vel_num_diff_noisy_cad, error_vel_noisy_cad, /nohat, /noconnect, errthick = 2, errcolor= 3

;***************************
; Acceleration Calculations
;***************************

; Calculate numerically differentiated data for ideal noiseless data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	acc_num_diff_upper = vel_num_diff[2:max(m)-1] - vel_num_diff[1:max(m)-2]

	print, acc_num_diff_upper

	acc_num_diff_lower = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	print, acc_num_diff_lower

	acc_num_diff = 1000.*((acc_num_diff_upper)/(acc_num_diff_lower))

	acc_num_diff_cad = 1000.*((acc_num_diff_upper)/(acc_num_diff_lower))*(cadence/time)

	print, acc_num_diff_cad
	
; Calculate numerically differentiated data for ideal noiseless data

	t_cadence = t_cad[1:max(n)-2]

	m = size(t_cadence, /n_elements)

	acc_num_diff_upper_noisy = vel_num_diff_noisy[2:max(m)-1] - vel_num_diff_noisy[1:max(m)-2]

	print, acc_num_diff_upper_noisy

	acc_num_diff_lower_noisy = t_cadence[2:max(m)-1] - t_cadence[1:max(m)-2]

	print, num_diff_lower_noisy

	acc_num_diff_noisy = 1000.*((acc_num_diff_upper_noisy)/(acc_num_diff_lower_noisy))

	acc_num_diff_noisy_cad = 1000.*((acc_num_diff_upper_noisy)/(acc_num_diff_lower_noisy))*(cadence/time)

	print, acc_num_diff_noisy_cad

;*****************************
; Acceleration Error Analysis
;*****************************

	error_acc = (2./acc_num_diff_lower^2.)*(acc_num_diff_upper) - (2./acc_num_diff_lower)*(acc_num_diff)
	
	error_acc_cad = error_acc*(cadence/time)
	
	print, error_acc_cad

	error_acc_noisy = (2./acc_num_diff_lower_noisy^2.)*(acc_num_diff_upper_noisy) - (2./acc_num_diff_lower_noisy)*(acc_num_diff_noisy)
	
	error_acc_noisy_cad = error_acc_noisy*(cadence/time)

	print, error_acc_noisy_cad

;********************
; Acceleration Plots
;********************

	t_plotting = t_cadence*time

	plot, t_plotting[1:max(m)-2], acc_num_diff_cad, psym = 4, xr = [0, max(t)], /xs, color = 0, $
		yr = [-1.1*max(error_acc_noisy_cad), 1.1*max(error_acc_noisy_cad)], /ys, $
		title = 'Acceleration-Time plot', charsize = 2, xtit = 'Time (s)', ytit = 'Acceleration (m/s/s)'

	oplot, t_plotting[1:max(m)-2], acc_num_diff_noisy_cad, psym = 2, color = 3, thick = 2

	oploterr, t_plotting[1:max(m)-2], acc_num_diff_cad, error_acc_cad, /nohat, /noconnect, errthick = 2, errcolor= 0

	oploterr, t_plotting[1:max(m)-2], acc_num_diff_noisy_cad, error_acc_noisy_cad, /nohat, /noconnect, errthick = 2, errcolor= 3

	stop
end