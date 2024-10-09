#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (10 20)
#set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#set siy = 2020
#set eiy = 1970
set siy = 2021
set eiy = 2021
#set siy = 1990
#set eiy = 1970
set var = TS
#set var = PSL
#set var = PRECT
#set var = TS

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
 # setenv ARC_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/atm/${var}
 # setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/atm/${var}/ens_all/ens_all_i${iyloop}
  setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}
  setenv SAVE_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/ens_all/ens_all_i${iyloop}
  
  mkdir -p $SAVE_ROOT
  @ fy_end = ${iyloop} + 4
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    foreach mon ( ${M_SET} )
      set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
      set outputname=${SAVE_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-${mon}.nc
#      echo "cdo -O ensmean "${input_set} ${outputname}
      cdo -O ensmean ${input_set} ${outputname}
    end
  end
end


