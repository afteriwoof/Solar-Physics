; Created:	2012-07-11	to plot the height, velocity and acceleration model figure.


pro fig_hva, tog=tog


if ~exist(fixed) then fixed=0

set_line_color

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
        set_plot, 'ps'
        device, /encapsul, bits=8, language=2, /portrait, /color, filename='fig_hva.eps', xs=15, ys=30
endelse
!p.multi=[0,1,3]
;Model;r0 = 100e6 ;m
;v0 = 400e3 ;m/s
;a0 = 50. ;m/s/s
time = 200. ;secs
t = dindgen(time)

cadence = 1

; coding up the timesteps from fixed with cadence
start_limit = fixed
while (start_limit-cadence) gt 0 do start_limit-=cadence
end_limit = fixed
while (end_limit+cadence) lt time do end_limit+=cadence

tt = start_limit
count=1
while max(tt) lt end_limit do tt=[tt,tt[n_elements(tt)-1]+cadence]

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 0 ;second

model_fac = 5.
; Accel model:
h_fullmodel = sqrt(model_fac*2.)*(t*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)))
v_fullmodel = sqrt(model_fac*2.)*atan(exp(t/(model_fac*2.))/sqrt(model_fac*2.)) + (exp(t/(model_fac*2.))*t)/((model_fac*2.)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2.))*(model_fac*2.*(t+4.*model_fac)-exp(t/model_fac)*(t-4.*model_fac)))/(2.*model_fac*((exp(t/model_fac)+2.*model_fac)^2.))


plot, t, h_fullmodel, psym=-0, linestyle=0, /ylog, yr=[0.1,1000],/ys, xr=[-10,210], /xs, xtit='Time (mins)', ytit='Height (Mm)'

plot, t, v_fullmodel*100., psym=-0, linestyle=0, yr=[0,700],/ys, xr=[-10,210], /xs, xtit='Time (mins)', ytit='Velocity (km s!U-1!N)'

plot, t, a_fullmodel*1000., psym=-0, linestyle=0, yr=[-500,1000], xr=[-10,210], /xs, xtit='Time (mins)', ytit='Accel. (m s!U-2!N)'


if keyword_set(tog) then device, /close_file


end
