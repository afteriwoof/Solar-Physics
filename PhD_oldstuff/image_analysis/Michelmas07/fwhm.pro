; Code to spit out the FWHM of a distribution

; Last Edited: 12-12-07

function fwhm, x, y

expr = 'p[0] + gauss1(x, p[1:3])'

start = [950.D, 2.5, 1., 1000.]

res = mpfitexpr(expr, x, y, y*0.1, start)

window, /free

yf = res[0] + gauss1(x, res[0:3])

plot, x, y, psym=2
oplot, x, yf

mu = moment(yf, sdev=sdev)

fwhm = 2*sqrt(2*alog(2))*sdev

peak = where(yf eq max(yf))






end
