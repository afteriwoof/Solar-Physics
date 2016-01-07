pro deriv_test, iterations

!p.multi = [0, 1, 2]

;********************************
; For constant Standard Deviation
;********************************

standard_deviation = 2.

; Calculations

main_mean_eqn_0 = fltarr(51)
main_mean_eqn_1 = fltarr(51)
main_mean_eqn_2 = fltarr(51)
main_mean_eqn_3 = fltarr(51)
main_mean_eqn_4 = fltarr(51)
main_mean_eqn_5 = fltarr(51)

main_mean_0 = fltarr(51)
main_mean_1 = fltarr(51)
main_mean_2 = fltarr(51)
main_mean_3 = fltarr(51)
main_mean_4 = fltarr(51)
main_mean_5 = fltarr(51)

main_mean_a_0 = fltarr(51)
main_mean_a_1 = fltarr(51)
main_mean_a_2 = fltarr(51)
main_mean_a_3 = fltarr(51)
main_mean_a_4 = fltarr(51)
main_mean_a_5 = fltarr(51)

; Increase number of data points under consideration

for n = 6, 50 do begin

mean_eqn_0 = fltarr(iterations)
mean_eqn_1 = fltarr(iterations)
mean_eqn_2 = fltarr(iterations)
mean_eqn_3 = fltarr(iterations)
mean_eqn_4 = fltarr(iterations)
mean_eqn_5 = fltarr(iterations)

mean_0 = fltarr(iterations)
mean_1 = fltarr(iterations)
mean_2 = fltarr(iterations)
mean_3 = fltarr(iterations)
mean_4 = fltarr(iterations)
mean_5 = fltarr(iterations)

mean_a_0 = fltarr(iterations)
mean_a_1 = fltarr(iterations)
mean_a_2 = fltarr(iterations)
mean_a_3 = fltarr(iterations)
mean_a_4 = fltarr(iterations)
mean_a_5 = fltarr(iterations)

; Repeat 1000 times to average over noise

;for i = 0, 999 do begin
i = 1
	ans = ' '
	t = findgen(n)
	u = 5.
	a = reverse(findgen(n))
	a = [a,replicate(0,n)]
	v = fltarr(n)
	h = fltarr(n)
	h_noise = fltarr(n)
	delta_t = randomn(seed, n)

	delta_t = delta_t*standard_deviation
	
	noise = replicate(standard_deviation, n)

	for k=0,n-1 do v[k] = u + a[k]*t[k]
	for k=0,n-1 do h[k] = u*t[k] + 0.5*a[k]*(t[k]^2.)

	for k=0,n-1 do h_noise[k] = u*t[k] + 0.5*a[k]*(t[k]^2.) + delta_t[k]

	deriv_v = deriv(t,h)
	deriv_v_err = derivsig(t, h, 0.0, 0.0)
	deriv_a = deriv(t,deriv_v)
	deriv_a_err = derivsig(t, deriv_v, 0.0, deriv_v_err)

	deriv_v_noise = deriv(t,h_noise)
	deriv_v_noise_err = derivsig(t, h_noise, 0.0, noise)
	deriv_a_noise = deriv(t,deriv_v_noise)
	deriv_a_noise_err = derivsig(t, deriv_v_noise, 0.0, deriv_v_noise_err)

	deriv_v_1 = deriv(t,smooth((h), 3, /edge))
	deriv_v_err_1 = derivsig(t, smooth((h), 3, /edge), 0.0, 0.0)
	deriv_a_1 = deriv(t,smooth((deriv_v_1), 3, /edge))
	deriv_a_err_1 = derivsig(t, smooth((deriv_v_1), 3, /edge), 0.0, deriv_v_err_1)

	deriv_v_2 = deriv(t,smooth((h_noise), 3, /edge))
	deriv_v_err_2 = derivsig(t, smooth((h_noise), 3, /edge), 0.0, noise)
	deriv_a_2 = deriv(t,smooth((deriv_v_2), 3, /edge))
	deriv_a_err_2 = derivsig(t, smooth((deriv_v_err_1), 3, /edge), 0.0, deriv_v_err_2)

	v_forward = (h[1:*] - h[0:n-1])/(t[1:*] - t[0:n-1])
	v_forward = smooth(v_forward, 3, /edge)
	v_forward_err = t[1:*] - t[0:n-1]

	a_forward = (v_forward[1:*] - v_forward[0:n-2])/(t[1:*] - t[0:n-2])
	a_forward = smooth(a_forward, 3, /edge)
	a_forward_err = t[1:*] - t[0:n-2]

	v_reverse = (h[0:n-1] - h[1:*])/(t[0:n-1] - t[1:*])
	v_reverse = smooth(v_reverse, 3, /edge)
	v_reverse_err = t[0:n-1] - t[1:*]

	a_reverse = (v_reverse[0:n-2] - v_reverse[1:*])/(t[0:n-2] - t[1:*])
	a_reverse = smooth(a_reverse, 3, /edge)
	a_reverse_err = t[0:n-2] - t[1:*]


; Plots

	set_line_color

; Distance

;	plot, t, h, xr = [-1, n], yr = [min(h), max(h)], xs = 1, background = 1, color = 0, thick = 2
;	read, 'Known Distance Equation - OK?', ans
;
;	oplot, t, h_noise, color = 3, thick = 2
;	oploterr, h_noise, noise, errcolor = 3, errthick = 2
;	legend, ['Equation', 'Equation & noise'], color = [0, 3], /bottom, /right, outline_color = 0, textcolors = [0, 3]
;
;	read, 'Known Distance Equation with noise added - OK?', ans

;***********
;***********
; Equation
;***********
;***********

	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(v - v))/v
	mean_eqn_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(v - v))/v
	mean_eqn_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(v - v))/v
	mean_eqn_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(v - v))/v
	mean_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(v - v))/v
	mean_eqn_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(v - v))/v
	mean_eqn_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]

;***********
;***********
; Velocity
;***********
;***********

;	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(v - deriv_v))/v
	mean_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

;	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(v - deriv_v_noise))/v
	mean_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(v - deriv_v_1))/v
	mean_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

;	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(v - deriv_v_2))/v
	mean_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(v - v_forward))/v
	mean_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(v - v_reverse))/v
	mean_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]


;*************
;*************
; Acceleration
;*************
;*************

;	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(a - deriv_a))/a
	mean_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

;	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(a - deriv_a_noise))/a
	mean_a_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(a - deriv_a_1))/a
	mean_a_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

;	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(a - deriv_a_2))/a
	mean_a_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(a - a_forward))/a
	mean_a_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(a - a_reverse))/a
	mean_a_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]

;endfor

;main_mean_eqn_0[n] = (mean(mean_eqn_0, /nan))*100.
;main_mean_eqn_1[n] = (mean(mean_eqn_1, /nan))*100.
;main_mean_eqn_2[n] = (mean(mean_eqn_2, /nan))*100.
;main_mean_eqn_3[n] = (mean(mean_eqn_3, /nan))*100.
;main_mean_eqn_4[n] = (mean(mean_eqn_4, /nan))*100.
;main_mean_eqn_5[n] = (mean(mean_eqn_5, /nan))*100.

;main_mean_0[n] = (mean(mean_0, /nan))*100.
;main_mean_1[n] = (mean(mean_1, /nan))*100.
;main_mean_2[n] = (mean(mean_2, /nan))*100.
;main_mean_3[n] = (mean(mean_3, /nan))*100.
;main_mean_4[n] = (mean(mean_4, /nan))*100.
;main_mean_5[n] = (mean(mean_5, /nan))*100.

;main_mean_a_0[n] = (mean(mean_a_0, /nan))*100.
;main_mean_a_1[n] = (mean(mean_a_1, /nan))*100.
;main_mean_a_2[n] = (mean(mean_a_2, /nan))*100.
;main_mean_a_3[n] = (mean(mean_a_3, /nan))*100.
;main_mean_a_4[n] = (mean(mean_a_4, /nan))*100.
;main_mean_a_5[n] = (mean(mean_a_5, /nan))*100.

endfor

;x_arr_main_mean_eqn_1 = findgen(45)

;x_arr_main_mean_1 = findgen(45)
;x_arr_main_mean_3 = findgen(45)

;x_arr_main_mean_a_1 = findgen(45)
;x_arr_main_mean_a_3 = findgen(45)


;plot, x_arr_main_mean_1, main_mean_1, psym = 2, xtitle = 'Number of data points', ytitle = '% difference of data points from equation', $
;		title = '% difference from equation with increasing data points (Velocity)', xr = [5, 45], xs = 1, charsize = 1.5, background = 1, color = 0

;oplot, x_arr_main_mean_3, main_mean_3, psym = 4, color = 3

;oplot, x_arr_main_mean_eqn_1, main_mean_eqn_3, psym = 5, color = 5

;legend, ['Deriv', 'Deriv + smooth', 'Original Equation'], psym = [2, 4, 5], colors = [0, 3, 5], textcolors = [0, 3, 5]


;plot, x_arr_main_mean_a_1, main_mean_a_1, psym = 2, xtitle = 'Number of data points', ytitle = '% difference of data points from equation', $
;		title = '% difference from equation with increasing data points (Acceleration)', xr = [5, 45], xs = 1, charsize = 1.5, background = 1, color = 0

;oplot, x_arr_main_mean_a_3, main_mean_a_3, psym = 4, color = 3

;oplot, x_arr_main_mean_eqn_1, main_mean_eqn_3, psym = 5, color = 5

;legend, ['Deriv', 'Deriv + smooth', 'Original Equation'], psym = [2, 4, 5], colors = [0, 3, 5], textcolors = [0, 3, 5]

;x2png, 'data_points.png'

;stop

;***********************************
; For constant number of data points
;***********************************

n = 8.

; Calculations

main_mean_eqn_0 = fltarr(31)
main_mean_eqn_1 = fltarr(31)
main_mean_eqn_2 = fltarr(31)
main_mean_eqn_3 = fltarr(31)
main_mean_eqn_4 = fltarr(31)
main_mean_eqn_5 = fltarr(31)

main_mean_0 = fltarr(31)
main_mean_1 = fltarr(31)
main_mean_2 = fltarr(31)
main_mean_3 = fltarr(31)
main_mean_4 = fltarr(31)
main_mean_5 = fltarr(31)

main_mean_a_0 = fltarr(31)
main_mean_a_1 = fltarr(31)
main_mean_a_2 = fltarr(31)
main_mean_a_3 = fltarr(31)
main_mean_a_4 = fltarr(31)
main_mean_a_5 = fltarr(31)

; Increase number of data points under consideration

for standard_deviation = 1, 30 do begin

mean_eqn_0 = fltarr(iterations)
mean_eqn_1 = fltarr(iterations)
mean_eqn_2 = fltarr(iterations)
mean_eqn_3 = fltarr(iterations)
mean_eqn_4 = fltarr(iterations)
mean_eqn_5 = fltarr(iterations)

mean_0 = fltarr(iterations)
mean_1 = fltarr(iterations)
mean_2 = fltarr(iterations)
mean_3 = fltarr(iterations)
mean_4 = fltarr(iterations)
mean_5 = fltarr(iterations)

mean_a_0 = fltarr(iterations)
mean_a_1 = fltarr(iterations)
mean_a_2 = fltarr(iterations)
mean_a_3 = fltarr(iterations)
mean_a_4 = fltarr(iterations)
mean_a_5 = fltarr(iterations)

; Repeat 1000 times to average over noise

for i = 0, 999 do begin

	ans = ' '
	t = findgen(n)
	u = 5.
	a = reverse(findgen(n))
	a = [a,replicate(0,n)]
	v = fltarr(n)
	h = fltarr(n)
	h_noise = fltarr(n)
	delta_t = randomn(seed, n)

	delta_t = delta_t*standard_deviation
	
	noise = replicate(standard_deviation, n)

	for k=0,n-1 do v[k] = u + a[k]*t[k]
	for k=0,n-1 do h[k] = u*t[k] + 0.5*a[k]*(t[k]^2.)

	for k=0,n-1 do h_noise[k] = u*t[k] + 0.5*a[k]*(t[k]^2.) + delta_t[k]

	deriv_v = deriv(t,h)
	deriv_v_err = derivsig(t, h, 0.0, 0.0)
	deriv_a = deriv(t,deriv_v)
	deriv_a_err = derivsig(t, deriv_v, 0.0, deriv_v_err)

	deriv_v_noise = deriv(t,h_noise)
	deriv_v_noise_err = derivsig(t, h_noise, 0.0, noise)
	deriv_a_noise = deriv(t,deriv_v_noise)
	deriv_a_noise_err = derivsig(t, deriv_v_noise, 0.0, deriv_v_noise_err)

	deriv_v_1 = deriv(t,smooth((h), 3, /edge))
	deriv_v_err_1 = derivsig(t, smooth((h), 3, /edge), 0.0, 0.0)
	deriv_a_1 = deriv(t,smooth((deriv_v_1), 3, /edge))
	deriv_a_err_1 = derivsig(t, smooth((deriv_v_1), 3, /edge), 0.0, deriv_v_err_1)

	deriv_v_2 = deriv(t,smooth((h_noise), 3, /edge))
	deriv_v_err_2 = derivsig(t, smooth((h_noise), 3, /edge), 0.0, noise)
	deriv_a_2 = deriv(t,smooth((deriv_v_2), 3, /edge))
	deriv_a_err_2 = derivsig(t, smooth((deriv_v_err_1), 3, /edge), 0.0, deriv_v_err_2)

	v_forward = (h[1:*] - h[0:n-1])/(t[1:*] - t[0:n-1])
	v_forward = smooth(v_forward, 3, /edge)
	v_forward_err = t[1:*] - t[0:n-1]

	a_forward = (v_forward[1:*] - v_forward[0:n-2])/(t[1:*] - t[0:n-2])
	a_forward = smooth(a_forward, 3, /edge)
	a_forward_err = t[1:*] - t[0:n-2]

	v_reverse = (h[0:n-1] - h[1:*])/(t[0:n-1] - t[1:*])
	v_reverse = smooth(v_reverse, 3, /edge)
	v_reverse_err = t[0:n-1] - t[1:*]

	a_reverse = (v_reverse[0:n-2] - v_reverse[1:*])/(t[0:n-2] - t[1:*])
	a_reverse = smooth(a_reverse, 3, /edge)
	a_reverse_err = t[0:n-2] - t[1:*]


; Plots

	set_line_color

; Distance

;	plot, t, h, xr = [-1, n], yr = [min(h), max(h)], xs = 1, background = 1, color = 0, thick = 2
;	read, 'Known Distance Equation - OK?', ans
;
;	oplot, t, h_noise, color = 3, thick = 2
;	oploterr, h_noise, noise, errcolor = 3, errthick = 2
;	legend, ['Equation', 'Equation & noise'], color = [0, 3], /bottom, /right, outline_color = 0, textcolors = [0, 3]
;
;	read, 'Known Distance Equation with noise added - OK?', ans

;***********
;***********
; Equation
;***********
;***********

;	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(v - v))/v
	mean_eqn_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

;	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(v - v))/v
	mean_eqn_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(v - v))/v
	mean_eqn_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

;	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(v - v))/v
	mean_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(v - v))/v
	mean_eqn_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(v - v))/v
	mean_eqn_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]

;***********
;***********
; Velocity
;***********
;***********

;	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(v - deriv_v))/v
	mean_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

;	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(v - deriv_v_noise))/v
	mean_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(v - deriv_v_1))/v
	mean_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

;	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(v - deriv_v_2))/v
	mean_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(v - v_forward))/v
	mean_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(v - v_reverse))/v
	mean_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]


;*************
;*************
; Acceleration
;*************
;*************

;	plot, t, v, xr = [-1, n], yr=[-10,max([v,deriv_v]) + 10], xs = 1, background = 1, color = 0, thick = 2, linestyle = 0
;	read, 'Known Velocity Equation - OK?', ans


; Oplot deriv_v

;	oplot, t, deriv_v, color = 3, thick = 2, linestyle = 0
;	oploterr, deriv_v, deriv_v_err, errcolor = 3, errthick = 2

	diff_0 = (abs(a - deriv_a))/a
	mean_0[i] = mean(diff_0, /nan)
;	print, '% Difference from actual expected value = ', mean_0
;
;	read, 'Velocity using DERIV on known distance equation - OK?', ans


; Oplot deriv_v_noise (Actual dist + noise)

;	oplot, t, deriv_v_noise, color = 4, thick = 2, linestyle = 0
;	oploterr, deriv_v_noise, deriv_v_noise_err, errcolor = 4, errthick = 2

	diff_1 = (abs(a - deriv_a_noise))/a
	mean_a_1[i] = mean(diff_1, /nan)
;	print, '% Difference from actual expected value = ', mean_1
;
;	read, 'Velocity using DERIV on known distance + noise - OK?', ans


; Oplot deriv_v_1 (Smooth actual dist)

;	oplot, t, deriv_v_1, color = 5, thick = 2, linestyle = 0
;	oploterr, deriv_v_1, deriv_v_err_1, errcolor = 5, errthick = 2

	diff_2 = (abs(a - deriv_a_1))/a
	mean_a_2[i] = mean(diff_2, /nan)
;	print, '% Difference from actual expected value = ', mean_2
;
;	read, 'Velocity using DERIV on smoothed known distance equation - OK?', ans


; Oplot deriv_v_2 (Smooth actual dist + noise)

;	oplot, t, deriv_v_2, color = 6, thick = 2, linestyle = 0
;	oploterr, deriv_v_2, deriv_v_err_2, errcolor = 6, errthick = 2

	diff_3 = (abs(a - deriv_a_2))/a
	mean_a_3[i] = mean(diff_3, /nan)
;	print, '% Difference from actual expected value = ', mean_3
;
;	read, 'Velocity using DERIV on smoothed known distance + noise equation - OK?', ans


; Oplot v_forward (Forward Differentiation)

;	oplot, t, v_forward, color = 7, thick = 2, linestyle = 0
;	oploterr, v_forward, v_forward_err, errcolor = 7, errthick = 2

	diff_4 = (abs(a - a_forward))/a
	mean_a_4[i] = mean(diff_4, /nan)
;	print, '% Difference from actual expected value = ', mean_4
;
;	read, 'Velocity using forward differentiation on known distance equation - OK?', ans


; Oplot v_reverse (Reverse Differentiation)

;	oplot, t, v_reverse, color = 9, thick = 2, linestyle = 0
;	oploterr, v_reverse, v_reverse_err, errcolor = 9, errthick = 2

	diff_5 = (abs(a - a_reverse))/a
	mean_a_5[i] = mean(diff_5, /nan)
;	print, '% Difference from actual expected value = ', mean_5
;
;	read, 'Velocity using reverse differentiation on known distance equation - OK?', ans
;
;	legend, ['Equation', 'Deriv', 'Deriv with noise', 'Deriv Smooth equation', 'Deriv Smooth noise', 'Forward', 'Reverse'], $
;		color = [0, 3, 4, 5, 6, 7, 9], /bottom, /right, outline_color = 0, textcolors = [0, 3, 4, 5, 6, 7, 9]

endfor

main_mean_eqn_0[standard_deviation] = (mean(mean_eqn_0, /nan))*100.
main_mean_eqn_1[standard_deviation] = (mean(mean_eqn_1, /nan))*100.
main_mean_eqn_2[standard_deviation] = (mean(mean_eqn_2, /nan))*100.
main_mean_eqn_3[standard_deviation] = (mean(mean_eqn_3, /nan))*100.
main_mean_eqn_4[standard_deviation] = (mean(mean_eqn_4, /nan))*100.
main_mean_eqn_5[standard_deviation] = (mean(mean_eqn_5, /nan))*100.

main_mean_0[standard_deviation] = (mean(mean_0, /nan))*100.
main_mean_1[standard_deviation] = (mean(mean_1, /nan))*100.
main_mean_2[standard_deviation] = (mean(mean_2, /nan))*100.
main_mean_3[standard_deviation] = (mean(mean_3, /nan))*100.
main_mean_4[standard_deviation] = (mean(mean_4, /nan))*100.
main_mean_5[standard_deviation] = (mean(mean_5, /nan))*100.

main_mean_a_0[standard_deviation] = (mean(mean_a_0, /nan))*100.
main_mean_a_1[standard_deviation] = (mean(mean_a_1, /nan))*100.
main_mean_a_2[standard_deviation] = (mean(mean_a_2, /nan))*100.
main_mean_a_3[standard_deviation] = (mean(mean_a_3, /nan))*100.
main_mean_a_4[standard_deviation] = (mean(mean_a_4, /nan))*100.
main_mean_a_5[standard_deviation] = (mean(mean_a_5, /nan))*100.

endfor

x_arr_main_mean_eqn_1 = findgen(45)

x_arr_main_mean_1 = findgen(45)
x_arr_main_mean_3 = findgen(45)

x_arr_main_mean_a_1 = findgen(45)
x_arr_main_mean_a_3 = findgen(45)


plot, x_arr_main_mean_1, main_mean_1, psym = 2, xtitle = 'Standard Deviation of noise', ytitle = '% difference of data points from equation', $
		title = '% difference from equation with increasing noise (Velocity)', xr = [0, 31], xs = 1, charsize = 1.5, background = 1, color = 0

oplot, x_arr_main_mean_3, main_mean_3, psym = 4, color = 3

oplot, x_arr_main_mean_eqn_1, main_mean_eqn_1, psym = 5, color = 5

legend, ['Deriv', 'Deriv + smooth', 'Original Equation'], psym = [2, 4, 5], colors = [0, 3, 5], textcolors = [0, 3, 5]


plot, x_arr_main_mean_a_1, main_mean_a_1, psym = 2, xtitle = 'Standard Deviation of noise', ytitle = '% difference of data points from equation', $
		title = '% difference from equation with increasing noise (Acceleration)', xr = [0, 31], xs = 1, charsize = 1.5, background = 1, color = 0

oplot, x_arr_main_mean_a_3, main_mean_a_3, psym = 4, color = 3

oplot, x_arr_main_mean_eqn_1, main_mean_eqn_1, psym = 5, color = 5

legend, ['Deriv', 'Deriv + smooth', 'Original Equation'], psym = [2, 4, 5], colors = [0, 3, 5], textcolors = [0, 3, 5]

x2png, 'noise.png'

end