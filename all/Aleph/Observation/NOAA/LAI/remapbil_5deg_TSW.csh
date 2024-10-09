#!/bin/csh
####!/bin/csh -fx
# Updated  12-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2021
set eiy = 1982

#precip

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv LAI_ROOT /mnt/lustre/proj/earth.system.predictability/OBS_DATA_FOR_COMPARISON/noaa/avhrr-land-leaf-area-index-and-fapar/access/${INITY}/
  setenv grid_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/TSW/
  setenv SAVE_monthly_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/LAI/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/LAI/monthly_reg_5deg
  mkdir -p $SAVE_monthly_ROOT
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${grid_ROOT}//SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${LAI_ROOT}/AVHRR-Land_*${INITY}${mon}??_*.nc 
    set output1 = ${SAVE_monthly_ROOT}/LAI_monthly.${iyloop}${mon}.nc 
    set output2 = ${SAVE_ROOT}/LAI_reg_5deg.${iyloop}${mon}.nc 
#    cdo -w -z zip_5 -ensmean ${input} ${output1}
#    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_LAI.nc
    cdo -O remapbil,r72x36 ${output1} ${output2}
#    cdo -O remapbil,${gridfile} ${output1} ${output2}
  end
end
#rm -f /proj/kimyy/tmp/test_LAI.nc

