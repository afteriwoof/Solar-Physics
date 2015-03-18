; CREATED	2014-04-26	Code to loop through the steps for performing the 3D of events.

pro run_3d, fls_dir, recon_dir, pandc=pandc, skip_ells=skip_ells, skip_3d=skip_3d

loadct, 8

spc = 0
jump1:
if spc eq 0 then spacecraft='a' else spacecraft='b'

;fls = file_search(fls_dir+'/*fts')
fls = file_search('~/Postdoc/Data_Stereo/20130513/fits/'+spacecraft+'/cor1/*fts')

recon_dir = '~/Postdoc/Data_Stereo/20130513/recon'

mreadfits_corimp,fls,in,da
diff=fltarr(512,512,n_elements(in)-1)
for i=0,n_elements(in)-2 do diff[*,*,i]=da[*,*,i+1]-da[*,*,0]


ks = [6,12]
if keyword_set(skip_ells) then goto, jump2
for k=ks[0],ks[1] do begin
	time = strjoin(strsplit(strmid(in[k].date_d$obs,11,5),':',/extract))
	outdir = recon_dir+'/'+spacecraft+'/cor1/'+time
	if ~dir_exist(outdir) then spawn, 'mkdir -p '+outdir
	window, xs=600, ys=600
	plot_image, diff[*,*,k]^0.05
	x2png, outdir+'/diff'+spacecraft+'_'+time+'.png'
	if keyword_set(pandc) then begin
		@pandc.b
		save, xf, yf, f=outdir+'/front'+spacecraft+'_'+time+'.sav'
	endif else begin
		restore, outdir+'/front'+spacecraft+'_'+time+'.sav'
	endelse
	image=intarr(in[k].naxis1,in[k].naxis2)
	for i=0,n_elements(xf)-1 do image[xf[i],yf[i]]=1
	errs = 1
	ang = 2
	noplot = 0
	front_ell_kinematics,image,errs,in[k],da[*,*,k]^0.1,ang,ei,re,xe,ye,pe,mhf,mhe,aa,noplot
	save, ei, re, xe, ye, pe, mhf, mhe, aa, f=outdir+'/ell_arcsec_'+spacecraft+'_'+time+'.sav'
	x2png, outdir+'/ell_arcsec_da'+spacecraft+'_'+time+'.png'
	front_ell_kinematics,image,errs,in[k],diff[*,*,k]^0.1,ang,ei,re,xe,ye,pe,mhf,mhe,aa,noplot
	x2png, outdir+'/ell_arcsec_diff'+spacecraft+'_'+time+'.png'
	da_ell=da[*,*,k]
	while where(da_ell eq 888) ne [-1] || where(da_ell eq 988) ne [-1] do da_ell*=2.
	plot_image,da_ell^0.1
	xcor=xe/in[k].cdelt1+in[k].naxis1/2.-in[k].xcen/in[k].cdelt1
	ycor=ye/in[k].cdelt2+in[k].naxis2/2.-in[k].ycen/in[k].cdelt2
	res=polyfillv(xcor,ycor,in[k].naxis1,in[k].naxis2)
	da_ell[res]=888
	for i=0,100 do da_ell[xcor[i],ycor[i]]=988
	plot_image,da_ell^0.01
	x2png, outdir+'/da'+spacecraft+'_ell_'+time+'.png'
	if spc eq 0 then begin
		daa_ell = da_ell
		save,daa_ell,f=outdir+'/da'+spacecraft+'_ell_'+time+'.sav'
	endif else begin
		dab_ell = da_ell
		save,dab_ell,f=outdir+'/da'+spacecraft+'_ell_'+time+'.sav'
	endelse
	save,xcor,ycor,f=outdir+'/xycor1'+spacecraft+'_ell_'+time+'.sav'
endfor

jump2:

if spc eq 0 then begin
	spc = 1
	goto, jump1
endif

if keyword_set(skip_3d) then goto, jump_end

; 3D reconstruction
;(probably best done manually for dodgy frames etc)

hdrsa = file_search('~/Postdoc/Data_Stereo/20130513/fits/a/cor1/*fts')
hdrsb = file_search('~/Postdoc/Data_Stereo/20130513/fits/b/cor1/*fts')

combined_dir = recon_dir+'/combined'
spawn, 'mkdir -p '+combined_dir

;for k=ks[0],ks[1] do begin
k=12
	mreadfits_corimp, hdrsa[k], ina
	mreadfits_corimp, hdrsb[k], inb
	time = strjoin(strsplit(strmid(ina.date_d$obs,11,5),':',/extract))
	combined_dir_time = combined_dir+'/'+time
	spawn, 'mkdir -p '+combined_dir_time
	;fls = file_search(fls_dir+'/*fts')
	
	cd, combined_dir_time

	spacecraft_location, ina, inb

	spawn, 'mv '+recon_dir+'/a/cor1/'+time+'/daa_ell_'+time+'.sav '+combined_dir_time+'/'
	spawn, 'mv '+recon_dir+'/b/cor1/'+time+'/dab_ell_'+time+'.sav '+combined_dir_time+'/'

	spawn, 'mkdir -p my_scc_measure'

	cd, 'my_scc_measure'	
	restore, '../daa*', /ver
	restore, '../dab*', /ver

	spawn, 'mkdir -p slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10 slice11 slice12 slice13 slice14 slice15 slice16 slice17 slice18 slice19 slice20 slice21 slice22 slice23 slice24 slice25 slice26 slice27 slice28 slice29 slice30 slice31 slice32 slice33 slice34 slice35 slice36 slice37 slice38 slice39 slice40 slice41 slice42 slice43 slice44 slice45 slice46 slice47 slice48 slice49 slice50 slice51 slice52 slice53 slice54 slice55 slice56 slice57 slice58 slice59 slice60 slice61 slice62 slice63 slice64 slice65 slice66 slice67 slice68 slice69 slice70 slice71 slice72 slice73 slice74 slice75 slice76 slice77 slice78 slice79 slice80 slice81 slice82 slice83 slice84 slice85 slice86 slice87 slice88 slice89 slice90 slice91 slice92 slice93 slice94 slice95 slice96 slice97 slice98 slice99 slice100 slices_all' 

;	resolve_routine, 'my_scc_measure.pro'
	my_scc_measure, daa_ell, dab_ell, ina, inb  ; click in left window
;	resolve_routine, 'my_scc_measure_readin.pro'
	my_scc_measure_readin, daa_ell, dab_ell, ina, inb ; click in right window

	get_wcs_intersects, ina, inb

	spawn, 'touch bogus.txt'
	spawn, 'open bogus.txt'
	print, 'List bogus files from runthru (remember to leave a blank line at the start).'
	runthru, ina, inb

	;cd, 'slices_all'
	
	;plot_slices, 1, 100

;endfor


jump_end:

end
