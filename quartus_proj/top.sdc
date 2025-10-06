create_clock -period "50.0 MHz" [get_ports CLOCK_50]
# create_clock -period "50.0 MHz" [get_ports CLOCK2_50]
# create_clock -period "50.0 MHz" [get_ports CLOCK3_50]
# create_clock -period "50.0 MHz" [get_ports CLOCK4_50]

derive_clock_uncertainty

set_false_path -from * -to [get_ports {LEDR[*]}]
set_false_path -from [get_ports {KEY[*]}] -to [all_clocks]
# set_false_path -from [get_ports {SW[*]}] -to [all_clocks]