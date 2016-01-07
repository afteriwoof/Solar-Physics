; Make plots for the AandA paper using toggle.

; Last Edited: 05-02-08

pro make_plots5

	!p.thick=2
	!p.charthick=2
	!p.charsize=2

	!p.multi=[0,2,2]

	toggle, f='images_20000102.ps';, /color, /landscape

	k=2
	
	fls = file_search('~/phd/data_vso/20000102/c2/normalised_rm/*fts')
	mreadfits, fls[k], temp, da
	;cme = da[525:975,175:625]
	fls = file_search('~/phd/data_Vso/20000102/c2/*fts')
	mreadfits, fls[k], in

	index2map, in, da, map
	sub_map, map, smap, xrange=[150,5500], yrange=[-4000,1350]
	
	restore, '~/PhD/data_vso/20000102/errorsc2.sav'
	restore, '~/PhD/data_vso/20000102/c2/normalised_rm/edg_images/my_fronts.sav'
	
;	ell_kinematics_printout3, in, da, edges, errorsc2, 2
	
	r_sun = pb0r(map.time, /arcsec, /soho)
	pos = [0.5, 0.5, 1, 1]
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	draw_circle, 0, 0, r_sun[2]
	front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap

	pos = [0, 0.5, 0.5, 1]
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	draw_circle, 0, 0, r_sun[2]

	;**********

	k=8
	fls = file_search('~/phd/data_vso/20000102/c3/normalised_rm/*fts')
	mreadfits, fls[k], temp, da
	fls = file_search('~/phd/data_vso/20000102/c3/*fts')
	mreadfits, fls[k], in

	index2map, in, alog(sigrange(da,frac=0.97)), map
	sub_map, map, smap, xr=[0,22000], yr=[-18000,4000]
	
	restore, '~/phd/data_vso/20000102/errorsc3.sav'
	restore, '~/phd/data_vso/20000102/c3/normalised_rm/edg_images/my_fronts.sav'

	r_sun = pb0r(map.time, /arcsec, /soho)
	pos = [0.5,0.15,1,0.65]
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	draw_circle, 0, 0, r_sun[2]
	front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap
	
	pos = [0,0.15,0.5,0.65]
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	draw_circle, 0, 0, r_sun[2]
	
	toggle
	
	;***********


	toggle, f='images_20000418.ps'
	
	k=6
	fls = file_search('~/phd/data_vso/20000418/c3/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_vso/20000418/c3/*fts')
        mreadfits, fls[k], in 

	index2map, in, sigrange(da,frac=0.97), map
	sub_map, map, smap, xr=[-12000,15000], yr=[-27000,0]
        
	restore, '~/phd/data_vso/20000418/errorsc3.sav'
        restore, '~/phd/data_vso/20000418/c3/normalised_rm/edg_images/my_fronts.sav'

;        ell_kinematics_printout3, in, da, edges[*,*,*], errorsc3, 2

    	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5,0.15,1,0.65]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap

        pos = [0,0.15,0.5,0.65]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]	

	;**********
	
	k=5
	fls = file_search('~/phd/data_vso/20000418/c2/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_Vso/20000418/c2/*fts')
        mreadfits, fls[k], in

	index2map, in, sigrange(da), map
        sub_map, map, smap, xr=[-1800,3200], yr=[-5100,-100]
		  
        restore, '~/PhD/data_vso/20000418/errorsc2.sav'
        restore, '~/PhD/data_vso/20000418/c2/normalised_rm/edg_images/my_fronts.sav'
					        
;        ell_kinematics_printout3, in, da, edges, errorsc2, 2
  	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5, 0.5, 1, 1]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap

        pos = [0, 0.5, 0.5, 1]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]
	
        toggle


	;**********

	toggle, f='images_20010423.ps'
	
	k=2
	fls = file_search('~/phd/data_vso/20010423/c2/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_Vso/20010423/c2/*fts')
        mreadfits, fls[k], in

	index2map, in, sigrange(da), map
	sub_map, map, smap, xr=[0,5000], yr=[-4500,500]
	
        restore, '~/PhD/data_vso/20010423/errorsc2.sav'
        restore, '~/PhD/data_vso/20010423/c2/normalised_rm/edg_images/my_fronts.sav'

       	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5, 0.5, 1, 1]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap

        pos = [0, 0.5, 0.5, 1]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]

        ;**********

	k=6	
	fls = file_search('~/phd/data_vso/20010423/c3/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_vso/20010423/c3/*fts')
        mreadfits, fls[k], in

	index2map, in, alog(sigrange(da,frac=0.98)), map
	sub_map, map, smap, xr=[0,20000],yr=[-18000,2000]
	
        restore, '~/phd/data_vso/20010423/errorsc3.sav'
        restore, '~/phd/data_vso/20010423/c3/normalised_rm/edg_images/my_fronts.sav'

;        ell_kinematics_printout3, in, da, edges[*,*,*], errorsc3, 2

	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5,0.15,1,0.65]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose5, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap

        pos = [0,0.15,0.5,0.65]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, r_sun[2]

	toggle
         


														 
end
