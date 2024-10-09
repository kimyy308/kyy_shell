#!/bin/csh

set mem = `cat mem_name`

### month_1
  set vnames = ( DIRECT_DISCHARGE_TO_OCEAN_ICE DIRECT_DISCHARGE_TO_OCEAN_LIQ )

  foreach   vname ( $vnames )
   rm -f /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/rof/proc/tseries/month_1/*.$vname.*.nc
  end
