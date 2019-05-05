#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim test_bench_for_lab3_behav -key {Behavioral:sim_1:Functional:test_bench_for_lab3} -tclbatch test_bench_for_lab3.tcl -log simulate.log
