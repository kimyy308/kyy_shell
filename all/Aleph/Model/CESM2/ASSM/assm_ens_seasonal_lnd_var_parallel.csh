#!/bin/csh
####!/bin/csh -fx
# Updated  14-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20230914
set vars = ( TWS RAIN SNOW NPP GPP TOTVEGC COL_FIRE_CLOSS FIRE FAREA_BURNED NFIRE SOILWATER_10CM Q2M RH2M TLAI )
#20231013
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT SOILWATER_10CM FAREA_BURNED NFIRE Q2M RH2M TLAI SNOW )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_seasonal_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_seasonal_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set seasons = ( JFM1 AMJ1 JAS1 OND1 )
set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_seasonal_transfer/lnd/${var}
#set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_seasonal_transfer/lnd/${var}/ens_all/\${season}

set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )

set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
foreach iyloop ( \${IY_SET} )
 foreach season ( \${seasons} )
  switch( \${season} )
    case "JFM1":
      set FY = \${iyloop}
      set M_SET = ( 01 02 03 )
      breaksw
    case "AMJ1":
      set FY = \${iyloop}
      set M_SET = ( 04 05 06 )
      breaksw
    case "JAS1":
      set FY = \${iyloop}
      set M_SET = ( 07 08 09 )
      breaksw
    case "OND1":
      set FY = \${iyloop}
      set M_SET = ( 10 11 12 )
      breaksw
  endsw
  set INITY = \${iyloop}
  set FILE_SET = (\`ls \${ARC_ROOT}/*/\${season}/*\${RESOLN}*\${iyloop}_\${season}.nc\` )
  set SAVE_ROOT = \${ARC_ROOT}/ens_all/\${season}
  mkdir -p \$SAVE_ROOT

  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_ensmax_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_ensmin_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_ensstd_\${INITY}_\${season}.nc
  ###en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/\${season}/*\${RESOLN}*en4.2_ba*\${iyloop}_\${season}.nc\` )
  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmax_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmin_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensstd_\${INITY}_\${season}.nc
  ###projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/\${season}/*\${RESOLN}*projdv7.3_ba*\${iyloop}_\${season}.nc\` )
  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_\${INITY}_\${season}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_\${INITY}_\${season}.nc
 end
end
echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
