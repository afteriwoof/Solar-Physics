; Code to plot postscript image of canny_atrous of data.

; Created:	05-08-11	


pro figure_canny

;scale
s = 5

my_charsize = 1
my_charthick = 2

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
device, xsize=23.56, ysize=8.52, /cm, /landscape, filename='figure_canny.ps'


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

edges = wtmm(modgrad[*,*,s], rows[*,*,s], columns[*,*,s])

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

multmods = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

multmods = congrid(multmods,732,732)
mods = congrid(modgrad[*,*,s],732,732)
alps = congrid(alpgrad[*,*,s],732,732)
edges = congrid(edges,732,732)


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
pos = [ 100/2356., 100/852., 832/2356., 832/852. ]

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

alps[nfov] = mean(alps[fov],/nan)
alps = hist_equal(alps,percent=1)
alps[nfov] = 200

pos = [ 852/2356., 100/852., 1584/2356., 832/852. ]

tv, alps, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, alps, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick, $
	ytickname=[' ',' ',' ',' ',' ',' ']

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(b)', /norm, charsize=my_charsize, charthick=my_charthick


; EDGE

edges *= multmods
edges = edges^0.1
edges[nfov] = mean(edges[fov],/nan)
edges = hist_equal(edges,percent=1)
edges[nfov] = 200

pos = [ 1604/2356., 100/852., 2336/2356., 832/852. ]

tvscl, edges, pos[0], pos[1], xsize=pos[2]-pos[0], ysize=pos[3]-pos[1], /norm

contour, edges, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xtitle='Solar X '+symbol_corimp('rs',/parenth), $
	/noerase, charsize=my_charsize, charthick=my_charthick, $
	ytickname=[' ',' ',' ',' ',' ',' ']

plots, xsun, ysun, thick=2

xyouts, pos[0]+0.01, pos[3]-0.04, '(c)', /norm, charsize=my_charsize, charthick=my_charthick


device, /close_file

set_plot, entry_device

end
