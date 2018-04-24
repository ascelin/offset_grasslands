library(offsetsim)

source('grassland_params.R' )

user_simulation_params = initialise_user_simulation_params()
user_global_params = initialise_user_global_params()
user_output_params <- initialise_user_output_params()

osim.run(user_global_params, user_simulation_params, loglevel = 'TRACE')
current_simulation_folder = find_current_run_folder()
osim.output(user_output_params, current_simulation_folder, loglevel = 'TRACE')