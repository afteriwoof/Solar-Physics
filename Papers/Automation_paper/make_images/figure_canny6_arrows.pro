; Code to plot postscript image of canny_atrous of data.

; Created:	11-08-11	;from figure_canny6.pro to show arrows instead of edges.


pro figure_canny6_arrows

;scale
s = 5

my_charsize = 1
my_charthick = 2

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
device, xsize=23.56, ysize=18.14, /cm, /landscape, filename='figure_canny6_arrows.ps'


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

;multmods = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

;multmods = congrid(multmods,732,732)
mods = congrid(modgrad[*,*,s],732,732)
alps = congrid(alpgrad[*,*,s],732,732)


;MOD

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
mods[nfov] = 200

; dimensions are 2356x852
pos = [ 100/2356., 882/1814., 832/2356., 1614/1814. ]

tv, mods, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, mods, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(a)', /norm, charsize=my_charsize, charthick=my_charthick


;ALP

; change alpgrad to be relative to radial direction in image
alps = wrap_n(pa-alps,360)-180

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = 200

pos = [ 852/2356., 882/1814., 1584/2356., 1614/1814. ]

tvscl, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick, $
	ytickname=[' ',' ',' ',' ',' ',' ']

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

;colorbar
loc = [ 852/2356., 1684/1814., 1584/2356., 1744/1814. ]
colorbar, pos=loc, ncolors=255, minrange=0, maxrange=360, /norm, /horizontal, title='Angle (degrees)'

; EDGE

arrow_im = intarr(732,732)
arrow_im[nfov] = mean(arrow_im[fov],/nan)
arrow_im[nfov] = 200

pos = [ 1604/2356., 882/1814., 2336/2356., 1614/1814. ]

tvscl, arrow_im, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, arrow_im, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick, $
	ytickname=[' ',' ',' ',' ',' ',' ']

;for i=0,731,15 do begin
;	for j=0,731,15 do begin
;		if mods[i,j] ne 0 then begin
;			arrow2, i, j, alps[i,j], mods[i,j]/5., /device, /norm, /angle, hsize=5, thick=3, hthick=2, color=100
;		endif
;	endfor
;endfor

readcol, 'arrow_ps.dat',xp0,xp1,yp0,yp1,xxp0,xxp1,yyp0,yyp1,f='F,F,F,F,F,F,F,F'
xp0 = ((xp0-inc2.crpix1)*inc2.pix_size)/inc2.rsun
xp1 = ((xp1-inc2.crpix1)*inc2.pix_size)/inc2.rsun
yp0 = ((yp0-inc2.crpix2)*inc2.pix_size)/inc2.rsun
yp1 = ((yp1-inc2.crpix2)*inc2.pix_size)/inc2.rsun
xxp0 = ((xxp0-inc2.crpix1)*inc2.pix_size)/inc2.rsun
xxp1 = ((xxp1-inc2.crpix1)*inc2.pix_size)/inc2.rsun
yyp0 = ((yyp0-inc2.crpix2)*inc2.pix_size)/inc2.rsun
yyp1 = ((yyp1-inc2.crpix2)*inc2.pix_size)/inc2.rsun

for i=0,n_elements(xp0)-1 do begin
	plots, [xp0[i],xp1[i]],[yp0[i],yp1[i]], color=100
	plots, [xxp0[i],xp1[i],xxp1[i]],[yyp0[i],yp1[i],yyp1[i]], color=100
endfor

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(c)', /norm, charsize=my_charsize, charthick=my_charthick

;goto,jump1
;******* NOW LASCO C3 ********

mreadfits_corimp, fls[51], inc3, dac3

dac3 = reflect_inner_outer(inc3, dac3)

canny_atrous2d, dac3, modgrad, alpgrad, rows=rows, columns=columns

dac3 = dac3[96:1119,96:1119]
modgrad = modgrad[96:1119,96:1119,*]
alpgrad = alpgrad[96:1119,96:1119,*]
rows = rows[96:1119,96:1119,*]
columns = columns[96:1119,96:1119,*]

edges = wtmm(modgrad[*,*,s], rows[*,*,s], columns[*,*,s])

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

multmods = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

; make them smaller so data fills image
multmods = multmods[146:877,146:877]
mods = modgrad[146:877,146:877,s]
alps = alpgrad[146:877,146:877,s]
edges = edges[146:877,146:877]

;MOD

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
mods[nfov] = 200
mods[pylon_inds] = 200

; dimensions are 2356x852
pos = [ 100/2356., 0, 832/2356., 732/1814. ]

tv, mods, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, mods, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(d)', /norm, charsize=my_charsize, charthick=my_charthick

;ALP

; change alpgrad to be relative to radial direction in image
alps = wrap_n(pa-alps,360)-180

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = 200
alps[pylon_inds] = 200

pos = [ 852/2356., 0, 1584/2356., 732/1814. ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        /noerase, charsize=my_charsize, charthick=my_charthick, $
        ytickname=[' ',' ',' ',' ',' ',' ']

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(e)', /norm, charsize=my_charsize, charthick=my_charthick

; EDGE

edges *= multmods
edges = edges^0.1
edges[nfov] = mean(edges[fov],/nan)
edges = hist_equal(edges,percent=1)
edges[nfov] = 200
edges[pylon_inds] = 200

pos = [ 1604/2356., 0, 2336/2356., 732/1814. ]

tvscl, edges, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, edges, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        xtitle='Solar X '+symbol_corimp('rs',/parenth), $
        /noerase, charsize=my_charsize, charthick=my_charthick, $
        ytickname=[' ',' ',' ',' ',' ',' ']

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(f)', /norm, charsize=my_charsize, charthick=my_charthick



jump1:

device, /close_file

set_plot, entry_device

end
