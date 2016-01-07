; Created	2012-10-28	to create the figure for the paper

pro figure_noise_cad, tog=tog

;restore, 'noise_cad_gail.sav'
;n = dblarr(501,800)
;for j=719,1,-1 do n[where(noise_variation[*,*,j] gt 0)]=j
;save, n, f='noise_cad_fig.sav'

restore, 'noise_cad_fig.sav'

if ~keyword_set(tog) then begin
	set_plot, 'x'
	;window, xs=800, ys=1400
	window, xs=800, ys=500
        !p.charsize=2.5
        !p.thick=1
        !x.thick=1
        !y.thick=1
        !p.charthick=1
endif else begin
        !p.charsize=2
        !p.thick=4
        !x.thick=4
        !y.thick=4
        !p.charthick=4
	set_plot, 'ps'
	device, /encapsul, bits=8, language=2, /color, filename='fig_noise_cad.eps', xs=18, ys=8
	print, 'Saving fig_noise_cad.eps'
endelse

loadct, 5
tvlct, r, g, b, /get
rr=reverse(r)
gg=reverse(g)
bb=reverse(b)
tvlct, rr, gg, bb
     
n[where(n eq 0)] = 720

n = rotate(n,3)

;n = smooth(n,2, /edge_truncate, /nan)

plot_image, alog10(n), pos=[0.15,0.2,0.85,0.95], origin=[0,-400], scale=[0.05,1], xtit='% Scatter', ytit='Acceleration (m s!U-2!N)', color=255

colorbar, pos=[0.87,0.2,0.9,0.95], ncolors=255, minrange=min(n), maxrange=max(n), /norm, /vertical, /right, tit='Cadence (s)', color=255


if keyword_set(tog) then device, /close_file


end
