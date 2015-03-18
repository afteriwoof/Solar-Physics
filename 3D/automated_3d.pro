; Created	2013-11-21	to run through the steps in an automated fashion for creating the 3D reconstructions.

; Last edited	2014-03-06	to edit for both model data and real data.


; INPUTS	base_path	- generally the HOME directory extension to the event in question. Eg: '/home/jbyrne/Postdoc/Data_Stereo/20130513'
;		detector	- the telescope in use, e.g. 'cor1/2'

; KEYWORDS:	run_detections	- to run the step of run_automated_3dmodel.pro
;		model		- to run on the model data.
;		difference	- to use difference images (eg if dynamic images unavailable or struggling with SECCHI).
;		pandc		- to perform point&click on the images. If not set the code will assume to load previous point&click save files.


pro automated_3d, base_path, detector, model=model, run_detections=run_detections, difference=difference, pandc=pandc


; For the case of the model:
if keyword_set(model) then begin

	orient = '090'
	sep = '090'

	; base_path = '~/Postdoc/Data_Stereo/cme_model'	
	fits_path = base_path+'/fits/scseprate_'+sep+'/lon2earth_000/lat2earth_000/cmeorient_'+orient
	dets_path = base_path+'/detections/scseprate_'+sep+'/lon2earth_000/lat2earth_000/cmeorient_'+orient 
	recon_path = base_path+'/recon/scseprate_'+sep+'/lon2earth_000/lat2earth_000/cmeorient_'+orient	
	
	out_dir = dets_path+'/a'
	flsa=file_Search(fits_path+'/a/*fits.gz')
	;--> changed the run_automated_new.pro to add noise and to set in.x/ycen to in.crpix1/2 , max_cme_mask=0 , sdev_factor=1.5
	if keyword_set(run_detections) then run_automated_3dmodel,flsa,out_dir,/stereo 
	
	out_dir = dets_path+'/b'
	flsb=file_search(fits_path+'/b/*fits.gz')
	;--> changed the run_automated_new.pro to add noise and to set in.x/ycen to in.crpix1/2 , max_cme_mask=0 , sdev_factor=1.5
	if keyword_set(run_detections) then run_automated_3dmodel,flsb,out_dir,/stereo 

	;************

	cd, recon_path
	
	flsa=file_Search(fits_path+'/a/*fits.gz')
	flsb=file_search(fits_path+'/b/*fits.gz')

endif else begin
	
	; base_path = '~/Postdoc/Data_Stereo/20110303_automated'
	fits_path = base_path+'/fits'
	sep_fits_path = base_path+'/separated_fits'
	dets_path = base_path+'/detections'
	recon_path = base_path+'/recon'
	spawn, 'mkdir -p '+dets_path
	spawn, 'mkdir -p '+recon_path

	cd, recon_path

	if keyword_set(difference) then begin
		flsa = file_search(fits_path+'/a/'+detector+'/*')
		flsb = file_search(fits_path+'/b/'+detector+'/*')
		diffa = differencing(flsa)
		diffb = differencing(flsb)
	endif else begin
		flsa = file_search(sep_fits_path+'/a/'+detector+'/*')
		flsb = file_search(sep_fits_path+'/b/'+detector+'/*')
	endelse

	if keyword_set(run_detections) then begin
		out_dir = dets_path+'/a'
		spawn, 'mkdir -p '+out_dir
		run_automated_new, flsa, out_dir, gail=gail, /stereo
		out_dir = dets_path+'/b'
		spawn, 'mkdir -p '+out_dir
		run_automated_new, flsb, out_dir, gail=gail, /stereo, /behind
	endif

endelse


for file_ind=0,n_elements(flsa)-1 do begin

	; Ahead

	save_dir = recon_path+'/a/'+detector
	spawn, 'mkdir -p '+save_dir
	
	mreadfits_corimp, flsa[file_ind], ina, daa

	time = strjoin(strsplit(strmid(anytim(ina.date_obs,/date_only,/ccsds),0,12),'-',/extract)) + '_' + strjoin(strsplit(strmid(anytim(ina.date_obs,/time_only,/ccsds),0,5),':',/extract))

	spawn, 'mkdir -p '+recon_path+'/'+detector+'/'+time

	if keyword_set(difference) then begin
		if keyword_set(pandc) then begin
			jump1:
			plot_image, sigrange(diffa[file_ind]^0.1)
			@pandc.b	
			ans = ' '
			read, 'Redo point&click? (y/n) ', ans
			if ans eq 'y' then goto, jump1
			xfa = xf & yfa = yf
			save, xfa, yfa, f=recon_path+'/a/'+detector+'/'+time+'/fronta_'+time+'.sav'
		endif else begin
			if exist(recon_path+'/a/'+detector+'/'+time+'/fronta_'+time+'.sav') then $
				 restore, recon_path+'/a/'+detector+'/'+time+'/fronta_'+time+'.sav' else goto, jump1
		endelse
	endif else begin
		check_fl = file_search(dets_path+'/a/'+detector+'/cme_dets/dets*'+time+'*sav', count=cnt)
		if cnt eq 0 then goto, jump_next
		restore,dets_path+'/a/'+detector+'/cme_dets/dets*'+time+'*sav',/ver
		xfa=transpose(dets.front[0,*])
		yfa=transpose(dets.front[1,*])
		loadct, 0
		window, xs=800, ys=800
		plot_image, sigrange(daa)
		set_line_color
		plots, xfa, yfa, psym=1, color=3
		x2png, save_dir+'/fronta_'+time+'.png'
		save,xfa,yfa,f=save_dir+'/fronta_'+time+'.sav'
	endelse

	image=intarr(ina.naxis1, ina.naxis2)
	for i=0,n_elements(xfa)-1 do image[xfa[i],yfa[i]]=1
	errs=1
	ang=2
	noplot=0
	loadct,0
	front_ell_kinematics,image,errs,ina,daa,ang,ei,re,xe,ye,pe,mhf,mhe,aa,noplot
	save, ei, re, xe, ye, pe, mhf, mhe, aa, f=save_dir+'/ella_arcsec_'+time+'.sav'
	x2png, save_dir+'/ella_'+time+'.png'
	daa_ell = daa
	while where(daa_ell eq 888) ne [-1] || where(daa_ell eq 988) ne [-1] do daa_ell*=2.
	xa=xe/ina.cdelt1+ina.naxis1/2.-ina.xcen/ina.cdelt1
	ya=ye/ina.cdelt2+ina.naxis2/2.-ina.ycen/ina.cdelt2
	pos_inds = where(xa ge 0 AND ya ge 0 AND xa lt ina.naxis1 AND ya lt ina.naxis2)
	xa = xa[pos_inds]
	ya = ya[pos_inds]
	res=polyfillv(xa,ya,ina.naxis1,ina.naxis2)
	daa_ell[res]=888
	for j=0,n_elements(pos_inds)-1 do daa_ell[xa[j],ya[j]]=988
	plot_image, sigrange(daa_ell)
	x2png, save_dir+'/daa_ell_'+time+'.png'
	save, daa_ell, f=save_dir+'/daa_ell_'+time+'.sav'
	save, xa, ya, f=save_dir+'/xya_ell_'+time+'.sav'

	; Behind

 	save_dir = recon_path+'/b/'+detector
        spawn, 'mkdir -p '+save_dir
 
	mreadfits_corimp, flsb[file_ind], inb, dab
	
	if keyword_set(difference) then begin
                if keyword_set(pandc) then begin
                        jump2:
                        plot_image, sigrange(diffb[file_ind]^0.1)
                        @pandc.b
                        ans = ' '
                        read, 'Redo point&click? (y/n) ', ans
                        if ans eq 'y' then goto, jump1
                        xfb = xf & yfb = yf
			save, xfb, yfb, f=recon_path+'/b/'+detector+'/'+time+'/frontb_'+time+'.sav'
                endif else begin
                        if exist(recon_path+'/b/'+detector+'/'+time+'/frontb_'+time+'.sav') then $
                                 restore, recon_path+'/b/'+detector+'/'+time+'/frontb_'+time+'.sav' else goto, jump2
                endelse
        endif else begin
		check_fl = file_search(dets_path+'/b/'+detector+'/cme_dets/dets*'+time+'*sav', count=cnt)
                if cnt eq 0 then goto, jump_next
                restore,dets_path+'/b/'+detector+'/cme_dets/dets*'+time+'*sav',/ver
                xfb=transpose(dets.front[0,*])
                yfb=transpose(dets.front[1,*])
                loadct, 0
                window, xs=800, ys=800
                plot_image, sigrange(dab)
                set_line_color
                plots, xfb, yfb, psym=1, color=3
                x2png, save_dir+'/frontb_'+time+'.png'
                save,xfb,yfb,f=save_dir+'/frontb_'+time+'.sav'
        endelse

	image=intarr(inb.naxis1, inb.naxis2)
	for i=0,n_elements(xfb)-1 do image[xfb[i],yfb[i]]=1
	errs=1
	ang=2
	noplot=0
	window, xs=800, ys=800
	loadct,0
	front_ell_kinematics,image,errs,inb,dab,ang,ei,re,xe,ye,pe,mhf,mhe,aa,noplot
	save, ei, re, xe, ye, pe, mhf, mhe, aa, f=save_dir+'/ellb_arcsec_'+time+'.sav'
	x2png, save_dir+'/ellb_'+time+'.png'
	dab_ell = dab
	while where(dab_ell eq 888) ne [-1] || where(dab_ell eq 988) ne [-1] do dab_ell*=2.
	xb=xe/inb.cdelt1+inb.naxis1/2.-inb.xcen/inb.cdelt1
	yb=ye/inb.cdelt2+inb.naxis2/2.-inb.ycen/inb.cdelt2
	pos_inds = where(xb ge 0 AND yb ge 0 AND xb lt inb.naxis1 AND yb lt inb.naxis2)
	xb = xb[pos_inds]
	yb = yb[pos_inds]
	res=polyfillv(xb,yb,inb.naxis1, inb.naxis2)
	dab_ell[res]=888
	for j=0,n_elements(pos_inds)-1 do dab_ell[xb[j],yb[j]]=988
	plot_image, sigrange(dab_ell)
	x2png, save_dir+'/dab_ell_'+time+'.png'
	save, dab_ell, f=save_dir+'/dab_ell_'+time+'.sav'
	save, xb, yb, f=save_dir+'/xyb_ell_'+time+'.sav'



	jump_next:



	;********************
	; DETERMINE 3D SLICES
	;****
	
	spawn, 'mv '+recon_path+'/a/'+detector+'/daa_ell_'+time+'.sav '+recon_path+'/'+time+'/'+detector+'/'
	spawn, 'mv '+recon_path+'/b/'+detector+'/dab_ell_'+time+'.sav '+recon_path+'/'+time+'/'+detector+'/'

	hdrsa = file_search(fits_path+'/a/'+detector+'/*')
	mreadfits_corimp, hdrsa[file_ind], ina
	hdrsb = file_search(fits_path+'/b/'+detector+'/*')
        mreadfits_corimp, hdrsb[file_ind], inb

	cd, recon_path+'/'+time+'/'+detector
	
	spacecraft_location, ina, inb

	spawn, 'mkdir -p my_scc_measure'

	cd, 'my_scc_measure'	
	restore, '../daa*', /ver
	restore, '../dab*', /ver

	spawn, 'mkdir -p slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10 slice11 slice12 slice13 slice14 slice15 slice16 slice17 slice18 slice19 slice20 slice21 slice22 slice23 slice24 slice25 slice26 slice27 slice28 slice29 slice30 slice31 slice32 slice33 slice34 slice35 slice36 slice37 slice38 slice39 slice40 slice41 slice42 slice43 slice44 slice45 slice46 slice47 slice48 slice49 slice50 slice51 slice52 slice53 slice54 slice55 slice56 slice57 slice58 slice59 slice60 slice61 slice62 slice63 slice64 slice65 slice66 slice67 slice68 slice69 slice70 slice71 slice72 slice73 slice74 slice75 slice76 slice77 slice78 slice79 slice80 slice81 slice82 slice83 slice84 slice85 slice86 slice87 slice88 slice89 slice90 slice91 slice92 slice93 slice94 slice95 slice96 slice97 slice98 slice99 slice100 slices_all' 

	my_scc_measure, daa_ell, dab_ell, ina, inb  ; click in left window

	my_scc_measure_readin, daa_ell, dab_ell, ina, inb ; click in right window

	get_wcs_intersects, ina, inb

	runthru, ina, inb, /no_pause

	cd, 'slices_all'
	
	plot_slices, /zoom, /tog


endfor



end
