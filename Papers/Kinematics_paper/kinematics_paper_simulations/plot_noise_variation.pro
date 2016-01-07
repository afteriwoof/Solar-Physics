; Routine to produce plots showing variation in model fit with noise
; for kinematics paper. This is a modified version of noise_loop.pro
; stripped down to only produce the required plot.

; Set /plot_h to plot the height distribution in the bootstrapping
; figure (Fig. 6 in the paper).

pro plot_noise_variation, weight = weight, plot_h = plot_h

; Simulated data  
  r_0 = 50d                     ; Mm
  v_0 = 0.4d                    ; km/s
  a_0 = -0.00015d               ; m/s/s
  t = dindgen(2401)             ; 2400s total time
  d = r_0 + v_0*t + (1d/2d)*a_0*t^2.
  sym = 1
  delta_t = 300.

  fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'
  loadct, 0
  
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
  
  restore, 'noise_parameters.sav'
  
; 10% noise plot
  mult_noise = 10.
  percent = (mult_noise/0.99)*0.68
  r_noise = noise*((d/100.)*percent)
  sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
  if keyword_set(weight) then err_d = replicate(3., n_elements(sim_d)) else err_d = (sim_d/100d)*percent
  
  fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                  bestnorm = bstnrm, /quiet)
  dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
  if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
  yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
  x_r = t[0:*:delta_t]
  
; Plot the simulated data with the associated fit.
  plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 0, $
        background = 255, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 700], /ys , $
        xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
  oplot, x_r, yfit, color = 0
  oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
  
  al_legend, ['10% scatter','300s cadence'], textcolor = [0,0], box = 0, /top, /left, charsize = chars_l
  al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(perror[1]*1e3)))+' km s!U-1!N', $
              'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(perror[2]*1e6)))+' m s!U-2!N'], $
             textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
  
; 2% noise plot     
  mult_noise = 2.
  percent = (mult_noise/0.99)*0.68
  r_noise = noise*((d/100.)*percent)
  sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
  if keyword_set(weight) then err_d = replicate(3., n_elements(sim_d)) else err_d = (sim_d/100d)*percent
  
  fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                  bestnorm = bstnrm)
  dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
  if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
  yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
  x_r = t[0:*:delta_t]
  
  plot, t[0:*:delta_t], sim_d[0:*:delta_t], ytitle = '!3Distance (Mm)', color = 0, $
        background = 255, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys, $
        xtitle = 'Time (s)', pos = [0.1, 0.42, 0.9, 0.7]
  oplot, x_r, yfit, color = 0
  oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
  
  al_legend, ['2% scatter','300s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
  al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(perror[1]*1e3)))+' km s!U-1!N', $
              'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(perror[2]*1e6)))+' m s!U-2!N'], $
             textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
  
  print, perror

; Histograms     
  plot_hist_mod, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 850], /ys, ytitle = 'Freq. of occurence', $
                 title = '', pos = [0.1, 0.08, 0.9, 0.36], xtit = 'Acceleration (m s!U-2!N)'
  plot_hist, acc_2, /oplot, linestyle = 0
  
  xyouts, -90, 90, '10% scatter', /data, charsize = chars_l
  xyouts, -130, 500, '2% scatter', /data, charsize = chars_l
  
  device, /close
  
; Bootstrap.
; Set some constants for calculating the confidence intervals.
  height_factor = 1.
  alpha = 0.05

  mult_noise = 5.
  delta_t = 300.
  
  !p.multi = [0,2,2]
  set_plot, 'ps'
  if keyword_set(plot_h) then begin
     if keyword_set(weight) then fname = 'ht_cad_boot_weight.eps' else fname = 'ht_cad_boot.eps'
  endif else begin
     if keyword_set(weight) then fname = 'cad_boot_weight.eps' else fname = 'cad_boot.eps'
  endelse
  device, /encapsul, bits=8, language=2, /portrait, /color, filename=fname, xs=20, ys=20
  
  chars = 1
  chars_l = 1
  !p.charthick=4
  !p.thick=4
  !x.thick=4
  !y.thick=4
  
; Plot positions
  pos_top = [0.11, 0.61, 0.97, 0.99]
  if keyword_set(plot_h) then begin
     pos_r = [0.11, 0.14, 0.39, 0.52]
     pos_v = [0.40, 0.14, 0.68, 0.52]
     pos_a = [0.69, 0.14, 0.97, 0.52]
  endif else begin
     pos_v = [0.11, 0.14, 0.535, 0.52]
     pos_a = [0.545, 0.14, 0.97, 0.52]
  endelse
  
; Noise to test
  percent = (mult_noise/0.99)*0.68
  r_noise = noise*((d/100.)*percent)
  sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
  if keyword_set(weight) then err_d = replicate(3., n_elements(sim_d)) else err_d = (sim_d/100d)*percent
  
; Bootstrap noisy data     
  sim_sz = n_elements(sim_d[0:*:delta_t])
  arr_size = 10001.
  res_b = dblarr(3, arr_size)
  
; Original fit to data     
  x = dindgen(max(t[0:*:delta_t]))
  
  fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'
  
  f = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=p_err, $
                bestnorm = bstnrm, /quiet)
  
  dof = n_elements(t[0:*:delta_t]) - n_elements(f)
  if n_elements(p_err) eq 0 then p_err = replicate(1., n_elements(f))
  pcerr = p_err
  
  yfit = f[0] + f[1]*(t[0:*:delta_t]) + (1./2.)*f[2]*(t[0:*:delta_t])^2.        
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
     fit = mpfitexpr(fit_model, x_r, y_r, err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, bestnorm = bestnorm, /quiet)
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
  
  plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = '!3Time (s)', ytitle = '!3Distance (Mm)', color = 0, $
        background = 255, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 700], /ys, $
        pos = pos_top
  oplot, x, fit_line, color = 0
  oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
  
  al_legend, [num2str(round(mult_noise))+'% noise', num2str(round(delta_t))+'s cadence'], textcolor = [0,0], box=0, /top, $
             /left, charsize = chars_l
  al_legend, ['v!D0!N = '+num2str(round(float(f[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerr[1]*1e3)))+' km s!U-1!N', $
              'a = '+num2str(round(float(f[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerr[2]*1e6)))+' m s!U-2!N'], $
             textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
  
; Histograms for parameters - R0    
  
  if keyword_set(plot_h) then begin
     plot, xd, hd, color = 0, background = 255, charsize = chars, title = ' ', ytitle = 'Freq. of occurence', $
           xtit = '!3Distance (Mm)', xr = [p1_b[0] - 3*s1_b, p1_b[0] + 3*s1_b], /xs, pos = pos_r, $
           yr = [0, 1.1*max([hd,hv,ha])], /ys, psym = 10
     plots, [p1_b[0], p1_b[0]], [0, 1.1*max([hd,hv,ha])], linestyle = 2, color = 0
     
; Add 95% confidence interval lines  
     mu = moment(res_b[0,*],sdev=sdev)
     temp = res_b[0,*]
     sorted_params = temp[sort(temp)]
     q1 = arr_size * alpha / 2. & q2 = arr_size - q1 +1
     conf_range = [sorted_params[q1],sorted_params[q2]]
     sigma = [abs(mu[0] - conf_range[0]/height_factor), abs(mu[0] - conf_range[1]/height_factor)]
     verline, mu[0]/height_factor, line=2
     verline, conf_range[0]/height_factor, line=1
     verline, conf_range[1]/height_factor, line=1
     
     al_legend, ['['+num2str(round(conf_range[0]/height_factor))+', '+num2str(round(conf_range[1]/height_factor))+'] Mm'], $
                textcolor = [0], box=0, /top, /left, charsize = chars_l, /clear
  endif
  
; Histograms for parameters - V0   
  if keyword_set(plot_h) then $
     plot, xv, hv, color = 0, background = 255, charsize = chars, title = ' ', psym = 10, $
           xr = [1e3*p2_b[0] - 3*1e3*s2_b, 1e3*p2_b[0] + 3*1e3*s2_b], /xs, yr = [0, 1.1*max([hd,hv,ha])], $
           /ys, xtit = '!3Velocity (km s!U-1!N)', pos = pos_v, ytitle = ' ', ytickname = [replicate(' ',10)] $
  else plot, xv, hv, color = 0, background = 255, charsize = chars, title = ' ', psym = 10, xtickinterval = 20, $
             xr = [1e3*p2_b[0] - 3*1e3*s2_b, 1e3*p2_b[0] + 3*1e3*s2_b], /xs, yr = [0, 1.1*max([hv,ha])], $
             /ys, xtit = '!3Velocity (km s!U-1!N)', pos = pos_v, ytitle = 'Freq. of occurence'
  
  if keyword_set(plot_h) then $
     plots, [1e3*p2_b[0], 1e3*p2_b[0]], [0, 1.1*max([hd,hv,ha])], linestyle = 2, color = 0 $
  else plots, [1e3*p2_b[0], 1e3*p2_b[0]], [0, 1.1*max([hv,ha])], linestyle = 2, color = 0
  
  
; Add 95% confidence interval lines  
  mu = moment(1e3*res_b[1,*],sdev=sdev)
  temp = 1e3*res_b[1,*]
  sorted_params = temp[sort(temp)]
  q1 = arr_size * alpha / 2. & q2 = arr_size - q1 +1
  conf_range = [sorted_params[q1],sorted_params[q2]]
  sigma = [abs(mu[0] - conf_range[0]/height_factor), abs(mu[0] - conf_range[1]/height_factor)]
  verline, mu[0]/height_factor, line=2
  verline, conf_range[0]/height_factor, line=1
  verline, conf_range[1]/height_factor, line=1
  
  al_legend, ['['+num2str(round(conf_range[0]/height_factor))+', '+num2str(round(conf_range[1]/height_factor))+'] km s!u-1!n'], $
             textcolor = [0], box=0, /top, /left, charsize = chars_l, /clear
  
; Histograms for parameters - A     
  if keyword_set(plot_h) then $
     plot, xa, ha, color = 0, background = 255, charsize = chars, title = ' ', psym = 10, $
           xr = [1e6*p3_b[0] - 3*1e6*s3_b, 1e6*p3_b[0] + 3*1e6*s3_b], /xs, yr = [0, 1.1*max([hd,hv,ha])], $
           /ys, xtit = '!3Acceleration (m s!U-2!N)', pos = pos_a, ytitle = ' ', ytickname = [replicate(' ',10)] $
  else plot, xa, ha, color = 0, background = 255, charsize = chars, title = ' ', psym = 10, xtickinterval = 30, $
             xr = [1e6*p3_b[0] - 3*1e6*s3_b, 1e6*p3_b[0] + 3*1e6*s3_b], /xs, yr = [0, 1.1*max([hv,ha])], $
             /ys, xtit = '!3Acceleration (m s!U-2!N)', pos = pos_a, ytitle = ' ', ytickname = [replicate(' ',10)]
  
  if keyword_set(plot_h) then $
     plots, [1e6*p3_b[0], 1e6*p3_b[0]], [0, 1.1*max([hd,hv,ha])], linestyle = 2, color = 0 $
  else plots, [1e6*p3_b[0], 1e6*p3_b[0]], [0, 1.1*max([hv,ha])], linestyle = 2, color = 0
  
; Add 95% confidence interval lines
  mu = moment(1e6*res_b[2,*],sdev=sdev)
  temp = 1e6*res_b[2,*]
  sorted_params = temp[sort(temp)]
  q1 = arr_size * alpha / 2. & q2 = arr_size - q1 +1
  conf_range = [sorted_params[q1],sorted_params[q2]]
  sigma = [abs(mu[0] - conf_range[0]/height_factor), abs(mu[0] - conf_range[1]/height_factor)]
  verline, mu[0]/height_factor, line=2
  verline, conf_range[0]/height_factor, line=1
  verline, conf_range[1]/height_factor, line=1
  
  al_legend, ['['+num2str(round(conf_range[0]/height_factor))+', '+num2str(round(conf_range[1]/height_factor))+'] m s!u-2!n'], $
             textcolor = [0], box=0, /top, /left, charsize = chars_l, /clear
  
  !p.charthick=1
  !p.thick=1
  !x.thick=1
  !y.thick=1
  
  device, /close
  set_plot, 'x'
  
end
