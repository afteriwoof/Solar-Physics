; Created	2012-10-05	from peaked_accel_kins.pro to plot out the kins with various fits to test for acceleration profile.


pro peaked_accel_kinscasestudy, tog=tog

fixed = 3595
if ~exist(fixed) then fixed=0

set_line_color
if ~keyword_set(tog) then begin
	set_plot, 'x'
	window, xs=700, ys=850
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
	device, /encapsul, bits=8, language=2, /portrait, /color, filename='fig_peaked_accel_kins.eps', xs=15, ys=20
	print, 'set_plot, ps'
	print, 'Saving fig_peaked_accel_kins.eps'
endelse

pos_h = [0.15,0.65,0.95,0.9]
pos_v = [0.15,0.4,0.95,0.65]
pos_a = [0.15,0.15,0.95,0.4]

!p.multi=[0,1,3]

time = 30000. ;secs
t = dindgen(time)

cadence = 12*60.
cadence = double(cadence)
if cadence mod 8 eq 0 then cadence+=0.0001


start_limit = fixed
while(start_limit-cadence) gt 0 do start_limit-=cadence
end_limit = fixed
while(end_limit+cadence) lt time do end_limit+=cadence

tt = start_limit
count=1
while max(tt) lt end_limit do tt=[tt,tt[n_elements(tt)-1]+cadence]
tt = double(tt)
tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0

; Accel model:
model_fac = 600.
h_fullmodel = sqrt(model_fac*2.)*(t*atan(exp(t/(model_fac*2.))/sqrt((model_fac*2.))))
v_fullmodel = sqrt((model_fac*2.))*atan(exp(t/(model_fac*2.))/sqrt((model_fac*2.))) + (exp(t/(model_fac*2.))*t)/((model_fac*2.)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2.))*((model_fac*2.)*(t+(model_fac*4.))-exp(t/model_fac)*(t-(model_fac*4.))))/((model_fac*2.)*((exp(t/model_fac)+(model_fac*2.))^2.))

; Sampling kins
h = sqrt(2.*model_fac)*(tt*atan(exp(tt/(2.*model_fac))/sqrt(2.*model_fac)))
v = sqrt(2.*model_fac)*atan(exp(tt/(2*model_fac))/sqrt(2.*model_fac)) + (exp(tt/(2.*model_fac))*tt)/(2.*model_fac+exp(tt/model_fac))
a = (exp(tt/(2.*model_fac))*(2.*model_fac*(tt+4.*model_fac)-exp(tt/model_fac)*(tt-4.*model_fac)))/(2.*model_fac*((exp(tt/model_fac)+2.*model_fac)^2.))


h_fullmodel += 695.5*100
h += 695.5*100

;Scaling
height_factor = 1e2
vel_factor = 1e-1
accel_factor = 1e-4

; Noise
noise_percent = 5.
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
if noise_percent eq 0 then h_noisy = h else h_noisy = h + (noise_percent/100.) * noise * h
; Fixed noise: h_noisy = h + (noise_percent/100.)*h[n_elements(h)/2]*noise

; Errorbars
errorbars = 4.
;h_noisy_sig = h_noisy*(errorbars/100.)
; Fixed errorbars:
h_indC2 = where(h_noisy/height_factor lt 6*695.5)
h_indC3 = where(h_noisy/height_factor gt 6*695.5)
h_noisy_sigC2 = replicate(h_noisy[n_elements(h_indC2)-1]*(errorbars/100.), n_elements(h_indC2))
h_noisy_sigC3 = replicate(h_noisy[n_elements(h_indC3)-1]*(errorbars/100.), n_elements(h_indC3))
h_noisy_sig = [h_noisy_sigC2, h_noisy_sigC3]
;Same fixed leve: h_noisy_sig = replicate(h_noisy[n_elements(h_noisy)/2.]*(errorbars/100.), n_elements(h_noisy))

; Derive kinematics
v_lagrangian = deriv(tt, h_noisy)
v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)

a_lagrangian = deriv(tt, v_lagrangian)
a_lagrangian_sig = derivsig(tt, v_lagrangian, tt_sig, v_lagrangian_sig)

;***********************************


;HEIGHT
xr = [0,time]
yr = [0, 20000]
plot, t, h_fullmodel/height_factor, psym=-0, yr=yr, /ys, xr=xr, /xs, ytit='Height (Mm)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_h
oplot, tt, h_noisy/height_factor, psym=1
oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor
horline, 2.2*695.5, line=1
horline, 6*695.5, line=1
horline, 19.5*695.5, line=1
;***
; Fitting the function back on the data to compare with model
;fit = 'sqrt(2*p[0])*x*atan((exp(x/(2*p[0])))/sqrt(2*p[0]))'
;res = mpfitexpr(fit, tt, h_noisy)
;h_fit = sqrt(2*res[0])*tt*atan((exp(tt/(2*res[0])))/sqrt(2*res[0]))
;oplot, tt, h_fit/height_factor, line=0, color=3
;***

;VELOCITY
yr = [0,1490]
plot, t, v_fullmodel/vel_factor, psym=-0, yr=yr, xr=xr, /xs, /ys, ytit='Velocity (km s!U-1!N)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_v
oplot, tt, v_lagrangian/vel_factor, psym=1
;***
;v_fit = sqrt(2*res[0]) * atan( exp(tt/(2*res[0]))/sqrt(2*res[0]) ) + exp(tt/(2*res[0]))*tt/(exp(tt/res[0])+2*res[0])
;oplot, tt, v_fit/vel_factor, line=0, color=3
;***

;ACCELERATION
yr = [-500,1000]
plot, t, a_fullmodel/accel_factor, psym=-0, yr=yr, xr=xr, /xs, /ys, xtit='Time (s)', ytit='Acceleration (m s!U-2!N)', pos=pos_a
horline, 0, linestyle=0, thick=1
oplot, tt, a_lagrangian/accel_factor, psym=1

;***
;a_fit = (exp(tt/(res[0]*2.))*((res[0]*2.)*(tt+(res[0]*4.))-exp(tt/res[0])*(tt-(res[0]*4.))))/((res[0]*2.)*((exp(tt/res[0])+(res[0]*2.))^2.))
;oplot, tt, a_fit/accel_factor, line=0, color=3
;***

save, t, tt, h_fullmodel, v_fullmodel, a_fullmodel, h_noisy, v_lagrangian, a_lagrangian, h_noisy_sig, height_factor, vel_factor, accel_factor, f='sample_kinscasestudy.sav'

if keyword_set(tog) then device, /close_file

set_plot, 'x'


end
