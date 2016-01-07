; Small file accompanying ellipse fitting using MPFITFUN / MPFITEXPR in mapcontours_fast.pro

; Last Edited: 01-03-07



pro polarellipse_centre, x, y, yfit1, yfit2

; Need to be given x, y values

;@mapcontours.bat

;x = a_new
;y = r_new

fit = 'sqrt((p(0)^2*p(1)^2)/((p(0)^2+p(1)^2)/2 - ((p(0)^2-p(1)^2)/2)*cos(2*x-2*p(2))))'

;fit1 = '((p(0)*p(3)^2*cos(x-p(4))+p(1)*p(2)^2*sin(x-p(4)))+sqrt((p(0)*p(3)^2*cos(x-p(4))+p(1)*p(2)^2*sin(x-p(4)))^2+4*(p(2)^2*sin(x-p(4))^2+p(3)^2*cos(x-p(4))^2)*(p(0)^2*p(3)^2+p(1)^2*p(2)^2+p(2)^2*p(3)^2)))/(2*(p(2)^2*sin(x-p(4))^2+p(3)^2*cos(x-p(4))^2))'
;fit2 = '((p(0)*p(3)^2*cos(x-p(4))+p(1)*p(2)^2*sin(x-p(4)))-sqrt((p(0)*p(3)^2*cos(x-p(4))+p(1)*p(2)^2*sin(x-p(4)))^2+4*(p(2)^2*sin(x-p(4))^2+p(3)^2*cos(x-p(4))^2)*(p(0)^2*p(3)^2+p(1)^2*p(2)^2+p(2)^2*p(3)^2)))/(2*(p(2)^2*sin(x-p(4))^2+p(3)^2*cos(x-p(4))^2))'

parinfo = replicate({value:0.D,fixed:0,limited:[0,0],limits:[0.D,0]},5)

parinfo(*).value = [1600.,-3000.,1500.,1000.,0.5]

param = mpfitexpr(fit,x,y,y*0.1,parinfo=parinfo,perror=perror,yfit=yfit)

;param1 = mpfitexpr(fit1,x,y,y*0.1,parinfo=parinfo,perror=perror,yfit=yfit1)
;param2 = mpfitexpr(fit2,x,y,y*0.1,parinfo=parinfo,perror=perror,yfit=yfit2)

plots, yfit1, x

end

