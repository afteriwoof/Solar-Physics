pro jb_plot, file

file=file_search('18-apr-2000/*')

mreadfits, file, index, data

stop

kernelsize=[3,3]

kernel=FLTARR(kernelsize[0],kernelsize[1])

kernel[*,*]=-1

kernel[1,1]=8

filteredimage=CONVOL(FLOAT(image8), kernel, /CENTER, /EDGE_TRUNCATE)

window, /free, title='smoothed image laplacian filtered'

plot_image, filteredimage

end


