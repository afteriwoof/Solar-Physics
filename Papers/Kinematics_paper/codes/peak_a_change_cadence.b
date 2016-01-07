num = 13000
fixed = 1200
al_array = dblarr(num+1)
att_array = dblarr(num+1)
a_max_array = dblarr(num+1)
al_fixed_err_array = dblarr(num+1)
.r plot_peakaccel_cadence_fixedpoint

for cadence=1,num,200 do begin & $
cadence_in = cadence & $
if cadence mod 8 eq 0 then cadence_in=cadence+0.0001 & $
plot_peakaccel_cadence_fixedpoint,cadence_in,fixed,al,att,a_max,al_fixed_err,/plot_fixed_point,/no_trunc & $
al_array[cadence] = al & $
att_array[cadence] = att & $
a_max_array[cadence] = a_max & $
al_fixed_err_array[cadence] = al_fixed_err & $
print, cadence & $
;$mkdir frames & $
;x2png, 'frames/frame'+int2str(cadence,2) & $
wait, 0.5 & $
endfor
toggle, /color, /portrait, f='peak_a_change_cadence.ps'
!p.multi=[0,1,3]
!p.thick=4
!p.charthick=4
!p.charsize=2
!x.thick=4
!y.thick=4
accel_factor = 1e-4
ind = where(att_array ne 0)
xnum = indgen(num)+1
xnum = xnum[ind]
plot, xnum, al_array[ind]/accel_factor, xr=[0,num], /xs, yr=[-300,600], /ys, xtit='Cadence (s)', ytit='Accel. (m s!U-2!N)', /nodata
oplot, xnum, al_array[ind]/accel_factor, psym=1, color=5
;oplot, xnum, att_array[ind]/accel_factor, psym=-3
;plot, indgen(num)+1, att_array[1:*]/accel_factor, psym=-3, yr=[-500,1000], /ys, xtit='Cadence (s)', ytit='Accel. (m s!U-2!N)'
;oplot, xnum, a_max_array[ind]/accel_factor, psym=-3, linestyle=1
oploterror, xnum, al_array[ind]/accel_factor, al_fixed_err_array[ind], psym=3, errcolor=5
horline, att_array[1]/accel_factor, line=1, thick=1
horline, a_max_array[1]/accel_factor, line=2, thick=1
horline, 0, line=0, thick=1
toggle
$ps2pdf peak_a_change_cadence.ps
$open peak_a_change_cadence.pdf
save,att_array,al_array,a_max_array,al_fixed_err_array,xnum,accel_factor,ind,num,f='peak_a_change_cadence_fixed1200.sav'
