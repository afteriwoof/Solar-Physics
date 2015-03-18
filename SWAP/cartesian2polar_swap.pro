; Created	2013-04-11	to use cartesian2polar_corimp for SWAP images.

function cartesian2polar_swap, in, da

; set up for cartesian2polar_corimp.pro
para = [0,360] ;range of position angles
rra = [1.,1.68] ;range of heights R_sun
npa = 360 ;desired no. of latitudinal bins output
nr = 200 ;desired no. of heights bins output
pix_size = ave([in.cdelt1,in.cdelt2]) / in.rsun_arc ;scaling factor for pixels in R_sun
roll = 0 ;roll of input image in degrees

imp = cartesian2polar_corimp(da, para, rra, npa, nr, in.crpix1, in.crpix2, pix_size, roll)

return, imp

end
