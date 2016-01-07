; Created	20121016	from fig_cadence_4landscape.pro to plot out the hva (height,vel,accel) together.

pro fig_cadence_hva, tog=tog

; current device
entry_device = !d.name

yr_h = [0,20000]
yr_v = [0,1200]
yr_a = [-450,750]

fixed = 3595

if ~exist(fixed) then fixed=0

set_line_color

if ~keyword_set(tog) then begin
	set_plot, 'x'
	;window, xs=800, ys=1400
	window, xs=600, ys=800
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
	;device, /encapsul, bits=8, language=2, /portrait, /color, filename='fig_cadence_4.eps', xs=15, ys=30
	device, /encapsul, bits=8, language=2, /color, filename='fig_cadence_hva.eps', xs=15, ys=20
	print, 'set_plot x'
	print, 'Saving fig_cadence_hva.eps'
endelse

!p.multi=[0,1,3]
;Model;r0 = 100e6 ;m
;v0 = 400e3 ;m/s
;a0 = 50. ;m/s/s

pos_h = [0.15,0.66,0.92,0.91]
pos_v = [0.15,0.4,0.92,0.65]
pos_a = [0.15,0.14,0.92,0.39]

time = 30000. ;secs
t = dindgen(time)

plot_no = 2

jump1:

if plot_no eq 2 then no_jump=1 else no_jump=0
if plot_no eq 1 then cadence=12*60. else cadence=50*60.
;cadence = 50*60.

cadence=double(cadence)

if cadence mod 8 eq 0 then cadence+=0.0001
;cadence = 1. ;secs

; coding up the timesteps from fixed with cadence
start_limit = fixed
while (start_limit-cadence) gt 0 do start_limit-=cadence
end_limit = fixed
while (end_limit+cadence) lt time do end_limit+=cadence

tt = start_limit
count=1
while max(tt) lt end_limit do tt=[tt,tt[n_elements(tt)-1]+cadence]
tt = double(tt)

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0 ;second

; Accel model:
model_fac = 600.
h_fullmodel = sqrt(model_fac*2.)*(t*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)))
v_fullmodel = sqrt(model_fac*2.)*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)) + (exp(t/(model_fac*2.))*t)/((model_fac*2.)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2.))*(model_fac*2.*(t+4.*model_fac)-exp(t/model_fac)*(t-4.*model_fac)))/(2.*model_fac*((exp(t/model_fac)+2.*model_fac)^2.))

print, 'Location of acceleration peak: ', where(a_fullmodel eq max(a_fullmodel))
print, 'Location of acceleration minimum: ', where(a_fullmodel eq min(a_fullmodel))

h = sqrt(2.*model_fac)*(tt*atan(exp(tt/(2.*model_fac))/sqrt(2.*model_fac)))
v = sqrt(2.*model_fac)*atan(exp(tt/(2*model_fac))/sqrt(2.*model_fac)) + (exp(tt/(2.*model_fac))*tt)/(2.*model_fac+exp(tt/model_fac))
a = (exp(tt/(2.*model_fac))*(2.*model_fac*(tt+4.*model_fac)-exp(tt/model_fac)*(tt-4.*model_fac)))/(2.*model_fac*((exp(tt/model_fac)+2.*model_fac)^2.))

;shifting the height up 1 solar radius
h_fullmodel += 695.5*100
h += 695.5*100

height_factor = 1e2
vel_factor = 1e-1
accel_factor = 1e-4

;Noisy distance eqn
noise = randomn(seed, size(t[0:*:cadence], /n_elements))
noise2 = randomn(seed, size(t[0:*:cadence], /n_elements))
noise_percent = 0.
print, 'Can change the noise percent, currently set at ', noise_percent

if noise_percent eq 0 then h_noisy = h; + noise_percent*height_factor*noise
if noise_percent ne 0 then h_noisy = h + (noise_percent/100.)*h*noise
;tt_noisy = tt+3.*noise2
;OVERRIDE WITH FIXED NOISE
;h_noisy = h + (noise_percent/100.)*h[n_elements(h)/2]*noise

; Using errorbars are the percentage error for 1-sigma error on hieght-time.
;errorbars = 4.0 ;percent
;h_noisy_sig = h_noisy*(errorbars/100.)
;OVERRIDE WITH FIXED ERRORBARS
;h_noisy_sig = replicate(h_noisy[n_elements(h_noisy)/2]*(errorbars/100.), n_elements(h_noisy))
errorbars = 300 ;Mm (plus/minus)
h_noisy_sig = replicate(errorbars*height_factor, n_elements(h_noisy))
print, 'h_noisy_sig/height_factor ', h_noisy_sig[0]/height_factor
;print, 'h_noisy/height_factor ', h_noisy/height_factor

;print, '---------------------------------------'

;Derive kinematics
v_lagrangian = deriv(tt, h_noisy)
v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)
;v_lagrangian = deriv(tt, h_noisy)

v_lagrangian_sig = derivsig(tt, h_noisy, tt_sig, h_noisy_sig)
;print, 'Error at fixedpoint v_lagrangian: ', v_lagrangian_sig[where(tt eq fixed)]/vel_factor

a_lagrangian = deriv(tt, v_lagrangian)
a_lagrangian_sig = derivsig(tt, v_lagrangian, tt_sig, v_lagrangian_sig)
;print, 'Error at fixedpoint a_lagrangian_sig: ', a_lagrangian_sig[where(tt eq fixed)]/accel_factor
al_fixed_err = a_lagrangian_sig[where(tt eq fixed)]/accel_factor

save, t, tt, h_noisy, h_noisy_sig, v_lagrangian, a_lagrangian, h_fullmodel, v_fullmodel, a_fullmodel, height_factor, vel_factor, accel_factor, f='temp_kins.sav'
;print, '---------------------------------------'

;HEIGHT
plot, t, h_fullmodel/height_factor, psym=-0, yr=yr_h, ytit='Height (Mm)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_h, ystyle=8
oplot, tt, h_noisy/height_factor, psym=1
oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3, errcolor=5
axis, yaxis=1, yrange=yr_h/695.5, /ys, ytit=symbol_corimp('rs')
;horline, 2.2*695.5, line=1
;horline, 6*695.5, line=1
;horline, 19.5*695.5, line=1
legend, [int2str(cadence/60)+'min cadence'], charsize=1.2, box=0
;legend, [int2str(noise_percent)+'% Noise', int2str(errorbars)+'Mm errorbars', 'Model: r(t) = sqrt(2x)(t tan!U-1!N(e!Ut/2x!N/sqrt(2x)))'], charsize=0.8, box=0, /bottom, /right

;VELOCITY
plot, t, v_fullmodel/vel_factor, psym=-0, yr=yr_v, /ys, ytit='Velocity (km s!U-1!N)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_v
oplot, tt, v_lagrangian/vel_factor, psym=1
oploterror, tt, v_lagrangian/vel_factor, v_lagrangian_sig/vel_factor, psym=3, errcolor=5

;ACCELERATION
plot, t, a_fullmodel/accel_factor, psym=-0, yr=yr_a, /ys, xtit='Time (s)', ytit='Acceleration (m s!U-2!N)', pos=pos_a
horline, 0, linestyle=0, thick=1
oplot, tt, a_lagrangian/accel_factor, psym=1
oploterror, tt, a_lagrangian/accel_factor, a_lagrangian_sig/accel_factor, psym=3, errcolor=5


if keyword_set(tog) then device, /close_file


end
