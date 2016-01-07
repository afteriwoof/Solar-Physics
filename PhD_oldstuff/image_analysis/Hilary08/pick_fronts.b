temp = image
sz = size(image, /dim)
for i=0,sz[0]-1 do temp[*,abs(sz[0]-1-i)] = image[*,i]
im = temp
fronts = where(im ne 0)
ind = array_indices(im, fronts)
x = ind[0,*]
y = ind[1,*]

