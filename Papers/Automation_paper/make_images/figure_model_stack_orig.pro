; code to save ps of figure_model_stack

;Created:	25-08-11	

pro figure_model_stack

!p.multi=0


;toggle, /color, /landscape, f='figure_model_stack.ps'

set_plot, 'ps'

device, xsize=18, ysize=10, /cm, bits=8, language=2, /portrait, /color, filename='figure_model_stack.eps', /encapsul

loadct, 13
tvlct, r, g, b, /get
upper_val = 255
i = 255
r[i] = upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 1.5
my_charthick = 3.5


restore, 'pa_total_model_thr3.sav'

temp = pa_total
pa_total[270:*,*] = pa_total[0:89,*]
pa_total[0:269,*] = temp[90:*,*]
delvarx, temp

maxp = max(pa_total)

ind = where(pa_total eq 0)
pa_total = (float(hist_equal(pa_total>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
pa_total[ind] = 255

tvlct, r, g, b

plot_image, pa_total, xtitle='Position Angle (degrees)', ytitle='Time (image no.)', $
	charsize=my_charsize, charthick=my_charthick, xtickinterval=30, color=-1, pos=[0.11,0.18,0.98,0.76]

xyouts, 53, 13, 'A', charsize=my_charsize, charthick=my_charthick
xyouts, 240, 13, 'B', charsize=my_charsize, charthick=my_charthick
xyouts, 28, 42, 'C', charsize=my_charsize, charthick=my_charthick
xyouts, 200, 45, 'D', charsize=my_charsize, charthick=my_charthick
xyouts, 200, 60, 'E', charsize=my_charsize, charthick=my_charthick
xyouts, 200, 77, 'F', charsize=my_charsize, charthick=my_charthick

; Work out heights in Mm from arcsec or pixels
restore, 'modelrsuns.sav'
km_arc = 6.96e8 / (1000.*ave(modelrsuns))  ; 983.28 is from in.rsun of the multiscme_model C2 files.
maxc = maxp*km_arc/(1000.*695.5)

colorbar, pos=[0.38, 0.85, 0.68, 0.89], ncolors=255, minrange=0, maxrange=maxc, /norm, $
	/horizontal, title='Height '+symbol_corimp('rs',/parenth), charthick=my_charthick, $
	charsize=my_charsize-0.2, color=-1;, divisions=maxc/1.5;, xtickname=['0','3','5','8','10','13','16']

;tv, pa_total, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

;contour, pa_total, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
;	xtitle='Angle (degrees)', ytitle='Time (Image No.)', ytick_get=yticks, $
;	charsize=my_charsize, charthick=my_charthick, /noerase



;xyouts, pos[0]+0.01, pos[3]-0.05, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

device, /close_file

;toggle

end
