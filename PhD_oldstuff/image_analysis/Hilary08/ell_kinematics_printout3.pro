; Code which calls the front_ell_kinematics.pro and gathers the ellipse kinematics into a text file.

; fronts is the front edges which need to be restored from save files.

; Last Edited: 30-01-08

pro ell_kinematics_printout3, in, da, fronts, errs, ang

sz = size(da,/dim)

;kins = fltarr(sz[2], 6)

my_fronts = fltarr(sz[0], sz[1], sz[2])

;openw, lun, /get_lun, 'write_kins.txt', error=err
;free_lun, lun

for k=0,sz[2]-1 do begin

	print, '*** Image Number: ', k, ' ***'
	
	front_ell_kinematics_printout3, fronts[*,*,k], errs[k], in[k], da[*,*,k], ang, x_org, y_org

	plot_image,fltarr(1024,1024)
	plots, x_org, y_org, psym=2
	for i=0,n_elements(x_org)-1 do my_fronts[x_org[i],y_org[i],k] = 1
pause
plot_image, my_fronts[*,*,k]

	;front_ell_kinematics2, fronts[*,*,k], in[k], da[*,*,k], ang, ell_info
	
	;for i=0,5 do kins[k,i] = ell_info[i]
	
	;openu, lun, 'write_kins.txt', /append
	;printf, lun, ell_info[0], ell_info[1], ell_info[2], ell_info[3], ell_info[4], $
	;	ell_info[5], in[k].detector, in[k].date_d$obs, in[k].time_d$obs, r_err, in[k].exptime
	;free_lun, lun
	
endfor


save, my_fronts, f='my_fronts.sav'


end
