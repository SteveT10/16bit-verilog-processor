# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./Datapath.sv"
vlog "./Mux_16w_2to1.sv"
vlog "./regfile16x16a.sv"
vlog "./ALU.sv"
vlog "./DataMemory.v"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work Datapath_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do datapath_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
