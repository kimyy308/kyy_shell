#!/bin/csh
####!/bin/csh -fx
# Updated  04-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set comp = lnd
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/${comp}
set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive_analysis/${comp}

#set vars = ( `ls ${ARC_ROOT}` )
set vars = ( RAIN )
foreach var ( ${vars} )
set adir_corr_ens = ${ARC_ROOT}/${var}/corr/ens
set sdir_corr_ens = ${SAVE_ROOT}/${var}/corr/ens

set siy = 2021
set eiy = 1960
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
foreach iy ( ${IY_SET} ) 
set adir_ens = ${ARC_ROOT}/${var}/ens_all/ens_all_i${iy}
set sdir_ens = ${SAVE_ROOT}/${var}/ens_all/ens_all_i${iy}
mkdir -p $sdir_ens

#set adir_corr_ens = ${ARC_ROOT}/${var}/corr/ens
#set sdir_corr_ens = ${SAVE_ROOT}/${var}/corr/ens
#mkdir -p $sdir_corr_ens

#mkdir -p ${SAVE_ROOT}/${var}/corr

#ln -sf ${adir_corr_ens}/* ${sdir_corr_ens}/
#ln -sf ${adir_ens}/*SNR* ${sdir_ens}/
#ln -sf ${adir_ens}/*_time_* ${sdir_ens}/

#ln -sf ${adir_ens}/*ensmean_all* ${sdir_ens}/

if ( -d ${adir_ens}/GLO ) then
  mkdir -p $sdir_ens/GLO
  ln -sf ${adir_ens}/GLO/M_* $sdir_ens/GLO/
endif

end
end

