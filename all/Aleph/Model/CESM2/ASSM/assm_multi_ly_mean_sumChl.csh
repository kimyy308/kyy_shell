#!/bin/csh
####!/bin/csh -fx
# Updated  01-Nov-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( sumChl )

set ly_s = 2
set ly_e = 4

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/multi_ly_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/multi_ly_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}
  set SAVE_Y_ROOT = \${ARC_Y_ROOT}/ens_all
  mkdir -p \$SAVE_Y_ROOT

set siy = 2025
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach INITY ( \${Y_SET} )
  @ fy_start = \${INITY} + ${ly_s} - 1
  @ fy_end  = \${INITY} + ${ly_e} - 1
  set FY_SET = ( \`seq \${fy_start} \${fy_end}\` )
  set len_s = ( \`seq 1 +1 "\${#FY_SET}"\` )
  foreach ci ( \${len_s} )
    if ( \${ci} == 1 ) then
      set inputname = \${SAVE_Y_ROOT}/${var}_ensmean_\${FY_SET[\${ci}]}.nc
    else
      set inputname = ( \${inputname} \${SAVE_Y_ROOT}/${var}_ensmean_\${FY_SET[\${ci}]}.nc  )
    endif
  end
  cdo -O -w -z zip_5 -ensmean \${inputname} \${SAVE_Y_ROOT}/${var}_ensmean_\${INITY}_ly_${ly_s}_${ly_e}.nc

end

EOF

csh $tmp_scr csh > $tmp_log &
end
