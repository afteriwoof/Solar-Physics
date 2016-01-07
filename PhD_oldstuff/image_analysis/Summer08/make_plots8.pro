; Make plots for the AandA paper using toggle.

; Last Edited: 15-10-08

pro make_plots8

	!p.thick=2
	!p.charthick=2
	!p.charsize=2

	!p.multi=[0,4,12]


	toggle, f='CME_images.ps', /portrait, /color


;ordering is (top) 20000102,20000418, 20000423, 20010423, 

; First The Top Two Rows!


	;**********	

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
        pos = [0.75, 0.75, 0.99, 1]
        plot_map, smap, /limb, tit='!62001 April 23', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        ;draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap

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

	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.75, 0.52, 0.99, 0.77]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        ;draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap




	;**********

	k=1
	fls = file_search('~/phd/data_vso/20000423/c2/normalised/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_Vso/20000423/c2/*fts')
        mreadfits, fls[k], in

	da = rm_inner(da, in, dr_px, thr=2.2)
	index2map, in, sigrange(da), map
	sub_map, map, smap, xr=[-100,5900], yr=[-3000,3000]
	
        restore, '~/PhD/data_vso/20000423/errorsc2.sav'
        restore, '~/PhD/data_vso/20000423/c2/normalised/edg_images/frontc2.sav'

       	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5, 0.75, 0.74, 1]
!p.color=0
        plot_map, smap, /limb, tit='!62000 April 23', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        front_ell_kinematics_printout_chose7, frontc2, errorsc2, in, da, 2, pos, smap
        ;draw_circle, 0, 0, r_sun[2]


        ;**********

	k=4
	fls = file_search('~/phd/data_vso/20000423/c3/normalised/*fts')
        mreadfits, fls[k+2], temp, da
        fls = file_search('~/phd/data_vso/20000423/c3/*fts')
        mreadfits, fls[k+2], in

	da = rm_inner(da, in, dr_px, thr=4.)
	index2map, in, alog(sigrange(da,frac=0.96)), map
	sub_map, map, smap, xr=[-3000,22000],yr=[-12000,13000]
	
        restore, '~/phd/data_vso/20000423/errorsc3.sav'
        restore, '~/phd/data_vso/20000423/c3/normalised/edg_images/frontsc3.sav'

	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.5,0.52,0.74,0.77]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        front_ell_kinematics_printout_chose7, frontsc3[*,*,k], errorsc3[k], in, da, 2, pos, smap
        ;draw_circle, 0, 0, r_sun[2]

	;************

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
	
	r_sun = pb0r(map.time, /arcsec, /soho)
	pos = [0, 0.75, 0.24, 1]
!p.color=0
        plot_map, smap, /limb, tit='!62000 January 2', pos=pos, /noaxes, /isotropic
!p.color=255
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap
	;draw_circle, 0, 0, r_sun[2]

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
	pos = [0,0.52,0.24,0.77]
	plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap
	;draw_circle, 0, 0, r_sun[2]
	
	
	;***********

	k=6
	fls = file_search('~/phd/data_vso/20000418/c3/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_vso/20000418/c3/*fts')
        mreadfits, fls[k], in 

	index2map, in, sigrange(da,frac=0.97), map
	sub_map, map, smap, xr=[-12000,15000], yr=[-27000,0]
        
	restore, '~/phd/data_vso/20000418/errorsc3.sav'
        restore, '~/phd/data_vso/20000418/c3/normalised_rm/edg_images/my_fronts.sav'

    	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.25,0.52,0.49,0.77]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        ;draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc3[k], in, da, 2, pos, smap

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
					        
  	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.25, 0.75, 0.49, 1]
!p.color=0
        plot_map, smap, /limb, tit='!62000 April 18', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        ;draw_circle, 0, 0, r_sun[2]
        front_ell_kinematics_printout_chose7, my_fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap
	
	;***********


	




; Now The Bottom Two Rows!

; 20020421, 20040401, 20071008, 20071116


	;**********

	k=6
	fls = file_search('~/phd/data_stereo/20071116/a_initial/cor1/normalised_rm/CME/*fts')
        da = sccreadfits(fls[k+2], in)
	da = fmedian(da,3,3)	
	da = rm_inner_stereo(da, in, dr_px, thr=1.5)
	map = mk_secchi_map(in, sigrange(da,frac=0.98))
	sub_map, map, smap, xr=[0,3500], yr=[-2400,1100]
	
       	restore, '~/phd/data_stereo/20071116/a_initial/cor1/normalised_rm/CME/edg_images/fronts2.sav', /ver

	pos = [0.75, 0.27, 0.99, 0.52]
!p.color=0
        plot_map, smap, /limb, tit='!62007 November 16', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb,  /notit, /nolabel, /noaxes, pos=pos, /isotropic	
	front = fronts2[*,*,k]
        front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap
        ;draw_circle, 0, 0, in.rsun


        ;**********

	k=6
	fls = file_search('~/phd/data_stereo/20071116/a_initial/cor2/*fts')
        da = sccreadfits(fls[k+2], in)
	restore, '~/totchop.sav'
	da = fltarr(2048,2048)
	sz_totchop = size(totchop,/dim)
	da[0:sz_totchop[0]-1,*]=totchop
	da = rm_inner(da, in, dr_px, thr=2.8)
	da = rot(da, -in.crota, /interp)
	
	map = mk_secchi_map(in, sigrange(da))
	sub_map, map, smap, xr=[-1100,11400],yr=[-7600,4900]
	
        restore, '~/phd/data_stereo/20071116/a_initial/cor2/edg_images/fronts.sav', /ver

        pos = [0.75, 0.041, 0.99, 0.291]
        plot_map, smap, /limb, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front = fronts[*,*,k]
	front = rot(front, -in.crota, /interp)
	front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap
	;draw_circle, 0, 0, in.rsun

	
	;**********

	
	k=0
	fls = file_search('~/phd/data_vso/20020421/c2/normalised/*fts')
        mreadfits, fls[k+1], temp, da
        fls = file_search('~/phd/data_Vso/20020421/c2/*fts')
        mreadfits, fls[k+1], in
	
	da = rm_inner(da, in, dr_px, thr=2.1)
	index2map, in, sigrange(da), map
	sub_map, map, smap, xr=[-100,4500], yr=[-2300,2300]
	
        restore, '~/PhD/data_vso/20020421/errorsc2.sav'
        restore, '~/PhD/data_vso/20020421/c2/normalised/edg_images/fronts.sav'

       	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0, 0.27, 0.24, 0.52]
!p.color=0
        plot_map, smap, /limb, tit='!62002 April 21', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        front_ell_kinematics_printout_chose7, fronts[*,*,k], errorsc2[k], in, da, 2, pos, smap
        ;draw_circle, 0, 0, r_sun[2]

       

        ;**********

	k=2
	fls = file_search('~/phd/data_vso/20020421/c3/normalised/*fts')
        mreadfits, fls[k+1], temp, da
        fls = file_search('~/phd/data_vso/20020421/c3/*fts')
        mreadfits, fls[k+1], in

	da = rm_inner(da, in, dr_px, thr=4.)
	index2map, in, alog(sigrange(da,frac=0.98)), map
	sub_map, map, smap, xr=[-500,19500],yr=[-10000,10000]
	
        restore, '~/phd/data_vso/20020421/errorsc3.sav'
        restore, '~/phd/data_vso/20020421/c3/normalised/edg_images/frontsc3.sav'


	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0, 0.041, 0.24, 0.291]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
        front_ell_kinematics_printout_chose7, frontsc3[*,*,k], errorsc3[k], in, da, 2, pos, smap
        ;draw_circle, 0, 0, r_sun[2]


	;**********

	
	k=3
	fls = file_search('~/phd/data_vso/20040401/c2/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_Vso/20040401/c2/*fts')
        mreadfits, fls[k], in
	
	da = rm_inner(da, in, dr_px, thr=2.1)
	index2map, in, sigrange(da), map
	sub_map, map, smap, xr=[-5000,100], yr=[-1000,4100]
	
        restore, '~/PhD/data_vso/20040401/errorsc2.sav'
        restore, '~/PhD/data_vso/20040401/c2/normalised_rm/edg_images/my_fronts.sav'

       	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.25, 0.27, 0.49, 0.52]
!p.color=0
        plot_map, smap, /limb, tit='!62004 April 1', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic	
	front = flip(my_fronts[*,*,k])
        front_ell_kinematics_printout_chose7, front, errorsc2[k], in, da, 2, pos, smap
	;draw_circle, 0, 0, r_sun[2]


        ;**********

	k=16
	fls = file_search('~/phd/data_vso/20040401/c3/normalised_rm/*fts')
        mreadfits, fls[k], temp, da
        fls = file_search('~/phd/data_vso/20040401/c3/*fts')
        mreadfits, fls[k], in

	da = rm_inner(da, in, dr_px, thr=4.)
	index2map, in, alog(sigrange(da,frac=0.97)), map
	sub_map, map, smap, xr=[-23000,100],yr=[-1600,21500]
	
        restore, '~/phd/data_vso/20040401/errorsc3.sav'
        restore, '~/phd/data_vso/20040401/c3/normalised_rm/edg_images/frontsc3.sav'

	r_sun = pb0r(map.time, /arcsec, /soho)
        pos = [0.25, 0.041, 0.49, 0.291]
        plot_map, smap, /limb, /log, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front = flip(frontsc3[*,*,k])
        front_ell_kinematics_printout_chose7, front, errorsc3[k], in, da, 2, pos, smap        
        ;draw_circle, 0, 0, r_sun[2]

      	;**********


	k=54
	fls = file_search('~/phd/data_stereo/20071008/b_initial/cor1/*fts')
        da = sccreadfits(fls[k], in)
	da = fmedian(da,3,3)	
	da = rm_inner_stereo(da, in, dr_px, thr=1.5)
	map = mk_secchi_map(in, sigrange(da,frac=0.96))
	sub_map, map, smap, xr=[0,3800], yr=[-1400,2400]
	
       	restore, '~/phd/data_stereo/20071008/b_initial/cor1/edg_images/fronts.sav', /ver

	pos = [0.5, 0.27, 0.74, 0.52]
!p.color=0
        plot_map, smap, /limb, tit='!62007 October 8', pos=pos, /noaxes, /isotropic
!p.color=255
        plot_map, smap, /limb,  /notit, /nolabel, /noaxes, pos=pos, /isotropic	
	front = fronts[*,*,k]
        front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap
        ;draw_circle, 0, 0, in.rsun
        

        ;**********

	k=14
	fls = file_search('~/phd/data_stereo/20071008/b_initial/cor2/*fts')
        da = sccreadfits(fls[k+5], in, outsize=1024)
	da = rot(da, -in.crota, /interp)
	
	map = mk_secchi_map(in, sigrange(da,frac=0.97))
	sub_map, map, smap, xr=[0,15000],yr=[-6000,9000]
	
        restore, '~/phd/data_stereo/20071008/b_initial/cor2/edg_images/fronts.sav', /ver

        pos = [0.5, 0.041, 0.74, 0.291]
        plot_map, smap, /limb, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front = fronts[*,*,k]
	front = rot(front, -in.crota, /interp)
        front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap        
	;draw_circle, 0, 0, in.rsun
        

	;**********




toggle



end
