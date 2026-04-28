#Edge: BOTTOM
place_pin -pin_name data_out[3] -layer met2 -location {27.83 0.242} -force_to_die_boundary
#Edge: RIGHT
place_pin -pin_name data_out[1] -layer met3 -location {51.21 26.18} -force_to_die_boundary
place_pin -pin_name data_out[2] -layer met3 -location {51.21 19.38} -force_to_die_boundary
place_pin -pin_name shift_en -layer met3 -location {51.21 31.62} -force_to_die_boundary
#Edge: TOP
place_pin -pin_name clk -layer met2 -location {23.23 51.367} -force_to_die_boundary
place_pin -pin_name data_in[0] -layer met2 -location {15.87 51.367} -force_to_die_boundary
place_pin -pin_name data_out[0] -layer met2 -location {31.51 51.367} -force_to_die_boundary
place_pin -pin_name rst -layer met2 -location {22.31 51.367} -force_to_die_boundary
place_pin -pin_name serial_in -layer met2 -location {32.43 51.367} -force_to_die_boundary
#Edge: LEFT
place_pin -pin_name data_in[1] -layer met3 -location {0.4 31.62} -force_to_die_boundary
place_pin -pin_name data_in[2] -layer met3 -location {0.4 24.82} -force_to_die_boundary
place_pin -pin_name data_in[3] -layer met3 -location {0.4 23.46} -force_to_die_boundary
place_pin -pin_name load -layer met3 -location {0.4 35.7} -force_to_die_boundary
