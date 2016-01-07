; Trying to hack this code for using it to make ellipse fit intersections!

; Last Edited: 11-02-09


;+
; $Id: scc_measure.pro,v 1.10 2008/10/31 15:47:09 thompson Exp $
;
; Project     :	STEREO - SECCHI
;
; Name        :	SCC_MEASURE
;
; Purpose     :	Measure 3D coordinates from two STEREO images
;
; Category    :	STEREO, SECCHI, Coordinates
;
; Explanation :	Widget application to allow a user to select with the cursor a
;               feature appearing in both images.  The selected coordinates are
;               used to locate the point in three-dimensional space.
;
;               The user first selects a point on one image.  The program then
;               displays a line on the other image representing the
;               line-of-sight from the first image.  The user then selects the
;               point along this line with the same feature.  The 3D
;               coordinates are then calculated and displayed within the widget
;               as (Earth-based) Stonyhurst heliographic longitude and
;               latitude, along with radial distance in solar radii.
;
;               In essence, this is a demonstration procedure showing how to
;               derive 3D information from STEREO data.
;
; Syntax      :	SCC_MEASURE, FILE_AHEAD, FILE_BEHIND
;
;               or
;
;               SCC_MEASURE, IMAGE_AHEAD, IMAGE_BEHIND, INDEX_AHEAD, INDEX_BEHIND
;
; Examples    :	FILE_AHEAD  = '20061101_000535_n4c1A.fts'
;               FILE_BEHIND = '20061101_000535_n4c1B.fts'
;               SCC_MEASURE, FILE_AHEAD, FILE_BEHIND
;
; Inputs      :	FILE_AHEAD  = List of filenames for the Ahead observatory
;               FILE_BEHIND = List of filenames for the Behind observatory
;
; Opt. Inputs :	Instead of passing the filenames, one can pass in images and
;               indices which have already been read in.  In that case, the
;               calling parameters are:
;
;               IMAGE_AHEAD  = Image(s) for the Ahead observatory
;               IMAGE_BEHIND = Image(s) for the Behind observatory
;               INDEX_AHEAD  = FITS index structure(s) for Ahead
;               INDEX_BEHIND = FITS index structure(s) for Behind
;
;               With this method, it's also possible to substitute data from
;               SOHO or other observatories for one of the STEREO satellites.
;
; Outputs     :	None.
;
; Opt. Outputs:	None.
;
; Keywords    :	WSIZE   = Window size to use for displaying the images.  The
;                         default is 512.
;
;               OUTFILE = Name of file to store results in.  Use the "Store"
;                         button to write each selected measurement into this
;                         file.  The stored points will also be displayed on
;                         the images.  Use the "Clear stored" button to clear
;                         these points out from memory.  At the same time, a
;                         blank line will be written to the output file to mark
;                         the separation between collections of points.
;
;               APPEND  = Append to existing output file.
;
;               FORCESAVE = If set, saves last results in given output
;                           file upon exit, even if manual 'Save' has
;                           or has not been used.  Has no effect if no
;                           output file was defined.
;
;               CROP = If set, restricts chosing of points to the
;                      inner region so that a crop to half size
;                      can later be done (outside of scc_measure)
;
;               NO_BLOCK = Call XMANAGER with /NO_BLOCK
;
;
; Calls       :	SCCREADFITS, FITSHEAD2WCS, EXPTV, SCC_MEASURE_EVENT,
;               SCC_MEASURE_SELECT_1ST, SCC_MEASURE_SELECT_2ND, BOOST_ARRAY,
;               SCC_MEASURE_REDISPLAY, SSC_MEASURE_REPLOT, SSC_MEASURE_CLEANUP,
;               SETWINDOW, GET_TV_SCALE, WCS_GET_COORD, CONVERT_STEREO_COORD
;
; Common      :	SCC_MEASURE = Internal common block used by the widget program.
;
; Restrictions:	None.
;
; Side effects:	None.
;
; Prev. Hist. :	None.
;
; Written     :	Version 1, 21-Sep-2006, William Thompson, GSFC
;
; $Log: scc_measure.pro,v $
; Revision 1.10  2008/10/31 15:47:09  thompson
; Include support for Earth-based observatories, and SOHOd
;
; Revision 1.9  2007/12/26 22:27:34  thompson
; Fixed minor sub-pixel bug
;
; Revision 1.8  2007/09/19 22:15:20  thompson
; Corrected plot labels
;
; Revision 1.7  2007/09/12 21:21:46  thompson
; Made no_block a keyword
;
; Revision 1.6  2007/09/12 21:09:37  thompson
; *** empty log message ***
;
; Revision 1.5  2007/09/12 21:07:16  thompson
; Added /noblock
;
; Revision 1.4  2007/07/02 22:32:50  thompson
; Add SECCHIPREP keyword, option of passing in images and headers
;
; Revision 1.3  2007/05/24 17:35:07  antunes
; New interactive cropping tools for SECCHI Cors.
;
; Revision 1.2  2007/05/24 11:08:54  antunes
; Added return of Pixel positions clicked on to save file, also set
; autosave upon exit if /forcesave given.
;
; Revision 1.1  2006/09/27 17:04:24  nathan
; moved from dev/analysis
;
;               Version 2, 26-Sep-2006, William Thompson, GSFC
;                       Added keywords OUTFILE, APPEND.  Numerous improvements.
;
; Contact     :	WTHOMPSON
;-
;
;==============================================================================
;
pro scc_measure_redisplay, window=k_window
;
;  Procure to redisplay the windows after various operations such as changing
;  the color table.
;
common my_scc_measure2nd, ahead, h_ahead, behind, h_behind, wcs_ahead, wcs_behind, $
  win_left, win_right, image_left, image_right, lon_wid, lat_wid, rsun_wid, $
  zoom_wid, unzoom_wid, maxz, param, pix_param, pix_left, pix_right, $
  heeq_left, heeq_right, in_progress, win_last, zoom, color, $
  lmin, lmax, rmin, rmax, lmin_wid, lmax_wid, rmin_wid, rmax_wid, $
  subimage_left, subimage_right, origin_left, origin_right, outlun, out_wid, $
  clear_wid, n_stored, store_left, store_right, pixpair, pixforce, roi

;
if n_elements(k_window) eq 1 then window = k_window else window = -1
;
;  If the left (or no) windor was selected, then redisplay the left window.
;
if (window eq win_left) or (window eq -1) then begin
    setwindow, win_left
    get_tv_scale, sx, sy, mx, my, jx, jy
    tv, image_left, jx, jy
    if n_stored gt 0 then $
      plots, store_left[0,*], store_left[1,*], psym=1, color=color
endif
;
;  If the right (or no) window was selected, then redisplay the right window.
;
if (window eq win_right) or (window eq -1) then begin
    setwindow, win_right
    get_tv_scale, sx, sy, mx, my, jx, jy
    tv, image_right, jx, jy
    if n_stored gt 0 then $
      plots, store_right[0,*], store_right[1,*], psym=1, color=color
endif
;
;  If no particular window was selected, and some points have been selected,
;  then recreate the plots on top of the image.
;
if (window eq -1) and (win_last ne '') then begin
;
;  If the point selection is in progress, then plot the point on the 1st
;  window, and the line on the 2nd window.
;
    if in_progress then begin
        if win_last eq 'LEFT' then begin
            setwindow, win_left
            plots, pix_left[0],  pix_left[1],  psym=5, symsize=3, color=color
		print, 'you have plots, pix_left[0], pix_left[1], psym=5'
	    setwindow, win_right
            plots, pix_param[0,*], pix_param[1,*], color=color, linestyle=2
	    	print, 'you plotted line pix_param[0,*], pix_para[1,*],linestyle=2'
            x = [0,wcs_behind.naxis[1]-1]
            plots, x, poly(x, param), line=2, color=color
        end else begin
            setwindow, win_right
            plots, pix_right[0],  pix_right[1],  psym=1, symsize=3, color=color
            setwindow, win_left
            plots, pix_param[0,*], pix_param[1,*], color=color
            x = [0,wcs_ahead.naxis[1]-1]
            plots, x, poly(x, param), line=1, color=color
        endelse
;
;  Otherwise, plot both points.
;
    end else begin
        setwindow, win_left
        plots, pix_left[0],  pix_left[1],  psym=1, symsize=3, color=color
        setwindow, win_right
        plots, pix_right[0], pix_right[1], psym=1, symsize=3, color=color
    endelse
endif
;
end
;
;==============================================================================
;
pro scc_measure_replot, left=left, right=right
;
;  Procedure to replot the images, e.g. after changing the image range.
;
common my_scc_measure2nd
;
;  Unless only the right image was selected, then plot the left image.  Get the
;  current min and max values.
;
if not keyword_set(right) then begin
    setwindow, win_left
    widget_control, lmin_wid, get_value=lmin1
    widget_control, lmax_wid, get_value=lmax1
    if lmax1 gt lmin1 then begin
        lmin = lmin1
        lmax = lmax1
    endif
    widget_control, lmin_wid, set_value=lmin
    widget_control, lmax_wid, set_value=lmax
    exptv, subimage_left, /data, /nobox, /noexact, origin=origin_left, $
      min=lmin, max=lmax, bscaled=image_left
endif
;
;  Unless only the left image was selected, then plot the right image.  Get the
;  current min and max values.
;
if not keyword_set(left) then begin
    setwindow, win_right
    widget_control, rmin_wid, get_value=rmin1
    widget_control, rmax_wid, get_value=rmax1
    if rmax1 gt rmin1 then begin
        rmin = rmin1
        rmax = rmax1
    endif
    widget_control, rmin_wid, set_value=rmin
    widget_control, rmax_wid, set_value=rmax
    exptv, subimage_right, /data, /nobox, /noexact, origin=origin_right, $
      min=rmin, max=rmax, bscaled=image_right
endif
;
;  Redisplay any overplots.
;
scc_measure_redisplay
;
end
;
;==============================================================================
;
pro scc_measure_select_1st, ev, win_1st, win_2nd, image_1st, image_2nd, $
                            wcs_1st, wcs_2nd, sc_1st, sc_2nd, $
                            heeq_1st, heeq_2nd, param_1st, pix_1st
;
;  Procedure to select the first point.
;
common my_scc_measure2nd
;
;  Start by converting from device pixels to pixels within the image.  Overplot
;  the selected point.
;
openw, lun_pix_1st, /get_lun, 'pix_1st.txt', error=err
free_lun, lun_pix_1st
openw, lun_intersects1, /get_lun, 'intersects1.txt', error=err
free_lun, lun_intersects1
openw, lun_intersects2, /get_lun, 'intersects2.txt', error=err
free_lun, lun_intersects2
my_count=0
jump1:
scc_measure_redisplay, window=win_1st
setwindow, win_1st
pix = convert_coord(ev.x, ev.y, /device, /to_data)
my_ind = where(ahead eq 988)
; i have chosen a pixel on the edge (value 988)
my_pix = array_indices(ahead, my_ind)
sz_my_pix = size(my_pix, /dim)
pix_1st = pix[0:1]
my_pix_1st = [my_pix[0,my_count], my_pix[1,my_count]]
print, 'you clicked at ', pix_1st
print, 'my_pix_1st ', my_pix_1st
pix_1st = my_pix_1st


if roi[9] then begin            ;ROI active
    if (pix_1st[0] lt roi[0] or pix_1st[0] gt roi[1] or $
        pix_1st[1] lt roi[2] or pix_1st[1] gt roi[3]) then begin
        ; out of our region of interest, force an early routine
        roi[8]=0                ; failed
        return
    end else begin
        roi[8]=1                ; success
    endelse
endif

if (sc_1st eq 'ahead') then pixpair[0:1]=pix_1st else pixpair[2:3]=pix_1st

if (pixforce ne 0) then pixforce=2; mark as 'needs to be saved'

plots, pix_1st[0], pix_1st[1], psym=1, symsize=3, color=color
;
;  Convert from image pixel into helioprojective-cartesian coordinates, in
;  radians.
;
coord = wcs_get_coord(wcs_1st, pix_1st)
conv = !dpi / 180.d0
case wcs_1st.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
coord = coord * conv
;
;  Calculate the equivalent heliocentric coordinates for distances D within
;  +/- maxz of Dsun.
;
dsun = wcs_1st.position.dsun_obs
d = dsun + maxz * [-1,1]
cosy = cos(coord[1])
x = d * cosy * sin(coord[0])
y = d * sin(coord[1])
z = dsun - d * cosy * cos(coord[0])
;
;  Determine the spacecraft parameter to pass to convert_stereo_coord.
;
spacecraft = sc_1st
test = execute('header = h_'+spacecraft)
obsrvtry = ''
if datatype(header) eq 'STC' then begin
    if tag_exist(header, 'OBSRVTRY') then obsrvtry = header.obsrvtry
end else obsrvtry = fxpar(header, 'OBSRVTRY')
if strmid(obsrvtry,0,7) eq 'STEREO_' then spacecraft = obsrvtry else $
  spacecraft = 'Earth'
if wcs_1st.position.soho and (not wcs_1st.position.pos_assumed) then $
  spacecraft = 'SOHO'
;
;  Convert to HEEQ coordinates, with rearranging into HGRTN format as an
;  intermediate state.
;
coord = transpose([[z],[x],[y]])
convert_stereo_coord, wcs_1st.time.observ_date, coord, 'HGRTN', 'HEEQ', $
  spacecraft=spacecraft
heeq_1st = coord
;
;  Determine the spacecraft parameter to pass to convert_stereo_coord.
;
spacecraft = sc_2nd
test = execute('header = h_'+spacecraft)
obsrvtry = ''
if datatype(header) eq 'STC' then begin
    if tag_exist(header, 'OBSRVTRY') then obsrvtry = header.obsrvtry
end else obsrvtry = fxpar(header, 'OBSRVTRY')
if strmid(obsrvtry,0,7) eq 'STEREO_' then spacecraft = obsrvtry else $
  spacecraft = 'Earth'
if wcs_2nd.position.soho and (not wcs_2nd.position.pos_assumed) then $
  spacecraft = 'SOHO'
;
;  Switch to the other window, and convert from HEEQ to heliocentric-cartesian
;  x,y,z values for the other perspective.
;
scc_measure_redisplay, window=win_2nd
convert_stereo_coord, wcs_2nd.time.observ_date, coord, 'HEEQ', 'HGRTN', $
  spacecraft=spacecraft
x = reform(coord[1,*])
y = reform(coord[2,*])
z = reform(coord[0,*])
;
;  Convert from heliocentric-cartesian to helioprojective-cartesian.  Put into
;  the target units.
;
dsun = wcs_2nd.position.dsun_obs
d = sqrt(x^2 + y^2 + (dsun-z)^2)
coord = transpose([[atan(x,dsun-z)], [asin(y/d)]])
conv = 180.d0 / !dpi
case wcs_2nd.cunit[0] of
    'arcmin': conv = conv * 60.d0
    'arcsec': conv = conv * 3600.d0
    'mas':    conv = conv * 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
coord = coord * conv
;
;  Convert from helioprojective-cartesian to image pixel coordinates, and
;  overplot the points.
;  
pix_param = wcs_get_pixel(wcs_2nd, coord)
plots, pix_param[0,*], pix_param[1,*], color=color

;
;  Extrapolate over the full X-range of the image.
;
param_1st = poly_fit(pix_param[0,*], pix_param[1,*], 1)
x = [0,wcs_2nd.naxis[1]-1]
plots, x, poly(x, param_1st), line=1, color=color
print, 'x',x
print, 'poly()', poly(x,param_1st)
my_x = x
my_y = poly(x, param_1st)
my_slope = (my_y[1]-my_y[0])/(my_x[1]-my_x[0])
my_intercept = my_y[0]+my_slope*my_x[0]
print, my_slope, my_intercept
qtemp_intersect1 = 0
qtemp_intersect2 = 0
temp_count = 0
for temp_x=0,2047 do begin
	temp_y = temp_x*my_slope + my_intercept
	if behind[temp_x,temp_y] eq 888 then begin
		if temp_count eq 0 then begin
			temp_intersect1 = [temp_x, temp_y]
			qtemp_intersect1 = 1
		endif
		temp_count = 1
	endif else begin
		if temp_count eq 1 then begin
			temp_intersect2 = [temp_x, temp_y]
			qtemp_intersect2 = 1
		endif
		temp_count = 0
	endelse
endfor
if qtemp_intersect1 eq 1 then plots, temp_intersect1, psym=2, color=3
if qtemp_intersect2 eq 1 then plots, temp_intersect2, psym=2, color=3
;print, temp_intersect1, temp_intersect2
if qtemp_intersect1 eq 1 && qtemp_intersect2 eq 1 then begin
	openu, lun_pix_1st, 'pix_1st.txt', /append
	printf, lun_pix_1st, pix_1st[0], pix_1st[1]
	free_lun, lun_pix_1st
	openu, lun_intersects1, 'intersects1.txt', /append
	printf, lun_intersects1, temp_intersect1[0], temp_intersect1[1]
	free_lun, lun_intersects1
	openu, lun_intersects2, 'intersects2.txt', /append
	printf, lun_intersects2, temp_intersect2[0], temp_intersect2[1]
	free_lun, lun_intersects2
endif
my_count += 1
if my_count lt sz_my_pix[1] then goto, jump1

;
;  Deactivate the zoom button, and clear out the text widgets.
;
widget_control, zoom_wid, sensitive=0
widget_control, out_wid,  sensitive=0
widget_control, lon_wid, set_value=''
widget_control, lat_wid, set_value=''
widget_control, rsun_wid, set_value=''
;
end
;
;==============================================================================
;
pro scc_measure_select_2nd, ev, win_2nd, image_2nd, wcs_2nd, sc_2nd, $
                            heeq_1st, heeq_2nd, param_1st, pix_2nd
;
;  Procedure to select the 2nd point.
;
common my_scc_measure2nd
;
;  Start by converting from device pixels to pixels within the image.
;
scc_measure_redisplay, window=win_2nd
pix = convert_coord(ev.x, ev.y, /device, /to_data)
pix = pix[0:1]

;  Find the intersection between the linear fit from the other window
;  (PARAM_1ST) and the orthogonal line represented by the current selection.
;  Overplot the selection.
;
a0 = param_1st[0]
a1 = param_1st[1]
x = (pix[0] + a1*(pix[1]-a0)) / (1 + a1^2)
pix_2nd = [x, a0 + a1*x]
help, x, pix_2nd
;
; Now check our region of interest again
;
if roi[9] then begin            ;ROI active
    if (pix_2nd[0] lt roi[4] or pix_2nd[0] gt roi[5] or $
        pix_2nd[1] lt roi[6] or pix_2nd[1] gt roi[7]) then begin
        ; out of our region of interest, force an early routine
        roi[8]=0                ; failed
        return
    end else begin
        roi[8]=1                ; success
    end
endif

if (sc_2nd eq 'ahead') then pixpair[0:1]=pix_2nd else pixpair[2:3]=pix_2nd
if (pixforce ne 0) then pixforce=2; mark as 'needs to be saved'

plots, pix_2nd[0], pix_2nd[1], psym=1, symsize=3, color=color
;
;  Convert from image pixel into helioprojective-cartesian coordinates, in
;  radians.  Store the angles in the common block
;
coord = wcs_get_coord(wcs_2nd, pix_2nd)
conv = !dpi / 180.d0
case wcs_2nd.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
coord = coord * conv
;
;  Calculate the equivalent heliocentric coordinates for distances D within
;  +/- maxz of Dsun.
;
dsun = wcs_2nd.position.dsun_obs
d = dsun + maxz * [-1,1]
cosy = cos(coord[1])
x = d * cosy * sin(coord[0])
y = d * sin(coord[1])
z = dsun - d * cosy * cos(coord[0])
;
;  Determine the spacecraft parameter to pass to convert_stereo_coord.
;
spacecraft = sc_2nd
test = execute('header = h_'+spacecraft)
obsrvtry = ''
if datatype(header) eq 'STC' then begin
    if tag_exist(header, 'OBSRVTRY') then obsrvtry = header.obsrvtry
end else obsrvtry = fxpar(header, 'OBSRVTRY')
if strmid(obsrvtry,0,7) eq 'STEREO_' then spacecraft = obsrvtry else $
  spacecraft = 'Earth'
if wcs_2nd.position.soho and (not wcs_2nd.position.pos_assumed) then $
  spacecraft = 'SOHO'
;
;  Convert to HEEQ coordinates, with rearranging into HGRTN format as an
;  intermediate state.  Store the coordinates in the common block
;
coord = transpose([[z],[x],[y]])
convert_stereo_coord, wcs_2nd.time.observ_date, coord, 'HGRTN', $
  'HEEQ', spacecraft=spacecraft
heeq_2nd = coord
;
;  Based on the HEEQ coordinates from the left and right images, find the
;  intersection on the equatorial (x-y) plane.
;
p1st = poly_fit(heeq_1st[0,*], heeq_1st[1,*], 1)
p2nd = poly_fit(heeq_2nd[0,*], heeq_2nd[1,*], 1)
x = (p1st[0] - p2nd[0]) / (p2nd[1] - p1st[1])
y = (poly(x,p1st) + poly(x,p2nd)) / 2
;
;  Using the same point, find the Z position.
;
p1st = poly_fit(heeq_1st[0,*], heeq_1st[2,*], 1)
p2nd = poly_fit(heeq_2nd[0,*], heeq_2nd[2,*], 1)
z = (poly(x,p1st) + poly(x,p2nd)) / 2
;
;  Populate the widgets.
;
rad = sqrt(x^2 + y^2 + z^2)
lon = atan(y, x) * 180 / !dpi
widget_control, lon_wid, set_value=ntrim(float(lon))
lat = asin(z / rad) * 180 / !dpi
widget_control, lat_wid, set_value=ntrim(float(lat))
rad = rad / 6.95508e8
widget_control, rsun_wid, set_value=ntrim(float(rad))
;
;  Activate the zoom and store buttons.
;
widget_control, zoom_wid, /sensitive
if outlun gt 0 then widget_control, out_wid, /sensitive
;
end
;
;==============================================================================
;
pro scc_measure_cleanup, id
;
;  Cleanup procedure, to make sure that the output file is properly closed.
;
common my_scc_measure2nd
if outlun gt 0 then free_lun, outlun
end
;
;==============================================================================
;
pro store_scc_measure
  common my_scc_measure2nd

  widget_control, lon_wid, get_value=lon
  widget_control, lat_wid, get_value=lat
  widget_control, rsun_wid, get_value=rad
  printf, outlun, lon, lat, rad, pixpair, format='(7(F11.5,1x))'
;        printf, outlun, lon, lat, rad, format='(3F5.5)'
  flush, outlun
  widget_control, out_wid, sensitive=0
  widget_control, clear_wid, /sensitive
  n_stored = n_stored + 1
  if n_stored eq 1 then begin
      store_left = pix_left
      store_right = pix_right
  end else begin
      boost_array, store_left, pix_left
      boost_array, store_right, pix_right
  endelse

end

;==============================================================================
;
pro scc_measure_event, ev
;
;  Widget event handler.
;
common my_scc_measure2nd
;
widget_control, ev.id, get_uvalue=uvalue
case uvalue of
    'EXIT': begin
        if (pixforce eq 2) then store_scc_measure
        widget_control, /destroy, ev.top
    end
;
    'XLOADCT': xloadct, group=ev.top, updatecallback="scc_measure_redisplay"
;
;  The plot color was changed.
;
    'COLOR': begin
        widget_control, ev.id, get_value=color
        color = 0 > color < (!d.table_size - 1)
        widget_control, ev.id, set_value=color
        scc_measure_replot
    end
;
;  The left window was selected.  Start by converting from device pixels to
;  pixels within the image.  Overplot the selected point.
;
    'LEFT': if ev.press gt 0 then begin
        if win_last eq 'LEFT' then in_progress = 0
        if in_progress then begin
            scc_measure_select_2nd, ev, win_left, image_left, wcs_behind, $
              'behind', heeq_right, heeq_left, param, pix_left
            if roi[8] or (roi[9] eq 0) then in_progress = 0
        end else begin
            scc_measure_select_1st, ev, win_left, win_right, image_left, $
              image_right, wcs_behind, wcs_ahead, 'behind', 'ahead', $
              heeq_left, heeq_right, param, pix_left
            if roi[8] or (roi[9] eq 0) then in_progress = 1
        endelse
        if roi[8] or (roi[9] eq 0) then win_last = 'LEFT'
    endif
;
;  The right window was selected.  Start by converting from device pixels to
;  pixels within the image.
;
    'RIGHT': if ev.press gt 0 then begin
        if win_last eq 'RIGHT' then in_progress = 0
        if in_progress then begin
            scc_measure_select_2nd, ev, win_right, image_right, wcs_ahead, $
              'ahead', heeq_left, heeq_right, param, pix_right
            if roi[8] or (roi[9] eq 0) then in_progress = 0
        end else begin
            scc_measure_select_1st, ev, win_right, win_left, image_right, $
              image_left, wcs_ahead, wcs_behind, 'ahead', 'behind', $
              heeq_right, heeq_left, param, pix_right
            if roi[8] or (roi[9] eq 0) then in_progress = 1
        endelse
        if roi[8] or (roi[9] eq 0) then win_last = 'RIGHT'
    endif
;
;  Modify the image ranges.
;
    'LMIN': scc_measure_replot, /left
    'LMAX': scc_measure_replot, /left
    'RMIN': scc_measure_replot, /right
    'RMAX': scc_measure_replot, /right
;
;  Store any selected points.
;
    'STORE': begin
        store_scc_measure
        if (pixforce ne 0) then pixforce=1; mark as 'saved'
    end
;
;  Clear the previously stored points from memory.
;
    'CLEAR': begin
        n_stored = 0
        printf, outlun
        flush, outlun
        widget_control, clear_wid, sensitive=0
        scc_measure_redisplay
    end
;
;  Zoom in on the previously selected points.
;
    'ZOOM': if min([wcs_ahead.naxis,wcs_behind.naxis]/(2*zoom)) gt 4 then begin
        zoom = zoom * 2
        naxis = wcs_behind.naxis
        nn = naxis / zoom
        origin_left = floor(pix_left - nn/2) > 0
        if origin_left[0]+nn[0] gt naxis[0] then $
          origin_left[0] = naxis[0] - nn[0]
        if origin_left[1]+nn[1] gt naxis[1] then $
          origin_left[1] = naxis[1] - nn[1]
        ix = origin_left[0]
        iy = origin_left[1]
        subimage_left = behind[ix:ix+nn[0]-1, iy:iy+nn[1]-1]
        setwindow, win_left
        exptv, subimage_left, /data, /nobox, /noexact, origin=origin_left, $
          min=lmin, max=lmax, bscaled=image_left
        plots, pix_left[0], pix_left[1], psym=1, symsize=3, color=color
;
        naxis = wcs_ahead.naxis
        nn = naxis / zoom
        origin_right = floor(pix_right - nn/2) > 0
        if origin_right[0]+nn[0] gt naxis[0] then $
          origin_right[0] = naxis[0] - nn[0]
        if origin_right[1]+nn[1] gt naxis[1] then $
          origin_right[1] = naxis[1] - nn[1]
        ix = origin_right[0]
        iy = origin_right[1]
        subimage_right = ahead[ix:ix+nn[0]-1, iy:iy+nn[1]-1]
        setwindow, win_right
        exptv, subimage_right, /data, /nobox, /noexact, origin=origin_right, $
          min=rmin, max=rmax, bscaled=image_right
        plots, pix_right[0], pix_right[1], psym=1, symsize=3, color=color
;
        widget_control, unzoom_wid, /sensitive
    endif
;
;  Zoom out from the previously zoomed image.
;
    'UNZOOM': if zoom gt 1 then begin
        zoom = zoom / 2
        if zoom eq 1 then begin
            setwindow, win_left
            subimage_left = behind
            origin_left = [0,0]
            exptv, behind, /data, /nobox, /noexact, min=lmin, max=lmax, $
              bscaled=image_left
            if not in_progress then plots, pix_left[0], pix_left[1], psym=1, $
              symsize=3, color=color
;
            setwindow, win_right
            subimage_right = ahead
            origin_right = [0,0]
            exptv, ahead, /data, /nobox, /noexact, min=rmin, max=rmax, $
              bscaled=image_right
            if not in_progress then plots, pix_right[0], pix_right[1], $
              psym=1, symsize=3, color=color
;
            widget_control, unzoom_wid, sensitive=0
        end else begin
            naxis = wcs_behind.naxis
            nn = naxis / zoom
            origin_left = floor(pix_left - nn/2) > 0
            if origin_left[0]+nn[0] gt naxis[0] then $
              origin_left[0] = naxis[0] - nn[0]
            if origin_left[1]+nn[1] gt naxis[1] then $
              origin_left[1] = naxis[1] - nn[1]
            ix = origin_left[0]
            iy = origin_left[1]
            subimage_left = behind[ix:ix+nn[0]-1, iy:iy+nn[1]-1]
            setwindow, win_left
            exptv, subimage_left, /data, /nobox, /noexact, min=lmin, $
              max=lmax, origin=origin_left, bscaled=image_left
            if not in_progress then plots, pix_left[0], pix_left[1], psym=1, $
              symsize=3, color=color
;
            naxis = wcs_ahead.naxis
            nn = naxis / zoom
            origin_right = floor(pix_right - nn/2) > 0
            if origin_right[0]+nn[0] gt naxis[0] then $
              origin_right[0] = naxis[0] - nn[0]
            if origin_right[1]+nn[1] gt naxis[1] then $
              origin_right[1] = naxis[1] - nn[1]
            ix = origin_right[0]
            iy = origin_right[1]
            subimage_right = ahead[ix:ix+nn[0]-1, iy:iy+nn[1]-1]
            setwindow, win_right
            exptv, subimage_right, /data, /nobox, /noexact, min=rmin, $
              max=rmax, origin=origin_right, bscaled=image_right
            if not in_progress then plots, pix_right[0], pix_right[1], $
              psym=1, symsize=3, color=color
        endelse
;
;  Redisplay any overplots.
;
        scc_measure_redisplay
    endif
;
    else: message, /continue, 'Unrecognized event ' + uvalue
endcase
;
end
;
;==============================================================================
;
pro my_scc_measure2nd, file_ahead, file_behind, index_ahead, index_behind, $
                 wsize=k_wsize, outfile=outfile, secchiprep=secchiprep, $
                 append=append, forcesave=forcesave, crop=crop, $
                 no_block=no_block, _extra=_extra
;
;  Main procedure to set up the widget.
;
common my_scc_measure2nd
;
if (n_elements(forcesave) ne 0) then pixforce=1 else pixforce=0
pixpair=fltarr(4)
if (xregistered("scc_measure") NE 0) then return
;
if datatype(file_ahead,1) eq 'String' then begin
    if keyword_set(secchiprep) then begin
        secchi_prep, file_ahead,  h_ahead,  ahead,  _extra=_extra
        secchi_prep, file_behind, h_behind, behind, _extra=_extra
    end else begin
        ahead  = sccreadfits(file_ahead,  h_ahead)
        behind = sccreadfits(file_behind, h_behind)
    endelse
    wcs_ahead = fitshead2wcs(h_ahead)
    wcs_behind = fitshead2wcs(h_behind)
end else begin
    ahead = file_ahead
    h_ahead = index_ahead
    wcs_ahead = fitshead2wcs(index_ahead)
    behind = file_behind
    h_behind = index_behind
    wcs_behind = fitshead2wcs(index_behind)
endelse
;
; If setting up for cropping, store the allowable region of interest,
; otherwise defaultq region is 'the entire image'
;
roi =fltarr(10)
if (n_elements(crop) ne 0) then begin
    roi[0]=wcs_ahead.naxis[0]/4
    roi[1]=3*wcs_ahead.naxis[0]/4
    roi[2]=wcs_ahead.naxis[1]/4
    roi[3]=3*wcs_ahead.naxis[1]/4
    roi[4]=wcs_behind.naxis[0]/4
    roi[5]=3*wcs_behind.naxis[0]/4
    roi[6]=wcs_behind.naxis[1]/4
    roi[7]=3*wcs_behind.naxis[1]/4
    roi[8]=1; status flag
    roi[9]=1; ROI active

    ; also mark our ROI within the data
    ahead[roi[0]:roi[1],roi[2]]=max(ahead)
    ahead[roi[0]:roi[1],roi[3]]=max(ahead)
    ahead[roi[0],roi[2]:roi[3]]=max(ahead)
    ahead[roi[1],roi[2]:roi[3]]=max(ahead)

    behind[roi[4]:roi[5],roi[6]]=max(behind)
    behind[roi[4]:roi[5],roi[7]]=max(behind)
    behind[roi[4],roi[6]:roi[7]]=max(behind)
    behind[roi[5],roi[6]:roi[7]]=max(behind)

endif



;
;  Set up the main widget base.
;
main = widget_base(title="SECCHI 3D coordinate measuring tool", /column)
;
;  Set up the two graphics windows.
;
if n_elements(k_wsize) eq 1 then wsize=k_wsize else wsize=512
show = widget_base(main, /row)
lcolumn = widget_base(show, /column, /frame)
dummy = widget_label(lcolumn, value='Behind')
left  = widget_draw(lcolumn, xsize=wsize, ysize=wsize, retain=2, $
                    uvalue="LEFT", /button_events)
dummy = widget_base(lcolumn, /row)
lmin_wid = cw_field(dummy, title='Image minimum:', xsize=15, /floating, $
                uvalue='LMIN', /return_events)
lmax_wid = cw_field(dummy, title='maximum:', xsize=15, /floating, $
                uvalue='LMAX', /return_events)
;
rcolumn = widget_base(show, /column, /frame)
dummy = widget_label(rcolumn, value='Ahead')
right = widget_draw(rcolumn, xsize=wsize, ysize=wsize, retain=2, $
                    uvalue="RIGHT", /button_events)
dummy = widget_base(rcolumn, /row)
rmin_wid = cw_field(dummy, title='Image minimum:', xsize=15, /floating, $
                uvalue='RMIN', /return_events)
rmax_wid = cw_field(dummy, title='maximum:', xsize=15, /floating, $
                uvalue='RMAX', /return_events)
;
;  Define a row for the output, and define fields for the heliographic
;  longitude, latitude, and radial distance.
;
output = widget_base(main, /row)
dummy = widget_label(output, value='Heliographic')
lon_wid  = cw_field(output, title='Longitude:',  xsize=10, /noedit)
lat_wid  = cw_field(output, title='Latitude:',  xsize=10, /noedit)
rsun_wid = cw_field(output, title='Solar radii:', xsize=10, /noedit)
out_wid = widget_button(output, value='Store', uvalue='STORE')
clear_wid = widget_button(output, value='Clear stored', uvalue='CLEAR')
;
;  Define a row for buttons.  Place the exit button a little off from the other
;  buttons.
;
control = widget_base(main, /row)
dummy = widget_button(control, uvalue="XLOADCT", value='Adjust color table')
zoom_wid = widget_button(control, uvalue="ZOOM", value='Zoom in')
unzoom_wid = widget_button(control, uvalue="UNZOOM", value='Zoom out')
color = !d.table_size - 1
color_wid = widget_slider(control, uvalue="COLOR", value=color, minimum=0, $
                          maximum=!d.table_size-1, title='Plot color')
dummy = widget_label(control, value="          ")
dummy = widget_button(control, uvalue="EXIT", Value="Exit", /frame)
;
;  Realize the widget, and draw the images.
;
widget_control, main, /realize
widget_control, left, get_value=win_left
setwindow, win_left
test = sigrange(behind)
lmin = min(test, max=lmax)
exptv, test, /data, /nobox, /noexact, bscaled=image_left
subimage_left = behind
origin_left = [0,0]
widget_control, lmin_wid, set_value=lmin
widget_control, lmax_wid, set_value=lmax
;
widget_control, right, get_value=win_right
setwindow, win_right
test = sigrange(ahead)
rmin = min(test, max=rmax)
exptv, test, /data, /nobox, /noexact, bscaled=image_right
subimage_right = ahead
origin_right = [0,0]
widget_control, rmin_wid, set_value=rmin
widget_control, rmax_wid, set_value=rmax
;
setwindow, win_left             ;Makes sure that plot parameters are stored.
;
;  Deactivate the zoom, unzoom, and store widgets.
;
widget_control, zoom_wid, sensitive=0
widget_control, unzoom_wid, sensitive=0
widget_control, out_wid, sensitive=0
widget_control, clear_wid, sensitive=0
;
;  Determine the maximum scale of the two images, in meters.  Make sure that
;  it's at least 3 solar radii
;
scale0 = max(wcs_ahead.naxis*wcs_ahead.cdelt)
conv = !dpi / 180.d0
case wcs_ahead.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
scale0 = scale0 * conv * wcs_ahead.position.dsun_obs
;
scale1 = max(wcs_behind.naxis*wcs_behind.cdelt)
conv = !dpi / 180.d0
case wcs_behind.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
scale1 = scale1 * conv * wcs_behind.position.dsun_obs
maxz = scale0 > scale1 > 2.1e9
;
;  If the OUTFILE parameter was passed, then open a file for writing.
;
if n_elements(outfile) eq 1 then $
  openw, outlun, outfile, /get_lun, append=append else $
  outlun = -1
;
;  Initialize some control parameters, and set the widget going.
;
in_progress = 0
win_last = ''
zoom = 1
n_stored = 0
;
xmanager, 'scc_measure', main, cleanup='scc_measure_cleanup', no_block=no_block
end
