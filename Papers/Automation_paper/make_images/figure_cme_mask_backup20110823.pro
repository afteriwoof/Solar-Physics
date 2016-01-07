; Code to plot postscript image of canny_atrous of data.

; Created:	08-08-11	;from figure_canny6.pro but for cme_mask.
;		18-08-11	to put colorbar at the size and same scale for both images.

pro figure_cme_mask

loadct, 39

my_charsize = 1
my_charthick = 2

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
;size		0-732-200-732-200		0-732-932-1664-1864
;		0-732				0-732
device, xsize=18.64, ysize=7.32, bits=8, language=2, /cm, /landscape, /color, filename='figure_cme_mask.ps'

fls = file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls = sort_fls(fls)
mreadfits_corimp, fls[21], inc2
mreadfits_corimp, fls[51], inc3

restore, 'cme_maskc2.sav'
cme_maskc2 = cme_mask
restore, 'cme_maskc3.sav'
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

cme_maskc2[nfov] = mean(cme_maskc2[fov],/nan)
;cme_maskc2 = hist_equal(cme_maskc2,percent=1)
upper_val = 15 ; this is from the pmm of cme_maskc2 and cme_maskc3 is the same.
cme_maskc2[nfov] = upper_val

pos = [ 0, 0, 732/1864., 1 ]

tvscl, cme_maskc2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_maskc2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.07, '(a)', /norm, charsize=my_charsize, charthick=my_charthick

; C3 IMAGE

inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ 932/1864., 0, 1664/1864., 1 ]

fov = where(ht ge 6 and ht lt 20, comp=nfov)
cme_maskc3[nfov] = mean(cme_maskc3[fov],/nan)
restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)
cme_maskc3[pylon_inds] = mean(cme_maskc3[fov],/nan)
;cme_maskc3 = hist_equal(cme_maskc3,percent=1)
cme_maskc3[nfov] = upper_val
cme_maskc3[pylon_inds] = upper_val

tvscl, cme_maskc3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, cme_maskc3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.07, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ 1700/1864., 0, 1760/1864., 1 ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=upper_val, /norm, /vertical, /right, title='Detection mask pixel values'


device, /close_file

set_plot, entry_device


end
