; Make plots for the AandA paper using toggle.

; Last Edited: 15-07-08

pro make_plots_secchi

	!p.thick=2
	!p.charthick=2
	!p.charsize=2

	!p.multi=[0,2,2]

	;**********	

	toggle, f='images_20071008.ps'
	;toggle, f='images_c_20071008.ps', /color, /portrait
	;loadct, 8
	
	k=54
	fls = file_search('~/phd/data_stereo/20071008/b/cor1/*fts')
        da = sccreadfits(fls[k], in)
	da = fmedian(da,3,3)	
	da = rm_inner_stereo(da, in, dr_px, thr=1.5)
	map = mk_secchi_map(in, sigrange(da,frac=0.96))
	sub_map, map, smap, xr=[0,3800], yr=[-1400,2400]
	
       ; restore, '~/PhD/data_vso/20040401/errors.sav'
       	restore, '~/phd/data_stereo/20071008/b/cor1/edg_images/fronts.sav', /ver

	pos = [0.5, 0.5, 1, 1]
        plot_map, smap, /limb,  /notit, /nolabel, /noaxes, pos=pos, /isotropic	
	front = fronts[*,*,k]
        front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap
        draw_circle, 0, 0, in.rsun
        
	pos = [0, 0.5, 0.5, 1]
        plot_map, smap, /limb,  /notit, /nolabel, /noaxes, pos=pos, /isotropic
        draw_circle, 0, 0, in.rsun

        ;**********

	;loadct, 1
	k=14
	fls = file_search('~/phd/data_stereo/20071008/b/cor2/*fts')
        da = sccreadfits(fls[k+5], in, outsize=1024)
	da = rot(da, -in.crota, /interp)
	
	;da = rm_inner_stereo(da, in, dr_px, thr=2.)
	map = mk_secchi_map(in, sigrange(da,frac=0.97))
	sub_map, map, smap, xr=[0,15000],yr=[-6000,9000]
	
        ;restore, '~/phd/data_vso/20040401/errorsc3.sav'
        restore, '~/phd/data_stereo/20071008/b/cor2/edg_images/fronts.sav', /ver

;        ell_kinematics_printout3, in, da, edges[*,*,*], errorsc3, 2

        pos = [0.5,0.15,1,0.65]
        plot_map, smap, /limb, /notit, /nolabel, /noaxes, pos=pos, /isotropic
	front = fronts[*,*,k]
	front = rot(front, -in.crota, /interp)
        front_ell_kinematics_printout_chose7, front, 8, in, da, 2, pos, smap        
	draw_circle, 0, 0, in.rsun
        
	pos = [0,0.15,0.5,0.65]
        plot_map, smap, /limb, /notit, /nolabel, /noaxes, pos=pos, /isotropic        
	draw_circle, 0, 0, in.rsun

	toggle
	;**********


end
