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
set vars = ( WVEL2 )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/merge_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/merge_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set FILE_ROOT = \${ARC_ROOT}/\${CASENAME}
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  cd \${FILE_ROOT}
  set FILE_SET = ( \`ls ${var}_\${CASENAME}.pop.h.????-??.nc\` )
  cdo -O -w -z zip_5 -mergetime \${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.pop.h.nc
  #echo "cdo -O -w -z zip_5 -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.pop.h.nc
  #sleep 3s
end 

EOF

csh $tmp_scr > $tmp_log &
end
