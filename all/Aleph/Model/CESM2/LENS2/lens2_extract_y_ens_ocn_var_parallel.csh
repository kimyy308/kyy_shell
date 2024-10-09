#!/bin/csh
####!/bin/csh -fx
# Updated  23-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20231008
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT )
#20231009
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT)
#20231101
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231107
set vars = ( pCO2SURF)
#20231113
set vars = ( ALK CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231123
set vars = ( PAR_avg )

#TBD set vars = ( pH_3D )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_y_lens2_tmp.csh
set tmp_log =  ~/tmp_log/${var}_y_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set siy = 2025
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
  if (\${yloop} <= 2014) then
    set scen = BHIST
  else if (\${yloop} >= 2015) then
    set scen = BSSP370
  endif
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_yearly
  cd \${ARC_ROOT}
    cd \${ARC_ROOT}
    set ENS = ens_smbb
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}/\${ENS}
    mkdir -p \$SAVE_ROOT
    set FILE_ROOT = \${ARC_ROOT}/ocn/${var}/\${ENS}
    echo \${FILE_ROOT}
    set period_SET = ( \`ls \${FILE_ROOT}/${var}*ensmean*  | cut -d '.' -f 3 | rev | cut -c 1-13 | rev\` )
    foreach period ( \${period_SET} )
      set Y_1 = (\`echo \$period | cut -c 1-4\`)
      set Y_2= (\`echo \$period | cut -c 8-11\`)
      if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
        set period_f=\${period}
        echo \${period_f}, \${yloop}
        @ tind2 = \`expr \( \${yloop} - \${Y_1} \) + 1\`
        #echo \${vind}
#          @ tind2 = \$tind + \$mloop
          ### ensmean
          #echo \$tind2i
          set inputname = \${FILE_ROOT}/${var}_y_ensmean_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_y_ensmean_\${yloop}.nc
          #ls \$input_head
           cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          #echo \${inputname}
          #echo \${outputname}
          
          ### ensmax
          set inputname = \${FILE_ROOT}/${var}_y_ensmax_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_y_ensmax_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          ### ensmin
          set inputname = \${FILE_ROOT}/${var}_y_ensmin_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_y_ensmin_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          ### ensstd
          set inputname = \${FILE_ROOT}/${var}_y_ensstd_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_y_ensstd_\${yloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
      endif
    end
  #end 
end
rm -f ${homedir}/lens2_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
