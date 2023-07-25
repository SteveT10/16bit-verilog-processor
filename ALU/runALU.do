# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
#     This compiles source code and SV extensions
#     into a specifiede working library
vlog "./ALU.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
#   -vopt is a tool
#   -t is specifies the simulator time resolution, fs, ps, ns, us, ms, sec allowed.
#   -lib <folder> specifies the working library in which vsim will look for design units
vsim -voptargs="+acc" -t 1ps -lib work ALU_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do ALUwave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
