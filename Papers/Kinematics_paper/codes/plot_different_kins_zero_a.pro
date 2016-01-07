; Code to plot the different kinematics generate on a noised data set compaed with the model, for different numerical differencing schemes.

;Created: 25-11-2010

pro plot_different_kins, no_plot=no_plot, chi_sq_v_forward, chi_sq_v_centre, chi_sq_a_forward, chi_sq_a_centre

!p.multi=[0,1,3]
;Model
r0 = 100. ;Mm
v0 = 0.4 ;km/s
a0 = 0.

time = 2000. ;secs
t = dindgen(time)
cadence = 50. ;secs
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))

tt = t[0:*:cadence]

;Ideal distance eqn
h = r0 + v0*tt
;Noisy distance eqn
h_noisy = r0 + v0*tt + 3.*noise
tt_noisy = tt+3.*noise2

;print, 'Model velocity: ', deriv(tt, h)

if ~keyword_set(no_plot) then begin
plot, tt, h, psym=-1
oplot, tt, h_noisy, psym=1, color=3
;oplot, tt_noisy, h_noisy, psym=1, color=4
endif
percent_noise = (abs(h_noisy - h)/h)*100.0d
;print, 'Mean % noise: ', mean(percent_noise)

;Derive kinematics
v_forward = choose_deriv(tt, h_noisy, /forward)
v_centre = choose_deriv(tt, h_noisy, /centre)
v_lagrangian = choose_deriv(tt, h_noisy, /lagrangian)

v_forward_n = choose_deriv(tt_noisy, h_noisy, /forward)
v_centre_n = choose_deriv(tt_noisy, h_noisy, /centre)
v_lagrangian_n = choose_deriv(tt_noisy, h_noisy, /lagrangian)

a_forward = choose_deriv(tt[0:n_elements(tt)-2], v_forward, /forward)
a_centre = choose_deriv(tt[1:n_elements(tt)-2], v_centre, /centre)
a_lagrangian = deriv(tt, v_lagrangian)

if ~keyword_set(no_plot) then begin
plot, tt, replicate(v0, n_elements(tt)), psym=-1, yr=[0,1]
plots, tt[0:n_elements(tt)-2], v_forward, psym=-1, color=2
plots, tt, v_lagrangian, psym=-1, color=4
plots, tt[1:n_elements(tt)-2], v_centre, psym=-1, color=3
endif

;plots, tt_noisy[0:n_elements(tt_noisy)-2], v_forward_n, psym=-1, color=2
;plots, tt_noisy[1:n_elements(tt_noisy)-2], v_centre_n, psym=-1, color=3
;plots, tt_noisy, v_lagrangian_n, psym=-1, color=4

chi_sq_v_forward = 0.
for i=0,n_elements(v_forward)-1 do chi_sq_v_forward += (v_forward[i]-v0)^2.
;print, 'chi-squared v_forward: ', chi_squared
chi_sq_v_centre = 0.
for i=0,n_elements(v_centre)-1 do chi_sq_v_centre += (v_centre[i]-v0)^2.
;print, 'chi-squared v_centre: ', chi_squared

;chi_squared = 0.
;for i=0,n_elements(v_lagrangian)-1 do chi_squared += (v_lagrangian[i]-v0)^2.
;print, 'chi-squared v_lagrangian: ', chi_squared

chi_sq_a_forward = 0.
for i=0,n_elements(a_forward)-1 do chi_sq_a_forward += (a_forward[i]-a0)^2.
chi_sq_a_centre = 0.
for i=0,n_elements(a_centre)-1 do chi_sq_a_centre += (a_centre[i]-a0)^2.

if ~keyword_set(no_plot) then begin
	plot, tt, replicate(0, n_elements(tt)), psym=-1, yr=[-0.01,0.01]
	plots, tt[0:n_elements(tt)-3], a_forward, psym=-1, color=2
	plots, tt, a_lagrangian, psym=-1, color=4
	plots, tt[2:n_elements(tt)-3], a_centre, psym=-1, color=3
endif



a = 0.00005 ;50m/s/s

h_quad = r0 + v0*tt + 0.5*a0*(tt^2.)





end
