; Code to plot the different kinematics generate on a noised data set compared with the model, for different numerical differencing schemes.

;Created: 02-02-2011 from plot_different_kins_cadence_fixedpoint.pro

; Last edited: 19-01-2011 to include most apropriate _fullmodel variables.
; 26-01-2011 to include keyword no_trunc  and to print the error at fixedpoint.
; 27-01-2011 to include keywords for fixed_point errors output to plot in peak_a_change_cadence.b

pro plot_kins_diffcadence_fixedpoint, cadence1, cadence2, cadence1_end, cadence2_begin, fixed, no_plot=no_plot, fit_vel=fit_vel, large_range=large_range, al, att, a_max,al_fixed_err, no_legend=no_legend, plot_fixed_point=plot_fixed_point, tog=tog, no_trunc=no_trunc

;INPUTS:	cadence1: the cadence for the first set of points
;		cadence2: the cadence for the second set of points
;		cadence_point: the point where the cadences overlap
;		fixed: the point to fix for measuring


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

time = 200. ;secs
t = dindgen(time)
;noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))

if fixed le cadence1_end then begin
	cadence1_start_limit = fixed
	while(cadence1_start_limit-cadence1) gt 0 do cadence1_start_limit-=cadence1
	cadence1_end_limit = fixed
	while(cadence1_end_limit+cadence1) le cadence1_end do cadence1_end_limit+=cadence1
	
	cadence2_start_limit = cadence2_begin
	cadence2_end_limit = cadence2_begin
	while(cadence2_end_limit+cadence2) lt time do cadence2_end_limit += cadence2
endif

if fixed gt cadence1_end then begin
	cadence1_end_limit = cadence1_end
	cadence1_start_limit = cadence1_end
	while(cadence1_start_limit-cadence1) gt 0 do cadence1_start_limit -= cadence1

	cadence2_start_limit = fixed
	while(cadence2_start_limit-cadence2) gt cadence1_end do cadence2_start_limit -= cadence2
	cadence2_end_limit = fixed
	while(cadence2_end_limit+cadence2) lt time do cadence2_end_limit += cadence2
endif
print,cadence1_start_limit,cadence1_end_limit,cadence2_start_limit,cadence2_end_limit


; coding up the timesteps from fixed with cadence

tt1 = cadence1_start_limit
count=1
while max(tt1) lt cadence1_end_limit do tt1=[tt1,tt1[n_elements(tt1)-1]+cadence1]
tt2 = cadence2_start_limit
count=1
while max(tt2) lt cadence2_end_limit do tt2=[tt2,tt2[n_elements(tt2)-1]+cadence2]
tt = [tt1,tt2]

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0 ;second

; Accel model:
h_fullmodel = sqrt(10)*(t*atan(exp(t/10.)/sqrt(10)))
v_fullmodel = sqrt(10)*atan(exp(t/10.)/sqrt(10)) + (exp(t/10.)*t)/(10+exp(t/5.))
a_fullmodel = (exp(t/10.)*(10*(t+20)-exp(t/5.)*(t-20)))/(10*((exp(t/5.)+10)^2.))

;h_fullmodel = sqrt(10)*(t*atan(exp(t/1000.)/10.))
;v_fullmodel = sqrt(10)*((exp(t/1000.)*t)/(10000*(exp(t/500.)/100.+1)) + atan(exp(t/1000.)/10))
;a_fullmodel = (exp(t/1000.)*(100*(t+2000)-exp(t/500.)*(t-2000)))/(10000*sqrt(10)*(exp(t/500.)+100)^2.)

;h_fullmodel = sqrt(10)*(t*atan(exp(t/100.)/(100*sqrt(10))))
;v_fullmodel = (10*exp(t/100.)*t)/(exp(t/50.)+100000) + sqrt(10)*atan(exp(t/100.)/(100*sqrt(10)))
;a_fullmodel = (exp(t/100.)*(100000*(t+200)-exp(t/50.)*(t-200)))/(10*(exp(t/50.)+100000)^2.)

;h_fullmodel = t*atan(exp(t/10.))
;v_fullmodel = (exp(t/10.)*t)/(10*(exp(t/5.)+1)) + atan(exp(t/10.))
;a_fullmodel = (exp(t/10.)*(-exp(t/5.)*(t-20)+t+20))/(100*(exp(t/5.)+1)^2.)

;h_fullmodel = (t*atan(exp(t/100.)/100.))/sqrt(10)
;v_fullmodel = ((exp(t/100.)*t)/(exp(t/50.)+10000)+atan(exp(t/100.)/100))/sqrt(10)
;a_fullmodel = (exp(t/100.)*(10000*(t+200)-exp(t/50.)*(t-200)))/(100*sqrt(10)*(exp(t/50.)+10000)^2.)

;h_fullmodel = t*atan(exp(t/(10*sqrt(10)))/(100*sqrt(10)))
;v_fullmodel = (10*exp(t/(10*sqrt(10)))*t)/(exp(t/(5*sqrt(10)))+100000) + atan(exp(t/(10*sqrt(10)))/(100*sqrt(10)))
;a_fullmodel = ((exp(t/(10*sqrt(10))))*(exp(t/(5*sqrt(10)))*(200-sqrt(10)*t)+100000*(sqrt(10)*t+200))) / (10*(exp(t/(5*sqrt(10)))+100000)^2.)

print, 'Location of acceleration peak: ', where(a_fullmodel eq max(a_fullmodel))
print, 'Location of acceleration minimum: ', where(a_fullmodel eq min(a_fullmodel))

h = sqrt(10)*(tt*atan(exp(tt/10.)/sqrt(10)))
v = sqrt(10)*atan(exp(tt/10.)/sqrt(10)) + (exp(tt/10.)*tt)/(10+exp(tt/5.))
a = (exp(tt/10.)*(10*(tt+20)-exp(tt/5.)*(tt-20)))/(10*((exp(tt/5.)+10)^2.))

height_factor = 1e1
vel_factor = 1e-2
accel_factor = 1e-2

;Noisy distance eqn
noise1 = randomn(seed, size(t[0:cadence1_end_limit:cadence1], /n_elements))
noise2 = randomn(seed, size(t[cadence2_start_limit:*:cadence2], /n_elements))
noise = [noise1, noise2]
print, noise1,noise2
noise_percent = 5.
if noise_percent eq 0 then h_noisy = h; + noise_percent*height_factor*noise ;1%noise
if noise_percent ne 0 then h_noisy = h + (noise_percent/100.)*h*noise ;1%noise
;tt_noisy = tt+3.*noise2

;*note the errorbars have to be twice the noise to overlap the model.

; Using errorbars are the percentage error for 1-sigma error on hieght-time.
errorbars = 10 ;percent
h_noisy_sig = h_noisy*(errorbars/100.)

print, '---------------------------------------'

;Derive kinematics
;v_forward = choose_deriv(tt, h_noisy, vf_trunc_err, /forward, no_trunc=no_trunc)
;v_centre = choose_deriv(tt, h_noisy, vc_trunc_err, /centre, no_trunc=no_trunc)
v_lagrangian = choose_deriv(tt, h_noisy, vl_trunc_err, /lagrangian, no_trunc=no_trunc)
if ~keyword_set(no_trunc) then begin
	print, '******************'
	print, '****'
	;print, 'Forward differencing:'
	;print, 'v_forward: ', v_forward, 'abs(vf_trunc_err): ', abs(vf_trunc_err)
	;print, 'percentage truncation error:', abs(vf_trunc_err/v_forward) * 100
	;print, '****'
	;print, 'Centre differencing:'
	;print, 'v_centre: ', v_centre,  'abs(vc_trunc_err): ', abs(vc_trunc_err)
	;print, 'percentage truncation error:', abs(vc_trunc_err/v_centre) * 100
	;print, '****'
	print, 'Lagrangian differencing:'
	print, 'v_lagrangian: ', v_lagrangian,  'abs(vl_trunc_err): ', abs(vl_trunc_err)
	print, 'percentage truncation error:', abs(vl_trunc_err/v_lagrangian) * 100
	print, '****'
	print, '******************'
endif
;v_lagrangian = deriv(tt, h_noisy)

;v_forward_sig = dblarr(n_elements(v_forward))
;for k=0,n_elements(v_forward_sig)-1 do v_forward_sig[k] = sqrt( (h_noisy_sig[k+1]^2.+h_noisy_sig[k]^2.)/((tt[k+1]-tt[k])^2.) + (v_forward[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k]^2.)/((tt[k+1]-tt[k])^2.)) )
;print, 'Error at fixedpoint v_forward_sig: ', v_forward_sig[where(tt eq fixed)]/vel_factor

;v_centre_sig = dblarr(n_elements(v_centre))
;for k=1,n_elements(v_centre_sig) do v_centre_sig[k-1] = sqrt( (h_noisy_sig[k+1]^2.+h_noisy_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (v_centre[k-1]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
;if (where(tt eq fixed)-1) ge 0 && (where(tt eq fixed)-1) lt n_elements(v_centre) then print, 'Error at fixedpoint v_centre_sig: ', v_centre_sig[where(tt eq fixed)-1]/vel_factor

v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)
v_lagrangian_sig_man = dblarr(n_elements(v_lagrangian))
for k=1,n_elements(v_lagrangian_sig_man)-2 do v_lagrangian_sig_man[k] = sqrt( (h_noisy_sig[k+1]^2.+h_noisy_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (v_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint v_lagrangian: ', v_lagrangian_sig[where(tt eq fixed)]/vel_factor

;choose_deriv2, tt[0:n_elements(tt)-2], v_forward, a_forward, af_trunc_err, /forward
;print, a_forward, af_trunc_err
;print, 'percentage truncation error:'
;print, abs(af_trunc_err/a_forward) *100
;pause
;a_forward = choose_deriv(tt[0:n_elements(tt)-2], v_forward, /forward, no_trunc=no_trunc)
;a_centre = choose_deriv(tt[1:n_elements(tt)-2], v_centre, /centre, no_trunc=no_trunc)
a_lagrangian = deriv(tt, v_lagrangian)

;a_forward_sig = dblarr(n_elements(a_forward))
;for k=0,n_elements(a_forward_sig)-1 do a_forward_sig[k] = sqrt( (v_forward_sig[k+1]^2.+v_forward_sig[k]^2.)/((tt[k+1]-tt[k])^2.) + (a_forward[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k]^2.)/((tt[k+1]-tt[k])^2.)) )
;print, 'Error at fixedpoint a_forward_sig: ', a_forward_sig[where(tt eq fixed)]/accel_factor
;af_fixed_err = a_forward_sig[where(tt eq fixed)]/accel_factor

;a_centre_sig = dblarr(n_elements(a_centre))
;for k=1,n_elements(a_centre_sig) do a_centre_sig[k-1] = sqrt( (v_centre_sig[k+1]^2.+v_centre_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (a_centre[k-1]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
;if (where(tt eq fixed)-2) ge 0 && (where(tt eq fixed)-2) lt n_elements(a_centre) then print, 'Error at fixedpoint a_centre_sig: ', a_centre_sig[where(tt eq fixed)-2]/accel_factor
;ac_fixed_err = a_centre_sig[where(tt eq fixed)-2]/accel_factor

a_lagrangian_sig = derivsig(tt, v_lagrangian, tt_sig, v_lagrangian_sig)
a_lagrangian_sig_man = dblarr(n_elements(a_lagrangian))
for k=1,n_elements(a_lagrangian_sig_man)-2 do a_lagrangian_sig_man[k] = sqrt( (v_lagrangian_sig[k+1]^2.+v_lagrangian_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (a_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint a_lagrangian_sig: ', a_lagrangian_sig[where(tt eq fixed)]/accel_factor
al_fixed_err = a_lagrangian_sig[where(tt eq fixed)]/accel_factor

print, '---------------------------------------'

if keyword_set(fit_vel) then begin
        ;yf = 'p[0]*x + p[1]'
        ;f = mpfitexpr(yf, tt, v_forward, 100,[h_noisy[0],v_forward[0],a_forward[0]], /quiet)
	;h_fit_forward = (f[0]*0.5)*tt^2. + f[1]*tt + h_noisy[0]
        ;v_fit_forward = f[0]*tt + f[1]
        ;a_fit_forward = f[0]
	;f = mpfitexpr(yf, tt, v_centre, 1, [h_noisy[0],v_centre[0],a_centre[0]], /quiet)
	;h_fit_centre = (f[0]*0.5)*tt^2. + f[1]*tt + h_noisy[0]
	;v_fit_centre = f[0]*tt + f[1]
	;a_fit_centre = f[0]
	yf = 'p[0]*x + p[1]'
	f = mpfitexpr(yf, tt, v_lagrangian, 1, [h_noisy[0],v_lagrangian[0],a_lagrangian[0]],/quiet)
	h_fit_lagrangian = (f[0]*0.5)*tt^2. + f[1]*tt + h_noisy[0]
	v_fit_lagrangian = f[0]*tt +f[1]
	a_fit_lagrangian = f[0]
endif
;print, 'Model velocity: ', deriv(tt, h)


if ~keyword_set(no_plot) then begin
	plot, tt, h/height_factor, psym=-0, linestyle=1, /ylog, yr=[0.1,100],/ys, xr=[-10,210], /xs, xtit='Time (secs)', ytit='Height (Mm)'
	;oplot, tt, h_noisy/height_factor, psym=1, color=3
	oploterror, tt, h_noisy/height_factor, tt_sig, h_noisy_sig/height_factor, psym=1
	if keyword_set(fit_vel) then begin
		;oplot, tt, h_fit_forward/height_factor, linestyle=4, color=5
		;oplot, tt, h_fit_centre/height_factor, linestyle=5, color=3
		oplot, tt, h_fit_lagrangian/height_factor, linestyle=6, color=6
	endif
	if ~keyword_set(no_legend) then legend, [int2str(noise_percent)+'% Noise', int2str(cadence)+'s cadence', int2str(errorbars)+'% errorbars','Model: r(t) = sqrt(10)(t tan!U-1!N(e!Ut/10!N/sqrt(10)))'], charsize=1, box=0, /bottom, /right
	;oplot, tt_noisy, h_noisy, psym=1, color=4
	oplot, t, h_fullmodel/height_factor, psym=-0
	if keyword_set(plot_fixed_point) then plots, fixed, h[where(tt eq fixed)]/height_factor, psym=6, color=6
endif

percent_noise = (abs(h_noisy - h)/h)*100.0d
print, 'Mean % noise: ', mean(percent_noise)

if keyword_set(fit_vel) then begin
	;chi_sq_v_forward = 0.
	;for i=0,n_elements(v_forward)-1 do chi_sq_v_forward += (v_forward[i]-v_fit_forward[i])^2.
	;chi_sq_v_centre = 0.
	;for i=0,n_elements(v_centre)-1 do chi_sq_v_centre += (v_centre[i]-v_fit_centre[i])^2.
	chi_sq_lagrangian = 0.
	for i=0,n_elements(v_lagrangian)-1 do chi_sq_v_lagrangian += (v_lagrangian[i]-v_fit_lagrangian[i])^2.
endif
	
if ~keyword_set(no_plot) then begin
	if ~keyword_set(large_range) then begin
		plot, tt, v/vel_factor, psym=-0, linestyle=1, yr=[0,700], xr=[-10,210], /xs, /ys, xtit='Time (secs)', ytit='Velocity (km s!U-1!N)'
	endif else begin
		plot, tt, v/vel_factor, psym=-0, linestyle=1, yr=[min(v_forward-v_forward_sig)/vel_factor,max(v_forward+v_forward_sig)/vel_factor], xr=[-10,210], /xs, /ys, xtit='Time (secs)', ytit='Velocity (km s!U-1!N)'
	endelse
	;plots, tt[0:n_elements(tt)-2], v_forward/vel_factor, psym=-1, color=5
;	oplot, tt, deriv(tt, h)/vel_factor, psym=1, color=2
	plots, tt, v_lagrangian/vel_factor, psym=-1, color=4
	;plots, tt[1:n_elements(tt)-2], v_centre/vel_factor, psym=-1, color=3
	;oploterror, tt, v_forward/vel_factor, v_forward_sig/vel_factor, psym=3, errcolor=5
	if (cadence1 mod 8 ne 0) || (cadence2 mod 8 ne 0) then oploterror, tt, v_lagrangian/vel_factor, v_lagrangian_sig/vel_factor, psym=3, errcolor=4
	;pause
	;oploterror, tt[1:n_elements(tt)-2], v_centre/vel_factor, v_centre_sig/vel_factor, psym=3, errcolor=3
	if keyword_set(fit_vel) then begin
		;oplot, tt, v_fit_forward/vel_factor, linestyle=4, color=5
		;oplot, tt, v_fit_centre/vel_factor, linestyle=5, color=3
		oplot, tt, v_fit_lagrangian/vel_factor, linestyle=6, color=6
		if ~keyword_set(no_legend) then legend, ['!9c!X!U2!Dforward!N='+int2str(chi_sq_v_forward),'!9c!X!U2!Dcentre!N='+int2str(chi_sq_v_centre)], charsize=1, box=0
	endif
	oplot, t, v_fullmodel/vel_factor, psym=-0
	if keyword_set(plot_fixed_point) then plots, fixed, v[where(tt eq fixed)]/vel_factor, psym=6, color=6
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
	;chi_sq_a_forward = 0.
	;for i=0,n_elements(a_forward)-1 do chi_sq_a_forward += (a_forward[i]-a_fit_forward)^2.
	;chi_sq_a_centre = 0.
	;for i=0,n_elements(a_centre)-1 do chi_sq_a_centre += (a_centre[i]-a_fit_centre)^2.
	chi_sq_lagrangian = 0.
	for i=0,n_elements(a_lagrangian)-1 do chi_sq_a_lagrangian += (a_lagrangian[i]-a_fit_lagrangian)^2.
endif

if ~keyword_set(no_plot) then begin
	if ~keyword_set(large_range) then begin
		plot, tt, a/accel_factor, psym=-0, linestyle=1, yr=[min(a_fullmodel/accel_factor)-10,max(a_fullmodel/accel_factor)+10], xr=[-10,210], /xs, /ys, xtit='Time (secs)', ytit='Acceleration (m s!U-2!N)'
	endif else begin
		plot, tt, a/accel_factor, psym=-0, linestyle=1, yr=[min(a_forward/accel_factor-a_forward_sig/accel_factor), max(a_forward/accel_factor+a_forward_sig/accel_factor)], xr=[-10,210], /xs, /ys, xtit='Time (secs)', ytit='Acceleration (m s!U-2!N)'
	endelse
	;plots, tt[0:n_elements(tt)-3], a_forward/accel_factor, psym=-1, color=5
	;plots, tt, a_lagrangian, psym=-1, color=4
	;oploterror, tt[0:n_elements(tt)-3], a_forward/accel_factor, a_forward_sig/accel_factor, psym=3, errcolor=5
	plots, tt, a_lagrangian/accel_factor, psym=-1, color=4
	if (cadence1 mod 8 ne 0) || (cadence2 mod 8 ne 0) then oploterror, tt, a_lagrangian/accel_factor, a_lagrangian_sig/accel_factor, psym=3, errcolor=4
	;plots, tt[2:n_elements(tt)-3], a_centre/accel_factor, psym=-1, color=3
	;oploterror, tt[2:n_elements(tt)-3], a_centre/accel_factor, a_centre_sig/accel_factor, psym=3, errcolor=3
	
	if keyword_set(fit_vel) then begin
		;oplot, tt, replicate(a_fit_forward/accel_factor,n_elements(tt)), linestyle=4, color=5
		;oplot, tt, replicate(a_fit_centre/accel_factor,n_elements(tt)), linestyle=5, color=3
		oplot, tt, replicate(a_fit_lagrangian/accel_factor,n_elements(tt)), linestyle=6, color=6
		if ~keyword_set(no_legend) then legend, ['!9c!X!U2!Dforward!N='+int2str(chi_sq_a_forward),'!9c!X!U2!Dcentre!N='+int2str(chi_sq_a_centre)], charsize=1, box=0
		if ~keyword_set(no_legend) then legend, ['Forward fit '+int2str(a_fit_forward),'Centre fit '+int2str(a_fit_centre)], charsize=1, box=0, /bottom,/right
	endif

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
;vf = v_forward[where(tt eq fixed)]
;if where(tt eq fixed) ge n_elements(v_forward) then vf=0.
;vc = v_centre[where(tt eq fixed)]
if where(tt eq fixed)-1 lt 0 then vc=0.
;if where(tt eq fixed)-1 ge n_elements(v_centre) then vc=0.
vl = v_lagrangian[where(tt eq fixed)]

v_max = max(v_fullmodel)

att = a[where(tt eq fixed)]/accel_factor
;af = a_forward[where(tt eq fixed)]
;if where(tt eq fixed) ge n_elements(a_forward) then af=0.
;ac = a_centre[where(tt eq fixed)-2]
if where(tt eq fixed)-2 lt 0 then ac = 0.
;if where(tt eq fixed)-2 ge n_elements(a_centre) then ac = 0.
al = a_lagrangian[where(tt eq fixed)]/accel_factor

a_max = max(a_fullmodel) / accel_factor

print, '**************'
print, 'Velocities:'
;print, 'forward: ', vf/vel_factor
;print, 'centre: ', vc/vel_factor
print, 'lagrangian: ', vl/vel_factor
print, 'v at fixed: ', vtt/vel_factor
print, 'peak v_fullmodel: ', max(v_fullmodel)/vel_factor

print, '**************'
print, 'Accelerations:'
;print, 'forward: ', af/accel_factor
;print, 'centre: ', ac/accel_factor
print, 'lagrangian: ', al
print, 'lagrangian errorbar: ', al_fixed_err
print, 'a at fixed: ', att
print, 'peak a_fullmodel: ', a_max

h = h_noisy/height_factor
h_sig = h_noisy_sig/height_factor
v = v_lagrangian/vel_factor
a = a_lagrangian/accel_factor
save, tt, h, h_sig, v, a, f='test.sav'


end
