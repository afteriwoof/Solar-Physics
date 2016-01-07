PRO hello_world, name, INCLUDE_NAME=include

IF(keyword_set(include) && (N_elements(name) NE 0)) then begin
	print, 'hello world from '+name
endif else print, 'hello world'
end
