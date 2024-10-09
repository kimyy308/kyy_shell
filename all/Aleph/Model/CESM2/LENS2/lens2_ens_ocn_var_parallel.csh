#!/bin/csh
####!/bin/csh -fx
# Updated  12-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( diatChl diazChl spChl )
#set vars = ( SSH )
set vars = ( photoC_TOT_zint photoC_TOT_zint_100m diatChl diazChl spChl )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}/ens_all
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}/ens_smbb
mkdir -p \$SAVE_ROOT
mkdir -p \$SAVE_ROOT_smbb


cd \${ARC_ROOT}
mkdir cmip6
set cmip6_set = ( \`ls /proj/jedwards/archive/ | grep BHISTcmip6 | cut -d '-' -f 2\` )
foreach cmip6num ( \${cmip6_set} )
  ln -sf \${ARC_ROOT}/LE2-\${cmip6num} ./cmip6/
end
mkdir smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | cut -d '-' -f 2\` )
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/LE2-\${smbbnum} ./smbb/
end

#set siy = 2025
#set eiy = 1993
set siy = 2025
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
foreach mloop ( \${M_SET} )
set CASENAME_SET = ( \`ls \${ARC_ROOT}/smbb/*/${var}_*\${yloop}-\${mloop}.nc\` )

cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_\${yloop}-\${mloop}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_\${yloop}-\${mloop}.nc

end
end





EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
