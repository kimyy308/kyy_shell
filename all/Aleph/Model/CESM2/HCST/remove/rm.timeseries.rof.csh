#!/bin/csh

set iyear = $1
set mem = `cat mem_name`

### month_1
  set vnames = ( DIRECT_DISCHARGE_TO_OCEAN_ICE DIRECT_DISCHARGE_TO_OCEAN_LIQ )

  foreach   vname ( $vnames )
   rm -f /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/*f09_g17.hcst.${mem}/f09_g17.hcst.${mem}_i${iyear}/rof/proc/tseries/month_1/*.$vname.*.nc
  end
