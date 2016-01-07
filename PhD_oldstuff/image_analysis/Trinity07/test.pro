pro test


restore, '~/PhD/Data_sav_files/in.sav'
restore, '~/PhD/Data_sav_files/dan.sav'

im1 = dan[*,*,7]
im2 = dan[*,*,8]

canny_atrous2d, im1, modgrad1, alpgrad1
canny_atrous2d, im2, modgrad2, alpgrad2

;save, modgrad1, f='modgrad1.sav'
;save, modgrad2, f='modgrad2.sav'
;save, alpgrad1, f='alpgrad1.sav'
;save, alpgrad2, f='alpgrad2.sav'

im1 = rm_inner((modgrad1[*,*,3]+modgrad1[*,*,4]+modgrad1[*,*,5])/modgrad1[*,*,0],in[7],dr_px,thr=2.5)
im1 = rm_outer(im1, in[7], dr_px, thr=7.)
im1 = rm_edges(im1, in[7], dr_px, edge=25.)

im2 = rm_inner((modgrad2[*,*,3]+modgrad2[*,*,4]+modgrad2[*,*,5])/modgrad2[*,*,0],in[8],dr_px,thr=2.5)
im2 = rm_outer(im2, in[8], dr_px, thr=7.)
im2 = rm_edges(im2, in[8], dr_px, edge=25.)

plot_image, im1^0.4
plot_image, im2^0.4


;alp1 = rm_inner((alpgrad1[*,*,3]+alpgrad1[*,*,4]+alpgrad1[*,*,5])/alpgrad1[*,*,0],in[7],dr_px,thr=2.5)
;alp1 = rm_outer(alp1, in[7], dr_px, thr=7.)
;alp1 = rm_edges(alp1, in[7], dr_px, edge=25.)

;alp2 = rm_inner((alpgrad2[*,*,3]+alpgrad2[*,*,4]+alpgrad2[*,*,5])/alpgrad2[*,*,0],in[8],dr_px,thr=2.5)
;alp2 = rm_outer(alp2, in[8], dr_px, thr=7.)
;alp2 = rm_edges(alp2, in[8], dr_px, edge=25.)


plot_image, alpgrad1[*,*,6]
plot_image, alpgrad2[*,*,6]


end
