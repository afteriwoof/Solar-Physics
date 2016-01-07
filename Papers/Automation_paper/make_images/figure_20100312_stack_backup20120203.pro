; code to save ps of figure_model_stack

;Created:	20120103 from figure_model_stack.pro	

pro figure_20100312_stack

!p.multi=0
toggle, /color, /landscape, f='figure_20100312_stack.ps'

loadct, 13
tvlct, r, g, b, /get
upper_val = 255
i = 255
r[i] = upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 1.2
my_charthick = 3


restore, '~/postdoc/automation/catalogue/20100312/pa_total_20100312.sav'

maxp = max(pa_total)

ind = where(pa_total eq 0)
pa_total = (float(hist_equal(pa_total>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
pa_total[ind] = 255

tvlct, r, g, b

plot_image, pa_total, xtitle='Position Angle (degrees)', ytitle='Time (image no.)', $
	charsize=my_charsize, charthick=my_charthick, xtickinterval=30, color=-1, pos=[0.1,0.3,1.,0.64]

xyouts, 25, 65, 'CME', charsize=my_charsize, charthick=my_charthick
xyouts, 130, 65, 'comet', charsize=my_charsize, charthick=my_charthick
xyouts, 190, 65, 'Mercury', charsize=my_charsize, charthick=my_charthick


; Work out heights in Mm from arcsec or pixels
restore, 'modelrsuns.sav'
km_arc = 6.96e8 / (1000.*ave(modelrsuns))  ; 983.28 is from in.rsun of the multiscme_model C2 files.
maxc = maxp*km_arc/(1000.*695.5)

colorbar, pos=[0.4, 0.68, 0.7, 0.71], ncolors=255, minrange=0, maxrange=maxc, /norm, $
	/horizontal, title='Height '+symbol_corimp('rs',/parenth), charthick=my_charthick, $
	charsize=my_charsize-0.2, color=-1;, divisions=maxc/1.5;, xtickname=['0','3','5','8','10','13','16']

;tv, pa_total, pos[0], pos[1], xs=pos[2]-pos[0], ys=pos[3]-pos[1], /norm

;contour, pa_total, x, y, /xst, /yst, /nodata, /iso, pos=pos, /norm, $
;	xtitle='Angle (degrees)', ytitle='Time (Image No.)', ytick_get=yticks, $
;	charsize=my_charsize, charthick=my_charthick, /noerase



;xyouts, pos[0]+0.01, pos[3]-0.05, '(b)', /norm, charsize=my_charsize, charthick=my_charthick

toggle

end
