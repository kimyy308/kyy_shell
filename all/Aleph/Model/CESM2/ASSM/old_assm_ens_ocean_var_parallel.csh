#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diatC diazC spC )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}/ens_all
mkdir -p \$SAVE_ROOT
set CASENAME_SET = ( \`ls \${ARC_ROOT}/*/merged/*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensmean.nc

#en4
set CASENAME_SET = ( \`ls \${ARC_ROOT}/*/merged/*en4.2_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean.nc

#projdv7.3
set CASENAME_SET = ( \`ls \${ARC_ROOT}/*/merged/*projdv7.3_ba*.nc\` )
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
