#!/bin/csh
####!/bin/csh -fx
# Updated  04-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set vars = ( aice sithick )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ice/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ice/${var}/ens_all

set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )

set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )
  foreach mon ( \${M_SET} )
    set INITY = \${iyloop}
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*\${iyloop}-\${mon}*.nc\` )
    set SAVE_ROOT = \${ARC_ROOT}/ens_all
    mkdir -p \$SAVE_ROOT
    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_\${INITY}-\${mon}.nc
    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_ensmax_\${INITY}-\${mon}.nc
    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_ensmin_\${INITY}-\${mon}.nc
    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_ensstd_\${INITY}-\${mon}.nc
    ###en4
      set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*en4.2_ba*\${iyloop}-\${mon}*.nc\` )
    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmax_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmin_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensstd_i\${INITY}.nc
    ###projdv7.3_ba
      set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*projdv7.3_ba*\${iyloop}-\${mon}*.nc\` )
    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_i\${INITY}.nc
    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_i\${INITY}.nc
  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
