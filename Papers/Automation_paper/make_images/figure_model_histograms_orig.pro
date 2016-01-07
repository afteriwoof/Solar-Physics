; Code to plot postscript image of multicme_model velocity histograms

; Created:	01-09-11	;from figure_canny4.pro


pro figure_model_histograms

toggle, /portrait, /color, f='figure_model_histograms.ps'
!p.charsize=2
!p.charthick=3
!p.thick=1

!p.multi=[0,2,5]

fls=file_Search('~/Postdoc/Automation/Test/multicme_model/*cme*')
fls=sort_fls(fls,28)
mreadfits_corimp, fls, in

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/heights1.sav'

xls = (anytim(time[0]))-utbasedata+20000
xrs = (anytim(time[n_elements(time)-1]))-utbasedata+66000

tx1 = t[0]-xls
tx2 = t[n_elements(t)-1]+xrs
utbase = utbasedata
print, 'tx1 ', tx1, 'tx2 ', tx2
print, 'utbasedata ',utbasedata

set_line_color

utplot, t, (heights_km/1000.), utbase, psym=1, ytit='Height (Mm)', pos=[0.1,0.81,0.5,1], $
        xr=[tx1,tx2], /xs, yr=[0,1.3e4], /ys, color=3, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME A', charsize=0.8

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/heights0.sav'

print, 'tx1 ', tx1, 'tx2 ', tx2
print, 'utbasedata ',utbasedata
utplot, t, (heights_km/1000.), utbase, psym=1, ytit='Height (Mm)', pos=[0.1,0.61,0.5,0.8], $
        xr=[tx1,tx2], /xs, yr=[0,1.3e4], /ys, color=3, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME B', charsize=0.8

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/heights2.sav'

utplot, t, (heights_km/1000.), utbase, psym=1, ytit='Height (Mm)', pos=[0.1,0.41,0.5,0.6], $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, color=3, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME C', charsize=0.8

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/heights3.sav'

utplot, t, (heights_km/1000.), utbase, psym=1, ytit='Height (Mm)', pos=[0.1,0.21,0.5,0.4], $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, color=3, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 18500, 11700, 'CMEs D & E', charsize=0.8

;***

restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/heights4.sav'

utplot, t, (heights_km/1000.), utbase, psym=1, ytit='Height (Mm)', pos=[0.1,0.01,0.5,0.2], $
        xr=[tx1,tx2], /xs, yrange=[0,1.3e4], /ys, color=3;, /nolabel, xtickname=[' ',' ',' ',' ',' ',' ',' ']
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 66000, 1900, 'C2', charsize=0.8
xyouts, 66000, 4500, 'C3', charsize=0.8
xyouts, 24000, 11700, 'CME F', charsize=0.8


;*********

; Histograms

;***

restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/v_nows1.sav'

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=50, ytit='Count', xr=[0,1000], pos=[0.6,0.81,1,1], $
	xtickname=[' ',' ',' ',' ',' ',' ']

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

xyouts, 40, 350, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
xyouts, 40, 315, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8


;***

restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/v_nows0.sav'

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=50, ytit='Count', xr=[0,1000], pos=[0.6,0.61,1,0.8], $
	xtickname=[' ',' ',' ',' ',' ',' ']

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

xyouts, 40, 1050, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
xyouts, 40, 950, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8


;***

restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/v_nows2.sav'

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=50, ytit='Count', xr=[0,1000], pos=[0.6,0.41,1,0.6], $
	xtickname=[' ',' ',' ',' ',' ',' ']

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

xyouts, 40, 88, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
xyouts, 40, 80, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8


;***

restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/v_nows3.sav'

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=50, ytit='Count', xr=[0,1000], pos=[0.6,0.21,1,0.4], $
	xtickname=[' ',' ',' ',' ',' ',' ']

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

xyouts, 40, 26, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
xyouts, 40, 23.5, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8


;***

restore,'~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/v_nows4.sav'

;cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]
plothist, v_nows, /nan, bin=50, xtit='Velocity (km s!U-1!N)', ytit='Count', xr=[0,1000], pos=[0.6,0.01,1,0.2]

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

xyouts, 40, 17.5, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
xyouts, 40, 15.8, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8











toggle


end
