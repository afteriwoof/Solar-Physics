openw, lun, /get_lun, 'kins_cadence.txt'
printf, lun, '# cadence a_forward a_centre a_lagrangian'
free_lun, lun
t = dindgen(400)+1
for k=200,400 do begin & $
cadence=k & $
plot_different_kins_cadence_fixed, cadence, 3, af, ac, al, at, /no_plot & $
if k ne 1 then begin & $
aft=[aft,af] & $
act=[act,ac] & $
alt=[alt,al] & $
endif else begin & $
aft=af & $
act=ac & $
alt=al & $
endelse & $
openu, lun, 'kins_cadence.txt', /append & $
printf, lun, cadence, af, ac, al & $
free_lun, lun & $
;pause & $
endfor
