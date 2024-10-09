#!/bin/csh
####!/bin/csh -fx
# Updated  07-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set siy = 2022
#set eiy = 2022
set siy = 2021
set eiy = 1950
set var = sst

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv HadISST1_ROOT /mnt/lustre/proj/kimyy/Observation/HadISST1
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/HadISST1/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${HadISST1_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${HadISST1_ROOT}/HadISST_sst.nc 
    set output = ${SAVE_ROOT}/HadISST1_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_HadISST.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_HadISST.nc ${output}
  end
end


#    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_GPCC.nc
#    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_GPCC.nc ${output}
