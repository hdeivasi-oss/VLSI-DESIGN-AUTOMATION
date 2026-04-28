create_clock [get_ports clk] -period 1.1
set_input_delay 0.0 -clock [get_clocks *] [all_inputs]
set_output_delay 0.0 -clock [get_clocks *] [all_outputs]
