#!/bin/csh
####!/bin/csh -fx
# Updated  28-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

set sy = 1998
set ey = 2020
set var = photoC_TOT_zint


#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (20)
set mbr_set = (1)
set RESOLN = f09_g17
set siy = ${sy}
set eiy = ${ey}
set outfreq = mon
set Y_SET = ( `seq ${siy} +1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach year ( ${Y_SET} )
foreach month ( ${M_SET} )
foreach OBS ( ${OBS_SET} ) #OBS loop1
  foreach FACTOR ( $FACTOR_SET ) #FACTOR loop1
    foreach mbr ( $mbr_set ) #mbr loop1
#      set CASENAME_M = b.e21.${scen}.${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}  #parent casename
      set CASENAME = ${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}  #parent casename
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ATM/archive_transfer/ocn/${outfreq}/${var}/${CASENAME}
      set SAVE_ROOT = ${ARC_ROOT} 
      mkdir -p ${SAVE_ROOT}/link
      set OBS_ROOT = /mnt/lustre/proj/kimyy/Observation/OC_CCI/monthly_reg_cam 
      mkdir -p $SAVE_ROOT
      mkdir -p ${SAVE_ROOT}/merged
      ln -sf ${ARC_ROOT}/b.e21.${var}_${outfreq}_${CASENAME}.pop.h.${year}-${month}.nc ${SAVE_ROOT}/link/
      ln -sf ${OBS_ROOT}/OC_CCI_reg_cesm2.${year}${month}.nc ${SAVE_ROOT}/link/

    end
  end
end
end
end
mkdir -p ${SAVE_ROOT}/corr
cdo -O -mergetime ${SAVE_ROOT}/link/b.e21* ${SAVE_ROOT}/merged/merged_${var}_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mergetime ${SAVE_ROOT}/link/OC_CCI* ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc
cdo -O -yearmean ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc
cdo -O -expr,'chlor_a=chlor_a/chlor_a' ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT}/merged/merged_${var}_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT}/merged/OC_CCI_masked_merged_${var}_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT}/merged/OC_CCI_masked_merged_${var}_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT}/merged/OC_CCI_masked_yearly_merged_${var}_${CASENAME}_${siy}_${eiy}.nc

cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,photoC_TOT_zint ${SAVE_ROOT}/merged/OC_CCI_masked_merged_${var}_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT}/corr/OC_CCI_masked_corr_${var}_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,photoC_TOT_zint ${SAVE_ROOT}/merged/OC_CCI_masked_yearly_merged_${var}_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT}/corr/OC_CCI_masked_yearly_corr_${var}_${CASENAME}_${siy}_${eiy}.nc

#rm -f ${homedir}/test2_${var}.nc
rm -rf ${SAVE_ROOT}/link/*
echo "postprocessing complete"


