; Created	2014-04-30	to perform fixed differencing on a set of images to be read in from a source directory of the fits files.


; INPUT		- fls		the fits files 

; KEYWORDS	- fixed		default is running difference so this keyword specifies fixed difference


function differencing, fls, fixed=fixed

mreadfits_corimp, fls, in, da

diff = dblarr(in[0].naxis1, in[0].naxis2, n_elements(in))

for i=0,n_elements(in)-2 do begin
	if keyword_set(fixed) then diff[*,*,i] = da[*,*,i+1] - da[*,*,0] else $
		diff[*,*,i] = da[*,*,i+1] - da[*,*,i]
endfor

return, diff

end
