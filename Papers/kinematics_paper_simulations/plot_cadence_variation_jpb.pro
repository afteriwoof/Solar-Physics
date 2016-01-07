; Routine to produce plots showing variation in model fit with cadence
; for kinematics paper. This is a modified version of cadence_loop.pro
; stripped down to only produce the required plot.

; Last edited:	2013-01-16	JASON - to scale the errors according to pcerror (see mpfit)
;		2013-04-14	to include the legend of model kinematics on the plots.

pro plot_cadence_variation_jpb, weight = weight

; Simulated data  
  r_0 = 50d                     ; Mm
  v_0 = 0.4d                    ; km/s
  a_0 = -0.00015d               ; m/s/s
  t = dindgen(2401)             ; 2400s total time
  d = r_0 + v_0*t + (1d/2d)*a_0*t^2.
  sym = 1

  fit_model = 'p[0] + p[1] * (x) + (1./2.) * p[2] * (x)^2.'
  loadct, 0

  !p.multi = [0,1,3]
  set_plot, 'ps'
  if keyword_set(weight) then fname = 'cad_hist_weight_jpb.eps' else fname = 'cad_hist_jpb.eps'
  device, /encapsul, bits=8, language=2, /portrait, /color, filename=fname, $
          xs=15, ys=20
  
  chars = 2
  chars_l = 1
  !p.charthick=4
  !p.thick=4
  !x.thick=4
  !y.thick=4
  
  restore, 'cadence_parameters.sav'
 
; Weight keyword, fixed err value
  weight_err = 1.1
 
  mult_noise = 10.
  percent = (mult_noise/0.99)*0.68
  r_noise = noise*((d/100.)*percent)
  sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
  if keyword_set(weight) then err_d = replicate(weight_err, n_elements(sim_d)) else err_d = (sim_d/100d)*percent
  
; 720s plot     
  delta_t = 720.
  
  fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                  bestnorm = bstnrm, /quiet)
  dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
  pcerror = perror * sqrt(bstnrm/dof)
  if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
  yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
  x_r = t[0:*:delta_t]
  
  plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 0, $
        background = 255, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 700], /ys , $
        xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
  oplot, x_r, yfit, color = 3
  oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
  
  al_legend, ['10% scatter', '720s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
  al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(perror[1]*1e3)))+' km s!U-1!N', $
              'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(perror[2]*1e6)))+' m s!U-2!N', 'Model: v!D0!N = 400 km s!U-1!N, a = -150 m s!U-2!N'], $
             textcolor = [0,0,0], box=0, /bottom, /right, charsize = chars_l
  
; 12s plot     
  delta_t = 12.
  
  fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                  bestnorm = bstnrm)
  dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
  pcerror = perror * sqrt(bstnrm/dof)
  if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
  yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
  x_r = t[0:*:delta_t]
  
  plot, t[0:*:delta_t], sim_d[0:*:delta_t], ytitle = '!3Distance (Mm)', color = 0, $
        background = 255, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 700], /ys, $
        xtitle = 'Time (s)', pos = [0.1, 0.42, 0.9, 0.7]
  oplot, x_r, yfit, color = 3
  oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
  
  al_legend, ['10% scatter', '12s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
  al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(perror[1]*1e3)))+' km s!U-1!N', $
              'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(perror[2]*1e6)))+' m s!U-2!N','Model: v!D0!N = 400 km s!U-1!N, a = -150 m s!U-2!N'], $
             textcolor = [0,0,0], box=0, /bottom, /right, charsize = chars_l
  
  print, 'perror: ', perror
  print, 'pcerror: ', pcerror

; Histograms     
  plot_hist_mod, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 850], /ys, ytitle = 'Freq. of occurence', $
                 title = '', pos = [0.1, 0.08, 0.9, 0.36], xtit = 'Acceleration (m s!U-2!N)'
  plot_hist, acc_2, /oplot, linestyle = 0
  
  xyouts, -90, 90, '720s cadence', /data, charsize = chars_l
  xyouts, -130, 400, '12s cadence', /data, charsize = chars_l
  
  !p.charthick=1
  !p.thick=1
  !x.thick=1
  !y.thick=1
  
  device, /close
  set_plot, 'x'
  
end
