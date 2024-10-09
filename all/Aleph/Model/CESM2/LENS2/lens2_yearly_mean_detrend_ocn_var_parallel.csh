#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = (NO3)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
#set vars = ( Fe )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( IRON_FLUX )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
set vars = (HBLT HMXL IRON_FLUX photoC_TOT_zint_100m )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/yearly_det_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/yearly_det_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep LE2-\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  set SAVE_Y_ROOT = \${ARC_Y_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  mkdir -p \$SAVE_Y_ROOT
  cdo -O -w -z zip_5 -timselmean,12,0,0 \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.pop.h.nc \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.lens2.\${CASENAME}.pop.h.nc
  cdo -O -w -z zip_5 -detrend \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.lens2.\${CASENAME}.pop.h.nc \${SAVE_Y_ROOT}/${var}_yearly_det_\${RESOLN}.lens2.\${CASENAME}.pop.h.nc
  #echo "cdo -O -w -z zip_5 -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.pop.h.nc
  #sleep 3s
end 

EOF

csh $tmp_scr csh > $tmp_log &
end
