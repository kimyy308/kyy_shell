#!/bin/csh
####!/bin/csh -fx
# Updated  01-Nov-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#20231101
set vars = ( sumChl )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_y_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_y_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2021
set eiy = 1960
set RESOLN = f09_g17
#set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )

foreach iyloop ( \${IY_SET} )  # iy loop1, inverse direction
  set INITY = \${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/ens_all/ens_all_i\${iyloop}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/ocn/${var}/ens_all/ens_all_i\${iyloop}

  mkdir -p \${SAVE_ROOT}
  @ fy_end = \${iyloop} + 4
  set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
  foreach fy ( \${FY_SET} )
      set input_set = (\`ls \${ARC_ROOT}/*ensmean_all_*\${fy}-*.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.pop.h.\${fy}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}

#      echo \$outputname
#      mv \$outputname2 \$outputname
  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
