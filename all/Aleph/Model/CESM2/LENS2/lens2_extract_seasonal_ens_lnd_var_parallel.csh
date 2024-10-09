#!/bin/csh
####!/bin/csh -fx
# Updated  14-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230914
set vars = ( TWS RAIN SNOW NPP GPP TOTVEGC COL_FIRE_CLOSS FIRE FAREA_BURNED NFIRE SOILWATER_10CM Q2M RH2M TLAI )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_seasonal_lens2_tmp.csh
set tmp_log =  ~/tmp_log/${var}_seasonal_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set seasons = ( JFM1 AMJ1 JAS1 OND1 )
set RESOLN = f09_g17
set siy = 2025
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
 foreach season ( \${seasons} )
  switch( \${season} )
    case "JFM1":
      set season_o = JFM
      set FY = \${yloop}
      breaksw
    case "AMJ1":
      set season_o = AMJ
      set FY = \${yloop}
      breaksw
    case "JAS1":
      set season_o = JAS
      set FY = \${yloop}
      breaksw
    case "OND1":
      set season_o = OND
      set FY = \${yloop}
      breaksw
  endsw
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_seasonal
  cd \${ARC_ROOT}
    set ENS = ens_smbb
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_seasonal_transfer/lnd/${var}/\${ENS}/\${season}
    mkdir -p \$SAVE_ROOT
    set FILE_ROOT = \${ARC_ROOT}/lnd/${var}/\${ENS}/\${season_o}
    echo \${FILE_ROOT}
    set period_SET = ( \`ls \${FILE_ROOT}/${var}*ensmean*  | cut -d '.' -f 3 | rev | cut -c 1-13 | rev\` )
    foreach period ( \${period_SET} )
      set Y_1 = (\`echo \$period | cut -c 1-4\`)
      set Y_2= (\`echo \$period | cut -c 8-11\`)
      if (\$Y_1 <= \${FY} && \${FY} <= \$Y_2) then
        set period_f=\${period}
        echo \${period_f}, \${FY}
        @ tind2 = \`expr \( \${FY} - \${Y_1} \) + 1\`
        #echo \${vind}
#          @ tind2 = \$tind + \$mloop
          ### ensmean
          #echo \$tind2i
          set inputname = \${FILE_ROOT}/${var}_\${season_o}_ensmean_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${season}_ensmean_\${yloop}.nc
          #ls \$input_head
           cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_season_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_season_${var}.nc \$outputname
          #echo \${inputname}
          #echo \${outputname}
          
          ### ensmax
          set inputname = \${FILE_ROOT}/${var}_\${season_o}_ensmax_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${season}_ensmax_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_season_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_season_${var}.nc \$outputname
          ### ensmin
          set inputname = \${FILE_ROOT}/${var}_\${season_o}_ensmin_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${season}_ensmin_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_season_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_season_${var}.nc \$outputname
          ### ensstd
          set inputname = \${FILE_ROOT}/${var}_\${season_o}_ensstd_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${season}_ensstd_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_season_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_season_${var}.nc \$outputname
      endif
    end
  end 
end
rm -f ${homedir}/lens2_test_season_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
