#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
#set vars = ( Fe )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4 Fe )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( IRON_FLUX )
set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )

foreach var ( ${vars} )
mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/corr_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/corr_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}/corr
mkdir -p \$SAVE_Y_ROOT
# all_det
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT} | grep \${RESOLN}.assm.\` )
@ ncase1 = \${#CASENAME_SET} - 1
foreach caseloop (\`seq 1 \${ncase1}\` )
  set case1 = \${CASENAME_SET[\$caseloop]}
  set file1 = \${ARC_Y_ROOT}/\${case1}/merged/${var}_yearly_det_\${RESOLN}.assm.\${case1}.pop.h.nc
  @ ncase2 = \${caseloop} + 1
  foreach caseloop2 (\`seq \${ncase2} \${#CASENAME_SET}\` )
    set case2 = \${CASENAME_SET[\$caseloop2]}
    set file2 = \${ARC_Y_ROOT}/\${case2}/merged/${var}_yearly_det_\${RESOLN}.assm.\${case2}.pop.h.nc
    cdo -O -w -z zip_5 -timcor \$file1 \$file2 \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}.nc
#    echo "cdo -timcor" \$file1 \$file2 \${SAVE_Y_ROOT}/${var}_corr_\${case1}_\${case2}.nc > \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}
#    sleep 3s
  end
end
set SAVE_Y_ens_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}/corr/ens
mkdir -p \${SAVE_Y_ens_ROOT}
#all_det
cdo -O -w -z zip_5 -ensmean \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmin.nc

#en4_det
set OBS = en4.2_ba
set FILESET = \`ls \${SAVE_Y_ROOT}/*\${OBS}*\${OBS}*\`
cdo -O -w -z zip_5 -ensmean \${FILESET} \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmin.nc

#projdv7.3_det
set OBS = projdv7.3_ba
set FILESET = \`ls \${SAVE_Y_ROOT}/*\${OBS}*\${OBS}*\`
cdo -O -w -z zip_5 -ensmean \${FILESET} \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmin.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
