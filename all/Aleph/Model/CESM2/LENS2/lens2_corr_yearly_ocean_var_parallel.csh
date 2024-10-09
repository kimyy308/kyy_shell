#!/bin/csh
####!/bin/csh -fx
# Updated  16-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
set vars = (HBLT HMXL IRON_FLUX photoC_TOT_zint_100m )

foreach var ( ${vars} )
mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/corr_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/corr_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}/corr
mkdir -p \$SAVE_Y_ROOT
# all_det
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT} | grep LE2-\` )
set NOC = 0
@ ncase1 = \${#CASENAME_SET} - 1
foreach caseloop (\`seq 1 \${ncase1}\` )
  set case1 = \${CASENAME_SET[\$caseloop]}
  set file1 = \${ARC_Y_ROOT}/\${case1}/merged/${var}_yearly_det_\${RESOLN}.lens2.\${case1}.pop.h.nc
  @ ncase2 = \${caseloop} + 1
  foreach caseloop2 (\`seq \${ncase2} \${#CASENAME_SET}\` )
    @ NOC = \${NOC} + 1
    set case2 = \${CASENAME_SET[\$caseloop2]}
    set file2 = \${ARC_Y_ROOT}/\${case2}/merged/${var}_yearly_det_\${RESOLN}.lens2.\${case2}.pop.h.nc
    cdo -O -w -z zip_5 -timcor \$file1 \$file2 \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}.nc
  end
  set TMP_ENS_DIR = /mnt/lustre/proj/kimyy/tmp_ens
  mkdir -p \${TMP_ENS_DIR}
  cdo -O -w -z zip_5 -ensmean \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}* \${TMP_ENS_DIR}/${var}_\${case1}_y_det_corr_tmp_ensmean.nc
  cdo -O -w -z zip_5 -ensmax \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}* \${TMP_ENS_DIR}/${var}_\${case1}_y_det_corr_tmp_ensmax.nc
  cdo -O -w -z zip_5 -ensmin \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}* \${TMP_ENS_DIR}/${var}_\${case1}_y_det_corr_tmp_ensmin.nc
end
set SAVE_Y_ens_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${var}/corr/ens
mkdir -p \${SAVE_Y_ens_ROOT}

cdo -O -w -z zip_5 -ensmean \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmean.nc  \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensmax \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmax.nc  \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmin.nc  \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmin.nc

rm -f \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmean.nc
rm -f \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmax.nc
rm -f \${TMP_ENS_DIR}/${var}_*_y_det_corr_tmp_ensmin.nc


# std
foreach caseloop (\`seq 1 \${ncase1}\` )
  set case1 = \${CASENAME_SET[\$caseloop]}
  @ ncase2 = \${caseloop} + 1
  foreach caseloop2 (\`seq \${ncase2} \${#CASENAME_SET}\` )
    set case2 = \${CASENAME_SET[\$caseloop2]}
    cdo -O -w -z zip_5 -sub \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmean.nc \${SAVE_Y_ROOT}/${var}_tmpano.nc
    cdo -O -w -z zip_5 -sqr \${SAVE_Y_ROOT}/${var}_tmpano.nc \${SAVE_Y_ROOT}/${var}_tmpano2.nc 
    cdo -O -w -z zip_5 -divc,\${NOC} \${SAVE_Y_ROOT}/${var}_tmpano2.nc \${SAVE_Y_ROOT}/${var}_y_det_corr_sq_ano_\${case1}_\${case2}.nc
  end
  set TMP_ENS_DIR = /mnt/lustre/proj/kimyy/tmp_ens
  mkdir -p \${TMP_ENS_DIR}
  cdo -O -w -z zip_5 -enssum \${SAVE_Y_ROOT}/${var}_y_det_corr_sq_ano_\${case1}* \${TMP_ENS_DIR}/${var}_\${case1}_y_det_corr_sq_ano_tmp_enssum.nc
end

cdo -O -w -z zip_5 -enssum \${TMP_ENS_DIR}/${var}_*_y_det_corr_sq_ano_tmp_enssum.nc  \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensvar.nc
cdo -O -w -z zip_5 -sqrt \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensvar.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensstd.nc

rm -f \${TMP_ENS_DIR}/${var}_*_y_det_corr_sq_ano_tmp_enssum.nc


EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
