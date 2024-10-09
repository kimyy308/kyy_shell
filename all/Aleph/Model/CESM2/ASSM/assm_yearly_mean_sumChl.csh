#!/bin/csh
####!/bin/csh -fx
# Updated  01-Nov-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( sumChl )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/yearly_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/yearly_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}
  set SAVE_ROOT = \${ARC_ROOT}/ens_all
  set SAVE_Y_ROOT = \${ARC_Y_ROOT}/ens_all
  mkdir -p \$SAVE_ROOT
  mkdir -p \$SAVE_Y_ROOT

set siy = 2020
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach INITY ( \${Y_SET} )
  cdo -O -w -z zip_5 -ensmean \${SAVE_ROOT}/${var}_ensmean_\${INITY}-*.nc \${SAVE_Y_ROOT}/${var}_ensmean_\${INITY}.nc
end


EOF

csh $tmp_scr csh > $tmp_log &
end
