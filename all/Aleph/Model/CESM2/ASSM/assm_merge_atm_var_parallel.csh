#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set vars = ( PS )
set vars = ( U V )
#set vars = ( CLOUD OMEGA Q RELHUM U V AODDUST dry_deposition_NOy_as_N dry_deposition_NHx_as_N dst_a1SF dst_a1_SRF dst_a2SF dst_a2DDF dst_a2SFWET dst_a2_SRF dst_a3SF dst_a3_SRF FSNS FSDS PRECT PSL SFdst_a1 SFdst_a2 SFdst_a3 TAUX TAUY TS U10 wet_deposition_NHx_as_N wet_deposition_NOy_as_N )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/merge_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_script/merge_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
#set ARC_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/atm/${var}
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/atm/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set FILE_ROOT = \${ARC_ROOT}/\${CASENAME}
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  cd \${FILE_ROOT}
  set FILE_SET = ( \`ls ${var}_\${CASENAME}.cam.h0.????-??.nc\` )
  cdo -O -w -z zip_5 -mergetime \${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  #echo "cdo -O -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  #sleep 3s
end 

EOF

csh $tmp_scr > $tmp_log &
end
