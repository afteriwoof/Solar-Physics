; Created	2013-01-07	from plot_kins_quartiles.pro to just do the specifics of the paper figure.

; Keywords:	main_angs	- to take only the main chunk of position angles that are read in.
;		sav_gol		- to use savitszky-golay filter instead of deriv.pro
;		no_plots	- to avoid plotting the fits to the height-time data.

pro plot_kins_quartiles_paperfig, datetimes_in, heights_in, pos_angles_in, out_dir, new_heights, new_pos_angles, gather_t_nows, gather_h_nows, gather_v_nows, gather_a_nows, tog=tog, plot_quartiles=plot_quartiles, plot_median=plot_median, remove_outliers=remove_outliers, saves=saves, model=model, main_angs=main_angs, sav_gol=sav_gol, quadratic=quadratic, linear=linear, debug=debug, no_plots=no_plots

if keyword_set(debug) then begin
	print, '***'
	print, 'plot_kins_quartiles.pro'
	print, '***'
	pause
endif

datetime = datetimes_in
heights = heights_in
pos_angles = pos_angles_in

if keyword_set(debug) then begin
	help, pos_angles
	print, 'pos_angles ', pos_angles
	pmm, pos_angles
	pause
endif
; If pos_angles crosses the 0/360 line
if min(pos_angles) le 1 AND max(pos_angles) ge 359 then begin
	ind_min = min(where(pos_angles eq min(pos_angles)))
	ind_max = max(where(pos_angles eq max(pos_angles)))
	pos_angles = [pos_angles_in[ind_min:n_elements(pos_angles_in)-1],pos_angles_in[0:ind_max]]
	heights = [heights_in[ind_min:n_elements(pos_angles_in)-1],heights_in[0:ind_max]]
	datetime = [datetimes_in[ind_min:n_elements(pos_angles_in)-1],datetimes_in[0:ind_max]]
endif

if keyword_set(debug) then begin
	print, 'pos_angles shifted ', pos_angles
	print, 'heights shifted ', heights
	print, 'datetime shifted ', datetime
	pause
endif

if n_elements(datetime) lt 3 then begin
	if keyword_set(debug) then print, 'n_elements(datetime) lt 3', n_elements(datetime)
	goto, jump_end
endif

if keyword_set(sav_gol) then begin
	nleft = 3
	nright = 3
	degree = 2
endif

pos_angles_init = pos_angles

if keyword_set(main_angs) then begin
	mu = moment(pos_angles, sdev=sdev)
	range = where(pos_angles ge (mu[0]-0.5*sdev) AND pos_angles le (mu[0]+0.5*sdev))
	;range = where(pos_angles eq median(pos_angles))
	pos_angles = pos_angles[range]
	datetime = datetime[range]
	heights = heights[range]
endif

; Ranges
h_max_range = 2.0e4
vel_max_range = 900
accel_max_range = 250
;Char params
if keyword_set(tog) then c=0 else c=1
thick_t = 5

loadct, 13
xs=800
ys=1200

t = datetime
time = anytim(t)
utbasedata = time[0]
rsun = fltarr(n_elements(datetime))
for i=0L,n_elements(rsun)-1 do rsun[i] = (pb0r(datetime[i],/arcsec))[2]
km_arc = 6.955e8 / (1000.*rsun)
heights_km = fltarr(n_elements(heights))
for i=0L,n_elements(heights)-1 do heights_km[i] = heights[i]*km_arc[i]

if keyword_set(linear) then plot_name='linear'
if keyword_set(quadratic) then plot_name='quadratic'
if keyword_set(sav_gol) then plot_name='sav_gol'

if keyword_set(tog) AND ~keyword_set(debug) then begin
	loadct, 13
	set_plot, 'ps'
	device, /encapsul, bits=8, language=2, /portrait, /color, filename=out_dir+'/plot_kins_quartiles_'+anytim(utbasedata,/truncate,/ccsds)+'_'+plot_name+'.eps', xs=20, ys=30
        !p.background=1
        !p.charsize=2.5
        !p.charthick=5
        !p.thick=3
	!x.thick=4
	!y.thick=4
        plot_char = 1
endif else begin
        window, xs=xs, ys=ys
        !p.charsize=2
        !p.charthick=1
        !p.thick=1
        plot_char = 1.5
endelse

;pos_angles = (pos_angles+180) mod 360

; REMOVING OUTLIERS
v = fltarr(n_elements(datetime)-1)
a = fltarr(n_elements(datetime)-2)
for i=0L,n_elements(datetime)-2 do begin
	if datetime[i+1] gt datetime[i] then v[i] = (heights[i+1]-heights[i])/(time[i+1]-time[i])
endfor
for i=0L,n_elements(datetime)-3 do begin
	if v[i+1] gt v[i] && v[i] ne 0 && v[i+1] ne 0 then a[i] = (v[i+1]-v[i])/(time[i+1]-time[i])
endfor
if keyword_set(saves) then begin
	print, 'Saving kins_temp.sav'
	save, heights, v, a, time, f='kins_temp.sav'
endif
infvar = 3./0.
infs = where(v eq infvar)
if infs ne [-1] then begin
	if keyword_set(debug) then print, 'Removing Inf values and replacing with maximums.'
	tempv = v
	remove, infs, tempv
	v[infs] = max(tempv)
endif
if keyword_set(remove_outliers) then begin
	plot_hist,v,x,y,bin=0.1
	newx=fltarr(n_elements(x)-1)
	newy=fltarr(n_elements(y)-1)
	if where(x eq 0) ne 0 then begin
		newx[0:where(x eq 0)-1]=x[0:where(x eq 0)-1]
		newx[where(x eq 0):*]=x[(where(x eq 0)+1):*]
		newy[0:where(x eq 0)-1]=y[0:where(x eq 0)-1]
		newy[where(x eq 0):*]=y[(where(x eq 0)+1):*]
		x = newx
		y = newy
		delvarx, newx, newy
	endif else begin
		x = x[1:*]
		y = y[1:*]
	endelse
	y_max = max(y)
	ind = where(y eq y_max)
	x_max = x[ind]
	count = 1
	while y[ind+count] lt y[ind+count-1] do begin
		x_cutoff1 = x[ind+count]
		count += 1
	endwhile
	count = 1
	x_cutoff2 = x[ind-count]
	while y[ind-count] lt y[ind-count+1] do begin
		x_cutoff2 = x[ind-count]
		count += 1
	endwhile
	if keyword_set(debug) then print, x_cutoff1, x_cutoff2
	verline, x_cutoff1
	verline, x_cutoff2
	inds = where(v le x_cutoff1[0] AND v ge x_cutoff2[0])
	all_inds = [inds, inds+1]
	delvarx, inds
	all_inds = all_inds[uniq(all_inds,sort(all_inds))]
	new_heights = heights_km[all_inds]
	new_pos_angles = pos_angles[all_inds]
	new_t = t[all_inds]
endif else begin
	new_heights = heights_km
	new_pos_angles = pos_angles
	new_t = t
endelse
; end of remove_outliers
;********************


; INTERQUARTILE RANGE on the heights
gather_t_nows = '0'
gather_h_nows = 0
flag = 0
flag1 = 0
flag_init = 0
big_count = 0
while flag eq 0 do begin
	count = 0
	h_now = new_heights[big_count+count];the current height
	t_now = new_t[big_count+count]; the current time
	while new_t[big_count+count+1] gt new_t[big_count+count] do begin
		if (big_count+count+2) lt n_elements(new_t) then count += 1 else goto, jump1
		h_now = [h_now, new_heights[big_count+count]]
		t_now = [t_now, new_t[big_count+count]]
		gather_h_nows = [gather_h_nows, h_now]
		gather_t_nows = [gather_t_nows, t_now]
	endwhile
	big_count += count+1
	if big_count+count+1 ge n_elements(new_t) then flag=1
endwhile
jump1:
if n_elements(gather_t_nows) lt 2 then goto, jump_end
t_nows = gather_t_nows[1:*]
h_nows = gather_h_nows[1:*]
t_bins = t_nows[uniq(t_nows,sort(t_nows))]
h_right_now = h_nows[where(t_nows eq t_bins[0])]
h_meds = median(h_right_now)
h_q1s = median(h_right_now[where(h_right_now ge h_meds)]);upper quartile
h_q3s = median(h_right_now[where(h_right_now le h_meds)]);lower quartile
h_iqr = h_q1s - h_q3s ;interquartile range
lowerfence = h_q1s - 1.5*h_iqr
upperfence = h_q3s + 1.5*h_iqr
for i=1,n_elements(t_bins)-1 do begin
	h_right_nows = h_nows[where(t_nows eq t_bins[i])]
	h_meds = [h_meds,median(h_right_nows)]
	h_q1s = [h_q1s,median(h_right_nows[where(h_right_nows ge h_meds[i])])]
	h_q3s = [h_q3s,median(h_right_nows[where(h_right_nows le h_meds[i])])]
	h_iqr = h_q1s[i] - h_q3s[i]
	lowerfence = [lowerfence, h_q1s[i] - 1.5*h_iqr]
	upperfence = [upperfence, h_q3s[i] + 1.5*h_iqr]
endfor
;***

pos_angles = new_pos_angles

if keyword_set(saves) then begin
	print, 'new_heights_info.sav'
	save, new_heights, time, t, heights_km, utbasedata, new_t, f='new_heights_info.sav'
endif

mov = fltarr(xs,ys,n_elements(new_pos_angles))
mov_count = 0
!p.multi=[0,1,3]
time_add = ( max(anytim(time)) - min(anytim(time)) ) * 0.05
xls = anytim(min(anytim(time)) - time_add, /hxrbs)
xrs = anytim(max(anytim(time)) + time_add, /hxrbs)

if keyword_set(linear) then title='Linear Fit'
if keyword_set(quadratic) then title='Quadratic Fit'
if keyword_set(sav_gol) then title='Savitzky-Golay Filter'

; First plot the heights at all position angles
utplot, t, (heights_km/1000.), utbasedata, psym=1, ytit='Height (Mm)', pos=[0.15,0.63,0.92,0.91],yr=[0,h_max_range],ystyle=8, $
	xr=[xls,xrs], /xs, /nolabel , xtickname=[' ',' ',' ',' ',' ',' ',' '], /nodata, $
	xtit='',tit='';, tit=title;color=3
	axis, yaxis=1, yrange=[0,h_max_range]/695.5, /ys, ytit=symbol_corimp('rs')
;legend, title, box=0, charsize=plot_char

any_fit = 0
flag_init = 0
never_v_fwd = 0
flag_v_fit = 0

for i=min(pos_angles),max(pos_angles) do begin
	pos_ind = where(abs(pos_angles-i) lt 0.5, cnt) ;finding the locations of just these pos_angles (since all others will differ by 1 and greater).
	if cnt gt 1 then begin
		outplot, new_t[pos_ind], new_heights[pos_ind]/1000.,$
			color=(i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles))), psym=1
		t_now = new_t[pos_ind]
		h_now = new_heights[pos_ind]
		if h_now[n_elements(h_now)-1]-h_now[0] eq 0 then pause
		v_fwd = (h_now[n_elements(h_now)-1]-h_now[0])/(anytim(t_now[n_elements(t_now)-1])-anytim(t_now[0]))
		; loop through for every v_fwd
		if never_v_fwd eq 0 then begin
			temp = fltarr(n_elements(h_now)-1)
			for count_fwd=0,n_elements(h_now)-2 do begin	
				temp[count_fwd] = (h_now[count_fwd+1]-h_now[count_fwd])/(anytim(t_now[count_fwd+1])-anytim(t_now[count_fwd]))
			endfor
			v_fwd_all = temp
			never_v_fwd = 1
		endif else begin
			temp = fltarr(n_elements(h_now)-1)
			for count_fwd=0,n_elements(h_now)-2 do begin
				temp[count_fwd] = (h_now[count_fwd+1]-h_now[count_fwd])/(anytim(t_now[count_fwd+1])-anytim(t_now[count_fwd]))
			endfor
			v_fwd_all = [v_fwd_all, temp]
		endelse

		; LINEAR
		if keyword_set(linear) AND (n_elements(t_now) ge 2) then begin
			any_fit = 1
                        t_norm = anytim(t_now) - anytim(t_now[0])
                        fit = 'p[0]*x + p[1]'
                        fun = mpfitexpr(fit, t_norm, h_now, /quiet)
                        h_fit = fun[0]*t_norm + fun[1]
                        if ~keyword_set(no_plots) then outplot, t_now, h_fit/1000., psym=-3, thick=1
                        v_fit = replicate(fun[0], n_elements(t_now))
                        a_fit = replicate(0, n_elements(t_now))
                        if flag_init eq 1 then begin
                                v_all = [v_all, v_fit]
                                v_all_angles = [v_all_angles, replicate(i,n_elements(v_fit))]
                                a_all = [a_all, a_fit]
                                t_all = [t_all, t_now]
                                kins_counter = [kins_counter,n_elements(pos_ind)]
                                kins_color = [kins_color, (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))]
                        endif else begin
                                v_all = v_fit
                                v_all_angles = replicate(i,n_elements(v_fit))
                                a_all = a_fit
                                t_all = t_now
                                kins_counter = n_elements(pos_ind)
                                kins_color = (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))
                                flag_init = 1
                        endelse
                        goto, jump4
                endif
		; QUADRATIC
		if keyword_set(quadratic) AND (n_elements(t_now) ge 3) then begin
			any_fit = 1
			t_norm = anytim(t_now) - anytim(t_now[0])
			fit = '0.5*p[0]*x^2. + p[1]*x + p[2]'
			fun = mpfitexpr(fit, t_norm, h_now, /quiet)
			h_fit = 0.5*fun[0]*t_norm^2. + fun[1]*t_norm + fun[2]
			if ~keyword_set(no_plots) then outplot, t_now, h_fit/1000., psym=-3, thick=1
			v_fit = fun[0]*t_norm + fun[1]
			a_fit = replicate(fun[0],n_elements(t_now))
			if flag_init eq 1 then begin
                                v_all = [v_all, v_fit]
                                v_all_angles = [v_all_angles, replicate(i,n_elements(v_fit))]
                                a_all = [a_all, a_fit]
                                t_all = [t_all, t_now]
                                kins_counter = [kins_counter,n_elements(pos_ind)]
                                kins_color = [kins_color, (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))]
                        endif else begin
                                v_all = v_fit
                                v_all_angles = replicate(i,n_elements(v_fit))
                                a_all = a_fit
                                t_all = t_now
                                kins_counter = n_elements(pos_ind)
                                kins_color = (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))
                                flag_init = 1
                        endelse
			goto, jump4
		endif
		; SAVITZKY-GOLAY
		if keyword_set(sav_gol) AND (n_elements(t_now) ge 7) then begin
			any_fit = 1
			h_fit = convol(h_now,savgol(nleft,nright,0,degree,/double),/edge_truncate,/nan)
			if ~keyword_set(no_plots) then outplot, t_now, h_fit/1000., psym=-3, thick=0.5
			stepsize = dblarr(n_elements(t_now)-1)
			for i_temp=1,n_elements(t_now)-1 do stepsize[i_temp-1] = anytim(t_now[i_temp]) - anytim(t_now[i_temp-1])
			v_fit = 1/(ave(stepsize))*convol(h_now,savgol(nleft,nright,1,degree,/double),/edge_truncate,/nan)
			a_fit = 2/((ave(stepsize))^2.)*convol(h_now,savgol(nleft,nright,2,degree,/double),/edge_truncate,/nan)
			if flag_init eq 1 then begin
                                v_all = [v_all, v_fit]
                                v_all_angles = [v_all_angles, replicate(i,n_elements(v_fit))]
                                a_all = [a_all, a_fit]
                                t_all = [t_all, t_now]
                                kins_counter = [kins_counter,n_elements(pos_ind)]
                                kins_color = [kins_color, (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))]
                        endif else begin
                                v_all = v_fit
                                v_all_angles = replicate(i,n_elements(v_fit))
                                a_all = a_fit
                                t_all = t_now
                                kins_counter = n_elements(pos_ind)
                                kins_color = (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))
                                flag_init = 1
                        endelse
			goto, jump4
		endif
		if ~keyword_set(quadratic) AND ~keyword_set(sav_gol) AND (n_elements(t_now) ge 3) then begin
			any_fit = 1
			v_now = deriv(anytim(t_now)-anytim(t_now[0]),h_now)
			a_now = deriv(anytim(t_now)-anytim(t_now[0]),v_now)
			if flag_init eq 1 then begin
				v_fwds = [v_fwds, v_fwd]
				v_all = [v_all, v_now]
				v_all_angles = [v_all_angles, replicate(i,n_elements(v_now))]
				a_all = [a_all, a_now]
				t_all = [t_all, t_now]
				kins_counter = [kins_counter,n_elements(pos_ind)]
				kins_color = [kins_color, (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))]
			endif else begin
				v_fwds = v_fwd
				v_all = v_now
				v_all_angles = replicate(i,n_elements(v_now))
				a_all = a_now
				t_all = t_now
				kins_counter = n_elements(pos_ind)
				kins_color = (i-min(pos_angles)) * (255./(max(pos_angles)-min(pos_angles)))
				flag_init = 1
			endelse
			goto, jump4
		endif
		jump4:
	endif
endfor

if any_fit eq 0 then goto, jump_end

;*** Plots the interquartile range of the original height-time data.
;if keyword_set(plot_quartiles) then begin
;	set_line_color
;	if keyword_set(tog) AND ~keyword_set(debug) then c=0 else c=1
;	outplot, t_bins, h_meds/1000., utbasedata, psym=-3, thick=1, color=c, line=0
;	outplot, t_bins, h_q1s/1000., utbasedata, psym=-3, thick=1, color=c, line=2
;	outplot, t_bins, h_q3s/1000., utbasedata, psym=-3, thick=1, color=c, line=2
;	outplot, t_bins, lowerfence/1000., utbasedata, psym=-3, thick=1, color=c, line=1
;	outplot, t_bins, upperfence/1000., utbasedata, psym=-3, thick=1, color=c, line=1
;endif else begin
	;if keyword_set(plot_median) then outplot, t_bins, h_meds/1000., utbasedata, psym=-3, thick=1, color=c, line=0
;endelse
;***

if keyword_set(model) then begin
        horline, 2.25*700., linestyle=1
        horline, 5.75*700., linestyle=1
        horline, 6*700., linestyle=2
        horline, 16*700., linestyle=2
endif else begin
        horline, 2.2*695.5, linestyle=2
	xyouts, 50000, 1800, 'C2', charsize=1
        ;horline, 5.7*695.5, linestyle=2
        horline, 6.*695.5, linestyle=2
	xyouts, 50000, 4400, 'C3', charsize=1
        ;horline, 25.*695.5, linestyle=2
	;xyouts, 100, 17000, '25R'
endelse

if keyword_set(tog) AND ~keyword_set(debug) then begin
	loadct, 13
	if min(pos_angles) ne max(pos_angles) then $
		colorbar, minra=min(pos_angles),maxra=max(pos_angles),ncol=255,pos=[0.195,0.86,0.495,0.875],$
		tit='Position Angle (deg.)', charsize=plot_char+0.5, xtit='' $
		else legend, 'Position angle '+int2str(pos_angles[0]), /right, box=0, charsize=plot_char
endif

; Plot the velocity corresponding to the heights at each position angle
utplot, t_all[0:kins_counter[0]-1], v_all[0:kins_counter[0]-1], utbasedata, psym=1, ytit='Velocity (km s!U-1!N)', $
	xr=[xls,xrs], /xs, yr=[0,vel_max_range], /ys, pos=[.15,0.34,0.92,0.62], /nolabel, $
	xtickname=[' ',' ',' ',' ',' ',' ',' '], xtit='', /nodata;, color=kins_color[0]
print, 'plotting 0 up to ', kins_counter[0]-1, ' as color ', kins_color[0]
outplot, t_all[0:kins_counter[0]-1], v_all[0:kins_counter[0]-1], psym=1, color=kins_color[0]
if size(kins_counter,/dim) ne 0 then begin
	first_t = kins_counter[0]
	last_t = kins_counter[0]+(kins_counter[1]-1)
	for i=1,n_elements(kins_counter)-2 do begin
                if (last_t) lt n_elements(v_all) then begin
                        print, 'plotting ', first_t, ' up to ', last_t, ' as color ', kins_color[i]
                        outplot, t_all[first_t:last_t], v_all[first_t:last_t],psym=1,$
                                color=kins_color[i]
                        first_t = last_t + 1
                        last_t = first_t + (kins_counter[i+1]-1)
                endif else begin
                        goto, loop_exit1
                endelse
        endfor
        print, 'final plotting ', first_t, ' up to ', n_elements(t_all)-1, ' as color ', kins_color[n_elements(kins_color)-1]
        outplot, t_all[first_t:n_elements(t_all)-1], v_all[first_t:n_elements(t_all)-1], psym=1, color=kins_color[n_elements(kins_color)-1]
endif
loop_exit1:
; PLOT INTERQUARTILES
v_right_now = v_all[where(t_all eq min(t_all))]
v_meds = median(v_right_now)
v_q1s = median(v_right_now[where(v_right_now ge v_meds)]);upper quartile
v_q3s = median(v_right_now[where(v_right_now le v_meds)]);lower quartile
v_iqr = v_q1s - v_q3s ;interquartile range
lowerfence = v_q1s - 1.5*v_iqr
upperfence = v_q3s + 1.5*v_iqr
t_bins = t_all[uniq(t_all,sort(t_all))]
for i=1,n_elements(t_bins)-1 do begin
	v_right_nows = v_all[where(t_all eq t_bins[i])]
	v_meds = [v_meds, median(v_right_nows)]
	v_q1s = [v_q1s,median(v_right_nows[where(v_right_nows ge v_meds[i])])]
	v_q3s = [v_q3s,median(v_right_nows[where(v_right_nows le v_meds[i])])]
	v_iqr = v_q1s[i] - v_q3s[i]
        lowerfence = [lowerfence, v_q1s[i] - 1.5*v_iqr]
        upperfence = [upperfence, v_q3s[i] + 1.5*v_iqr]
endfor
if keyword_set(plot_quartiles) then begin
	outplot, t_bins, v_meds, utbasedata, psym=-3, thick=thick_t, color=c, line=0
	outplot, t_bins, v_q1s, utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, v_q3s, utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, lowerfence, utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, upperfence, utbasedata, psym=-3, thick=thick_t, color=c, line=2
	;horline, median(v_all), line=4
	;legend, 'Median vel: '+int2str(median(v_all))+' km s!U-1!N', box=0, charsize=plot_char
        ;legend, 'Max median vel: '+int2str(max(v_meds))+' km s!U-1!N', box=0, charsize=plot_char, /right
endif else begin
	if keyword_set(plot_median) then begin
		outplot, t_bins, v_meds, utbasedata, psym=-3, thick=thick_t, color=c, line=0
		horline, median(v_all), line=4
		legend, 'Median vel: '+int2str(median(v_all))+' km s!U-1!N', box=0, charsize=plot_char
		legend, 'Max median vel: '+int2str(max(v_meds))+' km s!U-1!N', box=0, charsize=plot_char, /right
	endif
endelse

;***

; Plot the acceleration corresponding to the heights at each position angle
utplot, t_all[0:kins_counter[0]-1], a_all[0:kins_counter[0]-1]*1000., utbasedata, psym=1, ytit='Acceleration (m s!U-2!N)', $
        xr=[xls,xrs], /xs, yr=[-accel_max_range,accel_max_range], /ys, pos=[0.15,0.05,0.92,0.33], /nodata; ,color=kins_color[0]
print, 'plotting 0 up to ', kins_counter[0]-1, ' as color ', kins_color[0]
outplot, t_all[0:kins_counter[0]-1], a_all[0:kins_counter[0]-1]*1000., psym=1, color=kins_color[0]
if size(kins_counter,/dim) ne 0 then begin
        first_t = kins_counter[0]
        last_t = kins_counter[0]+(kins_counter[1]-1)
        for i=1,n_elements(kins_counter)-2 do begin
                if last_t lt n_elements(a_all) then begin
                        print, 'plotting ', first_t, ' up to ', last_t, ' as color ', kins_color[i]
                        outplot, t_all[first_t:last_t], a_all[first_t:last_t]*1000.,psym=1,$
                                color=kins_color[i]
                        first_t = last_t + 1
                        last_t = first_t + (kins_counter[i+1]-1)
                endif else begin
                        goto, loop_exit2
                endelse
        endfor
        print, 'final plotting ', first_t, ' up to ', n_elements(t_all)-1, ' as color ', kins_color[n_elements(kins_color)-1]
        outplot, t_all[first_t:n_elements(t_all)-1], a_all[first_t:n_elements(t_all)-1]*1000., psym=1, color=kins_color[n_elements(kins_color)-1]
endif
loop_exit2:
horline, 0, linestyle=0, thick=1

; PLOT INTERQUARTILES
a_right_now = a_all[where(t_all eq min(t_all))]
a_meds = median(a_right_now)
a_q1s = median(a_right_now[where(a_right_now ge a_meds)]);upper quartile
a_q3s = median(a_right_now[where(a_right_now le a_meds)]);lower quartile
a_iqr = a_q1s - a_q3s ;interquartile range
lowerfence = a_q1s - 1.5*a_iqr
upperfence = a_q3s + 1.5*a_iqr
for i=1,n_elements(t_bins)-1 do begin
        a_right_nows = a_all[where(t_all eq t_bins[i])]
        a_meds = [a_meds, median(a_right_nows)]
        a_q1s = [a_q1s,median(a_right_nows[where(a_right_nows ge a_meds[i])])]
        a_q3s = [a_q3s,median(a_right_nows[where(a_right_nows le a_meds[i])])]
	a_iqr = a_q1s[i] - a_q3s[i]
        lowerfence = [lowerfence, a_q1s[i] - 1.5*a_iqr]
        upperfence = [upperfence, a_q3s[i] + 1.5*a_iqr]
endfor
if keyword_set(plot_quartiles) then begin
	outplot, t_bins, a_meds*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=0
	outplot, t_bins, a_q1s*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, a_q3s*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, lowerfence*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=2
	outplot, t_bins, upperfence*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=2
	;horline, median(a_all)*1000., line=4
	;legend, 'Median accel: '+int2str(median(a_all)*1000.)+' m s!U-2!N', box=0, charsize=plot_char
        ;legend, 'Max median accel: '+int2str(max(a_meds)*1000.)+' m s!U-2!N', box=0, charsize=plot_char, /right
endif else begin
	if keyword_set(plot_median) then begin
		outplot, t_bins, a_meds*1000., utbasedata, psym=-3, thick=thick_t, color=c, line=0
		horline, median(a_all)*1000., line=4
		legend, 'Median accel: '+int2str(median(a_all)*1000.)+' m s!U-2!N', box=0, charsize=plot_char
		legend, 'Max median accel: '+int2str(max(a_meds)*1000.)+' m s!U-2!N', box=0, charsize=plot_char, /right
	endif
endelse

;***

pos_angles = pos_angles_init

if keyword_set(saves) then begin
	print, 'saving v_fwd_all.sav'
	save, v_fwd_all, f='v_fwd_all.sav'
	print, 'saving v_all.sav'
	save, v_all, f='v_all.sav'
	print, 'Saving v_all_angles.sav'
	save, v_all_angles, f='v_all_angles.sav'
	print, 'saving v_fwds.sav'
	save, v_fwds, f='v_fwds.sav'
	print, 'Saving v_fit_all.sav'
	save, v_fit_all, f='v_fit_all.sav'
	print, 'Saving v_fit_angles.sav'
	save, v_fit_angles, f='v_fit_angles.sav'

endif

jump_end:

if !d.name eq 'PS' then begin
	device, /close_file
	set_plot, 'x'
endif

end
