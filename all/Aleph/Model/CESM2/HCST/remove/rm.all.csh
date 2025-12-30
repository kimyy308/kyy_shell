#!/bin/csh

set mems = ( projdv7.3_ba-10p1 projdv7.3_ba-10p2 projdv7.3_ba-10p3 projdv7.3_ba-10p4 projdv7.3_ba-10p5 projdv7.3_ba-20p1 projdv7.3_ba-20p2 projdv7.3_ba-20p3 projdv7.3_ba-20p4 projdv7.3_ba-20p5 )
set iyears = ( 2021 )


foreach mem ( $mems )
foreach iyear ( $iyears )

# set mem = projdv7.3_ba-20p5

#  ls /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/lnd/proc/tseries/hour_3

  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/atm/proc/tseries/hour_?
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/lnd/proc/tseries/hour_3
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/lnd/proc/tseries/day_365
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/ocn/proc/tseries/year_1
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/glc
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/rof/proc/tseries/day_1
  rm -rf /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/rof/proc/tseries/month_1/*rtm*

  echo $mem > mem_name

  csh rm.timeseries.atm.csh $iyear
  csh rm.timeseries.atm.day_1.csh $iyear
  csh rm.timeseries.ice.csh $iyear
  csh rm.timeseries.lnd.csh $iyear
  csh rm.timeseries.ocn.csh $iyear
  csh rm.timeseries.rof.csh $iyear

end
end
