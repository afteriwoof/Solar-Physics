;Created:	2012-07-11	from plot_peaked_accel.pro to generate the kinematics of the model for paper figure.


pro fig_peaked_accel_kins, tog=tog

set_line_color
if ~keyword_set(tog) then begin
	window, xs=800, ys=1000
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
endelse

pos_h = [0.15,0.65,0.95,0.9]
pos_v = [0.15,0.4,0.95,0.65]
pos_a = [0.15,0.15,0.95,0.4]

!p.multi=[0,1,3]


time = 30000. ;secs
t = dindgen(time)

; Accel model:
model_fac = 600.
h_fullmodel = sqrt(model_fac*2.)*(t*atan(exp(t/(model_fac*2.))/sqrt((model_fac*2.))))
v_fullmodel = sqrt((model_fac*2.))*atan(exp(t/(model_fac*2.))/sqrt((model_fac*2.))) + (exp(t/(model_fac*2.))*t)/((model_fac*2.)+exp(t/model_fac))
a_fullmodel = (exp(t/(model_fac*2.))*((model_fac*2.)*(t+(model_fac*4.))-exp(t/model_fac)*(t-(model_fac*4.))))/((model_fac*2.)*((exp(t/model_fac)+(model_fac*2.))^2.))

height_factor = 1e2
vel_factor = 1e-1
accel_factor = 1e-4

xr = [0,time]
yr = [0, 20000]
plot, t, h_fullmodel/height_factor, psym=-0, yr=yr, /ys, xr=xr, /xs, ytit='Height (Mm)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_h

yr = [0,1490]
plot, t, v_fullmodel/vel_factor, psym=-0, yr=yr, xr=xr, /xs, /ys, ytit='Velocity (km s!U-1!N)', $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=pos_v

yr = [-500,1000]
plot, t, a_fullmodel/accel_factor, psym=-0, yr=yr, xr=xr, /xs, /ys, xtit='Time (s)', ytit='Acceleration (m s!U-2!N)', pos=pos_a
horline, 0, linestyle=0, thick=1


if keyword_set(tog) then device, /close_file

end
