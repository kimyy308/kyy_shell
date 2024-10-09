#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( WVEL2 )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
#set vars = ( HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
set vars = ( SST PRECT AODDUST PSL TS )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/merge_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/merge_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep LE2-\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set FILE_ROOT = \${ARC_ROOT}/\${CASENAME}
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  cd \${FILE_ROOT}
  set FILE_SET = ( \`ls ${var}_\${CASENAME}.cam.h0.????-??.nc\` )
  cdo -O -w -z zip_5 -mergetime \${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc
  #echo "cdo -O -w -z zip_5 -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.lens2.\${CASENAME}.cam.h0.nc
  #sleep 3s
end 

EOF

csh $tmp_scr > $tmp_log &
end
