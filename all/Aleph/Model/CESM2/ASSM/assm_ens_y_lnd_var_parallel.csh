#!/bin/csh
####!/bin/csh -fx
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20230830
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT ) #SNOW_PERSISTENCE -> removed
#20230907
set vars = ( SOILWATER_10CM )
#20231008
set vars = ( Q2M RH2M TLAI SNOW )
#20231012 
set vars = ( FAREA_BURNED NFIRE )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_y_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_y_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/lnd/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/lnd/${var}/ens_all

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
