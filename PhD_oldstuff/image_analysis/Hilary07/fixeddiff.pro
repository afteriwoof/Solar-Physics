pro fixeddiff, fdiff, sigfdiff

files = file_search('../18-apr-2000/*')

mreadfits, files, index, data

sz = size(data, /dim)

fdiff = fltarr( sz[0], sz[1], sz[2]-1 )
sigfdiff = fdiff

for i = 1, sz[2]-1 do begin

	fdiff[*,*,i-1] = data[*,*,i] - data[*,*,0]
	
	sigfdiff[*,*,i-1] = smooth( sigrange( data[*,*,i] - data[*,*,0] ), 5, /ed )

endfor





end
