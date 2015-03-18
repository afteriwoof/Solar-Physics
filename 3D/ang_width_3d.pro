; Obtain the angular width across the 3D reconstruction

; Created: from ang_width.pro in 20081212/combining/ells_fronts/ on 08-12-09
; Last edited: 09-12-09 to output the 2flankptsHHMM.sav files for including with the max_fronts.

; restore allhdrs.sav which is just the date_obs info.

pro ang_width_3d, fls, hdrs, widths, heights, t, plot_kins=plot_kins, choose_angle=choose_angle

list = ['0605','0615','0625','0635','0645','0655','0705','0715','0735','0822','0852','0922','0952','1022','1052','1122','1152','1222','1252','1322','1352','1422','1452','1649','1729','1809','1849','1929','2009','2049','2129','2209','2249','2329','2409','2449','2529']

openw, lun, 'kins.txt', /get_lun
printf, lun, '#		R_Sun		Min angle	Max angle	Ang width	Date_obs'
free_lun, lun
if keyword_set(choose_angle) then begin
	print, 'Note, angle must be positive (e.g. -10 = 350)'
	read, 'Choose angle? ', angle
	openw, lun, 'choose_angle.txt', /get_lun
	printf, lun, '#	R_Sun	Angle =', angle,	'	Date_obs', f='(A,F,A)'
	free_lun, lun
endif

count=0

sz = size(fls,/dim)

widths = dblarr(sz)
heights = dblarr(sz)

print, 'Expecting the restored variables to be xcs, ycs, zcs from ells_comb'

for k=0,sz[0]-1 do begin
	restore,fls[k]
	ind = where(xcs ne 0 and ycs ne 0 and zcs ne 0)
	xcs = xcs[ind]
	ycs = ycs[ind]
	zcs = zcs[ind]
	;plot,xcs,zcs,psym=2,yr=[min(zcs)-1,max(zcs)+1]
	; Take out the angles of top and bottom points
	recpol, xcs, zcs, r, a, /degrees
	;plot, r, a, psym=3
	max_a = max(a)
	min_a = min(a)
	print, min_a, max_a
	; Need to account for negative angle when flank is below zero axis!
	if max_a gt 90 then begin
		a = ((a+90.) mod 360.)-90.
		min_a = min(a)
		max_a = max(a)
		print, 'min_a: ', min_a
		print, 'max_a: ', max_a
		print, 'Clause that says if the maximum angle is above 90 (knowing the CME wont be) then its after crossing the ecliptic and the minimum angle must be corrected for!!!', max_a
	endif
	max_r = r[where(a eq max_a)]
	min_r = r[where(a eq min_a)]
	polrec, min_r, min_a, min_x, min_z, /degrees
	polrec, max_r, max_a, max_x, max_z, /degrees

	; find the nearest y coord to these flanks (since it doesn't line up perfectly for some reason!)
	init = (abs(xcs[0]-min_x))[0]
	for temp=0,n_elements(xcs)-1 do begin
		abs0 = (abs(xcs[temp]-min_x))[0]
		if abs0 lt init then begin
			flag_min = temp
			init = (abs(xcs[temp]-min_x))[0]
		endif
	endfor
	init = (abs(xcs[0]-max_x))[0]
	for temp=0,n_elements(xcs)-1 do begin
		abs1 = (abs(xcs[temp]-max_x))[0]
		if abs1 lt init then begin
			flag_max = temp
			init = (abs(xcs[temp]-max_x))[0]
		endif
	endfor
	min_y = ycs[flag_min]
	max_y = ycs[flag_max]
	;plot, xcs, zcs, psym=3
	;plots, min_x, min_z, psym=2
	;plots, max_x, max_z, psym=5
	;print, where(xcs eq min_x)
	;print, min_x
	;print, min(abs(xcs-min_x))
	save, max_x, min_x, min_y, max_y, max_z, min_z, f='2flankpts'+list[k]+'.sav'
	;plot, r, a, psym=3
	;plots, min_r, min_a, psym=5, color=3
	;plots, max_r, max_a, psym=4, color=4
	;pause
	if ~keyword_set(choose_angle) then if where(zcs lt 0) ne [-1] then zcs -= 2.d0*min(zcs) ; shift the whole front by a certain amount.
	if keyword_set(choose_angle) then begin
		recpol, xcs, zcs, r, a, /degrees
		plot, r, a, psym=3
		if where((a-angle) gt -0.5 and (a-angle) lt 0.5) eq [-1] then goto, jump1
		max_r_angle = max(r[where((a-angle) gt -0.5 and (a-angle) lt 0.5)])
		max_a_angle = a[where(r eq max_r_angle)]
		plots, max_r_angle, max_a_angle, psym=2, color=4
		openu, lun, 'choose_angle.txt', /append
		printf, lun, max_r_angle, max_a_angle, '	', hdrs[k], f='(D,D,A,A)'
		free_lun, lun
		jump1:
	endif
	heights[k] = max_r
	widths[k] = max_a - min_a
	if ~keyword_set(plot_kins) then if count eq 0 then $
		plot,r,a,psym=3,xr=[0,63],yr=[min(a)-10,max(a)+10],/xs,/ys,color=1 $
		else plots,r,a,psym=3,color=(k mod 7)+1
	openu, lun, 'kins.txt', /append
	printf, lun, heights[k], min_a, max_a, widths[k], '	',hdrs[k], f='(D,D,D,D,A,A)'
	free_lun, lun
	count=1
endfor 

;*** below top_point etc is wrong for this
;	top_point = [(xcs[where(zcs eq max(zcs))])[0], (ycs[where(zcs eq max(zcs))])[0], (max(zcs))[0]];
;	recpol, top_point[0], top_point[2], top_r, top_a, /degrees
;	bottom_point = [(xcs[where(zcs eq min(zcs))])[0], (ycs[where(zcs eq min(zcs))])[0], (min(zcs))[0]]
;	recpol, bottom_point[0], bottom_point[2], bottom_r, bottom_a, /degrees
;	if bottom_a gt 180 then bottom_a -= 360
	; Clause for when the width crosses the zero axis
		; shift the whole front by a certain amount
;	if ~keyword_set(choose_angle) then if where(zcs lt 0) ne [-1] then zcs -= 2.d0*min(zcs)
	;plots,xcs,zcs,psym=2,color=3
;	recpol,xcs,zcs,r,a,/degrees
;	if keyword_set(choose_angle) then begin
;		recpol, xcs, zcs, r, a, /degrees
;		plot, r, a, psym=3
;		if where((a-angle) gt -0.5 and (a-angle) lt 0.5) eq [-1] then goto, jump1
;		max_r_angle = max(r[where((a-angle) gt -0.5 and (a-angle) lt 0.5)])
;		max_a_angle = a[where(r eq max_r_angle)]
;		plots, max_r_angle, max_a_angle, psym=2, color=4
;		openu, lun, 'choose_angle.txt', /append
;		printf, lun, max_r_angle, max_a_angle, '	', hdrs[k], f='(D,D,A,A)'
;		free_lun, lun
;		jump1:
;	endif
;	heights[k] = max(r)
;	widths[k] = top_a-bottom_a
;	if ~keyword_set(plot_kins) then if count eq 0 then $
;		plot,r,a,psym=3,xr=[0,63],yr=[min(a)-10,max(a)+10],/xs,/ys,color=1 $
;		else plots, r, a, psym=3,color=(k mod 7)+1
;	openu, lun, 'kins.txt', /append
;	printf, lun, heights[k], bottom_a, top_a, widths[k], '	',hdrs[k], f='(D,D,D,D,A,A)'
;	free_lun,lun
;	count=1
;endfor


if keyword_set(plot_kins) then begin
	;window, 1, xs=800, ys=1000
	utbasedata = anytim(hdrs[0])
	t = anytim(hdrs) - utbasedata
	help,t,heights
	rsun = 6.95508e8
	
	h_km = heights * rsun / 1000.0d
	v_km = deriv(t, h_km)
	a_km = deriv(t, v_km)
	a_m = a_km * 1000.0d
	
	!p.multi=[0,1,3]
	
	lhs = 2000
	rhs = 2000
	utplot, t, heights, utbasedata, psym=-1, linestyle=1, ytit='!6Height (R!D!9n!N!X)', $
		xr=[t[0]-lhs,t[*]+rhs], yr=[0,65], /xs, /ys, /notit, /nolabel, $
		xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=[0.15,0.68,0.95,0.98]

	utplot, t, v_km, utbasedata, psym=-1, linestyle=1, ytit='!6Velocity (km s!U-1!N)', $
		xr=[t[0]-lhs,t[*]+rhs], yr=[0,max(v_km)+100], /xs, /ys, /notit, /nolabel, $
		xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=[0.15,0.38,0.95,0.68]

	utplot, t, a_m, utbasedata, psym=-1, linestyle=1, ytit='!6Acceleration (m s!U-1!N s!U-1!N)', $
		xr=[t[0]-lhs,t[*]+rhs], yr=[min(a_m)-50,max(a_m)+50], /xs, /ys, /notit, $
		pos=[0.15,0.08,0.95,0.38]
endif

end
