
kernelsize=[3,3]
        
kernel=FLTARR(kernelsize[0],kernelsize[1])
             
kernel[*,*]=-1

kernel[1,1]=8

print, 'kernel:'
print, kernel

l=CONVOL(FLOAT(s), kernel, /CENTER, /EDGE_TRUNCATE)

!p.multi=[0,3,1]
window, /free, title='Laplacian: img8, img9, diff8'
    
plot_image, img8_lp

img9_lp=convol(float(img9), kernel, /center, /edge_truncate)
plot_image, img9_lp

diff8_lp=convol(float(diff8), kernel, /center, /edge_truncate)
plot_image, diff8_lp




img8_scl_lp=CONVOL(FLOAT(img8_scl), kernel, /CENTER, /EDGE_TRUNCATE)
img9_scl_lp=CONVOL(FLOAT(img9_scl), kernel, /CENTER, /EDGE_TRUNCATE)
!p.multi=[0,2,1]
window, /free, title='Laplacian: img8_scl, img9_scl'
plot_image, img8_scl_lp
plot_image, img9_scl_lp


