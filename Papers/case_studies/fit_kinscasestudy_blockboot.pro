; Created:      2013-05-08      to fit a model curve to the CME height-time points and use a block bootstrap.

; Last Edited:	


pro fit_kinscasestudy_blockboot, restore_fl, lagrangian=lagrangian, quadratic=quadratic, cubic=cubic, powerlaw=powerlaw, exponential=exponential, sav_gol=sav_gol, residuals=residuals, fuzzy_error=fuzzy_error, bootstrap=bootstrap, tog=tog, occulters=occulters

if ~exist(restore_fl) then restore_fl = 'sample_kinscasestudy_3.sav'
restore, restore_fl

; EXPECT: t, tt, h_fullmodel, v_fullmodel, a_fullmodel, h_noisy, h_noisy_sig, v_lagrangian, a_lagrangian, height_factor, vel_factor, accel_factor


;h_noisy = h_noisy[0:5]
;tt = tt[0:5]

yr_h = [0,20000]
yr_v = [0,1200]
yr_a = [-450,750]

if keyword_set(tog) then begin
	!p.charsize=2
	!p.charthick=4
	!p.thick=4
	!x.thick=4
	!y.thick=4
	set_plot, 'ps'
	device, /encapsul, bits=8, language=2, /portrait, /color, filename='fit_kinscasestudy_blockboot_1.eps', $
		xs=15, ys=20
	print, 'set_plot, ps'
	print, 'Saving fit_kinscasestudy_blockboot_1.eps'
endif else begin
	!p.charsize=2
	!p.charthick=1
	!p.thick=1
	!x.thick=1
	!y.thick=1
	set_plot, 'x'
	window, 0, xs=700, ys=850
endelse

set_line_color
!p.multi = [0,1,3]

pos_h = [0.15,0.66,0.95,0.91]
pos_v = [0.15,0.4,0.95,0.65]
pos_a = [0.15,0.14,0.95,0.39]

; Temporary lines to make output of just the model kinematics
;if keyword_set(tog) then begin
;	plot, t, h_fullmodel/height_factor, psym=-3, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys, $
;		ytit='Height (Mm)'
;	plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys, $
;		ytit='Velocity (km s!U-1!N)'
;	plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys, $
;		ytit='Acceleration (m s!U-2!N)', xtit='Time (s)'
;endif
; end temporary.

; LAGRANGIAN INTERPOLATION (deriv.pro)
if keyword_set(lagrangian) then begin
	h_fit = smooth(h_noisy,3,/edge_truncate)
	;h_fit = h_noisy
	plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
	oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
	plots, tt, h_fit/height_factor, line=0, color=5
	if keyword_set(occulters) then begin
		horline, 2.2*695.5, line=1
        	horline, 6*695.5, line=1
        	horline, 19.5*695.5, line=1
	endif
        ; velocity
	v_fit = deriv(tt, h_fit)
	plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
	plots, tt, v_fit/vel_factor, psym=-7, color=5
	; acceleration
	a_fit = deriv(tt, v_fit)
	plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
	plots, tt, a_fit/accel_factor, psym=-7, color=5
	horline, 0, line=0, thick=1
endif

; QUADRATIC FIT
if keyword_set(quadratic) then begin
	fit = '0.5*p[0]*x^2. + p[1]*x + p[2]'
	fun = mpfitexpr(fit, tt, h_noisy, h_noisy_sig, bestnorm=h_chi_sq,/quiet)
	print, 'h_chi_sq ', h_chi_sq
	; height
	h_fit = 0.5*fun[0]*tt^2. + fun[1]*tt + fun[2]
	plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
	oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
	oplot, tt, h_fit/height_factor, line=0, color=5
	if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
	; velocity
	v_fit = fun[0]*tt + fun[1]
	plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
	plots, tt, v_fit/vel_factor, psym=-3, color=5
	; acceleration
	a_fit = fun[0]
	plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
	plots, tt, a_fit/accel_factor, psym=-3, color=5
        horline, 0, line=0, thick=1
endif

; CUBIC FIT
if keyword_set(cubic) then begin
	fit='p[0]*x^3. + p[1]*x^2. + p[2]*x + p[3]'
	fun = mpfitexpr(fit, tt, h_noisy, h_noisy_sig, bestnorm=h_chi_sq,/quiet)
	print, 'h_chi_sq ', h_chi_sq
        ; height
        h_fit = fun[0]*tt^3. + fun[1]*tt^2. + fun[2]*tt + fun[3]
        plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
        oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
        oplot, tt, h_fit/height_factor, line=0, color=5
        if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
        ; velocity
        v_fit = 3*fun[0]*tt^2. + 2*fun[1]*tt + fun[2]
        plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
        plots, tt, v_fit/vel_factor, psym=-3, color=5
        ; acceleration
        a_fit = 6*fun[0]*tt + 2*fun[1]
        plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
        plots, tt, a_fit/accel_factor, psym=-3, color=5
        horline, 0, line=0, thick=1
endif

; POWER LAW FIT
if keyword_set(powerlaw) then begin
        fit='p[0]*x^p[1] + p[2]*x + p[3]'
        fun = mpfitexpr(fit, tt, h_noisy, h_noisy_sig, bestnorm=h_chi_sq,/quiet)
        print, 'h_chi_sq ', h_chi_sq
        ; height
        h_fit = fun[0]*tt^fun[1] + fun[2]*tt + fun[3]
        plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
        oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
        oplot, tt, h_fit/height_factor, line=0, color=5
        if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
        ; velocity
        v_fit = fun[1]*fun[0]*tt^(fun[1]-1) + fun[2]
        plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
        plots, tt, v_fit/vel_factor, psym=-3, color=5
        ; acceleration
        a_fit = (fun[1]-1)*fun[1]*fun[0]*tt^(fun[1]-2)
        plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
        plots, tt, a_fit/accel_factor, psym=-3, color=5
        horline, 0, line=0, thick=1
endif
	
; EXPONENTIAL FIT
if keyword_set(exponential) then begin
        fit='p[0]*exp(p[1]*x) + p[2]'
        fun = mpfitexpr(fit, tt, h_noisy, h_noisy_sig, bestnorm=h_chi_sq,/quiet)
        print, 'h_chi_sq ', h_chi_sq
        ; height
        h_fit = fun[0]*exp(fun[1]*tt) + fun[2]
        plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
        oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
        oplot, tt, h_fit/height_factor, line=0, color=5
        if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
        ; velocity
        v_fit = fun[0]*fun[1]*exp(fun[1]*tt)
        plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
        plots, tt, v_fit/vel_factor, psym=-3, color=5
        ; acceleration
        a_fit = fun[0]*fun[1]*fun[1]*exp(fun[1]*tt)
        plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
        plots, tt, a_fit/accel_factor, psym=-3, color=5
        horline, 0, line=0, thick=1
endif

flag = 0
; SAVITZKY-GOLAY FIT
if keyword_set(sav_gol) then begin
	nleft = 3
	nright = 3
	degree = 2
	plot, tt, h_noisy/height_factor, psym=1, pos=pos_h, xtickname=[' ',' ',' ',' '], yr=yr_h, /ys
	oploterror, tt, h_noisy/height_factor, h_noisy_sig/height_factor, psym=3
	h_fit = convol(h_noisy,savgol(nleft,nright,0,degree,/double),/edge_truncate,/nan)
	oplot, tt, h_fit/height_factor, line=0, color=5
	if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
	;velocity
	stepsize = dblarr(n_elements(tt)-1)
	for i=1,n_elements(tt)-1 do stepsize[i-1] = tt[i] - tt[i-1]
	v_fit = 1/(ave(stepsize))*convol(h_noisy,savgol(nleft,nright,1,degree,/double),/edge_truncate,/nan)
	plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], yr=yr_v, /ys
	plots, tt, v_fit/vel_factor, psym=-7, color=5
	; acceleration
	a_fit = 2/((ave(stepsize))^2.)*convol(h_noisy,savgol(nleft,nright,2,degree,/double),/edge_truncate,/nan)
	plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys
	plots, tt, a_fit/accel_factor, psym=-7, color=5
	horline, 0, line=0, thick=1
endif


; RESIDUALS
if keyword_set(residuals) OR keyword_set(bootstrap) then begin
	res = h_fit - h_noisy
	if keyword_set(tog) then begin
		!p.charsize=1
	        device, /encapsul, bits=8, language=2, /portrait, /color, filename='fit_kinscasestudy_blockboot_2.eps', $
			xs=15, ys=8
        	print, 'Saving fit_kinscasestudy_blockboot_2.eps'
	endif else begin
	        window, 1, xs=600, ys=300
	endelse
	!p.multi=0
	yr_res = [min(res/height_factor)+0.1*min(res/height_factor),max(res/height_factor)+0.1*max(res/height_factor)]
	plot, h_fit/height_factor, res/height_factor, psym=7, yr=yr_res, /ys, $
		xtit='Fitted height (Mm)', ytit='Residuals (Mm)'
	;oploterror, h_fit/height_factor, res/height_factor, h_noisy_sig/height_factor, psym=3
	horline, 0, line=0, thick=1
endif


; FUZZY_ERROR // BOOTSTRAP
if keyword_set(fuzzy_error) OR keyword_set(bootstrap) then begin
	if keyword_set(tog) then begin
		!p.charsize=2
	        device, /encapsul, bits=8, language=2, /portrait, /color, filename='fit_kinscasestudy_blockboot_3.eps', $
			xs=15, ys=20
	        print, 'Saving fit_kinscasestudy_blockboot_3.eps'
	endif else begin
	        window, 2, xs=700, ys=850
	endelse
	iters = 10000
	if keyword_set(quadratic) then quad_params = dblarr(iters,3)
	h_noisy_orig = h_noisy
	stepsize = dblarr(n_elements(tt)-1)
        for i=1,n_elements(tt)-1 do stepsize[i-1] = tt[i] - tt[i-1]
	h_noisy = dblarr(iters,n_elements(h_noisy_orig))
	h_fit = dblarr(iters,n_elements(h_noisy_orig))
	v_fit = dblarr(iters,n_elements(h_noisy_orig))
	a_fit = dblarr(iters,n_elements(h_noisy_orig))
	
	if keyword_set(lagrangian) then begin
                if keyword_set(smooth) then h_fit_init = smooth(h_noisy_orig,3,/edge_truncate) else h_fit_init = h_noisy_orig
        endif
        if keyword_set(quadratic) then begin
                fit = '0.5*p[0]*x^2. + p[1]*x + p[2]'
                fun = mpfitexpr(fit,tt,h_noisy_orig,h_noisy_sig,bestnorm=h_chi_sq,/quiet)
                h_fit_init = 0.5*fun[0]*tt^2. + fun[1]*tt + fun[2]
        endif
        if keyword_set(sav_gol) then h_fit_init = convol(h_noisy_orig,savgol(nleft,nright,0,degree,/double),/edge_truncate,/nan)

	; 5 entries corresponding to the lowerfence, lower (first) quartile, median (second quartile), upper (third) quartile, and upperfence.
	h_iqr = dblarr(5,n_elements(h_noisy_orig)) 
	v_iqr = dblarr(5,n_elements(h_noisy_orig))
	a_iqr = dblarr(5,n_elements(h_noisy_orig))
	!p.multi=[0,1,3]

	for j=0,iters-1 do begin
		if keyword_set(fuzzy_error) then h_noisy[j,*] = h_noisy_orig + randomn(seed,n_elements(h_noisy_sig))*(h_noisy_sig/2.)
		if keyword_set(bootstrap) then begin
			block_len = 5.	;must be float
			print, 'block_len ', block_len
			if n_elements(h_noisy_orig) mod block_len eq 0 then ran = rand_ind(n_elements(h_noisy_orig)) else ran = rand_ind(n_elements(h_noisy_orig)-block_len,n_elements(h_noisy_orig))
			rand_inds = rand_ind(ceil(n_elements(h_noisy_orig)/block_len))
			ran = ran[rand_inds]
			;unit_array = randomn(seed,n_elements(h_noisy_orig),/normal)
			;unit_array /= abs(unit_array)
			res_blocks = res[ran[0]:[ran[0]+block_len-1]];*unit_array[ran[0]:[ran[0]+block_len-1]]
			for i=1,n_elements(h_noisy_orig)/block_len-1 do res_blocks = [res_blocks,res[ran[i]:[ran[i]+block_len-1]]];*unit_array[ran[i]:[ran[i]+block_len-1]]]
			if n_elements(res_blocks) lt n_elements(h_noisy_orig) then begin
				leftover = n_elements(h_noisy_orig) - n_elements(res_blocks)
				res_blocks = [res_blocks,res[ran[i]:[ran[i]+leftover-1]]];*unit_array[ran[i]:[ran[i]+leftover-1]]]
			endif
			print, 'res ', res
			print, 'res_blocks ', res_blocks
			h_noisy[j,*] = h_fit_init + res_blocks
		endif
		if keyword_set(lagrangian) then begin
			title = 'Lagrangian Interpolation'
			h_fit[j,*] = smooth(h_noisy[j,*], 3, /edge_truncate)
			;h_fit[j,*] = h_noisy[j,*]
			v_fit[j,*] = deriv(tt, h_fit[j,*])
			a_fit[j,*] = deriv(tt, v_fit[j,*])
		endif
		if keyword_set(quadratic) then begin
			title = 'Quadratic Polynomial'
			fit = '0.5*p[0]*x^2. + p[1]*x + p[2]'
        		fun = mpfitexpr(fit, tt, h_noisy[j,*], h_noisy_sig, bestnorm=h_chi_sq,/quiet)
        		h_fit[j,*] = 0.5*fun[0]*tt^2. + fun[1]*tt + fun[2]
			v_fit[j,*] = fun[0]*tt + fun[1]
			a_fit[j,*] = fun[0]
			quad_params[j,0] = fun[0]
			quad_params[j,1] = fun[1]
			quad_params[j,2] = fun[2]
		endif
		if keyword_set(sav_gol) then begin
			title = 'Savitzky-Golay Filter'
			h_fit[j,*] = convol(transpose(h_noisy[j,*]),savgol(nleft,nright,0,degree,/double),/edge_truncate,/nan)
			v_fit[j,*] = 1/(ave(stepsize))*convol(transpose(h_noisy[j,*]),savgol(nleft,nright,1,degree,/double),/edge_truncate,/nan)
			a_fit[j,*] = 2/((ave(stepsize))^2.)*convol(transpose(h_noisy[j,*]),savgol(nleft,nright,2,degree,/double),/edge_truncate,/nan)
		endif
	endfor

	;interquartile range
	for i=0,n_elements(h_noisy_orig)-1 do begin
		h_iqr[2,i] = median(h_fit[*,i])
		h_iqr[1,i] = median(h_fit[where(h_fit[*,i] lt h_iqr[2,i]),i])
		h_iqr[3,i] = median(h_fit[where(h_fit[*,i] gt h_iqr[2,i]),i])
		h_iqr[0,i] = h_iqr[1,i] - 1.5*(h_iqr[3,i]-h_iqr[1,i])
		h_iqr[4,i] = h_iqr[3,i] + 1.5*(h_iqr[3,i]-h_iqr[1,i])
		v_iqr[2,i] = median(v_fit[*,i])
                v_iqr[1,i] = median(v_fit[where(v_fit[*,i] lt v_iqr[2,i]),i])
                v_iqr[3,i] = median(v_fit[where(v_fit[*,i] gt v_iqr[2,i]),i])
                v_iqr[0,i] = v_iqr[1,i] - 1.5*(v_iqr[3,i]-v_iqr[1,i])
                v_iqr[4,i] = v_iqr[3,i] + 1.5*(v_iqr[3,i]-v_iqr[1,i])
		a_iqr[2,i] = median(a_fit[*,i])
                a_iqr[1,i] = median(a_fit[where(a_fit[*,i] lt a_iqr[2,i]),i])
                a_iqr[3,i] = median(a_fit[where(a_fit[*,i] gt a_iqr[2,i]),i])
                a_iqr[0,i] = a_iqr[1,i] - 1.5*(a_iqr[3,i]-a_iqr[1,i])
                a_iqr[4,i] = a_iqr[3,i] + 1.5*(a_iqr[3,i]-a_iqr[1,i])
	endfor
	; heights plot
	plot, t, h_fullmodel/height_factor, psym=-3, pos=pos_h, xtickname=[' ',' ',' ',' '], $
		yr=yr_h, /ys, ytit='Height (Mm)', tit='Bootstrap : '+title;, /ylog
	oplot, tt, h_noisy_orig/height_factor, psym=1
	for j=0,iters-1 do begin
		;plots, tt, h_noisy[j,*]/height_factor, psym=1
		oplot, tt, h_fit[j,*]/height_factor, psym=3, color=3
	endfor
	;for j=0,4 do plots, tt, h_iqr[j,*]/height_factor, psym=-3, color=4
	if keyword_set(occulters) then begin
                horline, 2.2*695.5, line=1
                horline, 6*695.5, line=1
                horline, 19.5*695.5, line=1
        endif
	; temporary xyouts (legend)
	xyouts, 1100, 17200, 'Scatter: 2%', charsize=1.
	xyouts, 1100, 15200, 'Cadence: 780s', charsize=1.
	; velocity plot
	for j=0,iters-1 do begin
                if j eq 0 then begin
			plot, t, v_fullmodel/vel_factor, psym=-3, pos=pos_v, xtickname=[' ',' ',' ',' '], $
				yr=yr_v, /ys, ytit='Velocity (km s!U-1!N)'
			oplot, tt, v_fit[j,*]/vel_factor, psym=3, color=3
		endif else begin
			oplot, tt, v_fit[j,*]/vel_factor, psym=3, color=3
		endelse
        endfor
	for j=0,4 do oplot, tt, v_iqr[j,*]/vel_factor, psym=-3, color=5, line=2
	; accel plot
	for j=0,iters-1 do begin
		if j eq 0 then begin
			plot, t, a_fullmodel/accel_factor, psym=-3, pos=pos_a, yr=yr_a, /ys, $
				ytit='Accel. (m s!U-2!N)', xtit='Time (s)'
			oplot, tt, a_fit[j,*]/accel_factor, psym=3, color=3
		endif else begin
			oplot, tt, a_fit[j,*]/accel_factor, psym=3, color=3
		endelse
	endfor
	for j=0,4 do oplot, tt, a_iqr[j,*]/accel_factor, psym=-3, color=5, line=2
	horline, 0, line=0, thick=1

	;For quadratic (to be extended to others too) do the bootstrap parameter plots
	if keyword_set(quadratic) then begin
		if keyword_set(tog) then begin
        	        !p.charsize=2
        	        device, /encapsul, bits=8, language=2, /portrait, /color, filename='fit_kinscasestudy_blockboot_4.eps', $
        	                xs=25, ys=10
        	        print, 'Saving fit_kinscasestudy_blockboot_4.eps'
        	endif else begin
        	        window, 3, xs=900, ys=500
        	endelse
		!p.multi=[0,3,1]
		pos1 = [0.1,0.2,0.35,0.95]
		pos2 = [0.38,0.2,0.63,0.95]
		pos3 = [0.66,0.2,0.91,0.95]
		yr_hist = [0,200]
		plot_hist_jpb, quad_params[*,2]/height_factor, bin=50, yr=yr_hist, /ys, chars=2, pos=pos1, xtit='Initial height (Mm)'
		mu = moment(quad_params[*,2],sdev=sdev)
		mode_val = mode(quad_params[*,2])
		temp = quad_params[*,2]
		sorted_params = temp[sort(temp)]
		alpha = 0.05
		q1 = iters * alpha / 2.
		q2 = iters - q1 +1
		conf_range = [sorted_params[q1],sorted_params[q2]]
		verline, mu[0]/height_factor, line=2
		;verline, (mu[0]+sdev)/height_factor, line=1
		;verline, (mu[0]-sdev)/height_factor, line=1
		verline, conf_range[0]/height_factor, line=1
		verline, conf_range[1]/height_factor, line=1
		print, 'Height:'
		print, 'mode: ', mode_val/height_factor
		print, 'mean: ', mu[0]/height_factor
		print, 'sdev: ', sdev/height_factor
		print, '95% CI: ', conf_range/height_factor
		plot_hist_jpb, quad_params[*,1]/vel_factor, bin=10, chars=2, yr=yr_hist, /ys, ytickname=[' ',' ',' ',' ',' '], pos=pos2, ytit=' ', xtit='Initial velocity (km s!U-1!N)'
 		mu = moment(quad_params[*,1],sdev=sdev)
                mode_val = mode(quad_params[*,1])
                temp = quad_params[*,1]
                sorted_params = temp[sort(temp)]
		conf_range = [sorted_params[q1],sorted_params[q2]]
		verline, mu[0]/vel_factor, line=2
                ;verline, (mu[0]+sdev)/vel_factor, line=1
                ;verline, (mu[0]-sdev)/vel_factor, line=1
                verline, conf_range[0]/vel_factor, line=1
                verline, conf_range[1]/vel_factor, line=1
		print, 'Velocity:'
                print, 'mode: ', mode_val/vel_factor
                print, 'mean: ', mu[0]/vel_factor
                print, 'sdev: ', sdev/vel_factor
                print, '95% CI: ', conf_range/vel_factor
		plot_hist_jpb, quad_params[*,0]/accel_factor, bin=0.5, chars=2, yr=yr_hist, /ys, ytickname=[' ',' ',' ',' ',' '], pos=pos3, ytit=' ', xtit='Acceleration (m s!U-2!N)'
		mu = moment(quad_params[*,0],sdev=sdev)
                mode_val = mode(quad_params[*,0])
                temp = quad_params[*,0]
                sorted_params = temp[sort(temp)]
		conf_range = [sorted_params[q1],sorted_params[q2]]
		verline, mu[0]/accel_factor, line=2
                ;verline, (mu[0]+sdev)/accel_factor, line=1
                ;verline, (mu[0]-sdev)/accel_factor, line=1
                verline, conf_range[0]/accel_factor, line=1
                verline, conf_range[1]/accel_factor, line=1
		print, 'Acceleration:'
                print, 'mode: ', mode_val/accel_factor
                print, 'mean: ', mu[0]/accel_factor
                print, 'sdev: ', sdev/accel_factor
                print, '95% CI: ', conf_range/accel_factor 
	endif
endif


if keyword_set(tog) then device, /close

end

