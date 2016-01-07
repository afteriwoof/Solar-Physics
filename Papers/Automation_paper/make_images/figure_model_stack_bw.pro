; code to save ps of figure_model_stack

;Created:	25-08-11	

pro figure_model_stack

toggle, /color, /landscape, f='figure_model_stack.ps'

loadct, 0
tvlct, r, g, b, /get
r=reverse(r) & g=reverse(g) & b=reverse(b)
tvlct, r, g, b


my_charsize = 1.5
my_charthick = 3


restore, 'pa_total_model.sav'

temp = pa_total
pa_total[270:*,*] = pa_total[0:89,*]
pa_total[0:269,*] = temp[90:*,*]
delvarx, temp

plot_image, pa_total, xtitle='Position Angle (degrees)', ytitle='Time (image no.)', $
	charsize=my_charsize, charthick=my_charthick, xtickinterval=30, color=-1


; Work out heights in Mm from arcsec or pixels
restore, 'modelrsuns.sav'
km_arc = 6.96e8 / (1000.*ave(modelrsuns))  ; 983.28 is from in.rsun of the multiscme_model C2 files.


colorbar, pos=[0.4, 0.68, 0.7, 0.71], ncolors=255, minrange=0, maxrange=max(pa_total)*km_arc/1000./695.5, /norm, $
	/horizontal, title='Height '+symbol_corimp('rs',/parenth), charthick=my_charthick, $
	charsize=my_charsize-0.5, color=-1

;tv, pa_total, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

;contour, pa_total, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
;	xtitle='Angle (degrees)', ytitle='Time (Image No.)', ytick_get=yticks, $
;	charsize=my_charsize, charthick=my_charthick, /noerase



;xyouts, pos[0]+0.01, pos[3]-0.05, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

toggle

end
