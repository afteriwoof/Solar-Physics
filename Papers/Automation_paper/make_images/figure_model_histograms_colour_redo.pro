; Code to plot postscript image of multicme_model velocity histograms

; Created:	19-09-11	;from figure_model_histograms_colour.pro


pro figure_model_histograms_colour_redo, means=means, remove_outliers=remove_outliers


set_plot, 'ps'

; define drawable space and filename
; size is to be 4 rows by 3 columns of images.
; size		x:	150-700-300-600-50			150-850-1150-1750-1800
;		y:	150-350-20-350-20-350-20-350-20-350-150	150-500-520-870-890-1240-1260-1610-1630-1980-2130
devxs = 1800.
devys = 2130.
device, xsize=devxs/100., ysize=devys/100., /encapsul, bits=8, language=2, /portrait, /cm, /color, filename='figure_model_histograms.eps'
pos_x = [150,850,1150,1750,1800] / devxs
pos_y = [150,500,520,870,890,1240,1260,1610,1630,1980,2130] / devys

;toggle, /portrait, /color, f='figure_model_histograms_colour_redo.ps'

!p.charsize=1.8
!p.charthick=3
!p.thick=1

!p.multi=[0,2,5]

fls=file_Search('~/Postdoc/Automation/Test/multicme_model/*cme*')
fls=sort_fls(fls,28)
mreadfits_corimp, fls, in

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights1.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h1.sav'
;restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/kins1.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/in_multicme_model.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

xls = (anytim(time[0]))-utbasedata+20000
xrs = (anytim(time[n_elements(time)-1]))-utbasedata+66000

tx1 = t[0]-xls
tx2 = t[n_elements(t)-1]+xrs
utbase = utbasedata
print, 'tx1 ', tx1, 'tx2 ', tx2
print, 'utbasedata ',utbasedata

loadct, 13

pos = [ pos_x[0], pos_y[8], pos_x[1], pos_y[9] ]

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=pos, $
	xr=[tx1,tx2], /xs, yr=[0,1.3e4], /ys, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	/nodata, tit='HEIGHT-TIME PROFILES', charsize=my_charsize, charthick=my_charthick, $
	ytickname=['0','2','4','6','8','10','12']

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180, cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
	pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
	if cnt gt 0 then outplot, t[pos_ind], heights[pos_ind]/1000., symsize=1, thick=2.5, $
		color=(i-min(pos_angles))*(255./(max(pos_angles)-min(pos_angles))), psym=1
endfor

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.35*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME A', charsize=0.8

loc = [ pos_x[1]+0.008, pos_y[8], pos_x[1]+0.021, pos_y[9] ]
colorbar, pos=loc, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights0.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h0.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

print, 'tx1 ', tx1, 'tx2 ', tx2
print, 'utbasedata ',utbasedata

pos = [ pos_x[0], pos_y[6], pos_x[1], pos_y[7] ]

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=pos, $
        xr=[tx1,tx2], /xs, yr=[0,1.3e4], /ys, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' '], /nodata, $
	ytickname=['0','2','4','6','8','10','12']

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180, cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights[pos_ind]/1000., symsize=1, thick=2.5, $
                color=(i-min(pos_angles))*(255./(max(pos_angles)-min(pos_angles))), psym=1
endfor

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.35*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME B', charsize=0.8

loc = [ pos_x[1]+0.008, pos_y[6], pos_x[1]+0.021, pos_y[7] ]
colorbar, pos=loc, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights2.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h2.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

pos = [ pos_x[0], pos_y[2], pos_x[1], pos_y[3] ]

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=pos, $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	ytickname=['0','2','4','6','8','10','12'], /nodata

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180, cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights[pos_ind]/1000., symsize=1, thick=2.5, $
                color=(i-min(pos_angles))*(255./(max(pos_angles)-min(pos_angles))), psym=1
endfor

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.35*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 18500, 11700, 'CMEs D & E', charsize=0.8

loc = [ pos_x[1]+0.008, pos_y[4], pos_x[1]+0.021, pos_y[5] ]
colorbar, pos=loc, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights3.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h3.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

pos = [ pos_x[0], pos_y[4], pos_x[1], pos_y[5] ]


utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=pos, $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' '], $
	ytickname=['0','2','4','6','8','10','12'], /nodata

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180, cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights[pos_ind]/1000., symsize=1, thick=2.5, $
                color=(i-min(pos_angles))*(255./(max(pos_angles)-min(pos_angles))), psym=1
endfor

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.35*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME C', charsize=0.8

loc = [ pos_x[1]+0.008, pos_y[2], pos_x[1]+0.021, pos_y[3] ]
colorbar, pos=loc, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights4.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h4.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

pos = [ pos_x[0], pos_y[0], pos_x[1], pos_y[1] ]

utplot, t, (heights_km/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=pos, $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, /nodata, $
	ytickname=['0','2','4','6','8','10','12'];, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']

; Arranging for plotting with the position angle as colour index on the profiles (to reveal trends).
pos_ind_color = where(pos_angles gt 180, cnt) ;shifting into workable range labelled -180 to 180
pos_angles_color = pos_angles
if cnt gt 0 then pos_angles_color[pos_ind_color] = pos_angles[pos_ind_color] - 360

for i=min(pos_angles),max(pos_angles) do begin
        pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles
        if cnt gt 0 then outplot, t[pos_ind], heights[pos_ind]/1000., symsize=1, thick=2.5, $
                color=(i-min(pos_angles))*(255./(max(pos_angles)-min(pos_angles))), psym=1
endfor

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.35*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME F', charsize=0.8

loc = [ pos_x[1]+0.008, pos_y[0], pos_x[1]+0.021, pos_y[1] ]
colorbar, pos=loc, ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick


;*********

; HISTOGRAMS

;***

my_binsize=20

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all1.sav'
	v_nows = v_all
endif else begin
	restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_fwds1.sav'
	v_nows = v_fwds
endelse

pos = [ pos_x[2], pos_y[8], pos_x[3], pos_y[9] ]

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=my_binsize, ytit='Count', xr=[0,1000], pos=pos, $
	xtickname=[' ',' ',' ',' ',' ',' '], tit='VELOCITY HISTOGRAMS', /halfbin

verline, 600, linestyle=2, thick=0.5

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4
	
	xyouts, 40, 350, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 315, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

;***

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all0.sav'
        v_nows = v_all
endif else begin
	restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_fwds0.sav'
	v_nows = v_fwds
endelse

pos = [ pos_x[2], pos_y[6], pos_x[3], pos_y[7] ]

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=my_binsize, ytit='Count', xr=[0,1000], pos=pos, $
	xtickname=[' ',' ',' ',' ',' ',' '], /halfbin

verline, 600, linestyle=2, thick=0.5
verline, 300, linestyle=3, thick=0.5

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 1050, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 950, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

;***

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all3.sav'
        v_nows = v_all
endif else begin
	restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_fwds3.sav'
	v_nows = v_fwds
endelse

pos = [ pos_x[2], pos_y[4], pos_x[3], pos_y[5] ]

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=my_binsize, ytit='Count', xr=[0,1000], pos=pos, $
	xtickname=[' ',' ',' ',' ',' ',' '], /halfbin

verline, 600, linestyle=2, thick=0.5
verline, 460, linestyle=3, thick=0.5

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 88, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 80, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

;***

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all2.sav'
        v_nows = v_all
endif else begin
	restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_fwds2.sav'
	v_nows = v_fwds
endelse

pos = [ pos_x[2], pos_y[2], pos_x[3], pos_y[3] ]

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=my_binsize, ytit='Count', xr=[0,1000], pos=pos, $
	xtickname=[' ',' ',' ',' ',' ',' '], /halfbin

verline, 500, linestyle=2, thick=0.5

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 26, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 23.5, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

;***

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all4.sav'
        v_nows = v_all
endif else begin
	restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_fwds4.sav'
	v_nows = v_fwds
endelse

pos = [ pos_x[2], pos_y[0], pos_x[3], pos_y[1] ]

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=my_binsize, xtit='Velocity (km s!U-1!N)', ytit='Count', $
	xr=[0,1000], pos=pos, /halfbin

verline, 500, linestyle=2, thick=0.5

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 17.5, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 15.8, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif



;toggle

device, /close_file

end
