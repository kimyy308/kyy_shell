#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3)
#set vars = (NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4 Fe )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
#set vars = ( Fe )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( IRON_FLUX )
set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_yearly_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_yearly_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}/ens_all
mkdir -p \$SAVE_Y_ROOT

#all
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_\${RESOLN}*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_y_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_SNR.nc

#all_det
set CASENAME_DET_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_det_\${RESOLN}*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_det_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_y_det_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_det_SNR.nc

#en4
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_\${RESOLN}*en4.2_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_ensstd.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_SNR.nc

#en4_det
set CASENAME_DET_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_det_\${RESOLN}*en4.2_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_ensstd.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_en4.2_ba_y_det_SNR.nc

#projdv7.3
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_\${RESOLN}*projdv7.3_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_ensstd.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_SNR.nc

#projdv7.3_det
set CASENAME_DET_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_det_\${RESOLN}*projdv7.3_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_ensstd.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_projdv7.3_ba_y_det_SNR.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
