# grasslands_example
1) Follow instructions to download offsetsim in https://github.com/isaacpeterson/offset_simulator/blob/master/README.md
2) Clone the repo from https://github.com/isaacpeterson/grasslands_example.git
3) For a simple example, run run_offset_simulation_grassland.R
4) Adjust data, simulation, and plot parameters in grassland_params.R
5) The simulation reformats the GIS data from data/ into suitable objects. To adjust the example dataset the user can edit the input files through load_grassland_data.R you will require the package 'rgdal' which in turn requires several packages to support it 

(a) for linux based systems do:
- sudo apt-get update && sudo apt-get install libgdal-dev libproj-dev

(b) from within R do 
- install.packages("rgdal"); library(rgdal)
