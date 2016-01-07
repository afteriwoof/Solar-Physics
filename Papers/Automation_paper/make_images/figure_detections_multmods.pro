; Code to plot postscript image of canny_atrous of data.

; Created:	19-08-11	;from figure_detections.pro

pro figure_detections_multmods

my_charsize = 1
my_charthick = 2

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
device, xsize=19.64, ysize=11.32, /cm, /landscape, /color, filename='figure_detections.ps'

fls = file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls = sort_fls(fls)
mreadfits_corimp, fls[21], inc2, dac2
mreadfits_corimp, fls[51], inc3, dac3

dac2 = reflect_inner_outer(inc2, dac2)
canny_atrous2d, dac2, modgrad

dac2 = dac2[96:1119,96:1119]
modgrad = modgrad[96:1119,96:1119,*]

multmodsc2 = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

canny_atrous2d, dac3, modgrad
multmodsc2 = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

; restores in, da, res, xf_out, yf_out
restore, 'plots_201003120506__C2.sav'
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

pos = [ 200/1964., 200/1132., 932/1964., 932/1132. ]

tvscl, cme_detectionc2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_detectionc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

circle_sym, 0, /fill
set_line_color
plots, res[0,*], res[1,*], psym=8, color=2, symsize=0.05
pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.05, '(a)', /norm, charsize=my_charsize, charthick=my_charthick


; C3 IMAGE

restore, 'plots_201003121142__C3.sav'
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
pos = [ 1132/1964., 200/1132., 1864/1964., 932/1132. ]
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

plots, res[0,*], res[1,*], psym=8, color=2, symsize=0.05
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.05, '(b)', /norm, charsize=my_charsize, charthick=my_charthick



device, /close_file

set_plot, entry_device


end
