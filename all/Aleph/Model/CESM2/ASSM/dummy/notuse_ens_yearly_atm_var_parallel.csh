#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3)
#set vars = (NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
set vars = ( CLOUD OMEGA Q RELHUM U V AODDUST dry_deposition_NOy_as_N dry_deposition_NHx_as_N dst_a1SF dst_a1_SRF dst_a2SF dst_a2DDF dst_a2SFWET dst_a2_SRF dst_a3SF dst_a3_SRF FSNS FSDS PRECT PSL SFdst_a1 SFdst_a2 SFdst_a3 TAUX TAUY TS U10 wet_deposition_NHx_as_N wet_deposition_NOy_as_N )
foreach var ( ${vars} )

mkdir ~/tmp_script
set tmp_scr =  ~/tmp_script/ens_yearly_${var}_assm_tmp.csh

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}/ens_all
mkdir -p \$SAVE_Y_ROOT
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_\${RESOLN}*.nc\` )
cdo -O -w -ensmean \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensmean.nc
cdo -O -w -ensstd \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensstd.nc
cdo -O -w -timmean \${SAVE_Y_ROOT}/${var}_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_spread.nc
cdo -O -w -timmean \${SAVE_Y_ROOT}/${var}_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_ensmean.nc
cdo -O -w -timstd \${SAVE_Y_ROOT}/${var}_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_std_ensmean.nc
cdo -O -w -div \${SAVE_Y_ROOT}/${var}_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_SNR.nc

set CASENAME_DET_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_det_\${RESOLN}*.nc\` )
cdo -O -w -ensmean \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc
cdo -O -w -ensstd \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensstd.nc
cdo -O -w -timmean \${SAVE_Y_ROOT}/${var}_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_spread.nc
cdo -O -w -timmean \${SAVE_Y_ROOT}/${var}_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_ensmean.nc
cdo -O -w -timstd \${SAVE_Y_ROOT}/${var}_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_std_ensmean.nc
cdo -O -w -div \${SAVE_Y_ROOT}/${var}_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_det_SNR.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr &
end
