# oseda -2025.01 yosys -C
# -C (short for --tcl-interactive) 
# Yosys to start an interactive TCL command line shell

# source \sw\synthesis_script.tcl
# run the script in the Yosys interactive shell

# To re-run
# exit
# rm -r tmp/ out/* reports/* *.log
# start again with the first 2 commands

# Non-interactive mode 
# oseda -2025.01 yosys -C \sw\synthesis_script.tcl

# Make sure we are at base croc directory and copy the script file to yosys/scripts
# Step-1

icdesign ihp13 -update all -nogui



# Step-2

cd yosys



# Step-3

oseda -2025.01 yosys -C



# Step-4
# Read liberty files for standard cells, SRAM macros, and I/O pads

yosys read_liberty -lib ../technology/lib/RM_IHPSG13_lP_256x64_c2_bm_bist_typ_lp20V_25C.lib
yosys read_liberty -lib ../technology/lib/sg13g2_io_typ_lp2V_3p3V_25C.lib
yosys read_liberty -lib ../technology/lib/sg13g2_stdcell_typ_lp20V_25C.lib



# Step-5
# Load the design

# Step-5.1
# Enable plugin: process SystemVerilog designs through yosys-slang plugin

yosys plugin -i slang.so


# Step-5.2
# read_slang command to load the design

yosys read_slang --top croc_chip -F ../croc.flist -allow-use-before-declare --ignore-unknown-modules --keep-hierarchy


# Step-5.3
# Print information about the loaded design

yosys stat


# Step-5.4
# Export the report into a file

yosys tee -q -o "reports/croc_parsed_preprocessing.rpt" stat -width 


# Step-5.5
# export the netlist

yosys write_verilog "out/croc.analysys_preprocessing.v"



# Step-6
# Elaboration

# Step-6.1
# Resolve design hierarchy
# hierarchy command is used to check, expand, and clean up the design hierarchy
# The -check flag is recommended, as it ensures that the design hierarchy is properly validated, generating an error if any unknown modules are used as cell types

yosys hierarchy -check -top croc_chip


# Step-6.2
# Convert processes to netlists
# Translate the behavioral logic into a RTL netlist. This is done using the proc command.

yosys proc


# Step-6.3
# Export report and netlists

yosys stat
yosys tee -q -o "reports/croc_parsed_elaboration.rpt" stat -width 
yosys write_verilog "out/croc.analysys_elaboration.v"



# Step-7
# Coarse-grain Synthesis

# Step-7.1
# Early-stage design check
# should not encounter any errors

yosys check


# Step-7.2
# First opt pass (no FF)
# Make sure to use the -noff flag to ensure that the opt_dff command is excluded from the optimization pass, as we have not optimized the design's FSMs yet.

yosys opt -noff


# Step-7.3
# Extract FSM and write report
# fsm command to extract and optimize Finite State Machines (FSMs) from the design

yosys fsm
yosys stat
yosys tee -q -o "reports/croc_parsed_coarse-grain-fsm.rpt" stat -width 
yosys write_verilog "out/croc.analysys_coarse-grain-fsm.v"


# Step-7.4
# Perform wreduce
# wreduce pass reduces the bit-width of operations

yosys wreduce


# Step-7.5
# Infer memories and optimize register-files
# peepopt pass applies a collection of peephole optimizers to the current design. This includes architectural level optimizations such as simplifying arithmetic expressions.

yosys peepopt
yosys opt -full


# Step-7.6
# Resource sharing
# Did no use this in the exercise but was given
# hare pass consolidates shareable resources into a single instance. It uses a SAT solver to determine if resources can be shared. 

yosys share


# Step-7.7
# Memory inference and register file optimization
# Was supposed to be done in exercise we didnt use in script
# memory command is used to infer memory blocks from the design.

yosys memory


# Step-7.8
# Optimize flip-flops

yosys opt_dff


# Step-7.8
# Export reports and netlists

yosys stat
yosys tee -q -o "reports/croc_parsed_coarse-grain.rpt" stat -width 
yosys write_verilog "out/croc.analysys_coarse-grain.v"



# Step-8
# Define target clock frequency

# Step-8.1
# Define a Clock Period
# To define a clock period of 10,000 picoseconds (which corresponds to 100 MHz)
set period_ps 10000



# Step-9
# Set input / output constraints in the constraint file
# croc/yosys/src/yosys_abc.constr

# Step-9.1
# Set driving cell
# The numerical suffix x indicates the size and reflects the relative drive strength of the cell. A stronger buffer (e.g., sg13g2_buf_16) will drive loads faster. However, Using a buffer that's too strong might not accurately represent how the chip will perform, which might not mirror real-world scenarios. In our example design, set the driving cell as sg13g2_buf_4.

# set_driving_cell sg13g2_buf_4


# Step-9.2
# Set Load
# the output load as 0.015pF. This roughly corresponds to the input capacitance of the sg13g2_buf_16 gate

# set_load 0.015



# Step-10
# Technology Mapping
#  RTL netlist is transformed into a functionally-equivalent netlist composed of standard cell instances from the target technology library and wires connecting them, making it ready for physical implementation.

# Step-10.1
# Generic cell substitution
# RTL cells are mapped to an internal Yosys library of generic single-bit gate-level cells

yosys techmap


# Step-10.2
# Generate report

yosys stat
yosys tee -q -o "reports/croc_parsed_generic_cell_substitution.rpt" stat -width 
yosys write_verilog "out/croc.analysys_generic_cell_substitution.v"


# Step-10.3
# Gate level technology mapping
