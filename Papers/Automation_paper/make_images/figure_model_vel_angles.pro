; Code to plot postscript image of multicme_model velocity histograms

; Created:	19-09-11	;from figure_model_histograms_colour.pro


pro figure_model_vel_angles, means=means, remove_outliers=remove_outliers

toggle, /portrait, /color, f='figure_model_vel_angles.ps'
!p.charsize=2
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

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=[0.04,0.81,0.46,1], $
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

colorbar, pos=[0.465,0.81,0.48,1], ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights0.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h0.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

print, 'tx1 ', tx1, 'tx2 ', tx2
print, 'utbasedata ',utbasedata
utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=[0.04,0.61,0.46,0.8], $
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

colorbar, pos=[0.465,0.61,0.48,0.8], ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights2.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h2.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=[0.04,0.21,0.46,0.4], $
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

colorbar, pos=[0.465,0.21,0.48,0.4], ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights3.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h3.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

utplot, t, (heights/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=[0.04,0.41,0.46,0.6], $
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

colorbar, pos=[0.465,0.41,0.48,0.6], ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/heights4.sav'
restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/all_h4.sav'

heights *= (6.955e8/(1000.*ave(in.rsun)))

utplot, t, (heights_km/1000.), utbase, ytit='Height (Mm x10!U3!N)', pos=[0.04,0.01,0.46,0.2], $
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

colorbar, pos=[0.465,0.01,0.48,0.2], ncolors=255, minrange=min(pos_angles), maxrange=max(pos_angles), /norm, /vertical, /right, $
        title='Position Angle (deg.)', charsize=my_charsize, charthick=my_charthick


;****************************************

; HISTOGRAMS

set_line_color

;***

my_binsize=20

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all1.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles1.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all1.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles1.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[68,110],/ys,pos=[0.63,0.81,1,1], $
	xtickname=[' ',' ',' ',' ',' ',' ']

verline, 600, linestyle=0, thick=1

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
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles0.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all0.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles0.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[240,333],/ys,pos=[0.63,0.61,1,0.8], $
	xtickname=[' ',' ',' ',' ',' ',' ']

verline, 600, linestyle=0, thick=1
verline, 300, linestyle=0, thick=1

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
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles3.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all3.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles3.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[41,60],/ys,pos=[0.63,0.41,1,0.6], $
	xtickname=[' ',' ',' ',' ',' ',' ']

verline, 600, linestyle=0, thick=1
verline, 460, linestyle=0, thick=1

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
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles2.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all2.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles2.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[214,236],/ys,pos=[0.63,0.21,1,0.4], $
	xtickname=[' ',' ',' ',' ',' ',' ']

verline, 500, linestyle=0, thick=1

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
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles4.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all4.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles4.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[216,240],/ys,pos=[0.63,0.01,1,0.2], $
	xtit='Velocity (km s!U-1!N)'

verline, 500, thick=1, linestyle=0

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 17.5, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 15.8, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif



toggle


end
