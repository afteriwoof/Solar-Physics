; Last Edited: 31-07-07

pro stereo_norm_totb_rot, files

	da = sccreadfits(files, in)
	sz = size(da, /dim)

	for i=0,sz[2]-1 do begin
		im = rot(da[*,*,i], -in[i].crota)
		im = rm_inner(im, in[i], dr_px, thr=1.5)
		im = rm_outer(im, in[i], dr_px, thr=4.2)
		da[*,*,i] = fmedian(im,5,3)
		in[i].crota = 0
		sccwritefits, 'totb_rot_'+in[i].filename, da[*,*,i], in[i], comments='Rotated Image'
	endfor
		
	


end
