pro snr_multiscale

restore, '~/PhD/Data_sav_files/dan.sav'
restore, '~/PhD/Data_sav_files/in.sav'

im9 = dan[*,*,9]

canny_atrous2d, im9, modgrad, alpgrad

set_line_color

; Found 3+4+5/0 is the best combination it seems, but NOT dividing by 0 is better!!!

window, 9
plot, (modgrad[*,150,3]+modgrad[*,150,4]+modgrad[*,150,5])/modgrad[*,150,0], color=3

window, 4
plot, (modgrad[*,150,3]+modgrad[*,150,4]+modgrad[*,150,5])

loadct, 0


window, 12
plot_image, ((modgrad[*,*,3]+modgrad[*,*,4]+modgrad[*,*,5])/(modgrad[*,*,0]+modgrad[*,*,1]))^0.4

window, 13
plot_image, bytscl((modgrad[*,*,3]+modgrad[*,*,4]+modgrad[*,*,5])/modgrad[*,*,0], 0, .005)

end
