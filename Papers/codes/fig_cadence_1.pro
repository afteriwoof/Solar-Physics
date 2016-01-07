; Created	2012-10-18	from fig_cadence_4landscape.pro for just the one plot

pro fig_cadence_1, tog=tog

; current device
entry_device = !d.name


fixed = 3595

if ~exist(fixed) then fixed=0

set_line_color

if ~keyword_set(tog) then begin
	set_plot, 'x'
	;window, xs=800, ys=1400
	window, xs=800, ys=500
        !p.charsize=2.5
        !p.thick=1
        !x.thick=1
        !y.thick=1
        !p.charthick=1
endif else begin
        !p.charsize=1
        !p.thick=4
        !x.thick=4
        !y.thick=4
        !p.charthick=4
	set_plot, 'ps'
	;device, /encapsul, bits=8, language=2, /portrait, /color, filename='fig_cadence_4.eps', xs=15, ys=30
	device, /encapsul, bits=8, language=2, /color, filename='fig_cadence_1.eps', xs=18, ys=8
	print, 'Saving fig_cadence_1.eps'
endelse
;!p.multi=[0,1,4]
!p.multi=[0,1,1]
;Model;r0 = 100e6 ;m
;v0 = 400e3 ;m/s
;a0 = 50. ;m/s/s
yr = [-450,750]

restore, 'peak_a_change_cadence_fixed3595.sav'
xnum /= 60.
num /= 60.
plot, xnum, al_array[ind]/accel_factor, xr=[0,num], /xs, yr=yr, /ys, ytit='Acceleration (m s!U-2!N)', /nodata, xtit='Cadence (min)'
horline, att_array[1]/accel_factor, line=3, thick=1
;horline, a_max_array[1]/accel_factor, line=2, thick=1
horline, 0, line=0, thick=1
oplot, xnum, al_array[ind]/accel_factor, psym=1, color=5
oploterror, xnum, al_array[ind]/accel_factor, al_fixed_err_array[ind], psym=3, errcolor=5


if keyword_set(tog) then device, /close_file


end
