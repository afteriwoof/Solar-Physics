
;Created	20120413	from plot_different_kins_cadence_fixedpoint.pro

; Code to plot the lagrangian kinematics on a peaked acceleration model, with errorbars, given a cadence and a fixed point to sample.

; Last edited: 19-01-2011 to include most apropriate _fullmodel variables.
; 26-01-2011 to include keyword no_trunc  and to print the error at fixedpoint.
; 27-01-2011 to include keywords for fixed_point errors output to plot in peak_a_change_cadence.b
; 2012-07-12	to include keyword no_points for plotting only the model profiles for paper.

pro plot_peakaccel_cadence_fixedpoint, cadence, fixed, no_plot=no_plot, fit_vel=fit_vel, large_range=large_range, al, att, a_max,al_fixed_err, no_legend=no_legend, plot_fixed_point=plot_fixed_point, tog=tog, no_trunc=no_trunc, no_points=no_points

if cadence mod 8 eq 0 then cadence+=0.001

set_line_color

if ~keyword_set(tog) then begin
	set_plot, 'x'
	window, xs=800, ys=1400
	!p.charsize=2.5
	!p.thick=1
	!x.thick=1
	!y.thick=1
	!p.charthick=1
endif else begin
	!p.charsize=2
	!p.thick=4
	!x.thick=4
	!y.thick=4
	!p.charthick=4
	set_plot, 'ps'
	device, /encapsul, bits=8, language=2, /portrait, /color, filename='plot_peakaccel_cadence_fixedpoint.eps', xs=15, ys=20
endelse
!p.multi=[0,1,3]
pos_h = [0.2, 0.65, 0.9, 0.9]
pos_v = [0.2, 0.4, 0.9, 0.65]
pos_a = [0.2, 0.15, 0.9, 0.4]

;Model
;r0 = 100e6 ;m
;v0 = 400e3 ;m/s
;a0 = 50. ;m/s/s

time = 30000. ;secs
t = dindgen(time)
;cadence = 1. ;secs
cadence = double(cadence)
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))

; coding up the timesteps from fixed with cadence
fixed = double(fixed)
start_limit = fixed
while (start_limit-cadence) gt 0 do start_limit-=cadence
end_limit = fixed
while (end_limit+cadence) lt time do end_limit+=cadence

tt = start_limit
count=1.
while max(tt) lt end_limit do tt=[tt,tt[n_elements(tt)-1]+cadence]
tt = double(tt)

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0 ;second

model_fac = 600.
; Accel model:
h_fullmodel = sqrt(model_fac*2.)*(t*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)))
v_fullmodel = sqrt(model_fac*2.)*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)) + (exp(t/(model_fac*2.))*t)/((model_fac*2.)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2.))*(model_fac*2.*(t+4.*model_fac)-exp(t/model_fac)*(t-4.*model_fac)))/(2.*model_fac*((exp(t/model_fac)+2.*model_fac)^2.))

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

h = sqrt(2.*model_fac)*(tt*atan(exp(tt/(2.*model_fac))/sqrt(2.*model_fac)))
v = sqrt(2.*model_fac)*atan(exp(tt/(2*model_fac))/sqrt(2.*model_fac)) + (exp(tt/(2.*model_fac))*tt)/(2.*model_fac+exp(tt/model_fac))
a = (exp(tt/(2.*model_fac))*(2.*model_fac*(tt+4.*model_fac)-exp(tt/model_fac)*(tt-4.*model_fac)))/(2.*model_fac*((exp(tt/model_fac)+2.*model_fac)^2.))

height_factor = 1e2
vel_factor = 1e-1
accel_factor = 1e-4

;Noisy distance eqn
noise_percent = 0.
print, 'Can change the noise percent, currently set at ', noise_percent

if noise_percent eq 0 then h_noisy = h; + noise_percent*height_factor*noise
if noise_percent ne 0 then h_noisy = h + (noise_percent/100.)*h*noise 
;tt_noisy = tt+3.*noise2
;OVERRIDE WITH FIXED NOISE
h_noisy = h + (noise_percent/100.)*h[n_elements(h)/2]*noise

; Using errorbars are the percentage error for 1-sigma error on hieght-time.
errorbars = 4.0 ;percent
h_noisy_sig = h_noisy*(errorbars/100.)
;OVERRIDE WITH FIXED ERRORBARS
h_noisy_sig = replicate(h_noisy[n_elements(h_noisy)/2]*(errorbars/100.), n_elements(h_noisy))

;Instead of errorbar scaled with height, can fix it throughout
;h_noisy_sig = 10
;h_noisy_sig = replicate(10,n_elements(h_noisy))
;h_noisy_sig[0:(n_elements(h_noisy)/4)] = 5
;print, h_noisy_sig

save, h_noisy, h_noisy_sig, tt, tt_sig, f='temp.sav'

print, '---------------------------------------'

;Derive kinematics
v_lagrangian = choose_deriv(tt, h_noisy, vl_trunc_err, /lagrangian, no_trunc=no_trunc)
;if ~keyword_set(no_trunc) then begin
;	print, '******************'
;	print, 'Lagrangian differencing:'
;	print, 'v_lagrangian: ', v_lagrangian,  'abs(vl_trunc_err): ', abs(vl_trunc_err)
;	print, 'percentage truncation error:', abs(vl_trunc_err/v_lagrangian) * 100
;	print, '******************'
;endif

v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)
v_lagrangian_sig_man = dblarr(n_elements(v_lagrangian))
help, v_lagrangian_sig
print, v_lagrangian_sig
for k=1,n_elements(v_lagrangian_sig_man)-2 do v_lagrangian_sig_man[k] = sqrt( (h_noisy_sig[k+1]^2.+h_noisy_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (v_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint v_lagrangian: ', v_lagrangian_sig[where(tt eq fixed)]/vel_factor

a_lagrangian = deriv(tt, v_lagrangian)

a_lagrangian_sig = derivsig(tt, v_lagrangian, tt_sig, v_lagrangian_sig)
a_lagrangian_sig_man = dblarr(n_elements(a_lagrangian))
for k=1,n_elements(a_lagrangian_sig_man)-2 do a_lagrangian_sig_man[k] = sqrt( (v_lagrangian_sig[k+1]^2.+v_lagrangian_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.) + (a_lagrangian[k]^2.)*((tt_sig[k+1]^2.+tt_sig[k-1]^2.)/((tt[k+1]-tt[k-1])^2.)) )
print, 'Error at fixedpoint a_lagrangian_sig: ', a_lagrangian_sig[where(tt eq fixed)]/accel_factor
al_fixed_err = a_lagrangian_sig[where(tt eq fixed)]/accel_factor

print, '---------------------------------------'

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

xr = [0,time]
yr = [0,20000]
if ~keyword_set(no_plot) then begin
	plot, tt, h/height_factor, xr=xr, yr=yr, /xs, /ys, ytit='Height (Mm)', $
		xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_h, /nodata
	oplot, t, h_fullmodel/height_factor, psym=-0
	if ~keyword_set(no_points) then begin
		oplot, tt, h_noisy/height_factor, psym=-1, line=1, color=5
		oploterror, tt, h_noisy/height_factor, tt_sig, h_noisy_sig/height_factor, psym=3, errcolor=5
		if keyword_set(fit_vel) then begin
			oplot, tt, h_fit_forward/height_factor, linestyle=4, color=5
			oplot, tt, h_fit_centre/height_factor, linestyle=5, color=3
		endif
	endif
	if ~keyword_set(no_legend) then legend, [int2str(noise_percent)+'% Noise', int2str(cadence)+'s cadence', int2str(errorbars)+'% errorbars','Model: r(t) = sqrt(10)(t tan!U-1!N(e!Ut/10!N/sqrt(10)))'], charsize=1, box=0, /bottom, /right
	;oplot, tt_noisy, h_noisy, psym=1, color=5
	if keyword_set(plot_fixed_point) then plots, fixed, h[where(tt eq fixed)]/height_factor, psym=6, color=6
endif

percent_noise = (abs(h_noisy - h)/h)*100.0d
print, 'Mean % noise: ', mean(percent_noise)

yr = [0,1190]
if ~keyword_set(no_plot) then begin
	if ~keyword_set(large_range) then begin
		plot, tt, v/vel_factor, xr=xr, yr=yr, /xs, /ys, ytit='Velocity (km s!U-1!N)', $
			xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_v, /nodata
	endif else begin
		plot, tt, v/vel_factor, psym=-0, linestyle=1, yr=[min(v_forward-v_forward_sig)/vel_factor,max(v_forward+v_forward_sig)/vel_factor], xr=[-10,210], /xs, /ys, xtit='Time (s)', ytit='Velocity (km s!U-1!N)'
	endelse
	oplot, t, v_fullmodel/vel_factor, psym=-0
	if ~keyword_set(no_points) then begin
	;	oplot, tt, deriv(tt, h)/vel_factor, psym=1, color=2
		if (cadence mod 8 ne 0) then oploterror, tt, v_lagrangian/vel_factor, v_lagrangian_sig/vel_factor, psym=3, errcolor=5
		plots, tt, v_lagrangian/vel_factor, psym=-1, line=1, color=5
	endif
	if keyword_set(plot_fixed_point) then plots, fixed, v[where(tt eq fixed)]/vel_factor, psym=6, color=6
endif

;plots, tt_noisy[0:n_elements(tt_noisy)-2], v_forward_n, psym=-1, color=5
;plots, tt_noisy[1:n_elements(tt_noisy)-2], v_centre_n, psym=-1, color=3
;plots, tt_noisy, v_lagrangian_n, psym=-1, color=5

;print, 'chi-squared v_forward: ', chi_squared
;print, 'chi-squared v_centre: ', chi_squared

;chi_squared = 0.
;for i=0,n_elements(v_lagrangian)-1 do chi_squared += (v_lagrangian[i]-v0)^2.
;print, 'chi-squared v_lagrangian: ', chi_squared

yr = [-300,590]
if ~keyword_set(no_plot) then begin
	if ~keyword_set(large_range) then begin
		plot, tt, a/accel_factor, xr=xr, yr=yr, /xs, /ys, xtit='Time (s)', ytit='Accel. (m s!U-2!N)', pos=pos_a, /nodata
	endif else begin
		plot, tt, a/accel_factor, psym=-0, linestyle=1, yr=[min(a_forward/accel_factor-a_forward_sig/accel_factor), max(a_forward/accel_factor+a_forward_sig/accel_factor)], xr=[-10,210], /xs, /ys, xtit='Time (s)', ytit='Acceleration (m s!U-2!N)'
	endelse
	oplot, t, a_fullmodel/accel_factor, psym=-0
	if ~keyword_set(no_points) then begin
		;plots, tt, a_lagrangian, psym=-1, color=5
		plots, tt, a_lagrangian/accel_factor, psym=-1, line=1, color=5
		if (cadence mod 8 ne 0) then oploterror, tt, a_lagrangian/accel_factor, a_lagrangian_sig/accel_factor, psym=3, errcolor=5
	endif	
	if keyword_set(plot_fixed_point) then begin
		; Plotting the fixed point
		plots, fixed, a[where(tt eq fixed)]/accel_factor, psym=6, color=6
		;plots, fixed, a_forward[where(tt eq fixed)]/accel_factor, psym=4, color=7
		;plots, fixed, a_lagrangian[where(tt eq fixed)]/accel_factor, psym=4, color=7
		;plots, fixed, a_centre[where(tt eq fixed)-2]/accel_factor, psym=4, color=7
	endif
	horline, 0, line=0, thick=1
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

if keyword_set(tog) then device, /close_file

end
