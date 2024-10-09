#!/bin/csh
####!/bin/csh -fx
# Updated  04-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set vars = ( GPP NPP TOTVEGC TWS )
set vars = ( COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230824
set vars = ( RAIN TWS )
set vars = ( GPP NPP TOTVEGC COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230907
set vars = ( SOILWATER_10CM )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2021
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.hcst.\` )
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
#foreach CASENAME_M ( \${CASENAME_SET} )
  foreach iyloop ( \${IY_SET} )
    set INITY = \${iyloop}
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*.nc\` )
    set SAVE_ROOT = \${ARC_ROOT}/ens_all
    mkdir -p \$SAVE_ROOT
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_i\${INITY}.nc
    #en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*en4.2_ba*.nc\` )
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i\${INITY}.nc
    #projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*projdv7.3_ba*.nc\` )
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i\${INITY}.nc
  end
#end



set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )  # iy loop1, inverse direction
  set INITY = \${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}/ens_all/ens_all_i\${iyloop}

  mkdir -p \${SAVE_ROOT}
  @ fy_end = \${iyloop} + 4
  set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
  foreach fy ( \${FY_SET} )
    foreach mon ( \${M_SET} )
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*\${fy}-\${mon}.nc\`)
      #set outputname=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for en4 
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*en4.2_ba*\${fy}-\${mon}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_en4.2_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for projdv7.3_ba
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*projdv7.3_ba*\${fy}-\${mon}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_projdv7.3_ba_i\${iyloop}.clm2.h0.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}

#      echo \$outputname
#      mv \$outputname2 \$outputname
    end
  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
