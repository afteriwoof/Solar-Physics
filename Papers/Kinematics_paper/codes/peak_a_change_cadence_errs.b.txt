num = 47
fixed = 9
af_array = dblarr(num+1)
ac_array = dblarr(num+1)
al_array = dblarr(num+1)
att_array = dblarr(num+1)
a_max_array = dblarr(num+1)
af_fixed_err_array = dblarr(num+1)
ac_fixed_err_array = dblarr(num+1)
al_fixed_err_array = dblarr(num+1)

for cadence=1,num do begin & $
plot_different_kins_cadence_fixedpoint,cadence,fixed,af,ac,al,att,a_max,af_fixed_err,ac_fixed_err,al_fixed_err,/plot_fixed_point,/no_trunc & $
af_array[cadence] = af & $
ac_array[cadence] = ac & $
al_array[cadence] = al & $
att_array[cadence] = att & $
a_max_array[cadence] = a_max & $
af_fixed_err_array[cadence] = af_fixed_err & $
ac_fixed_err_array[cadence] = ac_fixed_err & $
al_fixed_err_array[cadence] = al_fixed_err & $
print, cadence & $
;$mkdir frames & $
;x2png, 'frames/frame'+int2str(cadence,2) & $
wait, 0.5 & $
endfor
toggle, /color, /portrait, f='peak_a_change_cadence.ps'
!p.multi=[0,1,3]
!p.thick=3
!p.charthick=3
!p.charsize=2
!x.thick=3
!y.thick=3
plot, indgen(num)+1, att_array[1:*]/1e-2, psym=-3, yr=[-5,40], /ys, xtit='Cadence', ytit='Accel. (m s!U-2!N)'
oplot, indgen(num)+1, a_max_array[1:*]/1e-2, psym=-3, linestyle=1
oplot, indgen(num)+1, af_array[1:*]/1e-2, psym=-1, color=5
oploterror, indgen(num)+1, af_array[1:*]/1e-2, af_fixed_err_array[1:*], psym=3, errcolor=5
oplot, indgen(num)+1, al_array[1:*]/1e-2, psym=-1, color=4
oploterror, indgen(num)+1, al_array[1:*]/1e-2, al_fixed_err_array[1:*], psym=3, errcolor=4
oplot, indgen(num)+1, ac_array[1:4]/1e-2, psym=-1, color=3
oploterror, indgen(num)+1, ac_array[1:4]/1e-2, ac_fixed_err_array[1:4], psym=3, errcolor=3
toggle
$ps2pdf peak_a_change_cadence.ps
$open peak_a_change_cadence.pdf
