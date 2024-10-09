#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
set vars = ( UVEL VVEL PD )
foreach var ( ${vars} )
mkdir ~/tmp_script
set tmp_scr =  ~/tmp_script/corr_${var}_assm_tmp.csh

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}/corr
mkdir -p \$SAVE_ROOT
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )
@ ncase1 = \${#CASENAME_SET} - 1
foreach caseloop (\`seq 1 \${ncase1}\` )
  set case1 = \${CASENAME_SET[\$caseloop]}
  set file1 = \${ARC_ROOT}/\${case1}/merged/${var}_\${RESOLN}.assm.\${case1}.pop.h.nc
  @ ncase2 = \${caseloop} + 1
  foreach caseloop2 (\`seq \${ncase2} \${#CASENAME_SET}\` )
    set case2 = \${CASENAME_SET[\$caseloop2]}
    set file2 = \${ARC_ROOT}/\${case2}/merged/${var}_\${RESOLN}.assm.\${case2}.pop.h.nc
    cdo -O -timcor \$file1 \$file2 \${SAVE_ROOT}/${var}_corr_\${case1}_\${case2}.nc
#    echo "cdo -timcor" \$file1 \$file2 \${SAVE_ROOT}/${var}_corr_\${case1}_\${case2}.nc > \${SAVE_ROOT}/${var}_corr_\${case1}_\${case2}
#    sleep 3s
  end
end
set SAVE_ens_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}/corr/ens
mkdir -p \${SAVE_ens_ROOT}
cdo -O -ensmean \${SAVE_ROOT}/*.nc \${SAVE_ens_ROOT}/${var}_corr_ensmean.nc
cdo -O -ensstd \${SAVE_ROOT}/*.nc \${SAVE_ens_ROOT}/${var}_corr_ensstd.nc
cdo -O -ensmax \${SAVE_ROOT}/*.nc \${SAVE_ens_ROOT}/${var}_corr_ensmax.nc
cdo -O -ensmin \${SAVE_ROOT}/*.nc \${SAVE_ens_ROOT}/${var}_corr_ensmin.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr &
end
