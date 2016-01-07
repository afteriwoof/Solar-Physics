; Created:	20120131	to plot out frames of C3 and the COR2s.

; Edited	20120320	to call in the latest processed results.

pro animation3, out_dir

!p.charsize=2
!p.charthick=2
!p.thick = 2

my_charsize = 0.5
my_charthick = 3

set_plot, 'ps'

; define drawable space and filename
; size is to be 3 rows by 2 columns of images.
;new		x:	180-624-200-624-200		180-804-1004-1628-1828
;new		y:	180-624-30-624-30-624-30-624-30-624	180-804-834-1458-1488-2112-2142-2766-2796-3420

devxs = 2.5*3
devys = 2.5*1
;device, xsize=devxs, ysize=devys, bits=8, language=2, /portrait, /inch, /color, filename='animation3.eps', /encapsul

fls_cor2a = file_search('~/Postdoc/Automation/candidates/secchi_cor2_a/2011/01/13/sep*orig.fits.gz')
fls_cor2b = file_search('~/Postdoc/Automation/candidates/secchi_cor2_b/2011/01/13/orig*.fits.gz')
fls_c3 = file_search('~/Postdoc/Automation/candidates/20110113/original*fits.gz')

cnta = n_elements(fls_cor2a)
cntb = n_elements(fls_cor2b)
cntlasco = n_elements(fls_c3)

plots_cor2a = file_search('~/Postdoc/Automation/Catalogue/20110113_cor2a/plots*sav')
plots_cor2b = file_search('~/Postdoc/Automation/Catalogue/20110113_cor2b/plots*sav')
plots_c3 = file_search('~/Postdoc/Automation/candidates/20110113/detections_dublin/dets_*.sav')

time_cor2a = yyyymmdd2cal(strmid(file_basename(fls_cor2a),26,12))
date_cor2b = strmid(file_basename(fls_cor2b),9,8)
time_cor2b = strmid(file_basename(fls_cor2b),18,6)
time_cor2b = yyyymmdd2cal(date_cor2b + time_cor2b)
date_c3 = strmid(file_basename(fls_c3),9,8)
time_c3 = strmid(file_basename(fls_c3),18,6)
time_c3 = yyyymmdd2cal(date_c3 + time_c3)

ct = 1
loadct, ct

xs = 1/3.
ys = 1/1.
bglev = 200

for ib=0,cntb-1 do begin & $
;for ib=0,1 do begin & $

	print, 'ib: ', ib, ' of ', cntb

	device, xsize=devxs, ysize=devys, bits=8, language=2, /portrait, /inch, /color, filename=out_dir+'/animation3_'+int2str(ib)+'.eps', /encapsul

	imb = readfits_corimp(fls_cor2b[ib],hdrb) & $
	if ib eq 0 then maxht=hdrb.i4_ht1/hdrb.rsun & $
	get_ht_pa_2d_corimp, hdrb.naxis1, hdrb.naxis2, hdrb.crpix1, hdrb.crpix2, pix_size=hdrb.pix_size/hdrb.rsun, x, y,ht,pa
	fov = where(ht ge 4.5 and ht lt 11.5, comp=nfov)
	imb[nfov] = mean(imb[fov],/nan)
	imb = hist_equal(imb,percent=0.01)
	imb[nfov] = max(imb)
	
	;ind = where(~finite(imb))
	;imb = hist_equal(imb, per=0.5)
	;imb[ind] = bglev
	;imb = congrid(imb, 512, 512, /interp)
	voida = min(abs(anytim2tai(time_cor2b[ib])-anytim2tai(time_cor2a)),inda) & $
	voidl = min(abs(anytim2tai(time_cor2b[ib])-anytim2tai(time_c3)),indlasco) & $
	;print, voida/60, voidl/60
	ima = readfits_corimp(fls_cor2a[inda],hdra) & $
	get_ht_pa_2d_corimp, hdra.naxis1, hdra.naxis2, hdra.crpix1, hdra.crpix2, pix_size=hdra.pix_size/hdra.rsun, x, y,ht,pa
	fov = where(ht ge 3. and ht lt 11., comp=nfov)
	ima[nfov] = mean(ima[fov],/nan)
	ima = hist_equal(ima,percent=0.01)
	ima[nfov] = max(ima)

	;ind = where(~finite(ima))
	;ima = hist_equal(ima,per=0.5)
	;ima[ind] = bglev
	;ima = congrid(ima,512,512,/interp)
	
	imlasco = readfits_corimp(fls_c3[indlasco],hdrlasco) & $
	get_ht_pa_2d_corimp,hdrlasco.naxis1,hdrlasco.naxis2,hdrlasco.crpix1,hdrlasco.crpix2,pix_size=hdrlasco.pix_size/hdrlasco.rsun,x,y,ht,pa
	restore,'~/idl_codes/c3pylonmask.sav'
	c3pylonmask = rot(c3pylonmask,180)
	;c3pylonmask = c3pylonmask[146:877,146:877]
	pylon_inds = where(c3pylonmask eq 0)
	fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
	imlasco[nfov] = mean(imlasco[fov],/nan)
	imlasco = hist_equal(imlasco,percent=0.01)
	imlasco[nfov] = max(imlasco)
	imlasco[pylon_inds] = max(imlasco)

	;ix = where_limits(x,-maxht,maxht,/minmax)
	;iy = where_limits(y,-maxht,maxht,/minmax)
	;imlasco = imlasco[ix[0]:ix[1],iy[0]:iy[1]]
	;ind = where(~finite(imlasco))
	;imlasco = hist_equal(imlasco)
	;imlasco[ind] = bglev
	;imlasco = congrid(imlasco,512,512,/interp)

	contour, imb, xst=5, yst=5, pos=[2/3., 0, 3/3., 1],/norm,/nodata,/noerase & $
	tvscl, imb, 2/3., 0, xsize=xs, ysize=ys, /norm
	;tvcircle, 256./maxht, 256, 256, /data, color=0
	pasun = make_coordinates(360, [0,2*!pi])
	rsun = hdrb.rsun/hdrb.pix_size
	xsun = rsun*sin(pasun)
	ysun = rsun*cos(pasun)
	plots, xsun+512, ysun+512, thick=my_charthick
	xyouts, 10,950,'COR2-B', charsize=my_charsize, charthick=my_charthick
	xyouts, 10, 995, strmid(hdrb.date_obs,0,16), charsize=my_charsize, charthick=my_charthick
	restore, plots_cor2b[ib]
	set_line_color
	circle_sym, 0, /fill
	plots, res[0,*], res[1,*], psym=8, symsize=0.10, color=2
	plots, xf_out, yf_out, psym=1, color=3, symsize=my_charsize, thick=my_charthick
	loadct, ct

	contour, imb, xst=5, yst=5, pos=[1/3., 0, 2/3., 1], /norm, /nodata, /noerase
	tvscl, imlasco, 1/3., 0, xsize=xs, ysize=ys, /norm
	;tvcircle, 256./maxht, 256, 256, /data, color=0
	rsun = hdrlasco.rsun/hdrlasco.pix_size
        xsun = rsun*sin(pasun)
        ysun = rsun*cos(pasun)
        plots, xsun+512, ysun+512, thick=my_charthick
	xyouts, 10,950,'LASCO/C3', charsize=my_charsize, charthick=my_charthick
        xyouts, 10, 995, strmid(hdrlasco.date_obs,0,16), charsize=my_charsize, charthick=my_charthick
	restore, plots_c3[indlasco]
	res = dets.edges
	xf_out = dets.front[0,*]
	yf_out = dets.front[1,*]
	set_line_color
	plots, res[0,*], res[1,*], psym=8, symsize=0.1, color=2
	plots, xf_out, yf_out, psym=1, color=3, symsize=my_charsize, thick=my_charthick
	loadct, ct

	contour, imb, xst=5, yst=5, pos=[0/3., 0, 1/3., 1], /norm, /nodata, /noerase
	tvscl, ima, 0/3., 0, xsize=xs, ysize=ys, /norm & $
	;tvcircle, 256./maxht,256,256,/data,color=0
	rsun = hdra.rsun/hdra.pix_size
        xsun = rsun*sin(pasun)
        ysun = rsun*cos(pasun)
        plots, xsun+512, ysun+512, thick=my_charthick
	xyouts, 10,950,'COR2-A', charsize=my_charsize, charthick=my_charthick
        xyouts, 10, 995, strmid(hdra.date_obs,0,16), charsize=my_charsize, charthick=my_charthick
	restore, plots_cor2a[inda]
	set_line_color
	plots, res[0,*], res[1,*], psym=8, symsize=0.1, color=2
	plots, xf_out, yf_out, psym=1, color=3, symsize=my_charsize, thick=my_charthick
	loadct, ct

;	restore, plots_cor2a[inda] & $
;        set_line_color & $
 ;       plots, res[0,*], res[1,*], psym=3, color=2 & $
;        plots, xf_out, yf_out, psym=1, color=3 & $
 ;       loadct, 0 & $
;        restore, plots_c3[indlasco] & $
;        set_line_color & $
;        plots, res[0,*], res[1,*], psym=3, color=2 & $
;        plots, xf_out, yf_out, psym=1, color=3 & $
;        loadct, 0 & $
;        restore, plots_cor2b[ib] & $
;        set_line_color & $
;        plots, res[0,*], res[1,*], psym=3, color=2 & $
;        plots, xf_out, yf_out, psym=1, color=3 & $
;        pause & $
	
	device, /close_file
	
endfor


end
