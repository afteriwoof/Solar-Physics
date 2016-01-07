; code to save ps of figure1

;Created:	24-08-11	to make figures of the automated CME detection on the model, and show modgrad, alpgrad and mask = 8 plots.	

pro figure_model8

loadct, 13
tvlct, r, g, b, /get
upper_val = 255 
i = 255
r[i]=upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 0.6
my_charthick = 2

posaddx = 0.015
posaddy = 0.025

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
; size is to be 3 rows by 2 columns of images.
; size		x:	180-624-120-624-200		180-804-924-1548-1748
;		y:	180-624-30-624-30-624-30-624	180-804-834-1458-1488-2112-2142-2766-2796
devxs = 1800.
devys = 2796.
device, xsize=devxs/175., ysize=devys/175., /encapsul, bits=8, language=2, /portrait, /cm, /color, filename='figure_model8.eps'

pos_x = [180,804,924,1548,1748] / devxs
pos_y = [2766,2142,2112,1488,1458,834,804,180] / devys

;C2 IMAGE

fls = file_search('~/Postdoc/Automation/Test/multicme_model/*cme*')
;fls=sort_fls(fls)

mreadfits_corimp, fls[4], inc2, dac2


restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501180110_C2_1.sav'
res1 = res
restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501180110_C2_2.sav'
res2 = res
delvarx, res

; changing the edge detected structure to be in relevant coords in smaller image frame.
res1 = ((res1-inc2.crpix1)*inc2.pix_size) / inc2.rsun
res2 = ((res2-inc2.crpix1) * inc2.pix_size) / inc2.rsun

; C2 MOD

dafc2 = reflect_inner_outer(inc2, dac2, /model)
canny_atrous2d, dafc2, modgradc2, alpgradc2
delvarx, dafc2
modgradc2 = modgradc2[96:1119,96:1119,4]
modgradc2 = congrid(modgradc2,624,624)

inc2.naxis1 = 624
inc2.naxis2 = 624
inc2.crpix1 = 312
inc2.crpix2 = 312
inc2.pix_size /= 0.609375 ;percentage congrid from 1024 to 732

get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
	pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.7, comp=nfov)
modgradc2[nfov] = mean(modgradc2[fov],/nan)
modgradc2 = hist_equal(modgradc2,percent=0.01)
modgradc2[nfov] = max(modgradc2)

pos = [ pos_x[0], pos_y[1], pos_x[1], pos_y[0] ]

tv, modgradc2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, modgradc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize, charthick=my_charthick

;C2 ALP

alpgradc2 = alpgradc2[96:1119,96:1119,4]
alpgradc2 = congrid(alpgradc2,624,624)

alpgradc2 = (alpgradc2 + 270) mod 360

alpgradc2[nfov] = mean(alpgradc2[fov],/nan)
alpgradc2 = hist_equal(alpgradc2, percent=1)
alpgradc2[nfov] = max(alpgradc2)

pos = [ pos_x[0], pos_y[3], pos_x[1], pos_y[2] ]

tv, alpgradc2, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, alpgradc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
	ytitle = 'Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(c)', /norm, charsize=my_charsize, charthick=my_charthick


;C2 MASK

restore, 'cme_mask_model_c2_1.sav';/ver = cme_mask
cme_mask = congrid(cme_mask, 624, 624)
cme_mask[nfov] = 24 ;24 being the max value of pmm of both C2 and C3 cme_masks
cme_mask = (float(hist_equal(cme_mask>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
cme_mask[nfov] = 255

pos = [ pos_x[0], pos_y[5], pos_x[1], pos_y[4] ]

tvlct, r, g, b

tv, cme_mask, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

loadct, 0

contour, cme_mask, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(e)', /norm, charsize=my_charsize, charthick=my_charthick


; C2 Detections

dac2 = congrid(dac2, 624, 624)
dac2 = hist_equal(dac2,percent=0.01)
dac2[nfov] = max(dac2)

pos = [ pos_x[0], pos_y[7], pos_x[1], pos_y[6] ]

tv, dac2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res1[0,*], res1[1,*], psym=8, symsize=0.05, color=2

plots, res2[0,*], res2[1,*], psym=8, symsize=0.05, color=2

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(g)', /norm, charsize=my_charsize, charthick=my_charthick



; C3 IMAGE

restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501180411_C3_1.sav'
res1 = res
restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501180411_C3_2.sav'
res2 = res
delvarx, res

mreadfits_corimp, fls[17], inc3, dac3

; changing the edge detected structure to be in relevant coords in smaller image frame.
res1 = ((res1-inc3.crpix1)*inc3.pix_size) / inc3.rsun
res2 = ((res2-inc3.crpix1)*inc3.pix_size) / inc3.rsun

;C3 MOD

dafc3 = reflect_inner_outer(inc3, dac3, /model)
canny_atrous2d, dafc3, modgradc3, alpgradc3
delvarx, dafc3
modgradc3 = modgradc3[96:1119,96:1119,4]
modgradc3 = modgradc3[200:823,200:823]

restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[200:823,200:823]
pylon_inds = where(c3pylonmask eq 0)

inc3.naxis1 = 624
inc3.naxis2 = 624
inc3.crpix1 = 312
inc3.crpix2 = 312
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ pos_x[2], pos_y[1], pos_x[3], pos_y[0] ]

fov = where(ht ge 5.95 and ht lt 16, comp=nfov)
modgradc3[nfov] = mean(modgradc3[fov],/nan)
modgradc3 = hist_equal(modgradc3,percent=0.01)
modgradc3[nfov] = max(modgradc3)
modgradc3[pylon_inds] = max(modgradc3)

loadct, 0

tv, modgradc3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, modgradc3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
        xtickname=[' ',' ',' ',' ',' ',' ',' ',' '], $
	;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

;C3 ALP

alpgradc3 = alpgradc3[96:1119,96:1119,4]
alpgradc3 = alpgradc3[200:823,200:823]

alpgradc3 = (alpgradc3 + 270) mod 360

alpgradc3[nfov] = mean(alpgradc3[fov],/nan)
alpgradc3 = hist_equal(alpgradc3, percent=1)
alpgradc3[nfov] = max(alpgradc3)
alpgradc3[pylon_inds] = max(alpgradc3)


pos = [ pos_x[2], pos_y[3], pos_x[3], pos_y[2] ]

tv, alpgradc3, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, alpgradc3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
        xtickname=[' ',' ',' ',' ',' ',' ',' '], $
        ;ytitle = 'Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(d)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ pos_x[4]-0.1, pos_y[3], pos_x[4]-0.075, pos_y[2] ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=360, /norm, /vertical, /right, $
        title='Angle (deg.)', charsize=my_charsize, charthick=my_charthick


; C3 MASK

pos = [ pos_x[2], pos_y[5], pos_x[3], pos_y[4] ]

restore, 'cme_mask_model_c3_1.sav';/ver = cme_mask
cme_mask = cme_mask[200:823,200:823]
cme_mask = (float(hist_equal(cme_mask>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
cme_mask[nfov] = upper_val 
cme_mask[pylon_inds] = upper_val

tvlct, r, g, b

tv, cme_mask, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_mask, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
        xtickname=[' ',' ',' ',' ',' ',' ',' ',' '], $
	;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.015, pos[3]-0.025, '(f)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ pos_x[4]-0.1, pos_y[5], pos_x[4]-0.075, pos_y[4] ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=24, /norm, /vertical, /right, $
	title='Detection mask pixel values', charsize=my_charsize, charthick=my_charthick

;C3 detections

loadct, 0

dac3 = dac3[200:823,200:823]
dac3[nfov] = mean(dac3[fov],/nan)
dac3[pylon_inds] = mean(dac3[fov],/nan)
dac3 = hist_equal(dac3,percent=.1)
dac3[nfov] = max(dac3)
dac3[pylon_inds] = max(dac3)

pos = [ pos_x[2], pos_y[7], pos_x[3], pos_y[6] ]

tv, dac3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	yr=[round(min(y)),round(max(y))], xr=[round(min(x)),round(max(x))], $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
plots, res1[0,*], res1[1,*], psym=8, symsize=0.05, color=2
plots, res2[0,*], res2[1,*], psym=8, symsize=0.05, color=2

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(h)', /norm, charsize=my_charsize, charthick=my_charthick

device, /close_file

set_plot, entry_device

end
