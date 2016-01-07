; Routine to plot a given equation of constant acceleration and try and re-derive that equation
; for varying cadences. Initial estimates were presented at BUKS in Belgium. The routine needs to 
; estimate the maximum noise level at which the data is recoverable and estimate the noise in real data.

pro kinematics_simulation, vary_noise=vary_noise, vary_cadence=vary_cadence

;*******************
; VARY NOISE LEVEL
;*******************

; Routine calls kinematics_simulation_noise

	if keyword_set(vary_noise) then begin

		kinematics_simulation_noise

	endif
	
;***************
; VARY CADENCE
;***************

; Routine calls kinematics_simulation_cadence

	if keyword_set(vary_cadence) then begin

		kinematics_simulation_cadence

	endif


end