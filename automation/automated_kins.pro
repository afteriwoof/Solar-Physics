; Created	2012-11-18	from automated_dublin.pro

; Last edited:	2012-12-11	
;		2012-12-12	to include keyword _extra which will be used to debug.
;		2013-11-08	to include keyword originals that outputs the detections on the original fits file images too.
;		2014-02-04	to fix up the saved filename date/time for consistency over the cleaned versions.

pro automated_kins, debug=debug, originals=originals

;window, xs=1024, ys=1024

if keyword_set(debug) then print, '*** automated_kins.pro ***'

;path = '~/Postdoc_largefiles/detections'
;path = '~/Sites/CORIMP'
path = '/Volumes/Bluedisk/detections'
;fits_dir = '~/Postdoc_largefiles/fits/'
fits_dir = '/Volumes/Bluedisk/fits/'
years = file_search(path+'/2013')
;years = file_search(path+'detections_dublin/a/cor2/2010')
;years = file_search(path+'detections_gail/2005')
fits_fls = '/*dynamics*fits*'
;fits_fls = '/original/*fits*'
dets_path = '/cme_dets/dets*'
mass_path = '/Volumes/Bluedisk/cme_masses'

goto, jump1

for i_years=0,0 do begin
	months = file_search(years[i_years]+'/*')
        ;for i_months = 0,n_elements(months)-1 do begin
        for i_months = 1,1 do begin
                days = file_search(months[i_months]+'/*')
                for i_days=0,n_elements(days)-1 do begin
			dir = days[i_days]
			if i_years eq 0 && i_months eq 0 && i_days eq 0 then stack_fls = file_Search(dir+'/det_stack*') $
				else stack_fls = [stack_fls, file_Search(dir+'/det_stack*')]
		endfor
	endfor
endfor
print, stack_fls

; Save out the det_info_str_YYYYMMDD.sav into the relevant folders.
read_daily_stacks, stack_fls, years

jump1:
; Now gather the det_inf_str_*.sav

ans = ' '
read, 'Delete previous kinematic runs before proceeding? (y/n)', ans
if ans eq 'y' then begin
	print, 'Deleting any previous automated_kins.pro outputs in the file structure under ', years
        pause
	for i_years=0,n_elements(years)-1 do begin
		spawn, 'rm -f '+years[i_years]+'/*/*/*xml'
        	spawn, 'rm -f '+years[i_years]+'/*/*/det_info_str*sav'
        	spawn, 'rm -f '+years[i_years]+'/*/*/pa_total*.eps'
        	spawn, 'rm -f '+years[i_years]+'/*/*/rm_date*sav'
        	spawn, 'rm -f '+years[i_years]+'/*/*html'
        	spawn, 'rm -rf '+years[i_years]+'/*/*/cme_kins*'
        	spawn, 'rm -rf '+years[i_years]+'/*/*/cme_pngs*'
        	spawn, 'rm -rf '+years[i_years]+'/*/*/cme_ims*'
        	spawn, 'rm -rf '+years[i_years]+'/*/*/cme_profs'
        	spawn, 'rm -rf '+years[i_years]+'/*/*/cme_masses'
	endfor
endif

;for i_years=0,n_elements(years)-1 do begin
;for i_years=0,0 do begin
i_years = 0
	months = file_search(years[i_years]+'/*')
        ;for i_months = 0,n_elements(months)-1 do begin
        for i_months = 1,1 do begin
                days = file_search(months[i_months]+'/*')
               	; be sure it's only the directories and not the html
		test = strpos(days, 'html')
		test = where(test eq -1)
		days = days[test]
		print, days
		for i_days = 0,n_elements(days)-1 do begin
                ;for i_days = 0,0 do begin
			dir = days[i_days]
			print, '********'
			print, dir
			print, '********'
			current_year = strmid(dir,strlen(dir)-10,4)
			current_month = strmid(dir,strlen(dir)-5,2)
			current_day = strmid(dir,strlen(dir)-2,2)
			fls = file_search(fits_dir+current_year+'/'+current_month+'/'+current_day+fits_fls)
			fls = sort_fls(fls)
			;png_fls = file_search(dir+'/cme_pngs/*png')
			stack_fl = file_search(dir+'/det_stack*')
			if strlen(stack_fl) eq 0 then goto, jump4
			restore, stack_fl
			; condition that if there was only one image in the detection stack, skip it!
			if n_elements(size(det_stack.stack,/dim)) eq 1 then goto, jump4
			pa_total = det_stack.stack
			clean_pa_total, pa_total, pa_mask, debug=debug
			if keyword_set(debug) then begin
				print, 'dir ', dir
				print, 'current_year ', current_year
				print, 'current_month ', current_month
				print, 'current_day ', current_day
				print, 'fls[0] ', fls[0]
				print, 'stack_fl ', stack_fl
				help, det_stack, /str
				loadct, 39
				window, xs=1000, ys=1000
				!p.multi=[0,1,3]
				!p.charthick=1
				!p.charsize=2
				plot_image, pa_total, tit='pa_total initially'
				pause
				plot_image, pa_mask, tit='pa_mask'
				pause
				plot_image, pa_total*pa_mask, tit='pa_total cleaned'
				pause
			endif
			pa_total *= pa_mask
			pa_total_eps = pa_total
			separate_pa_total, pa_total, det_info, debug=debug
			if n_elements(det_info) eq 1 then begin
				if det_info eq 0 then goto, jump4
			endif
			if keyword_set(debug) then begin
				print, 'size(pa_total,/dim) ', size(pa_total,/dim)
				print, 'det_info ', det_info
				pause
			endif
			; if detection stack has ROIs that cross to next day, include those.
			if (where(det_info[3,*] eq n_elements(fls)-1) ne [-1]) then begin
				read_daily_stacks, stack_fl, dir, new_det_info, new_pa_total, count_days, /single_file, debug=debug
				if keyword_set(debug) then print, '(where(det_info[3,*] eq n_elements(fls)-1) ne [-1])'
				; combine the new_det_info with the current day's det_info
;				if n_elements(new_det_info) eq 0 then goto, jump3
				sz_det = size(new_det_info,/dim)
				if keyword_set(debug) then begin
					print, 'det_info goes off top of image'
					help, new_det_info
					print, 'sz_det ', sz_det
					print, 'count_days ', count_days
					pause
				endif
;				if n_elements(sz_det) gt 1 then loop_end=sz_det[1] else loop_end=1
;				for i=0,loop_end-1 do begin
;					temp_det_info = intarr(4)
;					temp_det_info[*] = new_det_info[*,i]
;					ind_1 = where(det_info eq temp_det_info[0])
;					if keyword_set(debug) then begin
 ;                                               help, new_det_info
  ;                                              print, 'new_det_info[*,i] ', new_det_info[*,i]
   ;                                             print, 'temp_det_info ', temp_det_info
;						print, 'ind_1 ', ind_1
;						pause
 ;                                       endif
;					if n_elements(ind_1) gt 1 then begin
;						ind_2 = where(det_info eq temp_det_info[1])
;						print, 'ind_2 ', ind_2
;						if n_elements(ind_2) gt 1 then begin
;							ind_3 = where(det_info eq temp_det_info[2])
;							print, 'ind_3 ', ind_3
;							if n_elements(ind_3) gt 1 then ind_2 =ind_2[0] else correct_ind_1 = ind_3 - 2
;						endif
;						if ~exist(correct_ind_1) then correct_ind_1 = ind_2 - 1
;					endif
;					if ~exist(correct_ind_1) then correct_ind_1 = ind_1
;					if keyword_set(debug) then print, 'correct_ind_1 ', correct_ind_1
;					if correct_ind_1+3 gt n_elements(det_info) then goto, jump3
;					det_info[correct_ind_1:correct_ind_1+3] = temp_det_info
;					delvarx, correct_ind_1
;				endfor
				i = 1
				while i le count_days do begin
					next_date = anytim(anytim(current_year+'/'+current_month+'/'+current_day, /sec)+(86400.*i),/date_only,/ecs)
					next_dir = strmid(dir, 0, strlen(dir)-10) + next_date
					if strlen(file_search(next_dir)) eq 0 then begin
						det_fls = file_Search(dir+dets_path)
                                		stack_fls = file_search(dir+'/det_stack*')
					endif else begin
						if n_elements(file_search(fits_dir+next_date+fits_fls)) gt 1 then begin
							fls = [fls, file_search(fits_dir+next_date+fits_fls)]
						endif else begin
							if strlen(file_search(fits_dir+next_date+fits_fls)) ne 0 then fls = [fls, file_search(fits_dir+next_date+fits_fls)]
						endelse
						if i eq 1 then det_fls = [file_search(dir+dets_path), file_search(next_dir+dets_path)] $
							else det_fls = [det_fls, file_search(next_dir+dets_path)]
						if i eq 1 then stack_fls = [stack_fl, file_search(next_dir+'/det_stack*')] else $
							stack_fls = [stack_fls, file_search(next_dir+'/det_stack*')]
						;png_fls = [png_fls, file_search(next_dir+'/cme_pngs/*png')]
					endelse
					i += 1
				endwhile
				if exist(new_det_info) then det_info = new_det_info				
				if exist(new_pa_total) then pa_total = new_pa_total
				delvarx, new_det_info, new_pa_total
				if keyword_set(debug) then begin
					plot_image, pa_total, tit='pa_total as it now appears in automated_kins.pro'
					help, fls
					print, 'fls[0] ', fls[0]
					print, 'fls[n_elements(fls)-1] ', fls[n_elements(fls)-1]
					print, 'fls[max(det_info[3,*])] ', fls[max(det_info[3,*])]
					help, det_fls
					print, 'det_fls[0] ', det_fls[0]
					print, 'det_fls[n_elements(det_fls)-1] ', det_fls[n_elements(det_fls)-1]
					;help, png_fls
					;print, 'png_fls[0] ', png_fls[0]
					;print, 'png_fls[n_elements(png_fls)-1]', png_fls[n_elements(png_fls)-1]
					sz = size(det_info,/dim)
					if n_elements(sz) gt 1 then i_end=sz[1]-1 else i_end=0
					for i=0,i_end do begin
						plots, [det_info[0,i],det_info[0,i]], [det_info[2,i],det_info[3,i]]
					        plots, [det_info[1,i],det_info[1,i]], [det_info[2,i],det_info[3,i]]
					        plots, [det_info[0,i],det_info[1,i]], [det_info[2,i],det_info[2,i]]
					        plots, [det_info[0,i],det_info[1,i]], [det_info[3,i],det_info[3,i]]
					endfor
					print, 'det_info'
					print, det_info
					pause
				endif
			endif else begin
				jump3:
				if keyword_set(debug) then print, '(where(det_info[3,*] eq n_elements(fls)-1) eq [-1])'
				temp = rm_prev_date(stack_fl, dir, debug=debug)
				if n_elements(size(temp,/dim)) eq 2 then pa_total = temp
				if keyword_set(debug) then plot_image, pa_total, tit='pa_total with prev removed but not overlap to next day'
				separate_pa_total, pa_total, det_info, debug=debug
				det_fls = file_Search(dir+dets_path)
				stack_fls = file_search(dir+'/det_stack*')
			endelse
			if n_elements(det_info) eq 1 then begin
                                if det_info eq 0 then goto, jump4
                        endif
			mreadfits_corimp, fls, in, /quiet
                        r_sun = ave(in.rsun)
                        make_pa_total_plot, pa_total_eps, dir+'/pa_total_'+current_year+current_month+current_day+'.eps', det_info, r_sun
                        ; can also do it so it's the full detections only: make_pa_total_plot, pa_total, dir+'/pa_total.eps', det_info, r_sun
			delvarx, pa_total_eps
			if ~dir_exist(dir+'/cme_profs') then spawn, 'mkdir -p '+dir+'/cme_profs'
			if keyword_set(debug) then begin
				help, stack_fls
				print, 'stack_fls: ', stack_fls
			endif
			; Check that each stack_fls is a real entry (exists in the directory that was searched):
			stack_fls = stack_fls[where(strlen(stack_fls) ne 0)]
			
			find_pa_heights_all_redo, fls, pa_total, det_info, det_fls, stack_fls, dir+'/cme_profs', debug=debug
			
			cme_prof_fls=file_Search(dir+'/cme_profs/cme_prof_*sav')
			if ~dir_exist(dir+'/cme_profs/cme_kin_profs') then spawn, 'mkdir -p '+dir+'/cme_profs/cme_kin_profs'
			; commented out these lines to avoid over-exaiminig with /debug set.
			;if keyword_set(debug) then find_pa_heights_masked, fls, pa_total, det_info, det_fls, stack_fls, cme_prof_fls, dir+'/cme_profs/cme_kin_profs',debug=debug $
			;	else find_pa_heights_masked, fls, pa_total, det_info, det_fls, stack_fls, cme_prof_fls, dir+'/cme_profs/cme_kin_profs',/no_plots
			find_pa_heights_masked, fls, pa_total, det_info, det_fls, stack_fls, cme_prof_fls, dir+'/cme_profs/cme_kin_profs',/no_plots;,debug=debug
			if ~dir_exist(dir+'/cme_kins') then spawn, 'mkdir -p '+dir+'/cme_kins'
			kin_fls = file_search(dir+'/cme_profs/yyyy-mm-dd_NN/*txt')
			extn_count = 0 ; intialise
			for i=0,n_elements(kin_fls)-1 do begin 
				readcol, kin_fls[i], datetimes, heights, angs, f='A, D, F'
				print, 'readcol ', kin_fls[i]
				if keyword_set(debug) then print, 'readcol ', kin_fls[i]
				if n_elements(datetimes) eq 0 then goto, jump2
				if keyword_set(debug) then begin
					print, 'datetimes[uniq(datetimes,sort(datetimes))]', datetimes[uniq(datetimes,sort(datetimes))]
					print, 'n_elements(datetimes[uniq(datetimes,sort(datetimes))]) ', n_elements(datetimes[uniq(datetimes,sort(datetimes))])
				endif
				if n_elements(datetimes[uniq(datetimes,sort(datetimes))]) ge 3 then begin
					angs_init = angs
					angs_clean = angs
					heights_clean = heights
					datetimes_clean = datetimes
					clean_heights, datetimes_clean, heights_clean, angs_clean
					test2 = n_elements(datetimes_clean[uniq(datetimes_clean,sort(datetimes_clean))])
					if test2 lt 4 then goto, jump2
					plot_kins_quartiles, datetimes_clean, heights_clean, angs_clean, dir+'/cme_kins', /linear, /plot_quartiles, /tog, debug=debug, /no_legend
					plot_kins_quartiles, datetimes_clean, heights_clean, angs_clean, dir+'/cme_kins', /quadratic, /plot_quartiles, /tog, debug=debug, /no_legend
					plot_kins_quartiles, datetimes_clean, heights_clean, angs_clean, dir+'/cme_kins', /sav_gol, /plot_quartiles, /tog, debug=debug, /no_legend
					; Group the pngs per event kinematics.
					t_label = (datetimes_clean[where(anytim(datetimes_clean) eq min(anytim(datetimes_clean)))])[0]
				        t_label = strmid(t_label,0,4)+strmid(t_label,5,2)+strmid(t_label,8,2)+'_'+strmid(t_label,11,2)+strmid(t_label,14,2)+strmid(t_label,17,2)
					datetimes_in = strmid(datetimes,0,4)+strmid(datetimes,5,2)+strmid(datetimes,8,2)+'_'$
						+strmid(datetimes,11,2)+strmid(datetimes,14,2)+strmid(datetimes,17,2)
					if dir_exist(dir+'/cme_ims_'+t_label) then begin
						extn_count = n_elements(file_search(dir+'/cme_ims_'+t_label+'*'))
						print, 'dir_exists: ', dir+'/cme_ims_'+t_label
						extn = '_'+int2str(extn_count)
					endif else begin
						extn = ''
					endelse
					spawn, 'mkdir -p '+dir+'/cme_ims_'+t_label+extn
					spawn, 'mkdir -p '+dir+'/cme_ims_'+t_label+extn+'/c3/'
					spawn, 'mkdir -p '+dir+'/cme_ims_'+t_label+extn+'/c2/'

					if keyword_set(debug) then window, xs=1024, ys=1024

					gather_gail_detections_inset_all_device, fls, det_fls, datetimes_in, angs_init, angs_clean, dir+'/cme_ims_'+t_label+extn, debug=debug
					gather_gail_detections_inset_all_device, fls, det_fls, datetimes_in, angs_init, angs_clean, dir+'/cme_ims_'+t_label+extn, debug=debug, /c2
				
					if keyword_set(originals) then begin
						datetimes_in = strmid(datetimes,0,4)+strmid(datetimes,5,2)+strmid(datetimes,8,2)+'_'$
                                                	+strmid(datetimes,11,2)+strmid(datetimes,14,2)+strmid(datetimes,17,2)
						spawn, 'mkdir -p '+dir+'/cme_ims_orig_'+t_label+extn+'/c3'
						spawn, 'mkdir -p '+dir+'/cme_ims_orig_'+t_label+extn+'/c2'
						flso = strarr(n_elements(fls))
						for flso_i=0,n_elements(fls)-1 do $
							flso[flso_i] = strmid(fls[flso_i],0,(strsplit(fls[flso_i],'/'))[n_elements(strsplit(fls[flso_i],'/'))-1])$
							+'original/'+str_replace(file_basename(fls[flso_i]),'dynamics','original')
						gather_gail_detections_inset_all_device, flso, det_fls, datetimes_in, angs_init, angs_clean, dir+'/cme_ims_orig_'+t_label+extn, debug=debug
						gather_gail_detections_inset_all_device, flso, det_fls, datetimes_in, angs_init, angs_clean, dir+'/cme_ims_orig_'+t_label+extn, debug=debug, /c2
					endif
				endif
				delvarx, fls1, fls2, det_fls1, det_fls2, datetimes_in1, datetimes_in2, angs_init1, angs_init2, angs1, angs2
				delvarx, datetimes, heights, angs, pa_total, det_info
				jump2:
			endfor 
			
			; Determine CME mass
			cmemass, dir, mass_path, /tog


			jump4:
                endfor ;end days
        endfor ; end months
;endfor ;end years


end
