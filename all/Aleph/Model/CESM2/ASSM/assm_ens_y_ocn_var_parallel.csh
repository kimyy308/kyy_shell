#!/bin/csh
####!/bin/csh -fx
# Updated  08-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20231007
#set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT )
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT)
#20231101
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231107
set vars = ( pCO2SURF )
#20231113
set vars = ( ALK CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231116
set vars = ( ALK CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231120
set vars = ( DIC )
#20231123
set vars = ( PAR_avg Jint_100m_NO3 tend_zint_100m_NO3 )
#20231218
set vars = ( DIC )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_y_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_y_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set siy = 2020
#set eiy = 1960
set siy = 1962
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}/ens_all

set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )

set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
foreach iyloop ( \${IY_SET} )
  set INITY = \${iyloop}
  set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*\${iyloop}.nc\` )
  set SAVE_ROOT = \${ARC_ROOT}/ens_all
  mkdir -p \$SAVE_ROOT

  cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_ensmax_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_ensmin_\${INITY}.nc
  cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_ensstd_\${INITY}.nc
  ###en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*en4.2_ba*\${iyloop}*.nc\` )
  cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmax_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmin_\${INITY}.nc
  cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensstd_\${INITY}.nc
  ###projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*projdv7.3_ba*\${iyloop}*.nc\` )
  cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_\${INITY}.nc
  cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_\${INITY}.nc
  cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_\${INITY}.nc
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
