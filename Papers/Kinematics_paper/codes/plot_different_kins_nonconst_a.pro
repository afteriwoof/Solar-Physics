; Code to plot the different kinematics generate on a noised data set compaed with the model, for different numerical differencing schemes.

;Created: 01-12-2010

; Last edited: 14-12-2010

pro plot_different_kins_nonconst_a, test_point, chi_sq_v_forward, chi_sq_v_centre, chi_sq_a_forward, chi_sq_a_centre, a_fit_forward, a_fit_centre, fit_vel=fit_vel, no_plot=no_plot, no_legend=no_legend

!p.charsize=2
!p.thick=2
!p.charthick=2

!p.multi=[0,1,3]
;Model
r0 = 100e6 ;m
v0 = 400e3 ;m/s
a0 = 50. ;m/s/s

time = 2000. ;secs
t = dindgen(time)
cadence = 200. ;secs
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))

tt = t[0:*:cadence]

print, 'test_point is ', test_point
if ((test_point-cadence) mod cadence) ne 0 then print, 'test_point is not in line with cadence ', cadence
test_point = where(tt eq test_point)

;Ideal distance eqn
h = r0 + v0*tt + (1/2.)*a0*(tt^(5/2.))
v = v0 + (5/4.)*a0*(tt^(3/2.))
a = (15/8.)*a0*(tt^(1/2.))

; Model values at test_point
print, 'Model height at test_point ', h[test_point]/1e6
print, 'Model velocity at test_point ', v[test_point]/1e3
print, 'Model acceleration at test_point ', a[test_point]

;Noisy distance eqn
noise_percent=0
h_noisy = h + noise_percent*1e6*noise ;1%noise
;tt_noisy = tt+3.*noise2

;Derive kinematics
v_forward = choose_deriv(tt, h_noisy, /forward)
v_centre = choose_deriv(tt, h_noisy, /centre)
v_lagrangian = choose_deriv(tt, h_noisy, /lagrangian)
print, 'v_forward at test_point ', v_forward[test_point]/1e3
print, 'v_centre at test_point ', v_centre[test_point-1]/1e3
print, 'v_lagrangian at test_point ', v_lagrangian[test_point]/1e3

a_forward = choose_deriv(tt[0:n_elements(tt)-2], v_forward, /forward)
a_centre = choose_deriv(tt[1:n_elements(tt)-2], v_centre, /centre)
a_lagrangian = deriv(tt, v_lagrangian)
print, 'a_forward at test_point ', a_forward[test_point]
print, 'a_centre at test_point ', a_centre[test_point-2]
print, 'a_lagrangian at test_point ', a_lagrangian[test_point]

print, 'Absolute relative approx. error ', (abs((a_centre[test_point-2]-a_forward[test_point])/a_centre[test_point-2]))*100.

if keyword_set(fit_vel) then begin
        yf = 'p[0]*x + p[1]'
        f = mpfitexpr(yf, tt, v_forward, 100,[h_noisy[0],v_forward[0],a_forward[0]], /quiet)
	h_fit_forward = (f[0]*0.5)*tt^2. + f[1]*tt + h_noisy[0]
        v_fit_forward = f[0]*tt + f[1]
        a_fit_forward = f[0]
	f = mpfitexpr(yf, tt, v_centre, 1, [h_noisy[0],v_centre[0],a_centre[0]], /quiet)
	h_fit_centre = (f[0]*0.5)*tt^2. + f[1]*tt + h_noisy[0]
	v_fit_centre = f[0]*tt + f[1]
	a_fit_centre = f[0]
endif
;print, 'Model velocity: ', deriv(tt, h)

if ~keyword_set(no_plot) then begin
	plot, tt, h/1e6, psym=-0, /ylog, xtit='Time (secs)', ytit='Height (Mm)'
	oplot, tt, h_noisy/1e6, psym=1, color=3
	if keyword_set(fit_vel) then begin
		oplot, tt, h_fit_forward/1e6, linestyle=4, color=5
		oplot, tt, h_fit_centre/1e6, linestyle=5, color=3
	endif
	if ~keyword_set(no_legend) then legend, ['Model: r!D0!N+v!D0!Nt+0.5a!D0!Nt!U5/2!N','r!D0!N=100Mm, v!D0!N=400kms!U-1!N, a!D0!N=50ms!U-2!N',int2str(noise_percent)+'% Noise', int2str(cadence)+'s cadence'], charsize=1, box=0
	;oplot, tt_noisy, h_noisy, psym=1, color=4
endif

percent_noise = (abs(h_noisy - h)/h)*100.0d
;print, 'Mean % noise: ', mean(percent_noise)

if keyword_set(fit_vel) then begin
	chi_sq_v_forward = 0.
	for i=0,n_elements(v_forward)-1 do chi_sq_v_forward += (v_forward[i]-v_fit_forward[i])^2.
	chi_sq_v_centre = 0.
	for i=0,n_elements(v_centre)-1 do chi_sq_v_centre += (v_centre[i]-v_fit_centre[i])^2.
endif
	
if ~keyword_set(no_plot) then begin
	plot, tt, v/1e3, psym=-0, yr=[min(v_forward/1e3)-abs(min(v_forward/1e3)*0.05),max(v_forward/1e3)+abs(max(v_forward/1e3)*0.05)], xtit='Time (secs)', ytit='Velocity (km/s)'
	plots, tt[0:n_elements(tt)-2], v_forward/1e3, psym=-1, color=5
;	oplot, tt, deriv(tt, h)/1e3, psym=1, color=2
	;plots, tt, v_lagrangian/1e3, psym=-1, color=4
	plots, tt[1:n_elements(tt)-2], v_centre/1e3, psym=-1, color=3
	if keyword_set(fit_vel) then begin
		oplot, tt, v_fit_forward/1e3, linestyle=4, color=5
		oplot, tt, v_fit_centre/1e3, linestyle=5, color=3
		if ~keyword_set(no_legend) then legend, ['!9c!X!U2!Dforward!N='+int2str(chi_sq_v_forward),'!9c!X!U2!Dcentre!N='+int2str(chi_sq_v_centre)], charsize=1, box=0
	endif
endif

;plots, tt_noisy[0:n_elements(tt_noisy)-2], v_forward_n, psym=-1, color=5
;plots, tt_noisy[1:n_elements(tt_noisy)-2], v_centre_n, psym=-1, color=3
;plots, tt_noisy, v_lagrangian_n, psym=-1, color=4

;print, 'chi-squared v_forward: ', chi_squared
;print, 'chi-squared v_centre: ', chi_squared

;chi_squared = 0.
;for i=0,n_elements(v_lagrangian)-1 do chi_squared += (v_lagrangian[i]-v0)^2.
;print, 'chi-squared v_lagrangian: ', chi_squared

if keyword_set(fit_vel) then begin
	chi_sq_a_forward = 0.
	for i=0,n_elements(a_forward)-1 do chi_sq_a_forward += (a_forward[i]-a_fit_forward)^2.
	chi_sq_a_centre = 0.
	for i=0,n_elements(a_centre)-1 do chi_sq_a_centre += (a_centre[i]-a_fit_centre)^2.
endif

if ~keyword_set(no_plot) then begin
	plot, tt, a, psym=-0, yr=[min(a_forward)-abs(min(a_forward)*0.20),max(a_forward)+abs(max(a_forward)*0.20)], xtit='Time (secs)', ytit='Acceleration (m/s/s)'
	plots, tt[0:n_elements(tt)-3], a_forward, psym=-1, color=5
	;plots, tt, a_lagrangian, psym=-1, color=4
	plots, tt[2:n_elements(tt)-3], a_centre, psym=-1, color=3
	if keyword_set(fit_vel) then begin
		oplot, tt, replicate(a_fit_forward,n_elements(tt)), linestyle=4, color=5
		oplot, tt, replicate(a_fit_centre,n_elements(tt)), linestyle=5, color=3
		if ~keyword_set(no_legend) then legend, ['!9c!X!U2!Dforward!N='+int2str(chi_sq_a_forward),'!9c!X!U2!Dcentre!N='+int2str(chi_sq_a_centre)], charsize=1, box=0
		if ~keyword_set(no_legend) then legend, ['Forward fit '+int2str(a_fit_forward),'Centre fit '+int2str(a_fit_centre)], charsize=1, box=0, /bottom,/right
	endif
endif





end
