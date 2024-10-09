#!/bin/csh
####!/bin/csh -fx
# Updated  12-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( AODDUST PRECT PSL SST TS )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}/ens_all
mkdir -p \$SAVE_ROOT

#set siy = 2024
#set eiy = 1960
set siy = 2025
set eiy = 2025
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
foreach mloop ( \${M_SET} )
set CASENAME_SET = ( \`ls \${ARC_ROOT}/*/${var}_*\${yloop}-\${mloop}.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensmean_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensstd_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensmax_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensmin_\${yloop}-\${mloop}.nc

end
end





EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
