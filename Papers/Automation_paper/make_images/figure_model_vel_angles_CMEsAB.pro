; Code to plot postscript image of multicme_model velocity histograms

; Created:	19-09-11	;from figure_model_histograms_colour.pro


pro figure_model_vel_angles_CMEsAB, means=means, remove_outliers=remove_outliers

set_plot, 'ps'

; define drawable space and filename
; size is to be 3 rows by 2 columns of images.
; size		x:	180-624-120-624-200		180-804-924-1548-1748
;		y:	180-624-30-624-30-624-30-624	180-804-834-1458-1488-2112-2142-2766-2796
devxs = 2200.
devys = 2796.

device, xsize=devxs/175., ysize=devys/175., /encapsul, bits=8, language=2, /portrait, /cm, /color, filename='figure_model_vel_angles_CMEsAB.eps'


!p.charsize=1.2
!p.charthick=3
!p.thick=3

!p.multi=[0,1,2]

fls=file_Search('~/Postdoc/Automation/Test/multicme_model/*cme*')
fls=sort_fls(fls,28)
mreadfits_corimp, fls, in



if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all1.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles1.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all1.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles1.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[65,115],/ys,pos=[0.2,0.64,0.9,0.92], $
	xtickname=[' ',' ',' ',' ',' ',' '], xthick=3, ythick=3

;verline, 600, linestyle=0, thick=1

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4
	
	xyouts, 40, 350, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 315, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

xyouts, 30, 109, 'CME A'

;***

if keyword_set(remove_outliers) then begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all0.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/outliers_removed/v_all_angles0.sav'
endif else begin
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all0.sav'
	restore, '~/Postdoc/Automation/Catalogue/multicme_model_dynamic_thr3/detections_noncleaned/redo/v_all_angles0.sav'
endelse

plot,v_all,v_all_angles,psym=1,xr=[0,1000],/xs,yr=[240,345],/ys,pos=[0.2,0.1,0.9,0.64], xtit='Velocity (km s!U-1!N)', $
	xthick=3, ythick=3

xyouts, -170, 290, 'Position Angle (deg.)', orientation=90

;verline, 600, linestyle=0, thick=1
;verline, 300, linestyle=0, thick=1

if keyword_set(means) then begin
	mu = moment(v_nows,sdev=sdev,/nan)

	verline, mu[0], linestyle=3
	verline, mu[0]-sdev, linestyle=4
	verline, mu[0]+sdev, linestyle=4

	xyouts, 40, 1050, '!4l!X = '+number_formatter(mu[0],decimals=1), charsize=0.8
	xyouts, 40, 950, '!4r!X = '+number_formatter(sdev,decimals=1), charsize=0.8
endif

xyouts, 30, 337, 'CME B'

;***

device, /close_file


end
