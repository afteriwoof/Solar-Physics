; code to save ps of figures from sample of events to put in proposal

;Created:	12-09-11	to make figures of the automated CME detection on the sample (four) events for proposal.
;Created	20120314	from figure_events_proposal_orig.pro
;Created	20120315	from figure_events.pro to work on the latest version of gail processed data.


pro figure_events_latest, ang_widths=ang_widths


!p.multi=[4,3,4]

my_charsize = 1
my_charthick = 2

posaddx = 0.015
posaddy = 0.025

; current device
entry_device = !d.name

; set to postscript
set_plot,'ps'

; define drawable space and filename
; size is to be 4 rows by 3 columns of images.
; size		x:	180-624-100-624-150-750-150		180-804-904-1528-1678-2428-2578
;		y:	180-624-130-624-130-624-130-624-150	180-804-934-1558-1688-2312-2442-3066-3216
devxs = 2678.
devys = 3216.
device, xsize=devxs/200., ysize=devys/200., /encapsul, bits=8, language=2, /portrait, /cm, /color, filename='figure_events_latest.eps'
pos_x = [804,904,1528,1678,2428]
pos_y = [2442,2312,1688,1558,934,804]


;C2 IMAGE 1

loadct, 0

restore, '~/Postdoc/Automation/candidates/20000102/detections_dublin/dets_20000102_073120_C2.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000102/original_20000102_073120_c2_soho.fits.gz')
da = readfits_corimp(fl, in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ 180/devxs, pos_y[0]/devys, pos_x[0]/devxs, 3066/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        title='LASCO/C2', $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
	restore, '~/Postdoc/Automation/candidates/20000102/detections_dublin/all_h0.sav'
	a_min = (min(pos_angles) + 90) mod 360
	a_max = (max(pos_angles) + 90) mod 360
	r = 6.
	polrec, [r,r], [a_min,a_max], x, y, /degrees
	plots, [0,x[0]], [0,y[0]], psym=-3, line=1
	plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif
;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; C3 IMAGE 1

loadct, 0

restore, '~/Postdoc/Automation/candidates/20000102/detections_dublin/dets_20000102_101806_C3.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000102/original_20000102_101806_c3_soho.fits.gz')
da = readfits_corimp(fl, in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

;da = da[146:877,146:877]
;in.naxis1 = 732
;in.naxis2 = 732
;in.crpix1 = 366
;in.crpix2 = 366

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res[0,*] -= in.xcen
res[1,*] -= in.ycen
res[0,*] *= in.cdelt1
res[1,*] *= in.cdelt2
res /= in.rsun
xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

restore,'~/idl_codes/c3pylonmask.sav'
;c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)
da[pylon_inds] = max(da)

pos = [ pos_x[1]/devxs, pos_y[0]/devys, pos_x[2]/devxs, 3066/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' '], $
        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	title='LASCO/C3', $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color

plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
        restore, '~/Postdoc/Automation/candidates/20000102/detections_dublin/all_h0.sav'
        a_min = (min(pos_angles) + 90) mod 360
        a_max = (max(pos_angles) + 90) mod 360
        r = 20.
        polrec, [r,r], [a_min,a_max], x, y, /degrees
        plots, [0,x[0]], [0,y[0]], psym=-3, line=1
        plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; KINS 1

loadct, 13

restore, '~/Postdoc/Automation/candidates/20000102/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/20000102/dyn*fits.gz')
;fls = sort_fls(fls)
mreadfits_corimp, fls, in

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.955e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[3]/devxs, pos_y[0]/devys, pos_x[4]/devxs, 3066/devys ]

xls = (anytim(time[0]))-utbasedata + 20000
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 12000

;utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm x10!U4!N)', pos=pos, $
;	xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, $
;	ytickname=['0','0.5','1.0','1.5'], tit='HEIGHT-TIME PROFILE'
utplot, t, (heights_km/6.955e5), utbasedata, psym=1, ytit='Height (R!D!9n!N!X)', pos=pos, $
       xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, $
       tit='HEIGHT-TIME PROFILE'

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/6.955e5, symsize=0.3, thick=1.5, $
                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
                ;color=((i+abs(min(pos_angles)))*255./(abs(max(pos_angles)-min(pos_angles)))), psym=1
		color = (i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
endfor

horline, 2.35, linestyle=1
horline, 5.95, linestyle=1
horline, 19.5, linestyle=1

;colorbar

pos = [ (pos_x[4]+20)/devxs, pos_y[0]/devys, (pos_x[4]+50)/devxs, 3066/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick


;C2 IMAGE 2

loadct, 0

restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/dets_20000418_165405_C2.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000418-19/original_20000418_165405_c2_soho.fits.gz')
da = readfits_corimp(fl, in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ 180/devxs, pos_y[2]/devys, pos_x[0]/devxs, pos_y[1]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
	restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/all_h0.sav'
	a_min = (min(pos_angles) + 90) mod 360
	a_max = (max(pos_angles) + 90) mod 360
	r = 6.
	polrec, [r,r], [a_min,a_max], x, y, /degrees
	plots, [0,x[0]], [0,y[0]], psym=-3, line=1
	plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; C3 IMAGE 2

loadct, 0

;restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/dets_20000418_194206_C3.sav'
;fl=file_Search('~/Postdoc/Automation/candidates/20000418-19/original_20000418_194206_c3_soho.fits.gz')
restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/dets_20000418_221809_C3.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000418-19/original_20000418_221809_c3_soho.fits.gz')

da = readfits_corimp(fl,in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

;da = da[146:877,146:877]
;in.naxis1 = 732
;in.naxis2 = 732
;in.crpix1 = 366
;in.crpix2 = 366

res[0,*] -= in.xcen
res[1,*] -= in.ycen
res[0,*] *= in.cdelt1
res[1,*] *= in.cdelt2
res /= in.rsun
xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

restore,'~/idl_codes/c3pylonmask.sav'
;c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)
da[pylon_inds] = max(da)

pos = [ pos_x[1]/devxs, pos_y[2]/devys, pos_x[2]/devxs, pos_y[1]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color

plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
        restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/all_h0.sav'
        a_min = (min(pos_angles) + 90) mod 360
        a_max = (max(pos_angles) + 90) mod 360
        r = 20.
        polrec, [r,r], [a_min,a_max], x, y, /degrees
        plots, [0,x[0]], [0,y[0]], psym=-3, line=1
        plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; KINS 2

loadct, 13

restore, '~/Postdoc/Automation/candidates/20000418-19/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/20000418-19/dyn*fits.gz')
;fls = sort_fls(fls)
mreadfits_corimp, fls, in

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.955e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[3]/devxs, pos_y[2]/devys, pos_x[4]/devxs, pos_y[1]/devys ]

xls = (anytim(time[0]))-utbasedata + 13000
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 11000

utplot, t, (heights_km/6.955e5), utbasedata, psym=1, ytit='Height (R!D!9n!N!X)', pos=pos, $
        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/6.955e5, symsize=0.3, thick=1.5, $
                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
		color=(i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
endfor

horline, 2.35, linestyle=1
horline, 5.95, linestyle=1
horline, 19.5, linestyle=1

;colorbar

pos = [ (pos_x[4]+20)/devxs, pos_y[2]/devys, (pos_x[4]+50)/devxs, pos_y[1]/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick


;C2 IMAGE 3

loadct, 0

restore, '~/Postdoc/Automation/candidates/20000423/detections_dublin/dets_20000423_125405_C2.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000423/original_20000423_125405_c2_soho.fits.gz')
da = readfits_corimp(fl, in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ 180/devxs, pos_y[4]/devys, pos_x[0]/devxs, pos_y[3]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
	restore, '~/Postdoc/Automation/candidates/20000423/detections_dublin/all_h0.sav'
	a_min = (min(pos_angles) + 90) mod 360
	a_max = (max(pos_angles) + 90) mod 360
	r = 6.
	polrec, [r,r], [a_min,a_max], x, y, /degrees
	plots, [0,x[0]], [0,y[0]], psym=-3, line=1
	plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; C3 IMAGE 3

loadct, 0

restore, '~/Postdoc/Automation/candidates/20000423/detections_dublin/dets_20000423_144206_C3.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20000423/original_20000423_144206_c3_soho.fits.gz')
da = readfits_corimp(fl,in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

;da = da[146:877,146:877]
;in.naxis1 = 732
;in.naxis2 = 732
;in.crpix1 = 366
;in.crpix2 = 366

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res[0,*] -= in.xcen
res[1,*] -= in.ycen
res[0,*] *= in.cdelt1
res[1,*] *= in.cdelt2
res /= in.rsun
xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

restore,'~/idl_codes/c3pylonmask.sav'
;c3pylonmask = c3pylonmask[146:877,146:877]
pylon_inds = where(c3pylonmask eq 0)

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)
da[pylon_inds] = max(da)

pos = [ pos_x[1]/devxs, pos_y[4]/devys, pos_x[2]/devxs, pos_y[3]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
	ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color

plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
        restore, '~/Postdoc/Automation/candidates/20000423/detections_dublin/all_h0.sav'
        a_min = (min(pos_angles) + 90) mod 360
        a_max = (max(pos_angles) + 90) mod 360
        r = 20.
        polrec, [r,r], [a_min,a_max], x, y, /degrees
        plots, [0,x[0]], [0,y[0]], psym=-3, line=1
        plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; KINS 3

loadct, 13

restore, '~/Postdoc/Automation/candidates/20000423/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/20000423/dyn*fits.gz')
fls = sort_fls(fls)
mreadfits_corimp, fls, in

;shifting pos_angles because it crosses 0/360 line
;pos_angles = (pos_angles+180) mod 360

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.955e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[3]/devxs, pos_y[4]/devys, pos_x[4]/devxs, pos_y[3]/devys ]

xls = (anytim(time[0]))-utbasedata + 10000
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 28000

utplot, t, (heights_km/6.955e5), utbasedata, psym=1, ytit='Height (R!D!9n!N!X)', pos=pos, $
        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/6.955e5, symsize=0.3, thick=1.5, $
		color=(i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles))), psym=1                
endfor

horline, 2.35, linestyle=1
horline, 5.95, linestyle=1
horline, 19.5, linestyle=1

;colorbar

pos = [ (pos_x[4]+20)/devxs, pos_y[4]/devys, (pos_x[4]+50)/devxs, pos_y[3]/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick;, $
	;ytickname=['191','225','260','294','328','3','37']

;C2 IMAGE 4

loadct, 0

restore, '~/Postdoc/Automation/candidates/20110113/detections_dublin/dets_20110113_102406_C2.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20110113/original_20110113_102406_c2_soho.fits.gz')
da = readfits_corimp(fl,in)

if in.xcen lt 0 then in.xcen=in.crpix1
if in.ycen lt 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 2.35 and ht lt 5.95, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ 180/devxs, 180/devys, pos_x[0]/devxs, pos_y[5]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color
circle_sym, 0, /fill
plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

pasun = make_coordinates(360, [0,2*!pi])
rsun = 1
xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
	restore, '~/Postdoc/Automation/candidates/20110113/detections_dublin/all_h0.sav'
	a_min = (min(pos_angles) + 90) mod 360
	a_max = (max(pos_angles) + 90) mod 360
	r = 6.
	polrec, [r,r], [a_min,a_max], x, y, /degrees
	plots, [0,x[0]], [0,y[0]], psym=-3, line=1
	plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; C3 IMAGE 4

loadct, 0

restore, '~/Postdoc/Automation/candidates/20110113/detections_dublin/dets_20110113_124207_C3.sav'
fl=file_Search('~/Postdoc/Automation/candidates/20110113/original_20110113_124207_c3_soho.fits.gz')
da = readfits_corimp(fl,in)

if in.xcen le 0 then in.xcen=in.crpix1
if in.ycen le 0 then in.ycen=in.crpix2

;da = da[146:877,146:877]
;in.naxis1 = 732
;in.naxis2 = 732
;in.crpix1 = 366
;in.crpix2 = 366

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res[0,*] -= in.xcen
res[1,*] -= in.ycen
res[0,*] *= in.cdelt1
res[1,*] *= in.cdelt2
res /= in.rsun
xf_out = ((xf_out-in.xcen)*in.cdelt1)/in.rsun
yf_out = ((yf_out-in.ycen)*in.cdelt2)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

restore,'~/idl_codes/c3pylonmask.sav'
;c3pylonmask = c3pylonmask[146:877,146:877]
c3pylonmask = rot(c3pylonmask,180)
pylon_inds = where(c3pylonmask eq 0)

fov = where(ht ge 5.95 and ht lt 19.5, comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)
da[pylon_inds] = max(da)

pos = [ pos_x[1]/devxs, 180/devys, pos_x[2]/devxs, pos_y[5]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	xr=[round(min(x)),round(max(x))], yr=[round(min(y)),round(max(y))], $
	;xtickname=[' ',' ',' ',' ',' ',' '], $
        ;ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color

plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

plots, xsun, ysun, thick=2

if keyword_set(ang_widths) then begin
        restore, '~/Postdoc/Automation/candidates/20110113/detections_dublin/all_h0.sav'                
        a_min = (min(pos_angles) + 90) mod 360 
        a_max = (max(pos_angles) + 90) mod 360
        r = 20.
        polrec, [r,r], [a_min,a_max], x, y, /degrees
        plots, [0,x[0]], [0,y[0]], psym=-3, line=1
        plots, [0,x[1]], [0,y[1]], psym=-3, line=1
endif

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; KINS 4

loadct, 13

restore, '~/Postdoc/Automation/candidates/20110113/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/20110113/dyn*fits.gz')
fls = sort_fls(fls)
mreadfits_corimp, fls, in

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.955e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[3]/devxs, 180/devys, pos_x[4]/devxs, pos_y[5]/devys ]

xls = (anytim(time[0]))-utbasedata + 6000
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 24000

utplot, t, (heights_km/6.955e5), utbasedata, psym=1, ytit='Height (R!D!9n!N!X)', pos=pos, $
        xr=[t[0]-xls,t[*]+xrs], /xs, /nodata, charsize=my_charsize, charthick=my_charthick, $
        ytickname=['0','0.5','1.0','1.5']

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180,cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights_km[pos_ind]/6.955e5, symsize=0.3, thick=1.5, $
                ;color=((i+abs(min(pos_angles_color)))*255./(abs(max(pos_angles_color)-min(pos_angles_color)))), psym=1
                ;color=((i+abs(min(pos_angles)))*255./(abs(max(pos_angles)-min(pos_angles)))), psym=1
                color = (i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
endfor

horline, 2.35, linestyle=1
horline, 5.95, linestyle=1
horline, 19.5, linestyle=1

;colorbar

pos = [ (pos_x[4]+20)/devxs, 180/devys, (pos_x[4]+50)/devxs, pos_y[5]/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick



device, /close_file

set_plot, entry_device

end
