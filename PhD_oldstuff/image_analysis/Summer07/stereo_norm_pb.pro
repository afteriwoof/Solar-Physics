; Last Edited: 18-07-07

pro stereo_norm_pb, files

	da = sccreadfits(files, in)

	sz = size(da, /dim)

	for i=0,sz[2]-1 do begin
		im = rm_inner(da[*,*,i], in[i], dr_px, thr=1.5)
		im = rm_outer(im, in[i], dr_px, thr=4.2)
		da[*,*,i] = fmedian(im,5,3)
		
		sccwritefits, 'pb_'+in[i].filename, da[*,*,i], in[i], comments='Normalised image'
	endfor
		
	


end
