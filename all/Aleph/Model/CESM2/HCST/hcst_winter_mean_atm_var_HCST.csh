#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (10 20)
#set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1970
#set siy = 1990
#set eiy = 1970
#set var = SST
set var = PSL

set region1 = NAOA
set xs1 = -28
set xe1 = -20
set ys1 = 36
set ye1 = 40
set region2 = NAOI
set xs2 = -25
set xe2 = -16
set ys2 = 63
set ye2 = 70


set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
 # setenv ARC_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/atm/${var}
 # setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/atm/${var}/ens_all/ens_all_i${iyloop}
  setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/ens_all/ens_all_i${iyloop}
  setenv SAVE_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/ens_all/ens_all_i${iyloop}/winter
  setenv SAVE_R1_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/ens_all/ens_all_i${iyloop}/winter/${region1}
  setenv SAVE_R2_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/ens_all/ens_all_i${iyloop}/winter/${region2}
  
  mkdir -p $SAVE_ROOT
  mkdir -p $SAVE_R1_ROOT
  mkdir -p $SAVE_R2_ROOT

  @ fy_end = ${iyloop} + 3
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    @ fy_next = ${fy} + 1
#    foreach mon ( ${M_SET} )
#      set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
      set input_dec = ${ARC_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-12.nc
      set input_jan = ${ARC_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy_next}-01.nc
      set input_feb = ${ARC_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy_next}-02.nc
      set input_mar = ${ARC_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy_next}-03.nc
      set outputname=${SAVE_ROOT}/${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-djfm.nc
      set outputname1=${SAVE_R1_ROOT}/${region1}_${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-djfm.nc
      set outputname1_m=${SAVE_R1_ROOT}/M_${region1}_${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-djfm.nc
      set outputname2=${SAVE_R2_ROOT}/${region2}_${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-djfm.nc
      set outputname2_m=${SAVE_R2_ROOT}/M_${region2}_${var}_${RESOLN}.hcst.ens_all_i${iyloop}.cam.h0.${fy}-djfm.nc
#      echo "cdo -O ensmean "${input_set} ${outputname}
      cdo -O ensmean ${input_dec} ${input_jan} ${input_feb} ${input_mar} ${outputname}
      
      #region1 extract, fldmean
      cdo -O -w -z zip_5 -sellonlatbox,${xs1},${xe1},${ys1},${ye1} ${outputname} ${outputname1}
      cdo -O -w -z zip_5 -fldmean ${outputname1} ${outputname1_m} 
      
      #region2 extract, fldmean
      cdo -O -w -z zip_5 -sellonlatbox,${xs2},${xe2},${ys2},${ye2} ${outputname} ${outputname2}
      cdo -O -w -z zip_5 -fldmean ${outputname2} ${outputname2_m} 
#    end
  end
end


