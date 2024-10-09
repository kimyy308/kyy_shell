#!/bin/csh
####!/bin/csh -fx
# Updated  18-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 diatC diazC spC )
#set vars = ( diatC diazC spC )
#set vars = ( UVEL VVEL SSH )
#set vars = ( diatChl spChl diazChl )
#set vars = ( PO4 )
set vars = ( SiO3 )
#set vars = ( NO3 )
#set vars = ( Fe )

#set vars = ( photoC_TOT_zint )
set siy = 2021
set eiy = 1970
set IY_SET = ( `seq ${siy} -1 ${eiy}` )
foreach iyloop ( ${IY_SET} )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_${iyloop}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_${iyloop}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.hcst.\` )
#foreach CASENAME_M ( \${CASENAME_SET} )
    set INITY = ${iyloop}
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*.nc\` )
    set SAVE_ROOT = \${ARC_ROOT}/ens_all
    mkdir -p \$SAVE_ROOT
#    cdo -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_i\${INITY}.nc
    #en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*en4.2_ba*.nc\` )
#    cdo -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i\${INITY}.nc
    #projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*projdv7.3_ba*.nc\` )
#    cdo -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i\${INITY}.nc
#end



set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  set INITY = ${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/ens_all/ens_all_i${iyloop}

  mkdir -p \${SAVE_ROOT}
  @ fy_end = ${iyloop} + 4
  set FY_SET = ( \`seq ${iyloop} \${fy_end}\` )
  foreach fy ( \${FY_SET} )
    foreach mon ( \${M_SET} )
      set input_set = (\`ls \${ARC_ROOT}/*/*_i${iyloop}/*\${fy}-\${mon}.nc\`)
      set outputname=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ens_all_i${iyloop}.pop.h.\${fy}-\${mon}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i${iyloop}.pop.h.\${fy}-\${mon}.nc
#      echo "cdo -O ensmean "\${input_set} \${outputname}
      cdo -O -z zip_5 ensmean \${input_set} \${outputname}
      echo \$outputname
#      mv \$outputname2 \$outputname
    end
  end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
end


foreach iyloop ( ${IY_SET} )
foreach var ( ${vars} )
set tmp_scr =  ~/tmp_script/ens_${var}_${iyloop}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_${iyloop}_hcst_tmp.log
  set stat = pre
  while ( ${stat} != postprocessing )
    sleep 10s
    set stat = ( `grep post $tmp_log | cut -d ' ' -f 1` )
  end
end
end
