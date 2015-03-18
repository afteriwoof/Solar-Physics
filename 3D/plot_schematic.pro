; Created: 06-30-13	from plot_slices_eoin.pro to plot the schematic of the observation.

;INPUTS:	slice_begin	is the starting sliceN folder
;		slice_end	is the final sliceN folder
;		bogus_slice	is the file, '../bogus_slices.txt'.
;		ledge		string to put as legend, containing instrument and date/time
;		angle_x/z	are just the 3D plot orientation angles.
;		model		the fits_path+'/cme*dat' file to overplot the model flux-rope (e.g. '~/Postdoc/Data_Stereo/cme_model/fits/scseprate_090/lon2earth_000/lat2earth_000/cmeorient_090/cme*dat').

pro plot_schematic, slice_begin, slice_end, bogus_slices, angle_x, angle_z, nolabels=nolabels, zoom=zoom, no_ell=no_ell, plot_cone=plot_cone, pauses=pauses, no_proj=no_proj, save_front=save_front, over=over, room_all=room_all, tog=tog, model=model

angle_x = 90
angle_z = 0

loadct,0
set_line_color

if n_elements(bogus_slices) ne 0 then readcol, bogus_slices, bogus, f='B' else bogus=0
if n_elements(bogus) eq 0 then bogus=0

if ~keyword_set(tog) then begin
	!p.charsize=2
	!p.charthick=1
	!p.thick=1
	!x.thick=1
	!y.thick=1
	!z.thick=1
	set_plot, 'x'
	print, 'set_plot, x'
	window, 0, xs=600, ys=500
	bc = 255
	mythick=1
endif else begin
;	set_plot, 'z'
;	print, 'set_plot, z'
	set_plot, 'ps'
	print, 'set_plot, ps'
	device, /encapsul, bits=8, language=2, /color, xs=15, ys=15, filename='plot_schematic.eps',/helvetica
	!p.font = 0
	temp = !p.color
	!p.color = !p.background
	!p.background = temp
	!p.charsize=1
	!p.charthick=5
	!p.thick=5
	!x.thick=5
	!y.thick=5
	!z.thick=5
	bc = 0
	mythick=5
	mycharsize=2
endelse

xr = [-50,250]
yr = [-250,50]


plot, indgen(10), /nodata, xr=xr, yr=yr, /xs, /ys, color=bc, xtit='Solar radii', ytit='Solar radii', $
	tit='Heliocentric Earth Equatorial (HEEQ)', /isotropic

plotsym,0,/fill
plots, 0, 0, psym=8, color=6 ;Sun
draw_circle, 0,0,1,color=6,/fill

earth_coords = (get_stereo_coord('2011-09-22','Earth',system='HEEQ'))[0:2]/6.955e5
plots, earth_coords[0], earth_coords[1], psym=8, color=4

restore, '../soho_location.sav'
plots, x_soho, y_soho, psym=4, color=3
restore, '../behind_location.sav'
plots, x_stereo, y_stereo, psym=4, color=5


xyouts, -3,10,'Sun',charsize=mycharsize,alignment=1,color=6, charthick=mythick
xyouts, 192, 10, 'Earth', charsize=mycharsize,alignment=0, color=4, charthick=mythick
xyouts, 180, -26, 'SOHO', charsize=mycharsize, alignment=0, color=3, charthick=mythick
xyouts, -20, -235, 'STEREO-B', charsize=mycharsize, alignment=0, color=5, charthick=mythick

for k=slice_begin,slice_end do begin
	if where(bogus eq k) eq [-1] then begin
		print, 'slice'+int2str(k)
		restore, '../slice'+int2str(k)+'/vertices.sav'
		if ~keyword_set(no_proj) then begin
			for i=0,3 do plots, [x_soho,x[i]], [y_soho,y[i]], linestyle=1, color=3
			for i=0,3 do plots, [x_stereo,x[i]], [y_stereo,y[i]], linestyle=1, color=5
		endif
		restore, '../slice'+int2str(k)+'/ell.sav'
		front_section,x,y,z,xe,ye,ze,xf,yf,zf
		plots, xf, yf, color=bc
		;help,xf,yf,zf
		if ~keyword_set(no_ell) then plots, xe, ye, color=bc
		if keyword_set(pauses) then pause
	endif
endfor

print,'***' & print, 'is the legend correct?'

if keyword_set(tog) then begin
;	b = tvrd()
;	!p.charsize=2
 ;       !p.charthick=4
  ;      !p.thick=4
   ;     !x.thick=4
    ;    !y.thick=4
     ;   !z.thick=4
      ;  set_plot, 'ps'
       ; print, 'set_plot, ps'
        ;device, /encapsul, bits=8, language=2, /portrait, /color, xs=15, ys=15, filename='plot_slices.eps'
	;tv, b
	device, /close
endif

end
