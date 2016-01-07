; Created	2011-03-08	to create lasco figure of cme detection for swap paper.

pro make_lasco_fig

fls = file_Search('~/Postdoc/Events_combined/20110308/LASCO/fits/original/*fits*')
mreadfits_corimp, fls[96], in, da

restore, '~/Postdoc/Events_combined/20110308/LASCO/fronts/*2106*sav',/ver
restore, '~/Postdoc/Events_combined/20110308/LASCO/corimp/cme_dets/*2106*sav',/ver
restore, '~/Postdoc/Events_combined/20110308/LASCO/ells/*2106*sav',/ver

plot_image,(da^0.5) 
plots,dets.edges[0,*],dets.edges[1,*],psym=3
plots,xf,yf,psym=1,color=1
plots,dets.front[0,*],dets.front[1,*],psym=-2,color=1

set_plot, 'ps'
device, /encapsul, bits=8, lang=2, /color, xs=30, ys=30, filename='make_lasco_fig.eps'
!p.charsize=2
!p.charthick=5
!p.thick=5
!x.thick=3
!y.thick=3
index2map, in, da^0.5, map
r=5800
xrange=[-r,r]
yrange=[-r,r]
plot_map, map, xr=xrange,yr=yrange,/limb,lcolor=255, tit=' ';,tit='SOHO LASCO C2 8-Mar-2011 21:06:51 UT'
axis,xaxis=0,xr=xrange,yr=yrange,xtickname=replicate(' ',6),color=255
axis,xaxis=1,xr=xrange,yr=yrange,xtickname=replicate(' ',6),color=255
axis,yaxis=0,xr=xrange,yr=yrange,ytickname=replicate(' ',6),color=255
axis,yaxis=1,xr=xrange,yr=yrange,ytickname=replicate(' ',6),color=255
set_line_color
plots,(dets.edges[0,*]-in.crpix1)*in.cdelt1,(dets.edges[1,*]-in.crpix2)*in.cdelt2,psym=3,color=2
;plots,(dets.front[0,*]-in.crpix1)*in.cdelt1,(dets.front[1,*]-in.crpix2)*in.cdelt2,psym=-1,color=4
plots,(xf-in.crpix1)*in.cdelt1,(yf-in.crpix2)*in.cdelt2,psym=1,color=3
plots, xe, ye, psym=-3, color=5


device, /close

end
