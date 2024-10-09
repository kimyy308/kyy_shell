#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = (NO3)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
#set vars = ( Fe )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( IRON_FLUX )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diatC diazC spC )


set comps = ( atm ocn )

foreach comp ( ${comps} )

  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/${comp}
  set RESOLN = f09_g17

  set statdir = ${ARC_ROOT}/../post_stat
  mkdir -p ${statdir}
  set stat_ext = ${statdir}/${comp}_stat_ext
  set stat_merge = ${statdir}/${comp}_stat_merge
  set stat_ens = ${statdir}/${comp}_stat_ens
  
  echo "postprocessing - extracting check" > ${stat_ext}
  echo "postprocessing - merging check" > ${stat_merge}
  echo "postprocessing - ensemble mean check" > ${stat_ens}

  set vars = ( `ls ${ARC_ROOT}` )
  
  foreach var ( ${vars} )
    set VAR_ROOT = ${ARC_ROOT}/${var}
    set CASENAME_SET = ( `ls ${VAR_ROOT} | grep ${RESOLN}.assm.` ) 
    foreach CASENAME ( ${CASENAME_SET} )
      set fin_period = `ls ${VAR_ROOT}/${CASENAME}/*.nc | rev | cut -d '.' -f 2 | rev | head --lines=1`
      echo ${var}", "${CASENAME}", "${fin_period} >> ${stat_ext}
    end
    set fin_period = `ls ${VAR_ROOT}/ens_all/*.nc | rev | cut -d '.' -f 2 | cut -d '_' -f 1 | rev | head --lines=1`
    echo ${var}", "ens_all", "${fin_period} >> ${stat_ens}
  end
end
