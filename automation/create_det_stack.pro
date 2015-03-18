; Created	2014-05-09	to create the det_stack from a series of dets that were run independently rather than as a block (so the pa_total wasn't built up). This is important for the realtime implementation.

; INPUTS	the list of dets

pro create_det_stack

; Testing
fls = file_Search('/Volumes/Bluedisk/fits/2003/01/01/*fits*')
dets = file_Search('/Volumes/Bluedisk/detections/2003/01/01/cme_dets/dets*.sav')

filenames = file_basename(fls)
detsnames = file_basename(dets)
tmp1 = strmid(filenames,23,15)
tmp2 = strmid(detsnames,5,15)

flag = 0
for i=0,n_elements(tmp1)-1 do begin & $
	res = strmatch(tmp2,tmp1[i]) & $
	test = where(res eq 1,cnt) & $
	if cnt gt 0 then begin & $
		case flag of & $
		0: 	begin & $
			gather_filenames = filenames[i] & $
			flag = 1 & $
			end & $
		1:	gather_filenames=[gather_filenames,filenames[i]] & $
		endcase & $
	endif & $
endfor



end
