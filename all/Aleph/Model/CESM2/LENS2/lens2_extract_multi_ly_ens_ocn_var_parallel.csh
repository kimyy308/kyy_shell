#!/bin/csh
####!/bin/csh -fx
# Updated  05-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20231017
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT ) # 2 ~ 5
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT ) # 2 ~ 4
#20231123
set vars = ( PAR_avg Jint_100m_NO3 tend_zint_100m_NO3 )


set ly_s = 2
set ly_e = 4
@ ly_l = ${ly_e} - ${ly_s} + 1

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_multi_ly__lens2_tmp.csh
set tmp_log =  ~/tmp_log/${var}_multi_ly_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set siy = 2025
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_yearly
  cd \${ARC_ROOT}
  set ENS = ens_smbb
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}/\${ENS}
  mkdir -p \$SAVE_ROOT
  set FILE_ROOT = \${ARC_ROOT}/ocn/${var}/\${ENS}
  echo \${FILE_ROOT}
  @ tind2 = \$yloop - 1959
  
  ### ensmean          
  set inputname = \${FILE_ROOT}/${var}_y_ensmean_runm_${ly_l}.nc
  set outputname = \${SAVE_ROOT}/${var}_y_ensmean_\${yloop}_ly_${ly_s}_${ly_e}.nc
  cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
  cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
  
  ### ensmax
  set inputname = \${FILE_ROOT}/${var}_y_ensmax_runm_${ly_l}.nc
  set outputname = \${SAVE_ROOT}/${var}_y_ensmax_\${yloop}_ly_${ly_s}_${ly_e}.nc
  cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
  cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname

  ### ensmin          
  set inputname = \${FILE_ROOT}/${var}_y_ensmin_runm_${ly_l}.nc
  set outputname = \${SAVE_ROOT}/${var}_y_ensmin_\${yloop}_ly_${ly_s}_${ly_e}.nc
  cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
  cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname

  ### ensstd          
  set inputname = \${FILE_ROOT}/${var}_y_ensstd_runm_${ly_l}.nc
  set outputname = \${SAVE_ROOT}/${var}_y_ensstd_\${yloop}_ly_${ly_s}_${ly_e}.nc
  cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
  cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          
end
rm -f ${homedir}/lens2_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
