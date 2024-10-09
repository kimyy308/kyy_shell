#!/bin/csh
cd /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive


set siy = 2021
set eiy = 1960
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 

foreach iy ( ${IY_SET} )
@ fy1 = $iy + 5
@ fy2 = $iy + 10
set fyset = ( `seq ${fy1} +1 ${fy2}` )
foreach fy ( ${fyset} )
rm -f f09_g17.hcst.en4.2_ba-10p1/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-10p2/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-10p3/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-10p4/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-10p5/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-20p1/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-20p2/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-20p3/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-20p4/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.en4.2_ba-20p5/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-10p1/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-10p2/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-10p3/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-10p4/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-10p5/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-20p1/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-20p2/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-20p3/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-20p4/*i${iy}/*/proc/tseries/*/*.${fy}01-*
rm -f f09_g17.hcst.projdv7.3_ba-20p5/*i${iy}/*/proc/tseries/*/*.${fy}01-*
end
end
