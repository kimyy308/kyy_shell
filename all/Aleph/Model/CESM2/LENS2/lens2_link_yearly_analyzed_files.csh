#!/bin/csh
####!/bin/csh -fx
# Updated  16-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set comp = ocn
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/${comp}
set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/LENS2/archive_yearly_analysis/${comp}

set vars = ( `ls ${ARC_ROOT}` )
foreach var ( ${vars} )
set adir_corr_ens = ${ARC_ROOT}/${var}/corr/ens
set sdir_corr_ens = ${SAVE_ROOT}/${var}/corr/ens

set adir_ens = ${ARC_ROOT}/${var}/ens_all
set sdir_ens = ${SAVE_ROOT}/${var}/ens_all
mkdir -p $sdir_ens
set adir_corr_ens = ${ARC_ROOT}/${var}/corr/ens
set sdir_corr_ens = ${SAVE_ROOT}/${var}/corr/ens
mkdir -p $sdir_corr_ens
#mkdir -p ${SAVE_ROOT}/${var}/corr

ln -sf ${adir_corr_ens}/* ${sdir_corr_ens}/
ln -sf ${adir_ens}/*SNR* ${sdir_ens}/
ln -sf ${adir_ens}/*_time_* ${sdir_ens}/

end

