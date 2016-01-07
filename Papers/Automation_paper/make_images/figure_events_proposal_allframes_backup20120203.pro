; code to save ps of figures from sample of events to put in proposal

;Created:	12-09-11	to make figures of the automated CME detection on the sample (four) events for proposal.

pro figure_events_proposal_allframes



my_charsize = 1
my_charthick = 5

posaddx = 0.015
posaddy = 0.025

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; Gather the files to put through the loop
plots_C2_1 = file_search('~/postdoc/automation/catalogue/20000102/plots*C2.sav')
fls_C2_1 = file_search('~/postdoc/automation/candidates/20000102/*C2.fits.gz')
time_C2_1 = yyyymmdd2cal(strmid(file_basename(fls_C2_1),25,12))
time_plots_C2_1 = yyyymmdd2cal(strmid(file_basename(plots_C2_1),6,12))

plots_C3_1 = file_search('~/postdoc/automation/catalogue/20000102/plots*C3.sav')
fls_C3_1 = file_search('~/postdoc/automation/candidates/20000102/*C3.fits.gz')
time_C3_1 = yyyymmdd2cal(strmid(file_basename(fls_C3_1),25,12))
time_plots_C3_1 = yyyymmdd2cal(strmid(file_basename(plots_C3_1),6,12))

plots_C2_2 = file_search('~/postdoc/automation/catalogue/20000418-19/plots*C2.sav')
fls_C2_2 = file_search('~/postdoc/automation/candidates/20000418-19/*C2.fits.gz')
time_C2_2 = yyyymmdd2cal(strmid(file_basename(fls_C2_2),25,12))
time_plots_C2_2 = yyyymmdd2cal(strmid(file_basename(plots_C2_2),6,12))

plots_C3_2 = file_search('~/postdoc/automation/catalogue/20000418-19/plots*C3.sav')
fls_C3_2 = file_search('~/postdoc/automation/candidates/20000418-19/*C3.fits.gz')
time_C3_2 = yyyymmdd2cal(strmid(file_basename(fls_C3_2),25,12))
time_plots_C3_2 = yyyymmdd2cal(strmid(file_basename(plots_C3_2),6,12))

plots_C2_3 = file_search('~/postdoc/automation/catalogue/20000423/plots*C2.sav')
fls_C2_3 = file_search('~/postdoc/automation/candidates/20000423/*C2.fits.gz')
time_C2_3 = yyyymmdd2cal(strmid(file_basename(fls_C2_3),25,12))
time_plots_C2_3 = yyyymmdd2cal(strmid(file_basename(plots_C2_3),6,12))

plots_C3_3 = file_search('~/postdoc/automation/catalogue/20000423/plots*C3.sav')
fls_C3_3 = file_search('~/postdoc/automation/candidates/20000423/*C3.fits.gz')
time_C3_3 = yyyymmdd2cal(strmid(file_basename(fls_C3_3),25,12))
time_plots_C3_3 = yyyymmdd2cal(strmid(file_basename(plots_C3_3),6,12))

plots_C2_4 = file_search('~/postdoc/automation/catalogue/20110112-14/plots*C2.sav')
fls_C2_4 = file_search('~/postdoc/automation/candidates/201101/13/*C2.orig.fits.gz')
time_C2_4 = yyyymmdd2cal(strmid(file_basename(fls_C2_4),25,12))
time_plots_C2_4 = yyyymmdd2cal(strmid(file_basename(plots_C2_4),6,12))

plots_C3_4 = file_search('~/postdoc/automation/catalogue/20110112-14/plots*C3.sav')
fls_C3_4 = file_search('~/postdoc/automation/candidates/201101/13/*C3.orig.fits.gz')
time_C3_4 = yyyymmdd2cal(strmid(file_basename(fls_C3_4),25,12))
time_plots_C3_4 = yyyymmdd2cal(strmid(file_basename(plots_C3_4),6,12))




for frame_count=0,51 do begin
;for frame_count=0,0 do begin

	print, '***********************************'
	print, 'Frame_count ', frame_count, ' of 51'
	print, '***********************************'
	
	!p.multi=[4,3,4]

	; define drawable space and filename
	; size is to be 4 rows by 3 columns of images.
	; size		x:	0-624-100-624-150-750-100	0-624-724-1348-1498-2248-2348
	;		y:	0-624-130-624-130-624-130-624	0-624-754-1378-1508-2132-2262-2886
	devxs = 2348.
	devys = 2886.
	device, xsize=devxs/200., ysize=devys/200., bits=8, language=2, /portrait, /cm, /color, filename='figure_events_proposal_frame'+int2str(frame_count)+'.ps'
	pos_x = [624,724,1348,1498,2248]
	pos_y = [2262,2132,1508,1378,754,624]
	
	
	;C2 IMAGE 1
	
	loadct, 0
	
	;first frame_count restores this file: '~/Postdoc/Automation/Catalogue/20000102/plots_200001020006__C2.sav'
	if frame_count ge n_elements(plots_C2_1) then begin
                restore, plots_C2_1[plots_C2_1_last]
                da = readfits_corimp(fls_C2_1[fls_C2_1_last])
        endif else begin
                if where(time_plots_c2_1 eq time_c2_1[frame_count]) ne [-1] then begin
			restore, plots_C2_1[where(time_plots_c2_1 eq time_c2_1[frame_count])]
                	plot_flag = 0
			da = readfits_corimp(fls_C2_1[frame_count])
		endif else begin
			plot_flag = 1
			da = readfits_corimp(fls_C2_1[frame_count],in)
		endelse
		if plot_flag eq 0 then plots_C2_1_last = where(time_plots_c2_1 eq time_c2_1[frame_count])
		fls_C2_1_last = frame_count
		print, 'Image: ', fls_c2_1[frame_count]
		if plot_flag eq 0 then print, 'Plots: ', plots_C2_1[where(time_plots_c2_1 eq time_c2_1[frame_count])]
        endelse

	if plot_flag eq 0 then begin
		res = ((res-in.crpix1)*in.pix_size)/in.rsun
		xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
		yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun
	endif

	if plot_flag eq 0 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	if plot_flag eq 1 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.xcen, in.ycen, pix_size=in.pix_size/in.rsun, x, y, ht, pa	
	
	fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	
	pos = [ 0, pos_y[0]/devys, pos_x[0]/devxs, 1 ]
	
	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm
	
	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
		;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
		xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	        title='LASCO/C2', $
		ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5
	
	if plot_flag eq 0 then begin
		set_line_color
		circle_sym, 0, /fill
		plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
		plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5
	endif
	pasun = make_coordinates(360, [0,2*!pi])
	rsun = 1
	xsun = rsun*sin(pasun)
	ysun = rsun*cos(pasun)
	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; C3 IMAGE 1

	loadct, 0

	;restore, '~/Postdoc/Automation/Catalogue/20000102/plots_200001020018__C3.sav'
	voidc3 = min(abs(anytim2tai(time_C2_1[fls_C2_1_last])-anytim2tai(time_C3_1)),indc3)
	restore, plots_C3_1[where(time_plots_C3_1 eq time_C3_1[indc3])]
	da = readfits_corimp(fls_C3_1[indc3])
	print, 'Image: ', fls_C3_1[indc3]
        print, 'Plots: ', plots_C3_1[where(time_plots_C3_1 eq time_C3_1[indc3])]
	
	da = da[146:877,146:877]
	in.naxis1 = 732
	in.naxis2 = 732
	in.crpix1 = 366
	in.crpix2 = 366

	res[0,*] -= in.xcen
	res[1,*] -= in.ycen
	res[0,*] *= in.cdelt1
	res[1,*] *= in.cdelt2
	res /= in.rsun
	xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
	yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

	get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

	restore,'~/idl_codes/c3pylonmask.sav'
	c3pylonmask = c3pylonmask[146:877,146:877]
	pylon_inds = where(c3pylonmask eq 0)

	fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	da[pylon_inds] = max(da)

	pos = [ pos_x[1]/devxs, pos_y[0]/devys, pos_x[2]/devxs, 1 ]
	
	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
		title='LASCO/C3', $
		xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5
	
	set_line_color

	plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
	plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5

	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; KINS 1

	loadct, 13

	restore, '~/Postdoc/Automation/Catalogue/20000102/detections_noncleaned/all_h0.sav'
	fls=file_search('~/Postdoc/Automation/candidates/20000102/cme_sep_fts/*')
	fls = sort_fls(fls)
	mreadfits_corimp, fls, in

	pos_angles = (pos_angles+270) mod 360

	t = in[image_no].date_obs
	time = anytim(t)
	utbasedata = time[0]
	
	km_arc = 6.96e8 / (1000.*in.rsun)
	heights_km = fltarr(n_elements(heights))
	for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]
	
	pos = [ pos_x[3]/devxs, pos_y[0]/devys, pos_x[4]/devxs, 1 ]
	
	xls = (anytim(time[0]))-utbasedata + 37000
	xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 28000

	utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm x10!U4!N)', pos=pos, $
		xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5, $
		ytickname=['0','0.5','1.0','1.5'], tit='HEIGHT-TIME PROFILE'

	; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
	pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
	pos_angles_color = pos_angles
	if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

	for i=min(pos_angles),max(pos_angles) do begin
	        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
	        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/1000., symsize=0.3, thick=5, $
	                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
	                ;color=((i+abs(min(pos_angles)))*255./(abs(max(pos_angles)-min(pos_angles)))), psym=1
			color = (i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
	endfor

	horline, 2.35*700., linestyle=1, thick=5
	horline, 5.95*700., linestyle=1, thick=5
	horline, 19.5*700., linestyle=1, thick=5
	
	;verline, anytim('2000/01/02 00:06')-utbasedata, linestyle=0, thick=5
	;verline, anytim('2000/01/02 00:18')-utbasedata, linestyle=2, thick=5
	if anytim(time_C2_1[fls_C2_1_last])-utbasedata lt xrs then verline, anytim(time_C2_1[fls_C2_1_last])-utbasedata, linestyle=0, thick=5
	if anytim(time_C3_1[indc3])-utbasedata lt xrs then verline, anytim(time_C3_1[indc3])-utbasedata, linestyle=2, thick=5

	;colorbar
	
	pos = [ (pos_x[4]+20)/devxs, pos_y[0]/devys, (pos_x[4]+50)/devxs, 1 ]
	
	colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
	        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5
	
	
	;C2 IMAGE 2
	
	loadct, 0

	; first frame_count restores this file: '~/Postdoc/Automation/Catalogue/20000418-19/plots_200004181030__C2.sav'
	if (frame_count+29) ge n_elements(plots_C2_2) then begin
                restore, plots_C2_2[plots_C2_2_last]
                da = readfits_corimp(fls_C2_2[fls_C2_2_last])
        endif else begin
                if where(time_plots_C2_2 eq time_C2_2[frame_count+29]) ne [-1] then begin
			restore, plots_C2_2[where(time_plots_C2_2 eq time_C2_2[frame_count+29])]
      			plot_flag = 0
	        	da = readfits_corimp(fls_C2_2[frame_count+29])
        	endif else begin
			plot_flag = 1
			da = readfits_corimp(fls_C2_2[frame_count+29],in)
		endelse
		if plot_flag eq 0 then plots_C2_2_last = where(time_plots_C2_2 eq time_C2_2[frame_count+29])
		fls_C2_2_last = frame_count+29
		print, 'Image: ', fls_C2_2[frame_count+29]
                if plot_flag eq 0 then print, 'Plots: ', plots_C2_2[where(time_plots_C2_2 eq time_C2_2[frame_count+29])]
	endelse

	if plot_flag eq 0 then begin
		res = ((res-in.crpix1)*in.pix_size)/in.rsun
		xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
		yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun
	endif

	if plot_flag eq 0 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	if plot_flag eq 1 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.xcen, in.ycen, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	
	fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)

	pos = [ 0, pos_y[2]/devys, pos_x[0]/devxs, pos_y[1]/devys ]

	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
		xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	if plot_flag eq 0 then begin
		set_line_color
		circle_sym, 0, /fill
		plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
		plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5
	endif
	pasun = make_coordinates(360, [0,2*!pi])
	rsun = 1
	xsun = rsun*sin(pasun)
	ysun = rsun*cos(pasun)
	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; C3 IMAGE 2

	loadct, 0

	; first frame_count restores this file: '~/Postdoc/Automation/Catalogue/20000418-19/plots_200004181042__C3.sav'
	voidc3 = min(abs(anytim2tai(time_C2_2[fls_C2_2_last])-anytim2tai(time_C3_2)),indc3)
	if where(time_plots_C3_2 eq time_C3_2[indc3]) ne [-1] then begin
		restore, plots_C3_2[where(time_plots_C3_2 eq time_C3_2[indc3])]
		da = readfits_corimp(fls_C3_2[indc3])
		plot_flag = 0
	endif else begin
		da = readfits_corimp(fls_C3_2[indc3],in)
		plot_flag = 1
	endelse
	print, 'Image: ', fls_C3_2[indc3]
	if plot_flag eq 0 then print, 'Plots: ', plots_C3_2[where(time_plots_C3_2 eq time_C3_2[indc3])]

	da = da[146:877,146:877]
	in.naxis1 = 732
	in.naxis2 = 732
	if plot_flag eq 0 then begin
		in.crpix1 = 366
		in.crpix2 = 366
	endif else begin
		in.xcen = 366
		in.ycen = 366
	endelse

	if plot_flag eq 0 then begin
		res[0,*] -= in.xcen
		res[1,*] -= in.ycen
		res[0,*] *= in.cdelt1
		res[1,*] *= in.cdelt2
		res /= in.rsun
		xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
		yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun
	endif

	if plot_flag eq 0 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	if plot_flag eq 1 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.xcen, in.ycen, pix_size=in.pix_size/in.rsun, x, y, ht, pa

	restore,'~/idl_codes/c3pylonmask.sav'
	c3pylonmask = c3pylonmask[146:877,146:877]
	pylon_inds = where(c3pylonmask eq 0)

	fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	da[pylon_inds] = max(da)

	pos = [ pos_x[1]/devxs, pos_y[2]/devys, pos_x[2]/devxs, pos_y[1]/devys ]
	
	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
		xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	if plot_flag eq 0 then begin	
		set_line_color
		plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
		plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5
	endif
	plots, xsun, ysun, thick=5
	
	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; KINS 2

	loadct, 13

	restore, '~/Postdoc/Automation/Catalogue/20000418-19/detections_noncleaned/all_h0.sav'
	fls=file_search('~/Postdoc/Automation/candidates/20000418-19/*fits.gz')
	fls = sort_fls(fls)
	mreadfits_corimp, fls, in

	pos_angles = (pos_angles+270) mod 360

	t = in[image_no].date_obs
	time = anytim(t)
	utbasedata = time[0]

	km_arc = 6.96e8 / (1000.*in.rsun)
	heights_km = fltarr(n_elements(heights))
	for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

	pos = [ pos_x[3]/devxs, pos_y[2]/devys, pos_x[4]/devxs, pos_y[1]/devys ]

	xls = (anytim(time[0]))-utbasedata - 21000
	xrs = (anytim(time[n_elements(time)-1])) - utbasedata - 55000

	utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm x10!U4!N)', pos=pos, $
	        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5, $
	        ytickname=['0','0.5','1.0','1.5']
	
	; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
	pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
	pos_angles_color = pos_angles
	if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

	for i=min(pos_angles),max(pos_angles) do begin
	        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
	        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/1000., symsize=0.3, thick=5, $
	                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
			color=(i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
	endfor

	horline, 2.35*700., linestyle=1, thick=5
	horline, 5.95*700., linestyle=1, thick=5
	horline, 19.5*700., linestyle=1, thick=5
	
	;verline, anytim('2000/04/18 10:30')-utbasedata, linestyle=0, thick=5
	;verline, anytim('2000/04/18 10:42')-utbasedata, linestyle=2, thick=5
	if anytim(time_C2_2[fls_C2_2_last])-utbasedata lt xrs then verline, anytim(time_C2_2[fls_C2_2_last])-utbasedata, linestyle=0, thick=5
        if anytim(time_C3_2[indc3])-utbasedata lt xrs then verline, anytim(time_C3_2[indc3])-utbasedata, linestyle=2, thick=5

	;colorbar

	pos = [ (pos_x[4]+20)/devxs, pos_y[2]/devys, (pos_x[4]+50)/devxs, pos_y[1]/devys ]

	colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
	        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5


	;C2 IMAGE 3
	
	loadct, 0
	
	; first frame_count restores: '~/Postdoc/Automation/Catalogue/20000423/plots_200004231130__C2.sav'
	if (frame_count+27) ge n_elements(plots_C2_3) then begin
		restore, plots_C2_3[plots_C2_3_last]
		da = readfits_corimp(fls_C2_3[fls_C2_3_last])
	endif else begin
		if where(time_plots_C2_3 eq time_C2_3[frame_count+27]) ne [-1] then begin
			restore, plots_C2_3[where(time_plots_C2_3 eq time_C2_3[frame_count+27])]
        		da = readfits_corimp(fls_C2_3[frame_count+27])
			plot_flag = 0
		endif else begin
			da = readfits_corimp(fls_C2_3[frame_count+27],in)
			plot_flag = 1
		endelse
		if plot_flag eq 0 then plots_C2_3_last = where(time_plots_C2_3 eq time_C2_3[frame_count+27])
		fls_C2_3_last = frame_count+27
		print, 'Image: ', fls_C2_3[frame_count+27]
		if plot_flag eq 0 then print, 'Plots: ', plots_C2_3[where(time_plots_C2_3 eq time_C2_3[frame_count+27])]
	endelse

	if plot_flag eq 0 then begin
		res = ((res-in.crpix1)*in.pix_size)/in.rsun
		xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
		yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun
	endif

	if plot_flag eq 0 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	if plot_flag eq 1 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.xcen, in.ycen, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	
	fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)

	pos = [ 0, pos_y[4]/devys, pos_x[0]/devxs, pos_y[3]/devys ]
	
	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
		xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	if plot_flag eq 0 then begin
		set_line_color
		circle_sym, 0, /fill
		plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
		plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5
	endif
	pasun = make_coordinates(360, [0,2*!pi])
	rsun = 1
	xsun = rsun*sin(pasun)
	ysun = rsun*cos(pasun)
	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; C3 IMAGE 3

	loadct, 0

	; first frame_count restores: '~/Postdoc/Automation/Catalogue/20000423/plots_200004231142__C3.sav'
	voidc3 = min(abs(anytim2tai(time_C2_3[fls_C2_3_last])-anytim2tai(time_C3_3)),indc3)
        restore, plots_C3_3[where(time_plots_C3_3 eq time_C3_3[indc3])]
        da = readfits_corimp(fls_C3_3[indc3])
	print, 'Image: ', fls_C3_3[indc3]
	print, 'Plots: ', plots_C3_3[where(time_plots_C3_3 eq time_C3_3[indc3])]
	
	da = da[146:877,146:877]
	in.naxis1 = 732
	in.naxis2 = 732
	in.crpix1 = 366
	in.crpix2 = 366

	res[0,*] -= in.xcen
	res[1,*] -= in.ycen
	res[0,*] *= in.cdelt1
	res[1,*] *= in.cdelt2
	res /= in.rsun
	xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
	yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

	get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

	restore,'~/idl_codes/c3pylonmask.sav'
	c3pylonmask = c3pylonmask[146:877,146:877]
	pylon_inds = where(c3pylonmask eq 0)

	fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	da[pylon_inds] = max(da)

	pos = [ pos_x[1]/devxs, pos_y[4]/devys, pos_x[2]/devxs, pos_y[3]/devys ]

	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
		ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	set_line_color

	plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
	plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5

	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5
	

	; KINS 3

	loadct, 13

	restore, '~/Postdoc/Automation/Catalogue/20000423/detections_noncleaned/all_h0.sav'
	fls=file_search('~/Postdoc/Automation/candidates/20000423/*fits.gz')
	fls = sort_fls(fls)
	mreadfits_corimp, fls, in

	t = in[image_no].date_obs
	time = anytim(t)
	utbasedata = time[0]

	km_arc = 6.96e8 / (1000.*in.rsun)
	heights_km = fltarr(n_elements(heights))
	for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]
	
	pos_angles = (pos_angles+270) mod 360
	
	pos = [ pos_x[3]/devxs, pos_y[4]/devys, pos_x[4]/devxs, pos_y[3]/devys ]
	
	xls = (anytim(time[0]))-utbasedata - 35000
	xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 26000
	
	utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm x10!U4!N)', pos=pos, $
	        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5, $
	        ytickname=['0','0.5','1.0','1.5']
	
	for i=min(pos_angles),max(pos_angles) do begin
	        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
	        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/1000., symsize=0.3, thick=5, $
			color=(i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles))), psym=1                
	endfor
	
	horline, 2.35*700., linestyle=1, thick=5
	horline, 5.95*700., linestyle=1, thick=5
	horline, 19.5*700., linestyle=1, thick=5

	;verline, anytim('2000/04/23 11:30')-utbasedata, linestyle=0, thick=5
	;verline, anytim('2000/04/23 11:42')-utbasedata, linestyle=2, thick=5
	if (anytim(time_C2_3[fls_C2_3_last])-utbasedata) lt xrs then verline, anytim(time_C2_3[fls_C2_3_last])-utbasedata, linestyle=0, thick=5
        if (anytim(time_C3_3[indc3])-utbasedata) lt xrs then verline, anytim(time_C3_3[indc3])-utbasedata, linestyle=2, thick=5
	
	;colorbar

	pos = [ (pos_x[4]+20)/devxs, pos_y[4]/devys, (pos_x[4]+50)/devxs, pos_y[3]/devys ]

	colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
	        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5


	;C2 IMAGE 4

	loadct, 0

	; first frame_count restores: '~/Postdoc/Automation/Catalogue/20110112-14/plots_201101130924_C2.sav'
	if (frame_count+146) ge n_elements(plots_C2_4) then begin
                restore, plots_C2_4[plots_C2_4_last]
                da = readfits_corimp(fls_C2_4[fls_C2_4_last])
        endif else begin
        	if where(time_plots_C2_4 eq time_C2_4[frame_count+36]) ne [-1] then begin
	        	restore, plots_C2_4[where(time_plots_C2_4 eq time_C2_4[frame_count+36])]
                	da = readfits_corimp(fls_C2_4[frame_count+36])
			plot_flag = 0
		endif else begin
			da = readfits_corimp(fls_C2_4[frame_count+36],in)
			plot_flag = 1
		endelse
		if plot_flag eq 0 then plots_C2_4_last = where(time_plots_C2_4 eq time_C2_4[frame_count+36])
		fls_C2_4_last = frame_count+36
        	print, 'Image: ', fls_C2_4[frame_count+36]
		if plot_flag eq 0 then print, 'Plots: ', plots_C2_4[where(time_plots_C2_4 eq time_C2_4[frame_count+36])]
	endelse

	if plot_flag eq 0 then begin
		res = ((res-in.crpix1)*in.pix_size)/in.rsun
		xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
		yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun
	endif
	
	if plot_flag eq 0 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	if plot_flag eq 1 then get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.xcen, in.ycen, pix_size=in.pix_size/in.rsun, x, y, ht, pa
	
	fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	
	pos = [ 0, 0, pos_x[0]/devxs, pos_y[5]/devys ]

	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	if plot_flag eq 0 then begin	
		set_line_color
		circle_sym, 0, /fill
		plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
		plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5
	endif
	pasun = make_coordinates(360, [0,2*!pi])
	rsun = 1
	xsun = rsun*sin(pasun)
	ysun = rsun*cos(pasun)
	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5

	
	; C3 IMAGE 4

	loadct, 0

	; first frame_count restores: '~/Postdoc/Automation/Catalogue/20110112-14/plots_201101130930_C3.sav'
	voidc3 = min(abs(anytim2tai(time_C2_4[fls_C2_4_last])-anytim2tai(time_C3_4)),indc3)
        restore, plots_C3_4[where(time_plots_C3_4 eq time_C3_4[indc3])]
        da = readfits_corimp(fls_C3_4[indc3])
	print, 'Image: ', fls_C3_4[indc3]
	print, 'Plots: ', plots_C3_4[where(time_plots_C3_4 eq time_C3_4[indc3])]

	;da = da[146:877,146:877]
	;in.naxis1 = 732
	;in.naxis2 = 732
	;in.crpix1 = 366
	;in.crpix2 = 366

	res[0,*] -= in.xcen
	res[1,*] -= in.ycen
	res[0,*] *= in.cdelt1
	res[1,*] *= in.cdelt2
	res /= in.rsun
	xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
	yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

	get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

	restore,'~/idl_codes/c3pylonmask.sav'
	;c3pylonmask = c3pylonmask[146:877,146:877]
	c3pylonmask = rot(c3pylonmask,180)
	pylon_inds = where(c3pylonmask eq 0)

	fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
	da[nfov] = mean(da[fov],/nan)
	da = hist_equal(da,percent=0.01)
	da[nfov] = max(da)
	da[pylon_inds] = max(da)

	pos = [ pos_x[1]/devxs, 0, pos_x[2]/devxs, pos_y[5]/devys ]

	tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

	contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
		xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5

	set_line_color

	plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
	plots, xf_out, yf_out, psym=1, symsize=0.2, color=3, thick=5

	plots, xsun, ysun, thick=5

	;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick, xthick=5, ythick=5


	; KINS 4

	loadct, 13

	restore, '~/Postdoc/Automation/Catalogue/2011_proposal_event/dynamic/all_h0.sav'
	fls=file_search('~/Postdoc/Automation/candidates/lasco_2011/*')
	fls = sort_fls(fls)
	mreadfits_corimp, fls, in

	pos_angles = (pos_angles+270) mod 360

	t = in[image_no].date_obs
	time = anytim(t)
	utbasedata = time[0]
	
	km_arc = 6.96e8 / (1000.*in.rsun)
	heights_km = fltarr(n_elements(heights))
	for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]
	
	pos = [ pos_x[3]/devxs, 0, pos_x[4]/devxs, pos_y[5]/devys ]
	
	xls = (anytim(time[0]))-utbasedata + 13000
	xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 24000
	
	utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm x10!U4!N)', pos=pos, $
	        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5, $
	        ytickname=['0','0.5','1.0','1.5']
	
	; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
	pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
	pos_angles_color = pos_angles
	if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360
	
	for i=min(pos_angles),max(pos_angles) do begin
	        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
	        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/1000., symsize=0.3, thick=5, $
	                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
	                ;color=((i+abs(min(pos_angles)))*255./(abs(max(pos_angles)-min(pos_angles)))), psym=1
	                color = (i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
	endfor
	
	horline, 2.35*700., linestyle=1, thick=5
	horline, 5.95*700., linestyle=1, thick=5
	horline, 19.5*700., linestyle=1, thick=5
	
	;verline, anytim('2011/01/13 09:24')-utbasedata, linestyle=0, thick=5
	;verline, anytim('2011/01/13 09:30')-utbasedata, linestyle=2, thick=5
	if anytim(time_C2_4[fls_C2_4_last])-utbasedata lt xrs then verline, anytim(time_C2_4[fls_C2_4_last])-utbasedata, linestyle=0, thick=5
	if anytim(time_C3_4[indc3])-utbasedata lt xrs then verline, anytim(time_C3_4[indc3])-utbasedata, linestyle=2, thick=5
	
	;colorbar
	
	pos = [ (pos_x[4]+20)/devxs, 0, (pos_x[4]+50)/devxs, pos_y[5]/devys ]

	colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
	        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick, xthick=5, ythick=5



	device, /close_file



endfor


set_plot, entry_device

end
