; Created: 07-07-11	from one of the plot_slices.pro in the other folders, to generalise for any event.
;			This code is called from slices_all/ folder.


; Last Edited: 28-01-09
; Last Edited: 01-02-09 to include angle_x, angle_z inputs.
; Last Edited: 19-03-09 to be a for-loop over the slice folders where some are removed (bogus_slices).
; 		26-03-09 to make the nolabels keyword.
;		2013-05-24	to include the tog keyword for making paper images.
;		2014-04-28	to include keyword for calling the folder contents directly instead of manually inputting the sliceN's and bogus.
;			^now done without keyword call in place of reading in the slices info.


;INPUTS:	slice_begin	is the starting sliceN folder
;		slice_end	is the final sliceN folder
;		bogus_slice	is the file, '../bogus_slices.txt'.
;		ledge		string to put as legend, containing instrument and date/time
;		angle_x/z	are just the 3D plot orientation angles.
;		model		the fits_path+'/cme*dat' file to overplot the model flux-rope (e.g. '~/Postdoc/Data_Stereo/cme_model/fits/scseprate_090/lon2earth_000/lat2earth_000/cmeorient_090/cme*dat').

pro plot_slices, angle_x, angle_z, ledge, nolabels=nolabels, zoom=zoom, no_ell=no_ell, plot_cone=plot_cone, pauses=pauses, no_proj=no_proj, save_front=save_front, over=over, room_all=room_all, tog=tog, model=model;, folder=folder

;if keyword_set(folder) then begin
	slice_dirs = file_search('../slice*')
	; the last one is slices_all
	slice_nums = fix(strmid(slice_dirs[0:n_elements(slice_dirs)-2],8))
	slice_begin = min(slice_nums)
	slice_end = max(slice_nums)
	bogus_slices = '../bogus.txt'
;endif


loadct,0
set_line_color

if n_elements(bogus_slices) ne 0 then readcol, bogus_slices, bogus, f='B' else bogus=0
if n_elements(bogus) eq 0 then bogus=0

if keyword_set(model) then begin
	model = ' '
	read, 'Model file path? ', model ;fits_path+'/cme*dat'
	restore, model, /ver
	read, 'For the model: file_ind=?', file_ind
endif
; restore the structure 'cme'.

if ~keyword_set(over) then begin

if ~keyword_set(tog) then begin
	!p.charsize=2
	!p.charthick=1
	!p.thick=1
	!x.thick=1
	!y.thick=1
	!z.thick=1
	set_plot, 'x'
	print, 'set_plot, x'
	window, 0, xs=800, ys=800
endif else begin
	set_plot, 'z'
	print, 'set_plot, z'
	temp = !p.color
	!p.color = !p.background
	!p.background = temp
	!p.charsize=1
	!p.charthick=1
	!p.thick=1
	!x.thick=1
	!y.thick=1
	!z.thick=1
	;set_plot, 'ps'
	;print, 'set_plot, ps'
	;device, /encapsul, bits=8, language=2, /portrait, /color, xs=15, ys=15, filename='plot_slices.eps'
endelse

if ~keyword_set(zoom) then surface, dist(5), /nodata, /save, xrange=[-40,220], yrange=[-160,160], $
	zrange=[-100,100], xstyle=1, ystyle=1, zstyle=1, charsize=2.5, ax=angle_x,az=angle_z, xtit='Solar Radii' $
	else surface, dist(5), /nodata, /save, xr=[-14,6], yr=[-10,10], zr=[-6,14], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2.5, ax=angle_x, az=angle_z, xtit='Solar Radii'
if keyword_set(room_all) then surface, dist(5), /nodata, /save, xr=[-15,15], yr=[-15,15], zr=[-15,15], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2.5, ax=angle_x, az=angle_z, xtit='Solar Radii'

endif

if exist(ledge) then legend, ledge, charsize=2, /left


plots, 0,0,0,psym=2, color=6, /t3d ;Sun
;if ~keyword_set(zoom) then xyouts, 0,3,'Sun',z=0,charsize=2,alignment=1,/t3d $
;	else xyouts, -1,1,'Sun',z=0,charsize=2,alignment=1,/t3d

plots, 215, 0,0,psym=5,color=5,/t3d ; Average distance to Earth

plots, 213.5, 0, 0, psym=6, color=6, /t3d ; L1 point (SOHO)

; Make sphere of the Sun
sphere = fltarr(21,21,21)
for x=0,20 do for y=0,20 do for z=0,20 do $
	sphere[x,y,z] = sqrt((x-10)^2.+(y-10)^2.+(z-10)^2.)
shade_volume, sphere, 10, v, p
v = (v/max(v))*2 - 1
plots, v, psym=3, color=6, /t3d

restore, '../../ahead_location.sav'
plots, xa, ya, za, psym=5, color=3, /t3d
restore, '../../behind_location.sav'
plots, xb, yb, zb, psym=5, color=4, /t3d

if ~keyword_set(nolabels) then begin
if ~keyword_set(zoom) then xyouts, 0,3,'Sun',z=0,charsize=2,alignment=1,/t3d $
	else xyouts, -1,1,'Sun',z=0,charsize=2,alignment=1,/t3d
	xyouts, 220, 0, 'Earth', z=0, charsize=2,alignment=0, /t3d
	xyouts, 210, -10, 'SOHO', z=0, charsize=2, alignment=1, /t3d
	xyouts, xa-1, ya+6, 'STEREO-A', z=za, charsize=2, alignment=1, /t3d
	xyouts, xb-5, yb-8, 'STEREO-B', z=zb, charsize=2, alignment=1, /t3d
endif

for k=slice_begin,slice_end do begin
	if where(bogus eq k) eq [-1] then begin
		print, 'slice'+int2str(k)
		restore, '../slice'+int2str(k)+'/vertices.sav'
		if ~keyword_set(no_proj) then begin
			for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
			for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
		endif
		restore, '../slice'+int2str(k)+'/ell.sav'
		front_section,x,y,z,xe,ye,ze,xf,yf,zf
		;help,xf,yf,zf
		if keyword_set(no_ell) then plots, xf,yf,zf,/t3d else plots, xe, ye, ze, /t3d
		if keyword_set(pauses) then pause
	endif
endfor

if n_elements(model) ne 0 then plots, cme[file_ind].x, cme[file_ind].y, cme[file_ind].z, psym=3, /t3d, color=5

print,'***' & print, 'is the legend correct?'

if keyword_set(tog) then begin
	b = tvrd()
	!p.charsize=2
        !p.charthick=4
        !p.thick=4
        !x.thick=4
        !y.thick=4
        !z.thick=4
        set_plot, 'ps'
        print, 'set_plot, ps'
        device, /encapsul, bits=8, language=2, /portrait, /color, xs=15, ys=15, filename='plot_slices.eps'
	tv, b
	device, /close
endif

end
