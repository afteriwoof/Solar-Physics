; code to save ps of figure1

;Created:	18-08-11	from figure_model6.pro but now for other model CMEs in multicme_model/.


pro figure_model6_2

loadct, 13
tvlct, r, g, b, /get
upper_val = 255
i = 255
r[i]=upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 0.8
my_charthick = 2

posaddx = 0.015
posaddy = 0.035

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
; size is to be 3 rows by 2 columns of images.
; size		x:	0-624-200-624-200	0-624-824-1448-1648
;		y:	0-624-30-624-30-624	0-624-654-1278-1308-1932
;device, xsize=16.48, ysize=19.32, /cm, /color, filename='figure_model6.ps'
device, xs=11.536, ys=13.524, bits=8, language=2, /cm, /color, filename='figure_model6_2.ps'

;C2 IMAGE

fls = file_search('~/Postdoc/Automation/Test/multicme_model/*cme*')
;fls=sort_fls(fls)

mreadfits_corimp, fls[34], inc2, dac2


restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501180843_C2_1.sav'
res1 = res
delvarx, res

; changing the edge detected structure to be in relevant coords in smaller image frame.
res1 = ((res1-inc2.crpix1)*inc2.pix_size) / inc2.rsun

dac2 = congrid(dac2,624,624)
inc2.naxis1 = 624
inc2.naxis2 = 624
inc2.crpix1 = 312
inc2.crpix2 = 312
inc2.pix_size /= 0.609375 ;percentage congrid from 1024 to 732
get_ht_pa_2d_corimp, inc2.naxis1, inc2.naxis2, inc2.crpix1, inc2.crpix2, $
	pix_size=inc2.pix_size/inc2.rsun, x, y, ht, pa
fov = where(ht ge 2.35 and ht lt 5.7, comp=nfov)
dac2[nfov] = mean(dac2[fov],/nan)
dac2 = hist_equal(dac2,percent=0.1)
dac2[nfov] = max(dac2)

pos = [ 0, 1308/1932., 624/1648., 1 ]

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

;C2 MASK

restore, 'cme_mask_model_c2_2.sav';/ver = cme_mask
pmm,cme_mask
cme_mask = congrid(cme_mask, 624, 624)
cme_mask[nfov] = 10 ;10 being the max of pmm of both the C2 and C3 cme_mask
cme_mask = (float(hist_equal(cme_mask>0,per=1,omin=mn,omax=mx))*254/255.)
cme_mask[nfov] = upper_val

pos = [ 0, 654/1932., 624/1648., 1278/1932. ]

tvlct, r, g, b

tv, cme_mask, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

loadct, 0

contour, cme_mask, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtickname=[' ',' ',' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize, charthick=my_charthick


; Detections

pos = [ 0, 0, 624/1648., 624/1932. ]

tv, dac2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res1[0,*], res1[1,*], psym=8, symsize=0.05, color=2

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(c)', /norm, charsize=my_charsize, charthick=my_charthick



; C3 IMAGE

restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501181214_c3_1.sav'
res1 = res
restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501181214_c3_2.sav'
res2 = res
restore, '~/Postdoc/Automation/Automation_paper/make_images/plots_model_200501181214_c3_3.sav'
res3 = res
delvarx, res

mreadfits_corimp, fls[49], inc3, dac3

; changing the edge detected structure to be in relevant coords in smaller image frame.
res1 = ((res1-inc3.crpix1)*inc3.pix_size) / inc3.rsun
res2 = ((res2-inc3.crpix1)*inc3.pix_size) / inc3.rsun
res3 = ((res3-inc3.crpix1)*inc3.pix_size) / inc3.rsun

dac3 = dac3[200:823,200:823]
inc3.naxis1 = 624
inc3.naxis2 = 624
inc3.crpix1 = 312
inc3.crpix2 = 312
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa

pos = [ 824/1648., 1308/1932., 1448/1648., 1 ]

fov = where(ht ge 5.95 and ht lt 16, comp=nfov)
dac3[nfov] = mean(dac3[fov],/nan)
restore,'~/idl_codes/c3pylonmask.sav'
c3pylonmask = c3pylonmask[200:823,200:823]
pylon_inds = where(c3pylonmask eq 0)
dac3[pylon_inds] = mean(dac3[fov],/nan)
dac3 = hist_equal(dac3,percent=.1)
dac3[nfov] = max(dac3)
dac3[pylon_inds] = max(dac3)

loadct, 0

tv, dac3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(d)', /norm, charsize=my_charsize, charthick=my_charthick

; C3 MASK

pos = [ 824/1648., 654/1932., 1448/1648., 1278/1932. ]

restore, 'cme_mask_model_c3_2.sav';/ver = cme_mask
pmm, cme_mask
cme_mask = cme_mask[200:823,200:823]
cme_mask = (float(hist_equal(cme_mask>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
cme_mask[nfov] = upper_val 
cme_mask[pylon_inds] = upper_val

tvlct, r, g, b

tv, cme_mask, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(e)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ 1460/1648., 654/1932., 1500/1648., 1278/1932. ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=10, /norm, /vertical, /right, $
	title='Detection mask pixel values', charsize=my_charsize, charthick=my_charthick

;C3 detections

loadct, 0

pos = [ 824/1648., 0, 1448/1648., 624/1932. ]

tv, dac3, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac3, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
plots, res1[0,*], res1[1,*], psym=8, symsize=0.05, color=2
plots, res2[0,*], res2[1,*], psym=8, symsize=0.05, color=2
plots, res3[0,*], res3[1,*], psym=8, symsize=0.05, color=2

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(f)', /norm, charsize=my_charsize, charthick=my_charthick

device, /close_file

set_plot, entry_device

end
