pro meanprobs, data, diff, sigdiff

;Reading in the images and plotting the contoured images with a level specified by the threshold of sigma.

files = file_search('18-apr-2000/*')

mreadfits, files, index, data

sz = size(data, /dim)

;Create the arrays for the difference images with appropriate dimensions.

diff = fltarr(sz[0],sz[1],sz[2]-1)

sigdiff = diff

for i = 1, sz[2]-1 do begin
	diff[*,*,i-1] = data[*,*,i] - data[*,*,i-1]
	sigdiff[*,*,i-1] = smooth(sigrange(data[*,*,i] - data[*,*,i-1]), 5, /ed)
endfor

szd = size(diff, /dim)

sigdiff3 = sigdiff[*,*,3]
sigdiff4 = sigdiff[*,*,4]
sigdiff8 = sigdiff[*,*,8]
sigdiff9 = sigdiff[*,*,9]







end

