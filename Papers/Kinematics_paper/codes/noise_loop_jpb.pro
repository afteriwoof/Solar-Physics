; Routine to loop through noise iterations

pro noise_loop_jpb, weight = weight, plot=plot, tog = tog

; Simulated data
  
  r_0 = 50d                     ; Mm
  v_0 = 0.4d                    ; km/s
  a_0 = -0.00015d               ; m/s/s
  t = dindgen(2401)             ; 2400s total time
  d = r_0 + v_0*t + (1d/2d)*a_0*t^2.
  sym = 1

  fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'
  set_line_color

  chars = 2
  chars_l = 1
  window, 0, xs = 600, ys = 800
  !p.multi = [0,1,3]

; Acceleration distributions

  n_iter = 100.

  acc_10 = fltarr(n_iter+1)
  acc_5 = fltarr(n_iter+1)
  acc_2 = fltarr(n_iter+1)

; Cadence
  delta_t = 300.                ; s
    
  for j = 0, n_iter do begin

     noise = randomn(seed, 2401)
     
; Amount of noise
     mult_noise = 10.           ; ->100/(% required)
     percent = (mult_noise/0.99)*0.68
;  percent = 100d/mult_noise
     
;  r_noise = noise*(d/mult_noise)
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
;  err_d = (sim_d/100d)*percent
    
     if keyword_set(weight) then err_d = replicate(1, 2401) else err_d = (sim_d/100d)*percent
     
;  toggle, filename = 'num_diff_noise.eps', /portrait, /color, xs = 3, ys = 3, /inches
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))
     
     if keyword_set(weight) then begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /weight)
     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm)
     endelse

     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)

	print, 'DoF: ', dof
	print, 'perror: ', perror
	print, 'bstnrm: ', bstnrm
	print, 'pcerror: ', pcerror
     
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     
     x_r = t[0:*:delta_t]
     
     if keyword_set(plot) then begin
        set_line_color
        plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 1, $
              background = 0, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys ;, $
;           xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
        oplot, x_r, yfit, color = 3
        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['10% noise; 300s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(fix(float(fit[1]*1e3)))+' !9+!3 '+num2str(fix(float(pcerror[1]*1e3)))+' kms!U-1!N', $
                    'a!D0!N = '+num2str(fix(float(fit[2]*1e6)))+' !9+!3 '+num2str(fix(float(pcerror[2]*1e6)))+' ms!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_10[j] = float(fit[2]*1e6)

; Amount of noise
     mult_noise = 5.           ; ->100/(% required)
     percent = (mult_noise/0.99)*0.68
;  percent = 100d/mult_noise
     
;  r_noise = noise*(d/mult_noise)
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
;  err_d = (sim_d/100d)*percent
     if keyword_set(weight) then err_d = replicate(1, 2401) else err_d = (sim_d/100d)*percent
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))

     if keyword_set(weight) then begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /weight)
     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm)
     endelse

     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     
     x_r = t[0:*:delta_t]
     
     if keyword_set(plot) then begin
        plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 1, $
              background = 0, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys ;, $
;           xtickname = [replicate(' ',5)], pos = [0.1, 0.43, 0.9, 0.71]
        oplot, x_r, yfit, color = 3
        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['5% noise; 300s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(fix(float(fit[1]*1e3)))+' !9+!3 '+num2str(fix(float(pcerror[1]*1e3)))+' kms!U-1!N', $
                    'a!D0!N = '+num2str(fix(float(fit[2]*1e6)))+' !9+!3 '+num2str(fix(float(pcerror[2]*1e6)))+' ms!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_5[j] = float(fit[2]*1e6)
     
; Amount of noise
     mult_noise = 2.            ; ->100/(% required)
     percent = (mult_noise/0.99)*0.68
;  percent = 100d/mult_noise
     
;  r_noise = noise*(d/mult_noise)
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
;  err_d = (sim_d/100d)*percent
     if keyword_set(weight) then err_d = replicate(1, 2401) else err_d = (sim_d/100d)*percent
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))
     
     if keyword_set(weight) then begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /weight)
     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm)
     endelse

     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     
     x_r = t[0:*:delta_t]
     
     if keyword_set(plot) then begin
        plot, t[0:*:delta_t], sim_d[0:*:delta_t], ytitle = '!3Distance (Mm)', color = 1, $
              background = 0, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys, $
              xtitle = 'Time (s)' ;, pos = [0.1, 0.15, 0.9, 0.43]
        oplot, x_r, yfit, color = 3
        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['2% noise; 300s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(fix(float(fit[1]*1e3)))+' !9+!3 '+num2str(fix(float(pcerror[1]*1e3)))+' kms!U-1!N', $
                    'a!D0!N = '+num2str(fix(float(fit[2]*1e6)))+' !9+!3 '+num2str(fix(float(pcerror[2]*1e6)))+' ms!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_2[j] = float(fit[2]*1e6)

;  toggle

     if keyword_set(plot) then begin
        save, filename = 'noise_loop_params.sav', t, sim_d, d, noise
        print, 'Iteration: ', j
        ans = ' '
        read, 'ok?', ans
     endif

  endfor

; Plot distribution of accelerations for each noise level.

  plot_hist, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '10% noise'

  plot_hist, acc_5, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '5% noise'

  plot_hist, acc_2, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '2% noise'

  if keyword_set(tog) then begin

     !p.multi = [0,1,3]
     set_plot, 'ps'
     if keyword_set(weight) then fname = 'noise_hist_weight.eps' else fname = 'noise_hist.eps'
     device, /encapsul, bits=8, language=2, /portrait, /color, filename=fname, $
             xs=15, ys=20

     chars = 2
     chars_l = 1
     !p.charthick=4
     !p.thick=4
     !x.thick=4
     !y.thick=4

     restore, 'noise_loop_params.sav'

; 10% noise plot
     mult_noise = 10.
     percent = (mult_noise/0.99)*0.68
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise

     fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                     bestnorm = bstnrm, /weight)
     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     x_r = t[0:*:delta_t]

     plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 0, $
           background = 1, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys , $
           xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
     oplot, x_r, yfit, color = 3
     if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     
     al_legend, ['10% noise','300s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
     al_legend, ['v!D0!N = '+num2str(fix(float(fit[1]*1e3)))+' !9+!3 '+num2str(fix(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                 'a = '+num2str(fix(float(fit[2]*1e6)))+' !9+!3 '+num2str(fix(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
     
; 2% noise plot     
     mult_noise = 2.
     percent = (mult_noise/0.99)*0.68
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise

     fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                     bestnorm = bstnrm, /weight)
     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     x_r = t[0:*:delta_t]

     plot, t[0:*:delta_t], sim_d[0:*:delta_t], ytitle = '!3Distance (Mm)', color = 0, $
           background = 1, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys, $
           xtitle = 'Time (s)', pos = [0.1, 0.42, 0.9, 0.7]
     oplot, x_r, yfit, color = 3
     if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     
     al_legend, ['2% noise','300s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
     al_legend, ['v!D0!N = '+num2str(fix(float(fit[1]*1e3)))+' !9+!3 '+num2str(fix(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                 'a = '+num2str(fix(float(fit[2]*1e6)))+' !9+!3 '+num2str(fix(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
     
; Histograms     
     plot_hist_mod, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 600], /ys, $
                title = '', pos = [0.1, 0.08, 0.9, 0.36], xtit = 'Acceleration (m s!U-2!N)'
     plot_hist, acc_2, /oplot, linestyle = 2

     xyouts, -90, 90, '10% noise', /data, charsize = chars_l
     xyouts, -130, 500, '2% noise', /data, charsize = chars_l

     !p.charthick=1
     !p.thick=1
     !x.thick=1
     !y.thick=1
     
     device, /close
     set_plot, 'x'

     height_factor = 1.

; Bootstrap. This has to be run for varying degrees of noise and
; cadence.
     nse = [10., 2., 10., 10.]
     cad = [300., 300., 720., 12.]

     for j = 0, 3 do begin
        
        !p.multi = [0,2,2]
        set_plot, 'ps'
        if keyword_set(weight) then fname = 'cad_boot_weight_'+num2str(j)+'.eps' else fname = 'cad_boot.eps'
        device, /encapsul, bits=8, language=2, /portrait, /color, filename=fname, xs=20, ys=20
        
        chars = 1
        chars_l = 1
        !p.charthick=4
        !p.thick=4
        !x.thick=4
        !y.thick=4
        
; Cdaence to test
        delta_t = cad[j]
        
; Noise to test
        mult_noise = nse[j]
        percent = (mult_noise/0.99)*0.68
        r_noise = noise*((d/100.)*percent)
        sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
        
; Bootstrap noisy data     
        sim_sz = n_elements(sim_d[0:*:delta_t])
        
        arr_size = 10001.
        
        res_b = dblarr(3, arr_size)
        
; Original fit to data     
        x = dindgen(max(t[0:*:delta_t]))
        
        fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'
        
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bestnorm, /weight)
        
        yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
        
        x_r = t[0:*:delta_t]
        
; Calculate residuals
        e = sim_d[0:*:delta_t] - yfit
        
; Loop over n! iterations to bootstrap     
        for i = 0, arr_size-1 do begin
           
; Generate number of data points random numbers between 0 and 100 from uniform distribution         
           ran = rand_ind(sim_sz)
           
; Create array of 1 and -1 to multiply ran array by to fill gaps in resulting array        
           unit_array = randomn(s, sim_sz, /normal)        
           unit_arr = unit_array/abs(unit_array)
           
; Randomly reassign the residuals        
           er = e[ran] * unit_arr
           
; Make new data with random residuals        
           y_r = sim_d[0:*:delta_t] + er
           
; New fit and store the results        
           fit = mpfitexpr(fit_model, x_r, y_r, [1., 0.2, 0.00005], perror=perror, bestnorm = bestnorm, /weight)
           res_b[*,i] = fit
           
        endfor
        
; Calculate the moments of the results arrays for m and c     
        p1_b = moment(res_b[0,*], sdev=s1_b)
        p2_b = moment(res_b[1,*], sdev=s2_b)
        p3_b = moment(res_b[2,*], sdev=s3_b)
        
; Calculate fitted line for r(t) vs t plot.     
        fit_line = p1_b[0] + p2_b[0]*(x) + (1./2.)*p3_b[0]*(x)^2.
        
        bin = 1.
        
        hd = histogram(res_b[0,*])
        n_d = n_elements(hd)
        amin_d = min(res_b[0,*])
        xd = findgen(n_d)*bin + long(amin_d)*bin + bin/2.
        
        hv = histogram(1e3*res_b[1,*])
        n_v = n_elements(hv)
        amin_v = min(1e3*res_b[1,*])
        xv = findgen(n_v)*bin + long(amin_v)*bin + bin/2.
        
        ha = histogram(1e6*res_b[2,*])
        n_a = n_elements(ha)
        amin_a = min(1e6*res_b[2,*])
        xa = findgen(n_a)*bin + long(amin_a)*bin + bin/2.
        
; Plot positions
        pos_top = [0.11, 0.61, 0.97, 0.99]
        pos_r = [0.11, 0.14, 0.39, 0.52]
        pos_v = [0.40, 0.14, 0.68, 0.52]
        pos_a = [0.69, 0.14, 0.97, 0.52]
        
        set_line_color
        plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = '!3Time (s)', ytitle = '!3Distance (Mm)', color = 0, $
              background = 1, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys, $
              pos = pos_top
        oplot, x, fit_line, color = 3
        
        al_legend, ['Cadence = '+num2str(cad[j])+'s', 'Noise = '+num2str(nse[j])+'%'], textcolor = [0,0], box=0, /top, $
                   /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(fix(float(p2_b[0]*1e3)))+' !9+!3 '+num2str(fix(float(s2_b*1e3)))+' kms!U-1!N', $
                    'a = '+num2str(fix(float(p3_b[0]*1e6)))+' !9+!3 '+num2str(fix(float(s3_b*1e6)))+' ms!U-2!N'], $
                   textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
 
; Histograms for parameters - R0       
        plot, xd, hd, color = 0, background = 1, charsize = chars, title = ' ', ytitle = 'Freq. of occurence', $
              xtit = '!3Distance (Mm)', xr = [p1_b[0] - 3*s1_b, p1_b[0] + 3*s1_b], /xs, pos = pos_r, $
              yr = [0, 1.1*max(hd)], /ys, psym = 10
        al_legend, ['R!D0!N'], textcolor = [0], box=0, /top, /left, charsize = chars_l
        plots, [p1_b[0], p1_b[0]], [0, 1.1*max(hd)], linestyle = 2, color = 0
        
; Add 95% confidence interval lines (by request)    
        mu = moment(res_b[0,*],sdev=sdev)
        temp = res_b[0,*]
        sorted_params = temp[sort(temp)]
        alpha = 0.05
        q1 = arr_size * alpha / 2.
        q2 = arr_size - q1 +1
        conf_range = [sorted_params[q1],sorted_params[q2]]
        verline, mu[0]/height_factor, line=2
;     verline, (mu[0]+sdev)/height_factor, line=1
;     verline, (mu[0]-sdev)/height_factor, line=1
        verline, conf_range[0]/height_factor, line=1
        verline, conf_range[1]/height_factor, line=1
        
; Histograms for parameters - V0       
        plot, xv, hv, color = 0, background = 1, charsize = chars, title = ' ', psym = 10, $
              xr = [1e3*p2_b[0] - 3*1e3*s2_b, 1e3*p2_b[0] + 3*1e3*s2_b], /xs, yr = [0, 1.1*max(hd)], $
              /ys, xtit = '!3Velocity (km/s)', pos = pos_v, ytitle = ' ', ytickname = [replicate(' ',7)]
        al_legend, ['V!D0!N'], textcolor = [0], box=0, /top, /left, charsize = chars_l
        plots, [1e3*p2_b[0], 1e3*p2_b[0]], [0, 1.1*max(hd)], linestyle = 2, color = 0
        
; Add 95% confidence interval lines (by request)    
        mu = moment(1e3*res_b[1,*],sdev=sdev)
        temp = 1e3*res_b[1,*]
        sorted_params = temp[sort(temp)]
        alpha = 0.05
        q1 = arr_size * alpha / 2.
        q2 = arr_size - q1 +1
        conf_range = [sorted_params[q1],sorted_params[q2]]
        verline, mu[0]/height_factor, line=2
;     verline, (mu[0]+sdev)/height_factor, line=1
;     verline, (mu[0]-sdev)/height_factor, line=1
        verline, conf_range[0]/height_factor, line=1
        verline, conf_range[1]/height_factor, line=1
        
; Histograms for parameters - A     
        plot, xa, ha, color = 0, background = 1, charsize = chars, title = ' ', psym = 10, $
              xr = [1e6*p3_b[0] - 3*1e6*s3_b, 1e6*p3_b[0] + 3*1e6*s3_b], /xs, yr = [0, 1.1*max(hd)], $
              /ys, xtit = '!3Acceleration (m/s/s)', pos = pos_a, ytitle = ' ', ytickname = [replicate(' ',7)]
        al_legend, ['A'], textcolor = [0], box=0, /top, /left, charsize = chars_l
        plots, [1e6*p3_b[0], 1e6*p3_b[0]], [0, 1.1*max(hd)], linestyle = 2, color = 0
        
; Add 95% confidence interval lines (by request)    
        mu = moment(1e6*res_b[2,*],sdev=sdev)
        temp = 1e6*res_b[2,*]
        sorted_params = temp[sort(temp)]
        alpha = 0.05
        q1 = arr_size * alpha / 2.
        q2 = arr_size - q1 +1
        conf_range = [sorted_params[q1],sorted_params[q2]]
        verline, mu[0]/height_factor, line=2
;     verline, (mu[0]+sdev)/height_factor, line=1
;     verline, (mu[0]-sdev)/height_factor, line=1
        verline, conf_range[0]/height_factor, line=1
        verline, conf_range[1]/height_factor, line=1
        
        !p.charthick=1
        !p.thick=1
        !x.thick=1
        !y.thick=1
        
        device, /close
        set_plot, 'x'
        
     endfor

  endif
  
;stop

     
end
