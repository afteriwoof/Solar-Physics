PRO print_results, anova_table 
; Define some labels for the anova table.  
labels = ['df for among groups     ', $ 
   'df for within groups           ', $ 
   'total (corrected) df           ', $ 
   'ss for among groups            ', $ 
   'ss for within groups           ', $ 
   'total (corrected) ss           ', $ 
   'mean square among groups       ', $ 
   'mean square within groups      ', $ 
   'F-statistic                    ', $ 
   'P-value                        ', $ 
   'R-squared (in percent)         ', $ 
   'adjusted R-squared (in percent)', $ 
   'est. std of within group error ', $ 
   'overall mean of y              ', $ 
   'coef. of variation (in percent)']  
PRINT, '       * * Analysis of Variance * *'  
; Print the analysis of variance table.  
FOR i = 0, 13 DO PRINT, labels(i), $ 
   anova_table(i), FORMAT = '(a32,f10.2)'  
END  
