; Code to plot the kinematics of the events for paper

; Plotting the Height-time for the spread of lines, and the velocities with the drag fit.

; Created 2013-05-21 from kins_3d.pro

; Last Edited: 

; Read in 'kins_meanspread.txt' as file

; Best to run this code as kins_model,'kins_meanspread.txt',/edges,/occulter,/mids,/tog,/heights


pro kins_model, file, edges=edges, tog=tog, heights=heights, occulter=occulter, arc_length=arc_length, mids=mids, prominence=prominence, occult_widths=occult_widths

;Specify date range for plots.
date_start = '2009/01/26T1400'
date_end = '2009/01/26T2100'

; HEIGHT PLOT RANGE
height_plot_start = 0
height_plot_end = 20
; ACCEL HEIGHT PLOT RANGE
height_accel_start = 4
height_accel_end = 9
; ACCEL PLOT RANGE
accel_lower = 0
accel_upper = 350
; ANG WIDTH PLOT RANGE
ang_width_lower = 30
ang_width_upper = 80
; DEFLECTION PLOT RANGE
deflect_lower = -40
deflect_upper = 50

if keyword_set(tog) then begin
	device, /encapsul, bits=8, language=2, /portrait, /color, filename='kins_model.ps', xs=15, ys=30
	!p.charsize=2
	!p.charthick=3
	!p.thick=3
	!x.thick = 1
	!y.thick = 1
endif else begin
	set_plot, 'x'
	window, xs=500, ys=800
	!p.charsize = 2.5
endelse

!p.multi=[0,1,5]

readcol, file, mid_a, mid_r, top_a, top_r, bottom_a, bottom_r, midtop_a, midtop_r, midbottom_a, midbottom_r, time, $
	f='D,D,D,D,D,D,D,D,D,D,A'

utbasedata = anytim(time[0])
t = anytim(time) - utbasedata
rsun = 6.95508e8

mid_km = mid_r * rsun / 1000.0d
top_km = top_r * rsun / 1000.0d
bottom_km = bottom_r * rsun / 1000.0d
midtop_km = midtop_r * rsun / 1000.0d
midbottom_km = midbottom_r * rsun / 1000.0d

mid_vel = deriv(t, mid_km)
top_vel = deriv(t, top_km)
bottom_vel = deriv(t, bottom_km)
midtop_vel = deriv(t, midtop_km)
midbottom_vel = deriv(t, midbottom_km)

mid_accel = deriv(t, mid_vel) * 1000.0d ; to be in Metres
top_accel = deriv(t, top_vel) * 1000.0d
bottom_accel = deriv(t, bottom_vel) * 1000.0d
midtop_accel = deriv(t, midtop_vel) * 1000.0d
midbottom_accel = deriv(t, midbottom_vel) * 1000.0d

save, mid_vel, f='mid_vel.sav'
save, mid_r, f='mid_r.sav'
save, t, f='t.sav'

;***********

; Include the errorbars for a +/- n pixel instrument error

;n=8 ;<-- taken as the scale4 matlab code which is 2^3. Only valid for Cor1/2 though since running difference in HI1.
; Then considering 3D error trapezoid Inhester paper errors: w/2*cos(alpha/2) and w/2*sin(alpha/2)
; Stereo separation is 86.7 to 86.8 over the day, so average at 86.75
; alpha/2 = 43.375 deg
; cos(alpha/2) = 0.7268744
; sin(alpha/2) = 0.6867704
; so two error trapezoid axes measure [16/2*(0.73), 16/2*(0.69)] = [11.006, 11.649]
n_cor = 11.6
; But this is a 3sigma error so calculate 1sigma by their percentages (68-95-99.7 rule) => 68n/99.7
n_cor = (68*n_cor)/99.7
; And in HI1 the error is as follows
;n_hi = 3 ;pixels re: Shanes calcs for 1sigma
; so in 3D recon this is [2*3/2*(0.73), 2*3/2*(0.69)] = [4.127, 4.368]
n_hi = 4.4

h_errs = fltarr(n_elements(mid_r))
t_errs = h_errs

; There are 9 cor1 points with platescl (cdelt) of 7.5043001 arcsec
;for k=0,1 do h_errs[k] = 7.5043001 * n_cor / ((pb0r_stereo(time[k],/arcsec))[2])
; There are 14 cor2 points with platescl (cdelt) of 14.700000 arcsec
;for k=2,7 do h_errs[k] = 14.700000 * n_cor / ((pb0r_stereo(time[k],/arcsec))[2])
for k=0,n_elements(mid_r)-1 do h_errs[k] = 14.700000 * n_cor / ((pb0r_stereo(time[k],/arcsec))[2])
; There are 14 HI1 points with platescl (cdelt) of 0.019979876 deg (x3600 = 71.927554 arcsec)
; If I were to make correction for spacecraft plane-of-sky begin at 90degrees but CME about half this (rounding off) it will reduce the error, but I don't think I want to do this!
;for k=23,36 do h_errs[k] = 71.927554 * n_hi / ((pb0r_stereo(time[k],/arcsec))[2]) 
print, 'h_errs (rsun?) ', h_errs
;t_errs[0:1] = 1.69984 ;seconds
;t_errs[2:7] = 2.00090
t_errs[0:n_elements(mid_r)-1] = 2.00090
;t_errs[23:36] = 1800.0000 ; 30mins ref. Eyles et al. 2008

v_errs = derivsig(t,mid_r,t_errs,h_errs*6.95508e5)
print, 'v_errs (km?) ', v_errs
a_errs = derivsig(t,mid_vel*1000.,t_errs,v_errs*1000.)
print, 'a_errs (m?) ', a_errs
;***********

; Calculate what angular width error these height errors would give:

aw_errs = fltarr(n_elements(mid_r))
for k=0,n_elements(mid_r)-1 do aw_errs[k]=atan(h_errs[k]/mid_r[k]) / !dtor
aw_errs *= 2. ;since have to count both flanks errors
print, 'aw_errs (deg?): ', aw_errs


;***********


;diamond symbol
tempx = [0,-1,0,1,0] 
tempy = [1,0,-1,0,1]

if ~keyword_set(heights) then begin
	
	set_line_color

	usersym, tempx, tempy, /fill
	
	plotsym, 0, /fill
	utplot, t, mid_r, utbasedata, psym=8, linestyle=1, ytit='!3Height (R!Do!N!X)', $
		xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], $
		yr=[0,height_plot_end], /xs, /ys, /nolabel, /notit, charsize=2.2, $
		xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=[0.15,0.75,0.95,0.95], color=5, xthick=3, ythick=3;  tit='!3CME Front Kinematics & Morphology'
	;oploterror, t, mid_r, t_errs, h_errs, psym=3, color=5
	if keyword_set(mids) then begin
		usersym, tempx, tempy, /fill
		outplot, t, midtop_r, utbasedata, psym=8, color=3
		outplot, t, midbottom_r, utbasedata, psym=8, color=9
		plotsym, 4, /fill
		outplot, t, top_r, utbasedata, psym=8, linestyle=1, color=3
		plotsym, 5, /fill
		outplot, t, bottom_r, utbasedata, psym=8, linestyle=1, color=9
		;legends
		plotsym, 4, /fill
		legend, ['Northern Flank'], psym=8, color=3, charsize=1.2, box=0, pos=[0,49]
		usersym, tempx, tempy, /fill
		legend, ['Midtop of Front'], psym=8, color=3, charsize=1.2, box=0, pos=[0,43]
		plotsym, 0, /fill
		legend, ['Midpoint of Front'], psym=8, color=5, charsize=1.2, box=0, pos=[0,37]
		usersym, tempx, tempy, /fill
		legend, ['Midbottom of Front'], psym=8, color=9, charsize=1.2, box=0, pos=[0,31]
		plotsym, 5, /fill
		legend, ['Southern Flank'], psym=8, color=9, charsize=1.2, box=0, pos=[0,25]
	endif else begin
		plotsym, 4, /fill
		legend, ['Northern Flank'], psym=8, color=3, charsize=1.2, box=0, pos=[0,45]
		plotsym, 0, /fill
		legend, ['Midpoint of Front'], psym=8, color=5, charsize=1.2, box=0, pos=[0,39]
		plotsym, 5, /fill
		legend, ['Southern Flank'], psym=8, color=9, charsize=1.2, box=0, pos=[0,33]
	endelse
	;legend, ['Top', 'Midtop', 'Middle', 'Midbottom', 'Bottom'], psym=[-7,-5,-1,-6,-2], linestyle=[1,1,1,1,1], color=[3,6,5,4,9], charsize=1.2, box=0
	;legend, ['Top', 'Middle', 'Bottom'], psym=[5,8,6], color=[3,5,9], charsize=1.2, box=0

	if ~keyword_set(edges) then begin
	
		utplot, t[1:(n_elements(mid_vel)-2)], mid_vel[1:(n_elements(mid_vel)-2)], utbasedata, psym=-1, linestyle=1, $
			ytit='!3Vel. (km s!U-1!N)', charsize=2.5, $
			yr=[0,650], /notit, xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], $
			/xs, /ys, /nolabel, color=5, pos=[0.15,0.55,0.95,0.75], xtickname=[' ',' ',' ',' ',' ',' ',' '], xthick=3, ythick=3
		
		;outplot, t[1:(n_elements(top_vel)-2)], top_vel[1:(n_elements(top_vel)-2)], utbasedata, psym=1, linestyle=1, color=3
		;outplot, t[1:(n_elements(bottom_vel)-2)], bottom_vel[1:(n_elements(bottom_vel)-2)], utbasedata, psym=1, linestyle=1, color=9
		;outplot, t[1:(n_elements(midtop_vel)-2)], midtop_vel[1:(n_elements(midtop_vel)-2)], utbasedata, psym=1, linestyle=1, color=6
		;outplot, t[1:(n_elements(midbottom_vel)-2)], midbottom_vel[1:(n_elements(midbottom_vel)-2)], utbasedata, psym=1, linestyle=1, color=4
		;---->this one is the one to use   outplot, tt, vv, utbasedata, lines=2, thick=3
		;outplot, tt, vv1, utbasedata, lines=3, thick=3
		;outplot, tsim, vsim, tbsim, lines=5, color=2, psym=-1
		oploterror, t[1:(n_elements(mid_vel)-2)], mid_vel[1:(n_elements(mid_vel)-2)], $
			t_errs[1:(n_elements(mid_vel)-2)], h_errs[1:(n_elements(mid_vel)-2)], psym=3, color=5
		;legend, ['Aerodynamic Drag Model'], psym=-0, linestyle=2, charsize=1
		
			
		;utplot, t[2:(n_elements(mid_accel)-3)], mid_accel[2:(n_elements(mid_accel)-3)], utbasedata, psym=-3, linestyle=1, $
		;	ytit='!3Accel. (m s!U-1!N s!U-1!N)', $
		;	yr=[min(mid_accel)-100,max(mid_accel)+100], /notit, xr=[anytim('2008/12/12T0500')-utbasedata,anytim('2008/12/13T0230')-utbasedata], $
		;	/xs, /ys, /nolabel, pos=[0.15,0.40,0.95,0.60], xtickname=[' ',' ',' ',' ',' ',' ',' ']
		;
		;outplot, t[2:(n_elements(top_accel)-3)], top_accel[2:(n_elements(top_accel)-3)], utbasedata, psym=-3, linestyle=1, color=6
		;outplot, t[2:(n_elements(bottom_accel)-3)], bottom_accel[2:(n_elements(bottom_accel)-3)], utbasedata, psym=-3, linestyle=1, color=4
		;outplot, t[2:(n_elements(midtop_accel)-3)], midtop_accel[2:(n_elements(midtop_accel)-3)], utbasedata, psym=-3, linestyle=1, color=3
		;outplot, t[2:(n_elements(midbottom_accel)-3)], midbottom_accel[2:(n_elements(midbottom_accel)-3)], utbasedata, psym=-3, linestyle=1, color=5
		;outplot, t[2:(n_elements(mid_accel)-3)], mid_accel[2:(n_elements(mid_accel)-3)], utbasedata, psym=-3, linestyle=1
		;outplot, tt, aa*1000.0, utbasedata, lines=2, thick=5
		;outplot, tt, aa1*1000.0, utbasedata, lines=3, thick=5

		; Plot the Angular Width against TIME

		if where(bottom_a gt 180) ne [-1] then bottom_a[where(bottom_a gt 180)] = bottom_a[where(bottom_a gt 180)] - 360.0d
		widths = top_a - bottom_a
		
		; Fit the time versus width with a line to test for expansion rate
		
		yf2 = 'p[0]*x^2.0d + p[1]*x + p[2]'
		f2 = mpfitexpr(yf2, t, widths, perror=perror)
		model2 = f2[0]*t^2.0d + f2[1]*t + f2[2]
		yf1 = 'p[0]*x + p[1]'
		f1 = mpfitexpr(yf1, t, widths, perror=perror)
		model1 = f1[0]*t + f1[1]
		
		utplot, t, widths, utbasedata, psym=1, linestyle=1, ytit='!3Ang. Width (deg)', /nolabel, $
			xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], /xs, /ys, $
			yr=[min(widths)-10, max(widths)+10], xtickname=[' ',' ',' ',' ',' ',' ',' '], pos=[0.15,0.35,0.95,0.55]
		
		outplot, t, model1, psym=3
		print, 'First order fit to angular width'
		legend, ['Linear Fit: !9h!3(t) = '+string(f1[0],f='(D0.5)')+'t + '+string(f1[1],f='(D0.2)')], $
			charsize=1, box=0, /right, /bottom
		print, 'f1 ', f1
		print, 't ', t
			
	endif else begin  ; if keyword edges is set
	
		plotsym, 0, /fill
		utplot, t, mid_vel, utbasedata, psym=8, linestyle=1, $
			ytit='!3Velocity (km s!U-1!N)', color=5, charsize=2.2, $
			yr=[0,650], xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], $
			/xs, /ys, pos=[0.15,0.55,0.95,0.75], $
			xtickname=[' ',' ',' ',' ',' ',' '], /nolabel, xthick=3, ythick=3;, ytickname=['100','200','300','400','500',' ']
		oploterror, t, mid_vel, v_errs, psym=3, color=5
		;outplot, t[ind], top_vel[ind], utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t[ind], bottom_vel[ind], utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t[ind], midtop_vel[ind], utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t[ind], midbottom_vel[ind], utbasedata, psym=-1, linestyle=1, color=9
		outplot, t, mid_vel, utbasedata, psym=1, linestyle=1, color=5
		
		utplot, t, mid_accel, utbasedata, psym=3, linestyle=1, $
		        ytit='!3Accel. (m s!U-2!N)', color=5, charsize=2, $
			yr=[-65,135], /notit, xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], $
			/xs, /ys, /nolabel, pos=[0.74,0.50,0.92,0.62], xthick=3, ythick=3, xtickname=['06:30',' ','07:30',' ','08:30',' '];, ytickname=[' ','0',' ','40',' ','80',' ']
		horline, 0, linestyle=0
		oploterror, t, mid_accel, t_errs, a_errs, psym=8, color=5
		;outplot, t[ind], top_accel[ind], utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t[ind], bottom_accel[ind], utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t[ind], midtop_accel[ind], utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t[ind], midbottom_accel[ind], utbasedata, psym=-1, linestyle=1, color=5
		outplot, t, mid_accel, utbasedata, psym=1, linestyle=1, color=5

		; Plot the Angular Width against TIME

		if where(midbottom_a gt 180) ne [-1] then midbottom_a[where(midbottom_a gt 180)] = midbottom_a[where(midbottom_a gt 180)] - 360.0d
		if where(bottom_a gt 180) ne [-1] then bottom_a[where(bottom_a gt 180)] = bottom_a[where(bottom_a gt 180)] - 360.0d
		widths = top_a - bottom_a
		
		
		if keyword_set(occulter) then begin
			ind = [3,4,5,6,7,8,12,13,14,15,16,17,18,19,20,21,22,26,27,28,29,30,31,32,33,34,35,36]
			ind2 = [0,1,2,9,10,11,23,24,25]
		endif else begin
			ind = indgen(n_elements(mid_r))
		endelse

		; Fit the time versus width with a line to test for expansion rate
		
		; guess at the errors (smaller in Cor1 out to HI)
		;errs = [replicate(1,9), replicate(2,14), replicate(5,15)]

		;POWER LAW
		yf3 = 'p[0]*x^p[1]'
		f3 = mpfitexpr(yf3, t[ind], widths[ind], perror=perror)
		model3 = f3[0]*t[ind]^f3[1]
		print, 'A power law expansion fit gives '
		print, f3[0], 't^+', f3[1]

		;Quadratic
		yf2 = 'p[0]*x^2.0d + p[1]*x + p[2]'
		f2 = mpfitexpr(yf2, t[ind], widths[ind], perror=perror)
		model2 = f2[0]*t[ind]^2.0d + f2[1]*t[ind] + f2[2]
		print, 'A second order expansion fit gives '
		print, f2[0], 't^2+', f2[1], 't+', f2[2]
		
		;Linear
		yf1 = 'p[0]*x + p[1]'
		f1 = mpfitexpr(yf1, t[ind], widths[ind], perror=perror)
		model1 = f1[0]*t[ind] + f1[1]
		
		tempx = [0,-1,0,1,0]
		tempy = [1,0,-1,0,1]
		usersym, tempx, tempy, /fill
		utplot, t[ind], widths[ind], utbasedata, psym=8, linestyle=1, ytit='!3Ang. Width (deg)', $
			xr=[anytim(date_start)-utbasedata,anytim(date_end)-utbasedata], /xs, /ys, $
			yr=[25, 70], pos=[0.15,0.15,0.95,0.35], charsize=2.2, xthick=3, ythick=3
		;oploterror, t[ind], widths[ind], t_errs[ind], errs[ind], psym=3, color=0
		if keyword_set(occulter) then begin
			usersym, tempx, tempy
			outplot, t[ind2], widths[ind2], psym=8, color=0
		endif
		outplot, t[ind], model1, psym=-3, linestyle=0
		outplot, t[ind], model2, psym=-3, linestyle=2
		outplot, t[ind], model3, psym=-3, linestyle=1
		print, 'First order fit to angular width'
		legend, ['Linear Expansion rate: '+string(f1[0]*3600.0d,f='(D0.2)')+' deg/hr'], $
			charsize=1.2, box=0;, /right, /bottom
		; !9¶!D!3t!N!9q!3(t) = 

		;outplot, t, model2, psym=-3, linestyle=2

		print, 'slope(quadratic): ', f2[0]*3600.0d
		print, 'slope: ', f1[0]*60*60, 'degrees/hour'
		
	endelse

endif else begin  ; if keyword HEIGHTS is set

	if ~keyword_set(edges) then begin

		; Plot the velocity against HEIGHT

		plotsym, 0, /fill
		plot, indgen(10), /nodata, ytit='!3Velocity (km s!U-1!N)', yr=[0,1000], xr=[0,height_plot_end], /xs, /ys, charsize=2.2, $
			pos=[0.15,0.58,0.95,1.00], xthick=3, ythick=3, xtickname=[' ',' ',' ',' ',' '], color=0
		oplot, mid_r, mid_vel, psym=8, linestyle=1, color=5
		oploterror, mid_r, mid_vel, v_errs, psym=3, color=5
		;outplot, t, top_vel, utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t, bottom_vel, utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t, midtop_vel, utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t, midbottom_vel, utbasedata, psym=-1, linestyle=1, color=9
		;oplot, mid_r, mid_vel, psym=1, linestyle=1, color=5
		;oplot, hh, vv, linestyle=0, thick=5
		
		
		;legend, ['Drag Model'], psym=-0, linestyle=0, charsize=1.1, box=0, thick=5, pos=[31.5,730]	 
	
		plotsym, 4;, /fill
		legend, ['Northern Flank'], psym=8, color=3, charsize=1., box=0, pos=[0.5,730]
		plotsym, 4, /fill
		legend, ['Midtop of Front'], psym=8, color=3, charsize=1., box=0, pos=[0.5,690]
		plotsym, 0, /fill
		legend, ['Midpoint of Front'], psym=8, color=5, charsize=1., box=0, pos=[0.5,650]
		plotsym, 5, /fill
		legend, ['Midbottom of Front'], psym=8, color=9, charsize=1., box=0, pos=[0.5,610]
		plotsym, 5;, /fill
		legend, ['Southern Flank'], psym=8, color=9, charsize=1., box=0, pos=[0.5,570]
	
		plot, indgen(10), /nodata, ytit='!3Accel. (m s!U-2!N)', charsize=2, yr=[accel_lower,accel_upper], xr=[height_accel_start,height_accel_end], $
			/xs, /ys, pos=[0.74,0.62,0.92,0.75], xthick=3, ythick=3, color=0
		plotsym, 0, /fill
		oplot, mid_r, mid_accel, psym=8, linestyle=1, color=5
		horline, 0, linestyle=0, thick=1
		oploterror, mid_r, mid_accel, a_errs, psym=8, color=5
		;outplot, t, top_accel, utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t, bottom_accel, utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t, midtop_accel, utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t, midbottom_accel, utbasedata, psym=-1, linestyle=1, color=5

	
	
		; Plot the Angular Width against HEIGHT

		;print, 'original top_a ', top_a & print, 'original bottom_a ', bottom_a
		; clause for width crossing the zero axis (ecliptic)
		if where(midbottom_a gt 180) ne [-1] then midbottom_a[where(midbottom_a gt 180)] = midbottom_a[where(midbottom_a gt 180)] - 360.0d
		if where(bottom_a gt 180) ne [-1] then bottom_a[where(bottom_a gt 180)] = bottom_a[where(bottom_a gt 180)] - 360.0d
		widths = top_a - bottom_a
		mid_widths = midtop_a - midbottom_a

		; similar clause for when the mid angles cross 0-360 boundary!
		if where(mid_a gt 180) ne [-1] then mid_a[where(mid_a gt 180)] = mid_a[where(mid_a gt 180)] - 360.0d

		; similar clause for the top angles!
		;if where(midtop_a gt 180) ne [-1] then midtop_a[where(midtop_a gt 180)] = midtop_a[where(midtop_a gt 180)] - 360.0d
		;if where(top_a gt 180) ne [-1] then top_a[where(top_a gt 180)] = top_a[where(top_a gt 180)] - 360.0d
		;print, 'corrected top_a ', top_a & print, 'corrected bottom_a ', bottom_a

		
		; Fit the time versus width with a line to test for expansion rate
		
		yf3 = 'p[0]*x^p[1]'
		;f3 = mpfitexpr(yf3, mid_r, widths, perror=perror)
		f3 = mpfitexpr(yf3, mid_r, widths, perror=perror)
		model3 = f3[0]*(dindgen(50))^f3[1]
		print, 'Power law angular width of flanks: '
		print, f3[0], 'h^+', f3[1]
		f3_mids = mpfitexpr(yf3, mid_r, mid_widths)
		model3_mids = f3_mids[0]*(dindgen(50))^f3_mids[1]
		print, 'Power law angular width of mids: '
		print,  f3_mids[0], ' h^', f3_mids[1]
		;f3_full = mpfitexpr(yf3, mid_r, awsall])
		;model3_full = f3_full[0]*(dindgen(50))^f3_full[1]

		yf2 = 'p[0]*x^2.0d + p[1]*x + p[2]'
		f2 = mpfitexpr(yf2, mid_r, widths, perror=perror)
		model2 = f2[0]*mid_r^2.0d + f2[1]*mid_r + f2[2]
		print, 'A second order expansion fit gives '
		print, f2[0], 'h^2+', f2[1], 'h+', f2[2]
		
		yf1 = 'p[0]*x + p[1]'
		f1 = mpfitexpr(yf1, mid_r, widths, perror=perror)
		model1 = f1[0]*mid_r + f1[1]

		plot, mid_r, widths, psym=8, linestyle=1, ytit='!3Angular Width !9Dq !3(deg)', $
			xr=[0,height_plot_end], /xs, /ys, xtit='!3Height (r/R'+sunsymbol()+')', $
			pos=[0.15,0.00,0.95,0.23], charsize=2.2, xthick=3, ythick=3, yr=[ang_width_lower,ang_width_upper]
		
		usersym, tempx, tempy, /fill
		legend, ['!9Dq!3!D!N = '+string(f3[0],f='(I2.0)')+'(r/R'+sunsymbol()+')!U'+string(f3[1],f='(D0.1)')], $
			psym=-8, linestyle=3, charsize=1.1, box=0, pos=[29,30];, /right, /bottom

		oplot, (dindgen(49)+1), model3[1:*], psym=-3, linestyle=3  ; plotting power law fit
		
	endif else begin  ; IF KEYWORD EDGES IS SET
	
		; Plot the velocity against HEIGHT

		ind = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,24,25,26,27,28,29,30,31,32,33,34,35]	
		plotsym, 0, /fill
		plot, indgen(10), /nodata, ytit='!3Velocity (km s!U-1!N)', yr=[0,750], xr=[0,48], /xs, /ys, charsize=2.2, $
			pos=[0.15,0.58,0.95,1.00], xthick=3, ythick=3, xtickname=[' ',' ',' ',' ',' '], color=0
		oplot, mid_r[ind], mid_vel[ind], psym=8, linestyle=1, color=5
		oploterror, mid_r[ind], mid_vel[ind], v_errs[ind], psym=3, color=5
		;outplot, t[ind], top_vel[ind], utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t[ind], bottom_vel[ind], utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t[ind], midtop_vel[ind], utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t[ind], midbottom_vel[ind], utbasedata, psym=-1, linestyle=1, color=9
		;oplot, mid_r[ind], mid_vel[ind], psym=1, linestyle=1, color=5
		oplot, hh, vv, linestyle=0, thick=5
		
		
		legend, ['Drag Model'], psym=-0, linestyle=0, charsize=1.1, box=0, thick=5, pos=[31.5,730]	 
	
		plotsym, 4;, /fill
		legend, ['Northern Flank'], psym=8, color=3, charsize=1., box=0, pos=[0.5,730]
		plotsym, 4, /fill
		legend, ['Midtop of Front'], psym=8, color=3, charsize=1., box=0, pos=[0.5,690]
		plotsym, 0, /fill
		legend, ['Midpoint of Front'], psym=8, color=5, charsize=1., box=0, pos=[0.5,650]
		plotsym, 5, /fill
		legend, ['Midbottom of Front'], psym=8, color=9, charsize=1., box=0, pos=[0.5,610]
		plotsym, 5;, /fill
		legend, ['Southern Flank'], psym=8, color=9, charsize=1., box=0, pos=[0.5,570]
	

		ind = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,26,27,28,29,30,31,32,33,34]	
		plot, indgen(10), /nodata, ytit='!3Accel. (m s!U-2!N)', charsize=2, yr=[-85,165], xr=[2,6], $
			/xs, /ys, pos=[0.74,0.62,0.92,0.75], xthick=3, ythick=3, color=0
		plotsym, 0, /fill
		oplot, mid_r[ind], mid_accel[ind], psym=8, linestyle=1, color=5
		horline, 0, linestyle=0, thick=1
		oploterror, mid_r[ind], mid_accel[ind], a_errs[ind], psym=8, color=5
		;outplot, t[ind], top_accel[ind], utbasedata, psym=-1, linestyle=1, color=6
		;outplot, t[ind], bottom_accel[ind], utbasedata, psym=-1, linestyle=1, color=4
		;outplot, t[ind], midtop_accel[ind], utbasedata, psym=-1, linestyle=1, color=3
		;outplot, t[ind], midbottom_accel[ind], utbasedata, psym=-1, linestyle=1, color=5
		

		; Plot the Angular Width against HEIGHT

		; clause for width crossing the zero axis (ecliptic)
		if where(midbottom_a gt 180) ne [-1] then midbottom_a[where(midbottom_a gt 180)] = midbottom_a[where(midbottom_a gt 180)] - 360.0d
		if where(bottom_a gt 180) ne [-1] then bottom_a[where(bottom_a gt 180)] = bottom_a[where(bottom_a gt 180)] - 360.0d
		widths = top_a - bottom_a
		mid_widths = midtop_a - midbottom_a
		;widths[12:14]+=5 just to test how a constant cor2 ang width would look for fit
		
		; Fit the time versus width with a line to test for expansion rate

		if keyword_set(occulter) then begin
			ind = [3,4,5,6,7,8,12,13,14,15,16,17,18,19,20,21,22,26,27,28,29,30,31,32,33,34,35,36]
			ind2 = [0,1,2,9,10,11,23,24,25]
		endif else begin
			ind = indgen(37)
			if keyword_set(occult_widths) then begin
				ind = [3,4,5,6,7,8,12,13,14,15,16,17,18,19,20,21,22,26,27,28,29,30,31,32,33,34,35,36]
				ind2 = [0,1,2,9,10,11,23,24,25]
			endif
		endelse

		restore,'~/PhD/Data_Stereo/20081212/combining2/ells/aws.sav'
		restore,'~/PhD/Data_Stereo/20081212/combining2/ells/awshi.sav'
		awsall = [aws,awshi]

		yf3 = 'p[0]*x^p[1]'
		;f3 = mpfitexpr(yf3, mid_r[ind], widths[ind], aw_errs[ind], perror=perror)
		f3 = mpfitexpr(yf3, mid_r[ind], widths[ind], perror=perror)
		model3 = f3[0]*(dindgen(50))^f3[1]
		print, 'Power law angular width of flanks: '
		print, f3[0], 'h^+', f3[1]
		f3_mids = mpfitexpr(yf3, mid_r[ind], mid_widths[ind])
		model3_mids = f3_mids[0]*(dindgen(50))^f3_mids[1]
		print, 'Power law angular width of mids: '
		print,  f3_mids[0], ' h^', f3_mids[1]
		f3_full = mpfitexpr(yf3, mid_r[ind], awsall[ind])
		model3_full = f3_full[0]*(dindgen(50))^f3_full[1]

		; test for fitting only cor data and overplot on hi to see where it lies
		;f3 = mpfitexpr(yf3, mid_r[ind[0:16]], widths[ind[0:16]], aw_errs[ind[0:16]])
		;test_model3 = f3[0]*mid_r[ind[0:16]]^f3[1]
		

		yf2 = 'p[0]*x^2.0d + p[1]*x + p[2]'
		f2 = mpfitexpr(yf2, mid_r[ind], widths[ind], aw_errs[ind], perror=perror)
		model2 = f2[0]*mid_r[ind]^2.0d + f2[1]*mid_r[ind] + f2[2]
		print, 'A second order expansion fit gives '
		print, f2[0], 'h^2+', f2[1], 'h+', f2[2]
		
		yf1 = 'p[0]*x + p[1]'
		f1 = mpfitexpr(yf1, mid_r[ind], widths[ind], aw_errs[ind], perror=perror)
		model1 = f1[0]*mid_r[ind] + f1[1]
		
		tempx = [0,-1,0,1,0]
		tempy = [1,0,-1,0,1]
		usersym, tempx, tempy, /fill
		if ~keyword_set(occult_widths) then begin
			plot, mid_r[ind], widths[ind], psym=8, linestyle=1, ytit='!3Angular Width !9Dq !3(deg)', $
			xr=[0,48], /xs, /ys, xtit='!3Height (r/R'+sunsymbol()+')', $
			pos=[0.15,0.00,0.95,0.23], charsize=2.2, xthick=3, ythick=3, yr=[20,70]
		endif else begin
			ind = [3,4,5,6,7,8,12,13,14,15,16,17,18,19,20,21,22,26,27,28,29,30,31,32,33,34,35,36]
			ind2 = [0,1,2,9,10,11,23,24,25]
			plot, mid_r[ind], widths[ind], psym=8, linestyle=1, ytit='!3Angular Width !9Dq !3(deg)', $
			xr=[0,48], /xs, /ys, xtit='!3Height (r/R'+sunsymbol()+')', $
			pos=[0.15,0.00,0.95,0.23], charsize=2.2, xthick=3, ythick=3, yr=[20,70]
		endelse
		usersym, tempx, tempy, /fill
		;oplot, mid_r[ind], mid_widths[ind], psym=8
		;oploterror, mid_r[ind], widths[ind], h_errs[ind], aw_errs[ind], psym=3, color=0

		; Stick in the plot of what the maximum angular width could be from full reconstructions
		;oplot, mid_r[ind], awsall[ind], psym=1
		;oplot, (dindgen(49)+1), model3_full[1:*], psym=-3, linestyle=1

		; delete the semicolons along this first indent to plot the hollow occulter points
		if keyword_set(occulter) || keyword_set(occult_widths) then begin
			usersym, tempx, tempy
			oplot, mid_r[ind2], widths[ind2], psym=8, color=0
			;oplot, mid_r[ind2], mid_widths[ind2], psym=8, color=0
		endif
		
		;oplot, mid_r[ind], model1, psym=-3, linestyle=0
		;print, 'First order fit to angular width'
		usersym, tempx, tempy, /fill
		legend, ['!9Dq!3!D!N = '+string(f3[0],f='(I2.0)')+'(r/R'+sunsymbol()+')!U'+string(f3[1],f='(D0.1)')], $
			psym=-8, linestyle=3, charsize=1.1, box=0, pos=[29,30];, /right, /bottom
		;legend, ['!9Dq!3!D!N = '+string(f3_full[0],f='(I2.0)')+'(r/R'+sunsymbol()+')!U'+string(f3_full[1],f='(D0.2)')], $
		;	psym=-1, linestyle=1, charsize=1.1, box=0, pos=[29,35];, /right, /bottom
		usersym, tempx, tempy, /fill
		;legend, ['!9DF!3!DMids!N = '+string(f3_mids[0],f='(I2.0)')+'(r/R'+sunsymbol()+')!U'+string(f3_mids[1],f='(D0.1)')], $
		;	psym=-8, linestyle=3, charsize=1.1, box=0, pos=[27.5,14]
			
		;legend, psym=-0, linestyle=3, thick=5, ['!9DF!3 = !9DF!3!D0!N'+'(r/R'+sunsymbol()+')'+string(f3[1],f='(D0.2)')], $
		;	charsize=1.2, box=0;, /right, /bottom
		; !9¶!D!3t!N!9q!3(t) = 
		; 'Quadratic Expansion: '+string(f2[0],f='(D0.2)')+'R!Do!N!X!U2!N!X+'+string(f2[1],f='(D0.2)')+'R!Do!N!X+'+string(f2[2],f='(D0.2)'), $
		;	'Linear Expansion: '+string(f1[0],f='(D0.2)')+' deg/R!Do!N!X'

		;legend, ['Quadratic Expansion rate: '+string(f2[0],f='(D0.2)')+'R^2+'+string(f2[1],f='(D0.2)')+'R+'+string(f2[2],f='(D0.2)')], $
		;	charsize=1.2, box=0;, /right, /bottom

		;oplot, mid_r[ind], model2, psym=-3, linestyle=2
		oplot, (dindgen(49)+1), model3[1:*], psym=-3, linestyle=3  ; plotting power law fit
		;oplot, dindgen(50), model3_mids, psym=-3, linestyle=3


		;print, 'slope(quadratic): ', f2[0]*3600.0d
		;print, 'slope: ', f1[0], 'degrees/R_Sun'
		
		if keyword_set(prominence) then begin
			;Plot the prominence points on top (though these aren't completely correct yet)
			readcol, '../prominence_apex.txt', prom_lon, prom_lat, prom_h
			plots, prom_h, prom_lat, psym=7, color=0, symsize=0.8
			legend, ['Prominence Apex'], psym=7, color=0, charsize=1, box=0, pos=[15,49.5]
		endif
		
	endelse

endelse
	

if keyword_set(tog) then toggle


if keyword_set(arc_length) then begin
	window, 1
	!p.multi=0
	if where(bottom_a gt 180) ne [-1] then bottom_a[where(bottom_a gt 180)] = bottom_a[where(bottom_a gt 180)] - 360.0d
	widths = top_a - bottom_a
	print, 'mid_r ', mid_r
	arc_length = widths * mid_r
	plot, mid_r, arc_length, psym=2, xr=[0,48], yr=[0,max(arc_length)+50], /xs, /ys, xtit='!3Height (R!Do!N!X)' 
	oplot, mid_r, widths, psym=1
	legend, ['Arc Length', 'Angular Width'], psym=[2,1]
endif

print, 'Have to set !p.font=2 for Helvetica'

if keyword_set(tog) then device, /close_file

end
