#!/bin/csh
####!/bin/csh -fx
# Updated  12-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2020
set eiy = 2001

#precip

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv burned_area_ROOT /mnt/lustre/proj/earth.system.predictability/OBS_DATA_FOR_COMPARISON/esacci/fire/data/burned_area/MODIS/grid/v5.1
  setenv grid_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/TSW/
#  setenv SAVE_monthly_ROOT /mnt/lustre/proj/kimyy/Observation/MODIS/burned_area/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/MODIS/burned_area/monthly_reg_cam
#  mkdir -p $SAVE_monthly_ROOT
  mkdir -p $SAVE_ROOT
  set gridfile = ${grid_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc

#  set output1 = ${SAVE_monthly_ROOT}/burned_area_monthly.${iyloop}.nc 
#  cdo -w -z zip_5 -monmean ${input} ${output1}

  foreach mon ( ${M_SET} )
    set input = ${burned_area_ROOT}/${INITY}/${INITY}${mon}01*.nc 
    set output2 = ${SAVE_ROOT}/burned_area_reg_cesm2.${iyloop}${mon}.nc 
#    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${output1} /proj/kimyy/tmp/test_burned_area.nc
    cdo -O remapbil,${gridfile} ${input} ${output2}
  end
end
rm -f /proj/kimyy/tmp/test_burned_area.nc

