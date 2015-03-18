; Created	2014-06-03	to loop over multiple inputs and determine the cme masses.

; INPUTS	startdate	- '2000-01-01'
;		enddate		- '2000-12-31'
;		in_dir		- '/Volumes/Bluedisk/detections'
;		out_dir		- '/Volumes/Bluedisk/detections'
;		mass_path	- '/Volumes/Bluedisk/cme_masses'

pro cmemass_all, startdate, enddate, in_dir, out_dir, mass_path

dates = anytim2cal(timegrid(startdate+' 00:00', enddate+' 23:59',/days), form=11)
days=anytim2cal(timegrid(startdate+' 00:00',enddate+' 23:59',/days),form=11,/da)

indir = in_dir+'/'+days

outdir = out_dir+'/'+days

index = where(dir_exist(indir), cntdir)
if cntdir eq 0 then begin
	print, 'No directories (cmemass_all)!'
	return
endif
index_many_arrays, index, dates, days, indir, outdir

; Loop over days
for i_days=0,cntdir-1 do cmemass, indir[i_days], mass_path, /tog
	

end
