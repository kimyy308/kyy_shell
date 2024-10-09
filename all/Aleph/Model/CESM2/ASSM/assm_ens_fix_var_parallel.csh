#!/bin/csh
####!/bin/csh -fx
# Updated  11-May-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set var = $1
set INITY = $2
set mon = $3
set comp = $4


#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/${comp}/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/${comp}/${var}/ens_all

set CASENAME_SET = ( `ls ${ARC_ROOT} | grep ${RESOLN}.assm.` )

set FILE_SET = (`ls ${ARC_ROOT}/*/*${RESOLN}*${iyloop}-${mon}*.nc` )
set SAVE_ROOT = ${ARC_ROOT}/ens_all
mkdir -p $SAVE_ROOT
cdo -O -L -z zip_5 -ensmean ${FILE_SET} ${SAVE_ROOT}/${var}_ensmean_${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmax ${FILE_SET} ${SAVE_ROOT}/${var}_ensmax_${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmin ${FILE_SET} ${SAVE_ROOT}/${var}_ensmin_${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensstd ${FILE_SET} ${SAVE_ROOT}/${var}_ensstd_${INITY}-${mon}.nc
###en4
  set FILE_SET = (`ls ${ARC_ROOT}/*/*${RESOLN}*en4.2_ba*${iyloop}-${mon}*.nc` )
cdo -O -L -z zip_5 -ensmean ${FILE_SET} ${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmax ${FILE_SET} ${SAVE_ROOT}/${var}_en4.2_ba_ensmax_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmin ${FILE_SET} ${SAVE_ROOT}/${var}_en4.2_ba_ensmin_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensstd ${FILE_SET} ${SAVE_ROOT}/${var}_en4.2_ba_ensstd_i${INITY}-${mon}.nc
###projdv7.3_ba
  set FILE_SET = (`ls ${ARC_ROOT}/*/*${RESOLN}*projdv7.3_ba*${iyloop}-${mon}*.nc` )
cdo -O -L -z zip_5 -ensmean ${FILE_SET} ${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmax ${FILE_SET} ${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensmin ${FILE_SET} ${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_i${INITY}-${mon}.nc
cdo -O -L -z zip_5 -ensstd ${FILE_SET} ${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_i${INITY}-${mon}.nc


