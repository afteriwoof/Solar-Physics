;2006
;written by Huw Morgan, Solar Post-doc at IfA hawaii
;hmorgan@ifa.hawaii.edu

pro build_loop_array,var,arr,concat=concat,onedim=onedim,reset=reset, $
		freeptr=freeptr

;very useful procedure for building arrays within loops. 
;Simple example. Instead of:

;for i=0,n-1 do begin
; a=some_variable_or_array
; if i eq 0 then array=a else array=[array,a]
;endfor

;we can just use
;for i=0,n-1 do begin
; a=some_variable_or_array
; build_loop_array,a,array
;endfor

;most useful for stacking or concatenating arrays. Of course
;can not stack arrays of different dimensions

;DEFAULT is to stack arrays, for example if var is 2D array dimension size 3,5
;and this procedure called 7 times (for i=0,6 do build_loop_array,var,arr)
;then array would build to array of dimension 3,5,7

;Keyword CONCAT
;With /concat set, variable is assumed to be
;of same dimension as array, for example if var is 2D array dimension 3,5
;and this procedure called 7 times (for i=0,6 do build_loop_array,var,arr,/concat)
;then array would build to array of dimension 3,35

;keyword ONEDIM
;onedim keyword just concatenates arrays like this: arr=[arr,var] regardless
;of array dimension, So if var is 2d array dimension 3,5 and this procedure is
;called 7 times (for i=0,6 do build_loop_array,var,arr,/onedim)
;then array would just build to array of dimension 21,5

;reset is to start arr again, i.e. for i=0,6 do build_loop_array,var,arr,reset=(i eq 0)

;can do with some obvious improvements i.e. test var and arr to see if they can
;be stacked and to return error if not, test type of var and arr etc.
;Also, is there not a more elegant way of doing this????


svar=size(var)
typ=size(var,/type)

if n_elements(arr) eq 0 or keyword_set(reset) then arr=[var] else begin
	if svar[0] eq 0 or keyword_set(onedim) or typ eq 8 $
		then arr=[arr,var] $
	else begin
		if keyword_set(concat) then $
		arr=transpose([transpose(arr),transpose(var)]) $
		else begin
			sarr=size(arr)
			sarr3=sarr[0] eq svar[0]?1:sarr[svar[0]+1]
			for i=1,svar[0] do build_loop_array,sarr[i],dimension
			dimension=[dimension,sarr3+1]
			arrt=make_array(dimension=dimension,/index)
			arrt[arrt[0:((n_elements(var)*(sarr3))-1)]]=arr[*]
			arrt[arrt[(n_elements(var)*(sarr3)):*]]=var[*]
			arr=arrt
		endelse
	endelse
endelse

if typ eq 8 and keyword_set(freeptr) then ptr_free_huw,var

end
