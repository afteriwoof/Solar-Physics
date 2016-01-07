; Routine to loop through cadence iterations

pro cadence_loop, weight = weight, plot=plot, tog = tog

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

  n_iter = 10000.

  acc_10 = fltarr(n_iter+1)
  acc_5 = fltarr(n_iter+1)
  acc_2 = fltarr(n_iter+1)

; Amount of noise
  mult_noise = 10.              ; ->100/(% required)
  percent = (mult_noise/0.99)*0.68
    
  for j = 0, n_iter do begin

     noise = randomn(seed, 2401)
     
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
    
     if keyword_set(weight) then err_d = replicate(3., 2401) else err_d = (sim_d/100d)*percent

; Cadence
     delta_t = 720.             ; s

;  toggle, filename = 'num_diff_noise.eps', /portrait, /color, xs = 3, ys = 3, /inches
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))
     
;     if keyword_set(weight) then begin
;        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
;                        bestnorm = bstnrm, /quiet, /weight)
;     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /quiet)
;     endelse

     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     
     x_r = t[0:*:delta_t]
     
     if keyword_set(plot) then begin
        set_line_color
        plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 1, $
              background = 0, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys ;, $
;           xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
        oplot, x_r, yfit, color = 3
;        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        if keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['720s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                    'a!D0!N = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_10[j] = float(fit[2]*1e6)

; Cadence
     delta_t = 300.
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))

;     if keyword_set(weight) then begin
;        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
;                        bestnorm = bstnrm, /quiet, /weight)
;     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /quiet)
;     endelse

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
;        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        if keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['300s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                    'a!D0!N = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_5[j] = float(fit[2]*1e6)
     
; Cadence
     delta_t = 12.
     
; Original fit to data
     
     x = dindgen(max(t[0:*:delta_t]))
     
;     if keyword_set(weight) then begin
;        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
;                        bestnorm = bstnrm, /quiet, /weight)
;     endif else begin
        fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                        bestnorm = bstnrm, /quiet)
;     endelse

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
;        if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        if keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 1
        
        al_legend, ['12s cadence'], textcolor = [1], box=0, /top, /left, charsize = chars_l
        al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                    'a!D0!N = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                   textcolor = [1,1], box=0, /bottom, /right, charsize = chars_l
     endif

     acc_2[j] = float(fit[2]*1e6)

;  toggle

     if keyword_set(plot) then begin
        save, filename = 'cad_loop_params.sav', t, sim_d, d, noise
        print, 'Iteration: ', j
        ans = ' '
        read, 'ok?', ans
     endif

  endfor

; Plot distribution of accelerations for each noise level.

  plot_hist, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '720s Cadence'

  plot_hist, acc_5, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '300s Cadence'

  plot_hist, acc_2, charsize = chars, xr = [-300, 0], /xs, yr = [0, 400], /ys, $
             title = '12s Cadence'

  if keyword_set(tog) then begin

     !p.multi = [0,1,3]
     set_plot, 'ps'
     if keyword_set(weight) then fname = 'cad_hist_weight.eps' else fname = 'cad_hist.eps'
     device, /encapsul, bits=8, language=2, /portrait, /color, filename=fname, $
             xs=15, ys=20

     chars = 2
     chars_l = 1
     !p.charthick=4
     !p.thick=4
     !x.thick=4
     !y.thick=4

     restore, 'cad_loop_params.sav'

     mult_noise = 10.
     percent = (mult_noise/0.99)*0.68
     r_noise = noise*((d/100.)*percent)
     sim_d = r_0 + v_0*t + (1d/2d)*a_0*t^2. + r_noise
     err_d = replicate(3., n_elements(sim_d))

; 720s plot     
     delta_t = 720.

     fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                     bestnorm = bstnrm, /quiet)
     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     x_r = t[0:*:delta_t]

     plot, t[0:*:delta_t], sim_d[0:*:delta_t], xtitle = ' ', ytitle = '!3Distance (Mm)', color = 0, $
           background = 1, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys , $
           xtickname = [replicate(' ',5)], pos = [0.1, 0.71, 0.9, 0.99]
     oplot, x_r, yfit, color = 3
;     if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     if keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     
     al_legend, ['10% noise', '720s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
     al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                 'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
     
; 12s plot     
     delta_t = 12.

     fit = mpfitexpr(fit_model, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], [1., 0.2, 0.00005], perror=perror, $
                     bestnorm = bstnrm, /quiet)
     dof = n_elements(t[0:*:delta_t]) - n_elements(fit)
     if n_elements(perror) eq 0 then perror = replicate(1., n_elements(fit))
     pcerror = perror*sqrt(bstnrm/dof)
     yfit = fit[0] + fit[1]*(t[0:*:delta_t]) + (1./2.)*fit[2]*(t[0:*:delta_t])^2.
     x_r = t[0:*:delta_t]

     plot, t[0:*:delta_t], sim_d[0:*:delta_t], ytitle = '!3Distance (Mm)', color = 0, $
           background = 1, charsize = chars, xr = [-50, 2450], /xs, psym = sym, yr = [0, 650], /ys, $
           xtitle = 'Time (s)', pos = [0.1, 0.42, 0.9, 0.7]
     oplot, x_r, yfit, color = 3
;     if not keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     if keyword_set(weight) then oploterr, t[0:*:delta_t], sim_d[0:*:delta_t], err_d[0:*:delta_t], /nohat, /noconnect, color = 0
     
     al_legend, ['10% noise', '12s cadence'], textcolor = [0,0], box=0, /top, /left, charsize = chars_l
     al_legend, ['v!D0!N = '+num2str(round(float(fit[1]*1e3)))+' !9+!3 '+num2str(round(float(pcerror[1]*1e3)))+' km s!U-1!N', $
                 'a = '+num2str(round(float(fit[2]*1e6)))+' !9+!3 '+num2str(round(float(pcerror[2]*1e6)))+' m s!U-2!N'], $
                textcolor = [0,0], box=0, /bottom, /right, charsize = chars_l
     
; Histograms     
     plot_hist_mod, acc_10, charsize = chars, xr = [-300, 0], /xs, yr = [0, 600], /ys, $
                title = '', pos = [0.1, 0.08, 0.9, 0.36], xtit = 'Acceleration (m s!U-2!N)'
     plot_hist, acc_2, /oplot, linestyle = 2

     xyouts, -90, 90, '720s cadence', /data, charsize = chars_l
     xyouts, -130, 400, '12s cadence', /data, charsize = chars_l

     !p.charthick=1
     !p.thick=1
     !x.thick=1
     !y.thick=1
     
     device, /close
     set_plot, 'x'

  endif
  
stop

     
end
