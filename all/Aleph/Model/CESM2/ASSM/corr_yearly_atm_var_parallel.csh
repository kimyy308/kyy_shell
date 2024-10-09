#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( CLOUD OMEGA Q RELHUM U V AODDUST dry_deposition_NOy_as_N dry_deposition_NHx_as_N dst_a1SF dst_a1_SRF dst_a2SF dst_a2DDF dst_a2SFWET dst_a2_SRF dst_a3SF dst_a3_SRF FSNS FSDS PRECT PSL SFdst_a1 SFdst_a2 SFdst_a3 TAUX TAUY TS U10 wet_deposition_NHx_as_N wet_deposition_NOy_as_N )

foreach var ( ${vars} )
mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/corr_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/corr_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}/corr
mkdir -p \$SAVE_Y_ROOT
# all_det
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT} | grep \${RESOLN}.assm.\` )
@ ncase1 = \${#CASENAME_SET} - 1
foreach caseloop (\`seq 1 \${ncase1}\` )
  set case1 = \${CASENAME_SET[\$caseloop]}
  set file1 = \${ARC_Y_ROOT}/\${case1}/merged/${var}_yearly_det_\${RESOLN}.assm.\${case1}.cam.h0.nc
  @ ncase2 = \${caseloop} + 1
  foreach caseloop2 (\`seq \${ncase2} \${#CASENAME_SET}\` )
    set case2 = \${CASENAME_SET[\$caseloop2]}
    set file2 = \${ARC_Y_ROOT}/\${case2}/merged/${var}_yearly_det_\${RESOLN}.assm.\${case2}.cam.h0.nc
    cdo -O -w -z zip_5 -timcor \$file1 \$file2 \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}.nc
#    echo "cdo -timcor" \$file1 \$file2 \${SAVE_Y_ROOT}/${var}_corr_\${case1}_\${case2}.nc > \${SAVE_Y_ROOT}/${var}_y_det_corr_\${case1}_\${case2}
#    sleep 3s
  end
end
set SAVE_Y_ens_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}/corr/ens
mkdir -p \${SAVE_Y_ens_ROOT}
#all_det
cdo -O -w -z zip_5 -ensmean \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${SAVE_Y_ROOT}/*.nc \${SAVE_Y_ens_ROOT}/${var}_y_det_corr_ensmin.nc

#en4_det
set OBS = en4.2_ba
set FILESET = \`ls \${SAVE_Y_ROOT}/*\${OBS}*\${OBS}*\`
cdo -O -w -z zip_5 -ensmean \${FILESET} \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmin.nc

#projdv7.3_det
set OBS = projdv7.3_ba
set FILESET = \`ls \${SAVE_Y_ROOT}/*\${OBS}*\${OBS}*\`
cdo -O -w -z zip_5 -ensmean \${FILESET} \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensstd.nc
cdo -O -w -z zip_5 -ensmax \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmax.nc
cdo -O -w -z zip_5 -ensmin \${FILESET}  \${SAVE_Y_ens_ROOT}/${var}_\${OBS}_y_det_corr_ensmin.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
