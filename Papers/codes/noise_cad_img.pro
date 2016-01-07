; Routine  to produce three-dimensional plot showing the variation in
; cadence and noise for the kinematics paper.

pro noise_cad_img, weight = weight, display = display, first_go = first_go

; Simulated data
  
  r_0 = 50.                     ; Mm
  v_0 = 0.4                     ; km/s
  a_0 = -0.00015                ; m/s/s

  fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'

; Number of iterations
  n_iter = 1000.
    
; Cadence jumps
  delta_t = 1
  max_cad = 720./delta_t

; Noise jumps
  max_noise = 40.
  delta_n = 0.05

; Acceleration binsize
  acc_range = 500.
  acc_bin = 1.

; Distance model
  t = findgen((2400/delta_t)+1)             ; 2400s total time
  d = r_0 + v_0*t + (1./2.)*a_0*t^2.

  if keyword_set(first_go) then begin
     
; Arrays
;     iter_acc = fltarr(n_iter+1)
;     noise_vary_acc = fltarr((max_cad/delta_t)+1, (max_noise/delta_n)+1, (acc_range/acc_bin)+1)
     
; Vary the cadence
     for vary_cad = 1, max_cad, 1 do begin
        
; Vary the noise
        for vary_noise = delta_n, max_noise, delta_n do begin
           
           percent = (vary_noise/0.99)*0.68
                      
; For 10,000 iterations
           for k = 0, n_iter do begin
           
		 print, 'vary_cad ', vary_cad, ' of ', max_cad, ' vary_noise ', vary_noise, ' of ', max_noise,  ' k ', k, ' of ', n_iter

              noise = randomn(seed, (2400/delta_t)+1)
   
              r_noise = noise*((d/100.)*percent)
              sim_d = r_0 + v_0*t + (1./2.)*a_0*t^2. + r_noise
              
              if keyword_set(weight) then err_d = replicate(1, (2400/delta_t)+1) else err_d = (sim_d/100d)*percent
              
; Original fit to data
              if keyword_set(weight) then fit = mpfitexpr(fit_model, t[0:*:vary_cad], sim_d[0:*:vary_cad], [1., 0.2, 0.00005], /quiet, /weight) $
              else fit = mpfitexpr(fit_model, t[0:*:vary_cad], sim_d[0:*:vary_cad], err_d[0:*:vary_cad], [1., 0.2, 0.00005], /quiet)
 
              if k eq 0 then iter_acc = [fit[2]*1e6] else iter_acc = [iter_acc,fit[2]*1e6]
print, k              
           endfor
           
           if vary_noise eq delta_n then noise_vary_acc = [histogram(iter_acc,bin=acc_bin, min = -400, max=100)] $
           else noise_vary_acc = [[noise_vary_acc], [histogram(iter_acc,bin=acc_bin, min = -400, max=100)]]

;           noise_vary_acc[vary_cad*(1./delta_t), vary_noise*(1./delta_n), *] = histogram(iter_acc,bin=acc_bin, min = -400, max=100)
box_message, 'Noise level = '+num2str(vary_noise)
        endfor
        
        if vary_cad eq 1 then noise_variation = noise_vary_acc else $
           noise_variation = [[[noise_variation]], [[noise_vary_acc]]]
box_message, 'Cadence = '+num2str(vary_cad)
     endfor
     
     save, filename = 'noise_array.sav', noise_variation

  endif

  if keyword_set(display) then begin
; Original save file

;     window, 0, xs = 800, ys = 600
;     !p.multi = 0

     set_plot, 'z'
     device, set_resolution = [900, 600]
     img = bytarr(3, 900, 600)

     restore, 'noise_vary_array.sav'
     
     noise = noise_vary_acc
     n = fltarr(81, 501)
     
     for j = 720, 1, -1 do n[where(noise[j,*,*] gt 0)] = j
     
     loadct, 5
     tvlct, r, g, b, /get
     rr=reverse(r)
     gg=reverse(g)
     bb=reverse(b)
     tvlct, rr, gg, bb
     
     n[where(n eq 0)] = 720
     
     plot_image, alog10(n), pos = [0.1, 0.1, 0.87, 0.95], origin = [0, -400], scale = [0.5, 1], charsize=1.5, missing = !d.table_size-1, $
                 xtit = '% Noise', ytit = 'Acc (m/s/s)', range=[1,720], color = !d.table_size-1, background = 0, psym=1
     
     color_bar, alog10(n), 0.87, 0.92, 0.1, 0.95, /normal, /right, min = 1, max = 720, charsize = 1.5, type=1, $
                ytitle = 'Cadence (s)', /ys, color = !d.table_size-1, missing = !d.table_size-1

     snap = tvrd()
     tvlct, r, g, b, /get
     img[0,*,*] = r[snap]
     img[1,*,*] = g[snap]
     img[2,*,*] = b[snap]
     write_png, 'noise_test_image.png', img

     set_plot, 'x'

     save, filename = 'image_array.sav', n
; Updated code:

;     restore, 'noise_array.sav'
;     
;     noise = noise_variation
;     n = fltarr((max_noise/delta_n)+1, (acc_range/acc_bin)+1)
;     
;     for j = max_cad, 1, -1 do n[where(noise[*,*,j] gt 0)] = j
;     
;     loadct, 5
;     tvlct, r, g, b, /get
;     rr=reverse(r)
;     gg=reverse(g)
;     bb=reverse(b)
;     tvlct, rr, gg, bb
;     
;     n[where(n eq 0)] = max_cad
;     
;     plot_image, alog10(n), pos = [0.1, 0.1, 0.87, 0.95], origin = [0, -400], scale = [delta_n, acc_bin], charsize=2, missing = !d.table_size-1, $
;                 xtit = '% Noise', ytit = 'Acc (m/s/s)', range=[1*delta_t,max_cad*delta_t], color = !d.table_size-1, background = 0, psym=1
;     
;     color_bar, alog10(n), 0.87, 0.92, 0.1, 0.95, /normal, /right, min = 1*delta_t, max = max_cad*delta_t, charsize = 2, type=1, $
;                ytitle = 'Cadence (s)', /ys, color = !d.table_size-1, missing = !d.table_size-1
;
  endif

end
