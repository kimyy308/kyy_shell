#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (HBLT HMXL IRON_FLUX photoC_TOT_zint_100m )
set vars = ( SST PRECT AODDUST PSL TS )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/yearly_det_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/yearly_det_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/atm/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep LE2-\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  set SAVE_Y_ROOT = \${ARC_Y_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  mkdir -p \$SAVE_Y_ROOT
  cdo -O -w -z zip_5 -timselmean,12,0,0 \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc
  cdo -O -w -z zip_5 -detrend \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_det_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc
  #echo "cdo -O -w -z zip_5 -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc
  #sleep 3s
end 

EOF

csh $tmp_scr csh > $tmp_log &
end
