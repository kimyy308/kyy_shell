#!/bin/csh


set fixed_dir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/ASSM_EXP_fixed/archive
set org_dir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive


set mems = ( projdv7.3_ba-10p1 projdv7.3_ba-10p2 projdv7.3_ba-10p3 projdv7.3_ba-10p4 projdv7.3_ba-10p5 projdv7.3_ba-20p1 projdv7.3_ba-20p2 projdv7.3_ba-20p3 projdv7.3_ba-20p4 projdv7.3_ba-20p5 )

foreach mem ( $mems )

  set model = "b.e21.BSSP370smbb.f09_g17.assm."${mem}
  set ts = "proc/tseries"

# ls ${fixed_dir}/${model}/atm/${ts}/day_1/*
# ls ${org_dir}/${model}/atm/${ts}/day_1/*



  set comp = day_1
  cp -f ${fixed_dir}/${model}/atm/${ts}/${comp}/* ${org_dir}/${model}/atm/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/ice/${ts}/${comp}/* ${org_dir}/${model}/ice/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/lnd/${ts}/${comp}/* ${org_dir}/${model}/lnd/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/ocn/${ts}/${comp}/* ${org_dir}/${model}/ocn/${ts}/${comp}/
  
  set comp = day_5
  cp -f ${fixed_dir}/${model}/ocn/${ts}/${comp}/* ${org_dir}/${model}/ocn/${ts}/${comp}/

  set comp = month_1
  cp -f ${fixed_dir}/${model}/atm/${ts}/${comp}/* ${org_dir}/${model}/atm/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/ice/${ts}/${comp}/* ${org_dir}/${model}/ice/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/lnd/${ts}/${comp}/* ${org_dir}/${model}/lnd/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/ocn/${ts}/${comp}/* ${org_dir}/${model}/ocn/${ts}/${comp}/
  cp -f ${fixed_dir}/${model}/rof/${ts}/${comp}/* ${org_dir}/${model}/rof/${ts}/${comp}/

end
