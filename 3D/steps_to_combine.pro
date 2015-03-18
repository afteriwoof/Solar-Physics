; Created	2013-07-19	to perform the steps once the point&click on CME front has been done, towards getting the 3D reconstruction done in 'combining'.

;INPUTS		in	- the header info of the relevant files.
;		da	- the image data of the relevant files.
;		
; KEYWORDS	ahead/behind	- specify which STEREO spacecraft.


pro steps_to_combine, in, da, bkg, ahead=ahead, behind=behind

fronts = file_search('front*sav')
times = strmid(fronts,6,4)

for i=0,n_elements(fronts)-1 do begin

	restore, fronts[i], /ver
	image = intarr(in[i].naxis1,in[i].naxis2)
	for j=0,n_elements(xf)-1 do image[xf[j],yf[j]]=1
	errs=1
	ang=2
	noplot=0
	front_ell_kinematics,image,errs,in[i],sigrange(da[*,*,i]-bkg),ang,ei,re,xe,ye,pe,mhf,mhe,aa,noplot
	save, ei, re, xe, ye, pe, mhf, mhe, aa, f='ell_arcsec_'+times[i]+'.sav'
	x2png, 'front_ell_'+times[i]+'.png'
	da_ell = da[*,*,i]
	while where(da_ell eq 888) ne [-1] || where(da_ell eq 988) ne [-1] do da_ell*=2.
	xcor2=xe/in[i].cdelt1+in[i].naxis1/2.-in[i].xcen/in[i].cdelt1
	ycor2=ye/in[i].cdelt2+in[i].naxis2/2.-in[i].ycen/in[i].cdelt2
	res=polyfillv(xcor2,ycor2,in[i].naxis1,in[i].naxis2)
	da_ell[res]=888
	for j=0,100 do da_ell[xcor2[j],ycor2[j]]=988
	window, xs=in[i].naxis1, ys=in[i].naxis2
	tvscl,sigrange(da_ell)
	if keyword_set(ahead) then begin
		daa_ell = da_ell
		x2png,'daa_ell_'+times[i]+'.png'
		save,daa_ell,f='daa_ell_'+times[i]+'.sav'
	endif
	if keyword_set(behind) then begin
		dab_ell = da_ell
		x2png,'dab_ell_'+times[i]+'.png'
		save,dab_ell,f='dab_ell_'+times[i]+'.sav'
	endif
	save,xcor2,ycor2,f='xycor2_ell_'+times[i]+'.sav'

endfor


end
