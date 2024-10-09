#!/bin/csh
####!/bin/csh -fx
# Updated  23-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20231005
set vars = ( TS SST PSL PRECT  )
#20231017
set vars = ( TS SST PSL PRECT  )

set ly_s = 2
set ly_e = 4

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_multi_ly_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_multi_ly_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2017
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/atm/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/atm/${var}/ens_all

set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )

set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
foreach iyloop ( \${IY_SET} )
  set INITY = \${iyloop}
  set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*\${iyloop}_ly_${ly_s}_${ly_e}.nc\` )
  set SAVE_ROOT = \${ARC_ROOT}/ens_all
  mkdir -p \$SAVE_ROOT

  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_ensmax_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_ensmin_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_ensstd_\${INITY}_ly_${ly_s}_${ly_e}.nc
  ###en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*en4.2_ba*\${iyloop}_ly_${ly_s}_${ly_e}.nc\` )
  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmax_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmin_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensstd_\${INITY}_ly_${ly_s}_${ly_e}.nc
  ###projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*projdv7.3_ba*\${iyloop}_ly_${ly_s}_${ly_e}.nc\` )
  cdo -w -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_\${INITY}_ly_${ly_s}_${ly_e}.nc
  cdo -w -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_\${INITY}_ly_${ly_s}_${ly_e}.nc
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
