#!/bin/csh
####!/bin/csh -fx
# Updated  16-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set comp = ocn
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/${comp}
set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/LENS2/archive_analysis/${comp}

set vars = ( `ls ${ARC_ROOT}` )
foreach var ( ${vars} )
#set adir_ens = ${ARC_ROOT}/${var}/ens_all
set adir_ens = ${ARC_ROOT}/${var}/ens_smbb
set sdir_ens = ${SAVE_ROOT}/${var}/ens_all
mkdir -p $sdir_ens

#mkdir -p ${SAVE_ROOT}/${var}/corr

#ln -sf ${adir_ens}/*.nc ${sdir_ens}/
ln -sf ${adir_ens}/*ensmean*.nc ${sdir_ens}/

end

