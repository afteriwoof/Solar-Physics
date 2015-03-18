; Created	2013-12-10	to gather the ells and create the kins plots.

; INPUTS	fl	-	the file extension to the event directory.

pro gather_kins, fl

;fl = '~/Postdoc/Data_Stereo/20130522/'

times = file_basename(file_search(fl+'recon/combining/*/*'))
dirs = file_search(fl+'recon/combining/*/*/my_scc_measure/slices_all')

for i=0,n_elements(times)-1 do begin

	cd, dirs[i]
	gather_ells, '../bogus.txt'
	gather_ells, '../bogus.txt', /fronts
	gather_ells, '../bogus.txt', /max_fronts
print, i
print, dirs[i]
pwd
pause

endfor



end
