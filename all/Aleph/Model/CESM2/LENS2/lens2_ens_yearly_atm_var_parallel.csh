#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set vars = ( SST PRECT AODDUST PSL TS )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_yearly_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_yearly_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/atm/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/atm/${var}/ens_all
mkdir -p \$SAVE_Y_ROOT

#all
set CASENAME_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_\${RESOLN}*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_Y_ROOT}/${var}_y_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_y_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_y_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_SNR.nc

#all_det
set CASENAME_DET_SET = ( \`ls \${ARC_Y_ROOT}/*/merged/${var}_yearly_det_\${RESOLN}*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_DET_SET} \${SAVE_Y_ROOT}/${var}_y_det_ensstd.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_det_ensstd.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_spread.nc
cdo -O -w -z zip_5 -timmean \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_ensmean.nc
cdo -O -w -z zip_5 -timstd \${SAVE_Y_ROOT}/${var}_y_det_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_std_ensmean.nc
cdo -O -w -z zip_5 -div \${SAVE_Y_ROOT}/${var}_y_det_time_std_ensmean.nc \${SAVE_Y_ROOT}/${var}_y_det_time_mean_spread.nc \${SAVE_Y_ROOT}/${var}_y_det_SNR.nc


EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
