# This ModelSim DO-script starts or restarts the
# simulation with or without the waveform window.
#
# Usage: do run.do [wave|nowave]
#
# Example: do run.do
#          do run.do wave
#          do run.do nowave
#
# A wave/nowave flag specified on the command line
# overrides the defaultWaveFlag variable

namespace eval ::run_do {

  # Change these settings to match your project
  #
  # tbEnt:   Testbench entity
  # tcLib:   Testbench library
  # runTime: Time value (e.g., "10 ns")
  #          or "-all" to run until the finish keyword
  variable tbEnt subframe_processor_tb
  variable tbLib spdif_amp_sim
  variable runTime -all

  variable defaultWaveFlag nowave
  variable waveFile wave.do

  # 0 = Note  1 = Warning  2 = Error  3 = Failure  4 = Fatal
  variable BreakOnAssertion 3

  # Don't show base (7'h, 32'd, etc.) in waveform
  quietly radix noshowbase

  # Avoid "File modified outside of source editor" popup warning
  set PrefSource(AutoReloadModifiedFiles) 1

  # Process command-line arguments $1 to $9
  for {variable i 1} {$i < 10} {incr i} {

    if {[info exists $i]} {
      variable arg [subst "\$$i"]

      if {$arg == "wave"} {
        variable defaultWaveFlag wave
      } elseif {$arg == "nowave"} {
        variable defaultWaveFlag nowave
      } else {
        echo "DO script: unrecognized command-line argument: \"$arg\""
        echo "(Should be \"wave\" or \"nowave\")"
      }
    }
  }

  # If the design already is loaded
  if {[runStatus] != "nodesign" && [find instances -bydu -nodu $tbEnt] == "/$tbEnt"} {

    # Restart the simulation
    restart -force

  } else {

    # Start a new simulation
    if {$defaultWaveFlag == "wave"} {
      vsim -gui -onfinish stop -do $waveFile -msgmode both $tbLib.$tbEnt
    } else {
      vsim -gui -onfinish stop -msgmode both $tbLib.$tbEnt
    }
  }

  if {$defaultWaveFlag == "wave"} {

    # If the wave window is not open
    if {[string first ".wave" [view]] == -1} {
      do $waveFile
    }

  } else {
    noview wave
  }

  # Save the signal history, even before adding them to the
  # waveform. This slows down the simulation for large designs,
  # but it allows us to add signals to the waveform
  # without restarting the simulation after adding them.
  log * -r

  # Run the testbench
  run $runTime
}