; Code to plot the different kinematics generate on a noised data set compared with the model.


; Created	20120404	from plot_different_kins_cadence_fixedpoints.pro
;				to only use the 3-pt Lagrangian, and on the updated peakaccel model.


pro plot_peakaccel, cadence, fixed, no_plot=no_plot, fit_vel=fit_vel, large_range=large_range, af, ac, al, att, a_max,af_fixed_err,ac_fixed_err,al_fixed_err, no_legend=no_legend, plot_fixed_point=plot_fixed_point, tog=tog, no_trunc=no_trunc

window, xs=800, ys=1200
!p.charsize=2
set_line_color

if ~exist(cadence) then begin
	print, 'No cadence specified: default is 100.'
	cadence = 100
endif
if ~exist(fixed) then begin
	print, 'No fixed point specified: default is 100.'
	fixed = 100
endif

fls=file_Search('~/postdoc/cme_model/run_peakaccel_file_increment1_20110920a/separated/fits/2005/01/18/*cme*')
mreadfits_corimp, fls, in

time = in.date_obs
t = anytim(time)
utbasedata = t[0]


if ~keyword_set(tog) then begin
	!p.charsize=2
	!p.thick=1
	!x.thick=1
	!y.thick=1
	!p.charthick=1
endif else begin
	!p.charsize=2
	!p.thick=3
	!x.thick=3
	!y.thick=3
	!p.charthick=3
endelse
!p.multi=[0,1,3]
;Model
;r0 = 100e6 ;m
;v0 = 400e3 ;m/s
;a0 = 50. ;m/s/s

total_t = 50.
t_model = dindgen(total_t+1)
t = t_model
;time = 200. ;secs
;t = dindgen(time)
;cadence = 1. ;secs
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))

help, fixed, cadence, total_t

; coding up the timesteps from fixed with cadence
start_limit = float(fixed)
while (start_limit-cadence) gt 0 do start_limit-=cadence
help, start_limit
end_limit = float(fixed)
while (end_limit+cadence) lt total_t do	end_limit+=cadence
help, end_limit	
tt = start_limit
count=1
while max(tt) lt end_limit do tt=[tt,tt[n_elements(tt)-1]+cadence]
help, tt

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0 ;second

; Accel model:
model_fac = 10.
h_fullmodel = (sqrt(model_fac*2))*(t*atan(exp(t/(model_fac*2))/sqrt(model_fac*2)))
v_fullmodel = sqrt((model_fac*2))*atan(exp(t/(model_fac*2))/sqrt(model_fac*2)) + (exp(t/(model_fac*2))*t)/((model_fac*2)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2))*((model_fac*2)*(t+(model_fac*4))-exp(t/(model_fac))*(t-(model_fac*4))))/((model_fac*2)*((exp(t/model_fac)+(model_fac*2))^2.))

; To make a smoother velocity with no deceleration:
help, t
pmm, t
temp = max(t)/5.
t -= temp
pmm, t
h_fullmodel = t*atan(t)
v_fullmodel = t / (t^2.+1) + atan(t)
a_fullmodel = 2./((t^2.+1)^2.)
t += temp
plot, h_fullmodel
plot, v_fullmodel
plot, a_fullmodel
pause

print, 'Location of acceleration peak: ', where(a_fullmodel eq max(a_fullmodel))
print, 'Location of acceleration minimum: ', where(a_fullmodel eq min(a_fullmodel))

h = (sqrt(model_fac*2))*(tt*atan(exp(tt/(model_fac*2.))/sqrt(model_fac*2)))
v = sqrt((model_fac*2))*atan(exp(tt/(model_fac*2))/sqrt(model_fac*2)) + (exp(tt/(model_fac*2))*tt)/((model_fac*2)+exp(tt/model_fac))
a = (exp(tt/(model_fac*2))*((model_fac*2)*(tt+(model_fac*4))-exp(tt/(model_fac))*(tt-(model_fac*4))))/((model_fac*2)*((exp(tt/model_fac)+(model_fac*2))^2.))

height_factor = 1e2
vel_factor = 1e-1
accel_factor = 1e-4

;Noisy distance eqn
noise_percent = 0.
print, 'Can change the noise percent, currently set at ', noise_percent

if noise_percent eq 0 then h_noisy = h; + noise_percent*height_factor*noise
if noise_percent ne 0 then h_noisy = h + (noise_percent/100.)*h*noise 
;tt_noisy = tt+3.*noise2

; Using errorbars are the percentage error for 1-sigma error on hieght-time.
errorbars = 1 ;percent
h_noisy_sig = h_noisy*(errorbars/100.)

print, '---------------------------------------'

;Derive kinematics
v_lagrangian = choose_deriv(tt, h_noisy, vl_trunc_err, /lagrangian, no_trunc=no_trunc)
if ~keyword_set(no_trunc) then begin
	print, '******************'
	print, 'Lagrangian differencing:'
	print, 'v_lagrangian: ', v_lagrangian,  'abs(vl_trunc_err): ', abs(vl_trunc_err)
	print, 'percentage truncation error:', abs(vl_trunc_err/v_lagrangian) * 100
	print, '******************'
endif

v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)
v_lagrangian_sig_man = dblarr(n_elements(v_lagrangian))
for k=1,n_elements(v_lagrangian_sig_man)-2 do v_lagrangian_sig_man[k] = sqrt( (h_noisy_sig[k+1]^2.+h_noisy_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (v_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint v_lagrangian: ', v_lagrangian_sig[where(tt eq fixed)]/vel_factor

a_lagrangian = deriv(tt, v_lagrangian)

a_lagrangian_sig = derivsig(tt, v_lagrangian, tt_sig, v_lagrangian_sig)
a_lagrangian_sig_man = dblarr(n_elements(a_lagrangian))
for k=1,n_elements(a_lagrangian_sig_man)-2 do a_lagrangian_sig_man[k] = sqrt( (v_lagrangian_sig[k+1]^2.+v_lagrangian_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (a_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint a_lagrangian_sig: ', a_lagrangian_sig[where(tt eq fixed)]/accel_factor
al_fixed_err = a_lagrangian_sig[where(tt eq fixed)]/accel_factor

print, '---------------------------------------'


if ~keyword_set(no_plot) then begin
	utplot, tt, h/height_factor, utbasedata, psym=-0, linestyle=1, ytit='Height (Mm)'
	;/ylog, yr=[0.1,100],/ys
	oploterror, tt, h_noisy/height_factor, tt_sig, h_noisy_sig/height_factor, psym=3
	if ~keyword_set(no_legend) then legend, [int2str(noise_percent)+'% Noise', int2str(cadence/60.)+' min. cadence', int2str(errorbars)+'% errorbars','Model: h(t) = sqrt(2x)(t tan!U-1!N(e!Ut/2x!N/sqrt(2x)))'], charsize=1, box=0, /bottom, /right
	;oplot, tt_noisy, h_noisy, psym=1, color=4
	oplot, t, h_fullmodel/height_factor, psym=-0
	if keyword_set(plot_fixed_point) then plots, fixed, h[where(tt eq fixed)]/height_factor, psym=6, color=6
endif

percent_noise = (abs(h_noisy - h)/h)*100.0d
print, 'Mean % noise: ', mean(percent_noise)

if ~keyword_set(no_plot) then begin
	utplot, tt, v/vel_factor, utbasedata, psym=-0, linestyle=1, ytit='Velocity (km s!U-1!N)'
	plots, tt, v_lagrangian/vel_factor, psym=-1, color=4
	if (cadence mod 8 ne 0) then oploterror, tt, v_lagrangian/vel_factor, v_lagrangian_sig/vel_factor, psym=3, errcolor=4
	oplot, t, v_fullmodel/vel_factor, psym=-0
	if keyword_set(plot_fixed_point) then plots, fixed, v[where(tt eq fixed)]/vel_factor, psym=6, color=6
endif

if ~keyword_set(no_plot) then begin
	utplot, tt, a/accel_factor, utbasedata, psym=-0, linestyle=1, ytit='Acceleration (m s!U-2!N)'
	;yr=[min(a_fullmodel/accel_factor)-10,max(a_fullmodel/accel_factor)+10], /ys
	plots, tt, a_lagrangian/accel_factor, psym=-1, color=4
	if (cadence mod 8 ne 0) then oploterror, tt, a_lagrangian/accel_factor, a_lagrangian_sig/accel_factor, psym=3, errcolor=4
	
	oplot, t, a_fullmodel/accel_factor, psym=-0
	
	if keyword_set(plot_fixed_point) then begin
		; Plotting the fixed point
		plots, fixed, a[where(tt eq fixed)]/accel_factor, psym=6, color=6
		;plots, fixed, a_forward[where(tt eq fixed)]/accel_factor, psym=4, color=7
		;plots, fixed, a_lagrangian[where(tt eq fixed)]/accel_factor, psym=4, color=7
		;plots, fixed, a_centre[where(tt eq fixed)-2]/accel_factor, psym=4, color=7
	endif

endif

vtt = v[where(tt eq fixed)]
vl = v_lagrangian[where(tt eq fixed)]

v_max = max(v_fullmodel)

att = a[where(tt eq fixed)]
al = a_lagrangian[where(tt eq fixed)]

a_max = max(a_fullmodel)

print, '**************'
print, 'Velocities:'
print, 'lagrangian: ', vl/vel_factor
print, 'v at fixed: ', vtt/vel_factor
print, 'peak v_fullmodel: ', max(v_fullmodel)/vel_factor

print, '**************'
print, 'Accelerations:'
print, 'lagrangian: ', al/accel_factor
print, 'a at fixed: ', att/accel_factor
print, 'peak a_fullmodel: ', max(a_fullmodel)/accel_factor

end
