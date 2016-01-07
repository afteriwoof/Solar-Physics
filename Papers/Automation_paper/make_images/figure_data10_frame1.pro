; code to save ps of figure1

;Created:	24-08-11	to make figures of the automated CME detection on the model, and show modgrad, alpgrad and mask = 8 plots.	
;Created:	20120130	from previous figure_data8.pro and figure1.pro combined.

pro figure_data10_frame1

loadct, 13
tvlct, r, g, b, /get
upper_val = 255 
i = 255
r[i]=upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 0.6
my_charthick = 2

posaddx = 0.015
posaddy = 0.020

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
; size is to be 3 rows by 2 columns of images.
; size		x:	0-624-200-624-200		0-624-824-1448-1648
;		y:	0-624-30-624-30-624-30-624	0-624-654-1278-1308-1932-1962-2586
;new		x:	180-624-200-624-200		180-804-1004-1628-1828
;new		y:	180-624-30-624-30-624-30-624-30-624	180-804-834-1458-1488-2112-2142-2766-2796-3420
devxs = 1828.
devys = 3450.
device, xsize=devxs/175., ysize=devys/175., bits=8, language=2, /portrait, /cm, /color, filename='figure_data10_frame1.eps', /encapsul
; 8 bits for colourbar smoothness

;********************************

;scale
s = 5

; C2 DATA

fls=file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls=sort_fls(fls)
mreadfits_corimp, fls[0], inc2, dac2

dac2 = congrid(dac2,732,732)
inc2.naxis1 = 732
inc2.naxis2 = 732
inc2.crpix1 = 366
inc2.crpix2 = 366
inc2.pix_size /= 0.71484375 ;percentage congrid from 1024 to 732
get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
	pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa
fov = where(ht ge 2.25 and ht lt 5.95, comp=nfov)
dac2[nfov] = mean(dac2[fov],/nan)
dac2 = hist_equal(dac2,percent=1)
dac2[nfov] = max(dac2)

pos = [ 180/devxs, 2796/devys, 804/devxs, 3420/devys ]

tv, dac2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize, charthick=my_charthick

; C3 DATA

mreadfits_corimp, fls[1], inc3, dac3

dac3 = dac3[146:877,146:877]
inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ 1004/devxs, 2796/devys, 1628/devxs, 3420/devys ]

fov = where(ht ge 6 and ht lt 20, comp=nfov)
dac3[nfov] = mean(dac3[fov],/nan)
restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)
dac3[pylon_inds] = mean(dac3[fov],/nan)
dac3 = hist_equal(dac3,percent=1)
dac3[nfov] = max(dac3)
dac3[pylon_inds] = max(dac3)

tv, dac3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize, charthick=my_charthick


; MOD & ALPS

fls=file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls=sort_fls(fls)
mreadfits_corimp, fls[0], inc2, dac2

dac2 = reflect_inner_outer(inc2, dac2)

canny_atrous2d, dac2, modgrad, alpgrad, rows=rows, columns=columns

dac2 = dac2[96:1119,96:1119]
modgrad = modgrad[96:1119,96:1119,*]
alpgrad = alpgrad[96:1119,96:1119,*]
rows = rows[96:1119,96:1119,*]
columns = columns[96:1119,96:1119,*]


thr_inner = replicate(2.35,4)
thr_outer = replicate(5.95,4)

for k=0,3 do begin & $
	modgrad[*,*,k+3]=rm_inner_corimp(modgrad[*,*,k+3],inc2,dr_px,thr=thr_inner[k]) & $
	alpgrad[*,*,k+3]=rm_inner_corimp(alpgrad[*,*,k+3],inc2,dr_px,thr=thr_inner[k]) & $
	modgrad[*,*,k+3]=rm_outer_corimp(modgrad[*,*,k+3],inc2,dr_px,thr=thr_outer[k]) & $
	alpgrad[*,*,k+3]=rm_outer_corimp(alpgrad[*,*,k+3],inc2,dr_px,thr=thr_outer[k]) & $
	rows[*,*,k+3] = rm_inner_corimp(rows[*,*,k+3],inc2,dr_px,thr=thr_inner[k]) & $
	rows[*,*,k+3] = rm_outer_corimp(rows[*,*,k+3],inc2,dr_px,thr=thr_outer[k]) & $
	columns[*,*,k+3]=rm_inner_corimp(columns[*,*,k+3],inc2,dr_px,thr=thr_inner[k]) & $
	columns[*,*,k+3]=rm_outer_corimp(columns[*,*,k+3],inc2,dr_px,thr=thr_outer[k]) & $
endfor

mods = congrid(modgrad[*,*,s],732,732)
alps = congrid(alpgrad[*,*,s],732,732)


;C2 MOD

inc2.naxis1 = 732
inc2.naxis2 = 732
inc2.crpix1 = 366
inc2.crpix2 = 366
inc2.pix_size /= 0.71484375 ;percentage congrid from 1024 to 732

get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
        pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
mods[nfov] = mean(mods[fov],/nan)
mods = hist_equal(mods,percent=1)
mods[nfov] = max(mods)

pos = [ 180/devxs, 2142/devys, 804/devxs, 2766/devys ]

tv, mods, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, mods, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(c)', /norm, charsize=my_charsize, charthick=my_charthick


;C2 ALP

; change alpgrad to be relative to radial direction in image
;alps = wrap_n(pa-alps,360)-180

alps = (alps + 270) mod 360

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = max(alps)

pos = [ 180/devxs, 1488/devys, 804/devxs, 2112/devys ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(e)', /norm, charsize=my_charsize, charthick=my_charthick



;******* NOW LASCO C3 ********

mreadfits_corimp, fls[1], inc3, dac3

dac3 = reflect_inner_outer(inc3, dac3)

canny_atrous2d, dac3, modgrad, alpgrad, rows=rows, columns=columns

dac3 = dac3[96:1119,96:1119]
modgrad = modgrad[96:1119,96:1119,*]
alpgrad = alpgrad[96:1119,96:1119,*]
rows = rows[96:1119,96:1119,*]
columns = columns[96:1119,96:1119,*]


thr_inner = replicate(5.95,4)
thr_outer = replicate(19.5,4)

restore, '~/idl_codes/c3pylonmask.sav'

for k=0,3 do begin & $
        modgrad[*,*,k+3]=rm_inner_corimp(modgrad[*,*,k+3],inc3,dr_px,thr=thr_inner[k]) & $
        alpgrad[*,*,k+3]=rm_inner_corimp(alpgrad[*,*,k+3],inc3,dr_px,thr=thr_inner[k]) & $
        modgrad[*,*,k+3]=rm_outer_corimp(modgrad[*,*,k+3],inc3,dr_px,thr=thr_outer[k]) & $
        alpgrad[*,*,k+3]=rm_outer_corimp(alpgrad[*,*,k+3],inc3,dr_px,thr=thr_outer[k]) & $
        rows[*,*,k+3] = rm_inner_corimp(rows[*,*,k+3],inc3,dr_px,thr=thr_inner[k]) & $
        rows[*,*,k+3] = rm_outer_corimp(rows[*,*,k+3],inc3,dr_px,thr=thr_outer[k]) & $
        columns[*,*,k+3]=rm_inner_corimp(columns[*,*,k+3],inc3,dr_px,thr=thr_inner[k]) & $
        columns[*,*,k+3]=rm_outer_corimp(columns[*,*,k+3],inc3,dr_px,thr=thr_outer[k]) & $
	modgrad[*,*,k+3]*=c3pylonmask & $
	alpgrad[*,*,k+3]*=c3pylonmask & $
	rows[*,*,k+3]*=c3pylonmask & $
	columns[*,*,k+3]*=c3pylonmask & $
endfor


; make them smaller so data fills image
mods = modgrad[146:877,146:877,s]
alps = alpgrad[146:877,146:877,s]

;C3 MOD

inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366

get_ht_pa_2d_corimp, inc3.naxis1, inc3.naxis2, inc3.crpix1, inc3.crpix2, $
        pix_size=inc3.pix_size/inc3.rsun, x, y, ht, pa

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
mods[nfov] = mean(mods[fov],/nan)
c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)
mods[pylon_inds] = mean(mods[fov],/nan)
mods = hist_equal(mods,percent=1)
mods[nfov] = max(mods)
mods[pylon_inds] = max(mods)

pos = [ 1004/devxs, 2142/devys, 1628/devxs, 2766/devys ]

tv, mods, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, mods, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtickname=[' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(d)', /norm, charsize=my_charsize, charthick=my_charthick

; C3 ALP

; change alpgrad to be relative to radial direction in image
;alps = wrap_n(pa-alps,360)-180

alps = (alps + 270) mod 360

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = max(alps)
alps[pylon_inds] = max(alps)

pos = [ 1004/devxs, 1488/devys, 1628/devxs, 2112/devys ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(f)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ 1645/devxs, 1488/devys, 1680/devxs, 2112/devys ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=360, /norm, /vertical, $
	title='Angle (degrees)', /right, charthick=my_charthick, charsize=my_charsize


;**************


; C2 MASK

fls = file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls = sort_fls(fls)
mreadfits_corimp, fls[0], inc2
mreadfits_corimp, fls[1], inc3

restore, '~/Postdoc/Automation/Catalogue/temp/CME_mask_201003120006_C2.sav'
cme_maskc2 = cme_mask
restore, '~/Postdoc/Automation/Catalogue/temp/CME_mask_201003120018_C3.sav'
cme_maskc3 = cme_mask
delvarx, cme_mask
;	restore, 'cme_mask_dyn_3_c2.sav' ;mask is rois only > 3
;	restore, 'cme_mask_dyn_1_c3.sav' ;mask is rois only > 1

cme_maskc2 = congrid(cme_maskc2, 732, 732)
cme_maskc3 = cme_maskc3[146:877,146:877]

inc2.naxis1 = 732
inc2.naxis2 = 732
inc2.crpix1 = 366
inc2.crpix2 = 366
inc2.pix_size /= 0.71484375 ;percentage congrid from 1024 to 732
get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
        pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa
fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
cme_maskc2[nfov] = 15 ;15 being the max of pmm of both the C2 and C3 cme_masks
;scale pixels between 0 and 254
cme_maskc2 = (float(hist_equal(cme_maskc2>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
;cme_maskc2[nfov] = mean(cme_maskc2[fov],/nan)
cme_maskc2[nfov] = upper_val
;cme_maskc2 = hist_equal(cme_maskc2,percent=1)
;upper_val = 15 ; this is from the pmm of cme_maskc2 and cme_maskc3 is the same.
;cme_maskc2[nfov] = upper_val

pos = [ 180/devxs, 834/devys, 804/devxs, 1458/devys ]

tvlct, r, g, b
tvscl, cme_maskc2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm
loadct, 0
contour, cme_maskc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(g)', /norm, charsize=my_charsize, charthick=my_charthick

; C3 MASK

inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ 1004/devxs, 834/devys, 1628/devxs, 1458/devys ]

fov = where(ht ge 6 and ht lt 20, comp=nfov)
cme_maskc3 = (float(hist_equal(cme_maskc3>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
cme_maskc3[nfov] = upper_val
restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)
cme_maskc3[pylon_inds] = upper_val
;cme_maskc3 = hist_equal(cme_maskc3,percent=1)

tvlct, r, g, b
tvscl, cme_maskc3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm
;loadct, 0
contour, cme_maskc3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtickname=[' ',' ',' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(h)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar  
loc = [ 1645/devxs, 834/devys, 1680/devxs, 1458/devys ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=15, /norm, /vertical, /right, $
	title='Detection mask pixel values', charthick=my_charthick, charsize=my_charsize


; C2 DETECTIONS

loadct, 0

fls = file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls = sort_fls(fls)
mreadfits_corimp, fls[21], inc2
mreadfits_corimp, fls[51], inc3

; restores in, da, res, xf_out, yf_out
restore, '~/Postdoc/Automation/Catalogue/temp/plots_201003120006_C2.sav'
cme_detectionc2 = congrid(da, 732, 732)
inc2 = in

inc2.naxis1 = 732
inc2.naxis2 = 732
inc2.crpix1 = 366
inc2.crpix2 = 366
inc2.pix_size /= 0.71484375 ;percentage congrid from 1024 to 732

; transform the coordinates to solar radii
res[0,*] -= inc2.xcen
res[1,*] -= inc2.ycen
xf_out -= inc2.xcen
yf_out -= inc2.ycen
res[0,*] *= inc2.cdelt1
res[1,*] *= inc2.cdelt2
xf_out *= inc2.cdelt1
yf_out *= inc2.cdelt2
res /= inc2.rsun
xf_out /= inc2.rsun
yf_out /= inc2.rsun


get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
        pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa
fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)

cme_detectionc2[nfov] = mean(cme_detectionc2[fov],/nan)
;cme_maskc2 = hist_equal(cme_maskc2,percent=1)
cme_detectionc2[nfov] = max(cme_detectionc2)

pos = [ 180/devxs, 180/devys, 804/devxs, 804/devys ]

tvscl, cme_detectionc2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_detectionc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

circle_sym, 0, /fill
set_line_color
plots, res[0,*], res[1,*], psym=8, color=2, symsize=0.03
pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(i)', /norm, charsize=my_charsize, charthick=my_charthick


; C3 DETECTIONS

restore, '~/Postdoc/Automation/Catalogue/temp/plots_201003120018_C3.sav'
cme_detectionc3 = da[146:877, 146:877]
inc3 = in

inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366

; transform the coordinates to solar radii
res[0,*] -= inc3.xcen
res[1,*] -= inc3.ycen
xf_out -= inc3.xcen
yf_out -= inc3.ycen
res[0,*] *= inc3.cdelt1
res[1,*] *= inc3.cdelt2
xf_out *= inc3.cdelt1
yf_out *= inc3.cdelt2
res /= inc3.rsun
xf_out /= inc3.rsun
yf_out /= inc3.rsun

get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ 1004/devxs, 180/devys, 1628/devxs, 804/devys ]

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
cme_detectionc3[nfov] = mean(cme_detectionc3[fov],/nan)
restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)
cme_detectionc3[pylon_inds] = mean(cme_detectionc3[fov],/nan)
;cme_detectionc3 = hist_equal(cme_detectionc3,percent=1)
cme_detectionc3[nfov] = max(cme_detectionc3)
cme_detectionc3[pylon_inds] = max(cme_detectionc3)

tvscl, cme_detectionc3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_detectionc3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, res[0,*], res[1,*], psym=8, color=2, symsize=0.03
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(j)', /norm, charsize=my_charsize, charthick=my_charthick



;********************************


device, /close_file

set_plot, entry_device


end
