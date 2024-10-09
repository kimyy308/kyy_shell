#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr




set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive/b.e21.BSSP370smbb.f09_g17.assm.projdv7.3_ba-10p1/atm/hist

set ARC_FILE_SET = ( `ls ${ARC_ROOT}/*.cam.h2.*` )
set HEAD = b.e21.BSSP370smbb.f09_g17.assm.projdv7.3_ba-10p1
set NUDGE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/nudging/analyses/${HEAD}
set NUDGE_TMP = ${NUDGE_ROOT}/tmp
mkdir -p ${NUDGE_TMP}
foreach ARC_FILE ( ${ARC_FILE_SET} ) 
  cdo -splitsel,1 ${ARC_FILE} ${NUDGE_TMP}/tmp_split_
  set SPL_FILE_SET = ( `ls ${NUDGE_TMP}/tmp_split_*.nc` )
  foreach SPL_FILE ( ${SPL_FILE_SET} )
    #set dsec = `printf %05i \`ncdump ${SPL_FILE} -v datesec | grep "datesec = " | cut -d ' ' -f 4\``
    set dsec = `ncdump ${SPL_FILE} -v datesec | grep "datesec = " | cut -d ' ' -f 4`
    set dsec5 = `printf %05i ${dsec}`
    set fileymd = `ncdump ${SPL_FILE} -v date | grep "date =" | cut -d ' ' -f 4` 
    set filey = `echo ${fileymd} | cut -c 1-4`
    set filem = `echo ${fileymd} | cut -c 5-6`
    set filed = `echo ${fileymd} | cut -c 7-8`
    mkdir -p ${NUDGE_ROOT}/${filey}
    mv ${SPL_FILE} ${NUDGE_ROOT}/${filey}/${HEAD}.cam.h2.${filey}-${filem}-${filed}-${dsec5}.nc
  end 
  echo ${ARC_FILE}
end

#b.e21.BSSP370smbb.f09_g17.assm.projdv7.3_ba-10p1.cam.h2.2020-01-01-00000.nc
