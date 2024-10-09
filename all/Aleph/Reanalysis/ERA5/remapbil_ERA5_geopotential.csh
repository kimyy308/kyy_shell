#!/bin/csh
####!/bin/csh -fx
# Updated  23-Jul-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set siy = 2022
#set eiy = 1960
set siy = 2011
set eiy = 2011
#set var = geopotential #var157
#set var = u10
set var = v10

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set M_SET = ( 02 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv grid_ROOT /proj/kimyy/Observation/ERA5/msl 
#  setenv ERA5_ROOT /mnt/lustre/proj/earth.system.predictability/OBS_DATA_FOR_COMPARISON/ERA5/${var}
  setenv ERA5_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/raw_monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${grid_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
#    @ tind = `expr \( ${INITY} - 1940 \) \* 12`
#    @ tind2 = $tind + $mon - 5
#    set input = ${ERA5_ROOT}/monthly_${INITY}.grib
    set input = ${ERA5_ROOT}/ERA5_${var}_${iyloop}${mon}.nc
#    set tempgrib = ${SAVE_ROOT}/temp1.grib
#    set temp1 = ${SAVE_ROOT}/temp1.nc
#    set temp2 = ${SAVE_ROOT}/temp2.nc
    set output = ${SAVE_ROOT}/ERA5_${var}_reg_cesm2.${iyloop}${mon}.nc
#    cdo -O -w -seltimestep,$tind2 $input $temp1
#    cdo -f nc copy $temp1 $temp2
    cdo -O -w -z zip_5 remapbil,${gridfile} ${input} ${output}
  end
end
#rm -f $temp1

