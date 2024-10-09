#!/bin/csh
####!/bin/csh -fx
# Updated  14-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#20230914
set vars = ( TS SST PSL PRECT AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT )
#20240207
set vars = ( TS )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_seasonal_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_seasonal_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set seasons = ( JFM1 AMJ1 JAS1 OND1 )
set seasons = ( MAM1 JJA1 SON1 DJF1 MAM2 JJA2 SON2 )
set siy = 2021
set eiy = 1960
set RESOLN = f09_g17
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )

foreach iyloop ( \${IY_SET} )  # iy loop1, inverse direction
 set yloop = \${iyloop}
 @ yloop2 = \${yloop} + 1
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
      case "MAM1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 03 04 05 )
        breaksw
      case "JJA1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 06 07 08 )
        breaksw
      case "SON1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 09 10 11 )
        breaksw
      case "DJF1":
        set FY = ( \${yloop} \${yloop2} \${yloop2} )
        set M_SET = ( 12 01 02 )
        breaksw
      case "MAM2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 03 04 05 )
        breaksw
      case "JJA2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 06 07 08 )
        breaksw
      case "SON2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 09 10 11 )
        breaksw
    endsw


  set INITY = \${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_seasonal_transfer/atm/${var}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_seasonal_transfer/atm/${var}/ens_all/ens_all_i\${iyloop}/\${season}

  mkdir -p \${SAVE_ROOT}
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/\${season}/*\${FY[2]}_\${season}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_all_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_all_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_all_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
#      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for en4 
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/\${season}/*en4.2_ba*\${FY[2]}_\${season}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_en4.2_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_en4.2_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_en4.2_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_en4.2_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
#      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
#      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for projdv7.3_ba
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/\${season}/*projdv7.3_ba*\${FY[2]}_\${season}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_projdv7.3_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_projdv7.3_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_projdv7.3_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_projdv7.3_ba_i\${iyloop}.cam.h0.\${FY[2]}_\${season}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
#      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
#      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
#      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}

#      echo \$outputname
#      mv \$outputname2 \$outputname
 end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
