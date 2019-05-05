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
ExecStep $xv_path/bin/xelab -wto b6f32a63cfde4a3d9fdb4fcc310c64d4 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot test_bench_for_lab3_behav xil_defaultlib.test_bench_for_lab3 xil_defaultlib.glbl -log elaborate.log
