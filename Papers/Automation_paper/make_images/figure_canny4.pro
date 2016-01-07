; Code to plot postscript image of canny_atrous of data.

; Created:	08-08-11	;from figure_canny.pro but for 6 figures, 3 of each C2 and C3.


pro figure_canny4

loadct, 0

;scale
s = 5

my_charsize = 1
my_charthick = 3

posaddx = 0.010
posaddy = 0.035

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
; size/spacing is 	x:100-732-200-732-200		0-100-832-1032-1764-1964
;			y:100-732-20-732		0-100-832-852-1584

devxs = 1964.
devys = 1584.
device, xsize=devxs/100., ysize=devys/100., bits=8, /cm, /landscape, filename='figure_canny4.ps', language=2
; 8 bits for colourbar smoothness


fls=file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls=sort_fls(fls)
mreadfits_corimp, fls[21], inc2, dac2

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

pos = [ 100/devxs, 852/devys, 832/devxs, 1584/devys ]

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

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize, charthick=my_charthick


;C2 ALP

; change alpgrad to be relative to radial direction in image
;alps = wrap_n(pa-alps,360)-180

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = max(alps)

pos = [ 100/devxs, 100/devys, 832/devxs, 832/devys ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(c)', /norm, charsize=my_charsize, charthick=my_charthick



;******* NOW LASCO C3 ********

mreadfits_corimp, fls[51], inc3, dac3

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
 
pos = [ 1032/devxs, 852/devys, 1764/devxs, 1584/devys ]

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

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

;ALP

; change alpgrad to be relative to radial direction in image
;alps = wrap_n(pa-alps,360)-180

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = max(alps)
alps[pylon_inds] = max(alps)
 
pos = [ 1032/devxs, 100/devys, 1764/devxs, 832/devys ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        /noerase, charsize=my_charsize, charthick=my_charthick

plots, xsun, ysun, thick=2

xyouts, pos[0]+posaddx, pos[3]-posaddy, '(d)', /norm, charsize=my_charsize, charthick=my_charthick

loc = [ 1800/devxs, 100/devys, 1840/devxs, 832/devys ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=360, /norm, /vertical, $
	title='Angle (degrees)', /right, charthick=my_charthick


device, /close_file

set_plot, entry_device

end
