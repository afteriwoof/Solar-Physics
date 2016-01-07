; Code to plot postscript image of multicme_model velocity histograms

; Created:	29-08-11	;from figure_canny4.pro


pro figure_model_histogram

toggle, /portrait, /color, f='figure_model_histogram.ps'
!p.charsize=1.2
!p.charthick=4
!p.thick=2

fls=file_Search('~/Postdoc/Automation/Test/multicme_model/*cme*')
fls=sort_fls(fls,28)
mreadfits_corimp, fls, in

restore, 'heights0.sav'

!p.multi=[0,1,2]
xls = (anytim(time[0]))-utbasedata+42000
xrs = (anytim(time[n_elements(time)-1]))-utbasedata+48000

set_line_color

utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm)', pos=[0.13,0.55,0.96,0.88], $
        xr=[t[0]-xls,t[*]+xrs], /xs, color=3;, /nolabel ;, xtickname=[' ',' ',' ',' ',' ',' ',' '], color=3
outplot, new_t, new_heights/1000., psym=1, color=0

; plot line to mark occulter edges/crossover 5.75-6 Rsun
horline, 2.25*700., linestyle=1
horline, 5.75*700., linestyle=1
horline, 6*700., linestyle=2
horline, 16*700., linestyle=2

xyouts, 34000, 1900, 'C2 FoV', charsize=1
xyouts, 34000, 4500, 'C3 FoV', charsize=1

; Histograms

restore,'v_nows0.sav'

cghistoplot, v_nows, binsize=50, xtit='Velocity (km s!U-1!N)', datacolorname='black', xr=[0,1000]

mu = moment(v_nows,sdev=sdev,/nan)

verline, mu[0], linestyle=3
verline, mu[0]-sdev, linestyle=4
verline, mu[0]+sdev, linestyle=4

print, 'mu[0] ', mu[0] & print, 'sdev ', sdev
toggle

end
