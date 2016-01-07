; code to save ps of figure_model_stack

;Created:	20120103 from figure_model_stack.pro	

;Created	20120329	from figure_20100312_stack.pro and figure_20100227_0305_stack.pro


pro figure_twostack

set_plot, 'ps'

!p.multi=[0,1,2]
;toggle, /color, /landscape, f='figure_20100312_stack.ps'
device, xsize=24, ysize=60, /cm, bits=8, language=2, /portrait, /color, filename='figure_twostack.eps', /encapsul

loadct, 39
tvlct, r, g, b, /get
upper_val = 255
i = 255
r[i] = upper_val & g[i]=upper_val & b[i]=upper_val
loadct, 0

my_charsize = 1.5
my_charthick = 4

;********************

restore, '~/postdoc/automation/candidates/20100311-13/detections_dublin/det_stack*sav'

pa_total = det_stack.stack

cd,'~/postdoc/automation/catalogue'
clean_pa_total,pa_total,pa_mask
cd, '~/postdoc/automation/automation_paper/make_images'

pa_total *= pa_mask
pa_total = pa_total[*,80:220]

maxp = max(pa_total)

ind = where(pa_total eq 0)
pa_total = (float(hist_equal(pa_total>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
pa_total[ind] = 255

tvlct, r, g, b

print, ((size(pa_total,/dim))[1])
plot_image, pa_total, ytitle='2010/03/11-13', xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '], $
	charsize=my_charsize, charthick=my_charthick, xtickinterval=30, color=-1, pos=[0.15,0.76,0.98,0.9], $
	yticks=((size(pa_total,/dim))[1])/10, xthick=my_charthick, ythick=my_charthick, $
	ytickname=[' ','20:30',' ',' ','04:06',' ',' ','10:42',' ',' ','17:54',' ',' ','00:54',' ']

xyouts, 19, 75, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 130, 55, 'comet', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 240, 33, 'Mercury', charsize=my_charsize-0.2, charthick=my_charthick


; Work out heights in Mm from arcsec or pixels
restore, 'modelrsuns.sav'
km_arc = 6.96e8 / (1000.*ave(modelrsuns))  ; 983.28 is from in.rsun of the multiscme_model C2 files.
maxc = maxp*km_arc/(1000.*695.5)


;********************


restore, '~/postdoc/automation/candidates/20100227-0305/detections_dublin/det_stack*sav'

pa_total = det_stack.stack

cd,'~/postdoc/automation/catalogue'
clean_pa_total,pa_total,pa_mask
cd, '~/postdoc/automation/automation_paper/make_images'

pa_total *= pa_mask

maxp = max(pa_total)

ind = where(pa_total eq 0)
pa_total = (float(hist_equal(pa_total>0,per=1,omin=mn,omax=mx,minv=0,maxv=maxv))*254/255.)
pa_total[ind] = 255

tvlct, r, g, b

print, ((size(pa_total,/dim))[1])
plot_image, pa_total, xtitle='Position Angle (degrees)', ytitle='2010/02/27 - 2010/03/05', $
	charsize=my_charsize, charthick=my_charthick, xtickinterval=30, color=-1, pos=[0.15,0.1,0.98,0.76], $
	yticks=((size(pa_total,/dim))[1])/12, xthick=my_charthick, ythick=my_charthick, $
	ytickname=['00:06',' ',' ','10:24',' ',' ','18:06',' ',' ','03:30',' ',' ','12:06',' ',' ','20:30',' ',' ', $
	'05:06',' ',' ','13:32',' ',' ','21:30',' ',' ','05:54',' ',' ','14:06',' ',' ','23:54',' ',' ','08:06', $
	' ',' ','16:06',' ',' ','00:30',' ',' ','08:42',' ',' ','16:54',' ',' ','01:54',' ',' ','10:06',' ',' ','17:54',' ',' ']

xyouts, 115, 200, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 285, 230, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 315, 175, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 120, 310, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 115, 510, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 300, 640, 'CME', charsize=my_charsize-0.2, charthick=my_charthick
xyouts, 165, 60, 'Jupiter', charsize=my_charsize-0.2, charthick=my_charthick


; Work out heights in Mm from arcsec or pixels
restore, 'modelrsuns.sav'
km_arc = 6.96e8 / (1000.*ave(modelrsuns))  ; 983.28 is from in.rsun of the multiscme_model C2 files.
maxc = maxp*km_arc/(1000.*695.5)

toppos = [0.415, 0.915, 0.715, 0.923]
insetpos = [0.23, 0.7, 0.48, 0.710]
colorbar, pos=toppos, ncolors=255, minrange=0, maxrange=maxc, /norm, $
	/horizontal, title='Height '+symbol_corimp('rs',/parenth), charthick=my_charthick, $
	charsize=my_charsize-0.5, color=-1;, divisions=maxc/1.5


device, /close_file

end
