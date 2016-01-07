; code to save ps of figure1

;Created:	05-08-11	

pro figure1

my_charsize = 1
my_charthick = 3

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
device, xsize=19.64, ysize=10.32, bits=8, language=2, /cm, filename='figure1.ps'



;C2 IMAGE


fls=file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls=sort_fls(fls)
mreadfits_corimp, fls[21], inc2, dac2

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

pos = [ 200/1964., 200/1032., 932/1964., 932/1032. ]
;pos = [0.10183299,0.19379845,0.47454175,0.90310078]

tv, dac2, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, dac2, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.05, '(a)', /norm, charsize=my_charsize, charthick=my_charthick



; C3 IMAGE

mreadfits_corimp, fls[51], inc3, dac3

dac3 = dac3[146:877,146:877]
inc3.naxis1 = 732
inc3.naxis2 = 732
inc3.crpix1 = 366
inc3.crpix2 = 366
get_ht_pa_2d_corimp,inc3.naxis1,inc3.naxis2,inc3.crpix1,inc3.crpix2,pix_size=inc3.pix_size/inc3.rsun,x,y,ht,pa
pos = [ 1132/1964., 200/1032., 1864/1964., 932/1032. ]
;pos = [0.57637475,0.19379845,0.9490835,0.90310078]
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
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.05, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

device, /close_file

set_plot, entry_device

end
