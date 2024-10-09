#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( PS PSL PRECT U10 AODDUST SST TS )
#20230825
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ SNOW_PERSISTENCE RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230907
set vars = ( SOILWATER_10CM )
#20231006
set vars = ( Q2M RH2M TLAI SNOW )
#20231012
set vars = ( NFIRE FAREA_BURNED )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_y_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_y_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2021
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
  @ fy_end = \${iyloop} + 4
  set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
  foreach fy ( \${FY_SET} )
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*\${fy}.nc\`)
      #set outputname=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_all_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_all_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_all_i\${iyloop}.clm2.h0.\${fy}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.clm2.h0.\${fy}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for en4 
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*en4.2_ba*\${fy}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for projdv7.3_ba
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*projdv7.3_ba*\${fy}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}

#      echo \$outputname
#      mv \$outputname2 \$outputname
  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
