; Batch routine to call the parametric bootstrapping routine several times for different dates

pro batch_bootstrapping

	resolve_routine, 'parametric_bootstrapping'

	parametric_bootstrapping, 20071207, /plot_on

	resolve_routine, 'parametric_bootstrapping'

	parametric_bootstrapping, 20080107, /plot_on

	resolve_routine, 'parametric_bootstrapping'

	parametric_bootstrapping, 20080426, /plot_on

	resolve_routine, 'parametric_bootstrapping'

	parametric_bootstrapping, 20071207, /plot_on




end