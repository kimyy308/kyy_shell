#!/bin/csh
####!/bin/csh -fx
# Updated  17-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20231017
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FAREA_BURNED FIRE FPSN NFIRE SOILWATER_10CM SOILICE SOILLIQ SNOW TOTSOILICE TLAI TOTSOILLIQ RAIN Q2M QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC RH2M NEP DSTFLXT ) # 2 ~ 4
#20231120
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FAREA_BURNED FIRE FPSN NFIRE SOILWATER_10CM SOILICE SOILLIQ SNOW TOTSOILICE TLAI TOTSOILLIQ RAIN Q2M QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC RH2M NEP DSTFLXT ) # 1 ~ 3

set ly_s = 1
set ly_e = 3

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_multi_y_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_multi_y_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/lnd/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.hcst.\` )
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )

foreach iyloop ( \${IY_SET} )  # iy loop1, inverse direction
  set INITY = \${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/lnd/${var}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/lnd/${var}/ens_all/ens_all_i\${iyloop}

  mkdir -p \${SAVE_ROOT}
#  @ fy_end = \${iyloop} + 4
#  set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
#  foreach fy ( \${FY_SET} )
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*ly_${ly_s}_${ly_e}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_all_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_all_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_all_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for en4 
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*en4.2_ba*ly_${ly_s}_${ly_e}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_en4.2_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_en4.2_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_en4.2_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_en4.2_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for projdv7.3_ba
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*projdv7.3_ba*ly_${ly_s}_${ly_e}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_projdv7.3_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_projdv7.3_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_projdv7.3_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_projdv7.3_ba_i\${iyloop}.clm2.h0.ly_${ly_s}_${ly_e}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}

#  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
