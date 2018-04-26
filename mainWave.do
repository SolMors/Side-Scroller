# working directory
vlib work

# Compile all Verilog modules
vlog -timescale 1ns/1ns main.v

# Load Sim
vsim main

# Log it

log {/*}
add wave {/*}
add wave {/main/c0/*}
add wave {/main/c0/f0/*}
add wave {/main/m0/*}
add wave {/main/v0/*}
add wave {/main/m0/mc0/*}
add wave {/main/m0/md0/*}
add wave {/main/m0/md0/pfms0/*}

#Sim clock
force {CLOCK_50} 0 0, 1 1 -r 2
#force {KEY[0]} 0 0, 1 1, 0 2

# Start it
force {KEY[1]} 1 0, 0 3, 1 4

# Sim keyboard input
force {SW[2:0]} 000 0, 010 1520, 000 1550
# force {SW[4]} 0 0

run 5000ns
