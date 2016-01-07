; code to save ps of figures from sample of events to put in proposal

;Created:	20120117	from figure_events_proposal.pro to make similar images for secchi/cor images.

pro figure_events_secchi


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
; size		x:	180-624-180-750-220		180-804-984-1734-1954
;		y:	180-624-180-624-130		180-804-984-1608-1738
devxs = 1954.
devys = 1738.
device, xsize=devxs/200., ysize=devys/200., /encapsul, bits=8, language=2, /portrait, /cm, /color, filename='figure_events_secchi.eps'
pos_x = [180,804,984,1734,1954]
pos_y = [1738,1608,984,804,180]


; COR2-A IMAGE

loadct, 0


;restore, '~/Postdoc/Automation/Catalogue/20110113_cor2a/plots_201101131139.sav'
restore, '~/Postdoc/Automation/candidates/secchi_files/a/detections_dublin/dets_20110113_113900_COR2.sav'
fl=file_Search('~/Postdoc/Automation/candidates/secchi_cor2_a/2011/01/13/separated_secchi_20110113_201101131139__C2.orig.fits.gz')
da = readfits_corimp(fl,in)

if in.xcen le 0 then in.xcen=in.crpix1
if in.ycen le 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.pix_size)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.pix_size)/in.rsun

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 3. and ht lt 11., comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ pos_x[0]/devxs, pos_y[2]/devys, pos_x[1]/devxs, pos_y[1]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
	;xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
        title='SECCHI/COR2-A', $
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

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(a)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; COR2-A KINS

loadct, 13

;restore, '~/Postdoc/Automation/Catalogue/20110113_cor2a/detections_noncleaned/all_h0.sav'
restore, '~/Postdoc/Automation/candidates/secchi_files/a/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/secchi_files/a/dyn*fits.gz')
mreadfits_corimp, fls, in

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.96e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[2]/devxs, pos_y[2]/devys, pos_x[3]/devxs, pos_y[1]/devys ]

xls = (anytim(time[0]))-utbasedata + 14251
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 4500

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

horline, 3., linestyle=1
horline, 11., linestyle=1

;colorbar

pos = [ (pos_x[4]-195)/devxs, pos_y[2]/devys, (pos_x[4]-165)/devxs, pos_y[1]/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick


; COR2-B IMAGE 

loadct, 0

;restore, '~/Postdoc/Automation/Catalogue/20110113_cor2b/plots_201101131139.sav'
restore, '~/Postdoc/Automation/candidates/secchi_files/b/detections_dublin/dets_20110113_113943_COR2.sav'
fl=file_Search('../../candidates/secchi_cor2_b/2011/01/13/original_20110113_113943_cor2B_stereo.fits.gz')
da = readfits_corimp(fl,in)

if in.xcen le 0 then in.xcen=in.crpix1
if in.ycen le 0 then in.ycen=in.crpix2

res = dets.edges
xf_out = dets.front[0,*]
yf_out = dets.front[1,*]

res = ((res-in.crpix1)*in.pix_size)/in.rsun
xf_out = ((xf_out-in.crpix1)*in.cdelt1)/in.rsun
yf_out = ((yf_out-in.crpix2)*in.cdelt2)/in.rsun

da = da[36:987,36:987]
in.xcen = 476
in.ycen = 476
in.naxis1 = 952
in.naxis2 = 952
in.crpix1 = 476
in.crpix2 = 476

get_ht_pa_2d_corimp, in.naxis1, in.naxis2, in.crpix1, in.crpix2, pix_size=in.pix_size/in.rsun, x, y, ht, pa

fov = where(ht ge 4.65 and ht lt 11., comp=nfov)
da[nfov] = mean(da[fov],/nan)
da = hist_equal(da,percent=0.01)
da[nfov] = max(da)

pos = [ pos_x[0]/devxs, pos_y[4]/devys, pos_x[1]/devxs, pos_y[3]/devys ]

tvscl, da, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

contour, da, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
        ;xtickname=[' ',' ',' ',' ',' ',' '], $
        ytitle='Solar Y '+symbol_corimp('rs',/parenth), $
	title='SECCHI/COR2-B', $
	xtitle = 'Solar X '+symbol_corimp('rs',/parenth), $
        ytick_get=yticks, /noerase, charsize=my_charsize, charthick=my_charthick

set_line_color

plots, res[0,*], res[1,*], psym=8, symsize=0.05, color=2
plots, xf_out, yf_out, psym=1, symsize=0.2, color=3

xsun = rsun*sin(pasun)
ysun = rsun*cos(pasun)
plots, xsun, ysun, thick=2

;xyouts, pos[0]+posaddx, pos[3]-posaddy, '(b)', /norm, charsize=my_charsize-0.4, charthick=my_charthick


; COR2-B KINS

loadct, 13

;restore, '~/Postdoc/Automation/Catalogue/20110113_cor2b/detections_noncleaned/all_h0.sav'
restore, '~/Postdoc/Automation/candidates/secchi_files/b/detections_dublin/all_h0.sav'
fls=file_search('~/Postdoc/Automation/candidates/secchi_files/b/dyn*fits.gz')
mreadfits_corimp, fls, in

t = in[image_no].date_obs
time = anytim(t)
utbasedata = time[0]

km_arc = 6.96e8 / (1000.*in.rsun)
heights_km = fltarr(n_elements(heights))
for i=0,n_elements(heights)-1 do heights_km[i]=heights[i]*km_arc[image_no[i]]

pos = [ pos_x[2]/devxs, pos_y[4]/devys, pos_x[3]/devxs, pos_y[3]/devys ]

xls = (anytim(time[0]))-utbasedata + 5294
xrs = (anytim(time[n_elements(time)-1])) - utbasedata + 4500

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
                ;color=((i+abs(min(pos_angles)))*255./(abs(max(pos_angles)-min(pos_angles)))), psym=1
		color = (i-min(pos_angles)) * (255/(max(pos_angles)-min(pos_angles))), psym=1
endfor

horline, 4.5, linestyle=1
horline, 11., linestyle=1

;colorbar

pos = [ (pos_x[4]-195)/devxs, pos_y[4]/devys, (pos_x[4]-165)/devxs, pos_y[3]/devys ]

colorbar, pos=pos, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick



device, /close_file

set_plot, entry_device

end
