|;+ 
; NAME: 
; normal_prob_plot 
;
;
; PURPOSE: 
; make a normal probability plot 
;
;
; CATEGORY: 
; Stats 
;
;
; INPUTS: 
; res: the residuals from regression analysis 
;
;
; KEYWORD PARAMETERS: 
; BLOM: set this to use the blom position test 
; TITLE: the title for the plot 
; _EXTRA: extra keywords to plot 
;
; OUTPUTS: 
; the normal probablty plot
;
;
; RESTRICTIONS: 
; One should add more plotting options but I dont use this often 
;
;
; EXAMPLE: 
; x = findgen(10) 
; y = randomu(seed, 10)
; reg=regress(x, y, yfit=yfit) 
; res = y-yfit 
; normal_prob_plot, res, /blom 
;
;
;
; MODIFICATION HISTORY: 
;
; Tue Jan 22 14:37:22 2008, Brian Larsen 
; documented, written previously 
;
;- 

PRO normal_prob_plot, res, BLOM=blom, TITLE=title, _EXTRA = _extra 

;; i need the MSE 

mse = mse(res)

srt = sort(res) 

rank = ranks(res[srt]) 

exp = fltarr(N_ELEMENTS(rank))

FOR j=0l, N_ELEMENTS(rank)-1 DO BEGIN 

exp[j] = sqrt(mse)*GAUSS_CVF((rank[j]-0.375)/(N_ELEMENTS(rank)+0.25) )

ENDFOR 

;HELP, exp, res[srt]

reg2 = regress(-exp, res[srt], CORRELATION=corr2, yfit=yfit2) 

;PRINT, corr2 

IF KEYWORD_SET(blom) THEN BEGIN 

IF blom_position_test(corr2, N_ELEMENTS(res), 0.01) THEN BEGIN 
subtitle = 'Normal at ' + TeXtoIDL("\alpha") + '=0.01' 
ENDIF ELSE subtitle = 'Not normal at ' + TeXtoIDL("\alpha") + '=0.01' 
ENDIF 

IF NOT KEYWORD_SET(title) THEN BEGIN
title='Normal Probability Plot' 
ENDIF 

plot, -exp, res[srt], /psym, xtitle='Expected residual', ytitle='Residual', $ 
title=title, subtitle=subtitle, _STRICT_EXTRA = _extra 

oplot, -exp, yfit2, _EXTRA = _extra 

RETURN 

END
