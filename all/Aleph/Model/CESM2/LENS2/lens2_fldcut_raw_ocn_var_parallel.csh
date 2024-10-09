#!/bin/csh
####!/bin/csh -fx
# Updated  23-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp


set comp = ocn

set REGION = NWP
set xw = 133
set xe = 205
set ys = 221
set yn = 325

set vars = ( TEMP SSH SALT DIC DIC_ALT_CO2 FG_CO2 )
#set vars = ( SSH )

foreach var ( ${vars} )
mkdir ~/tmp_script
mkdir ~/tmp_log

set tmp_scr =  ~/tmp_script/fldcut_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/fldcut_${var}_lens2_tmp.log

cat > $tmp_scr << EOF

set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive

set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )

foreach period ( \${period_set_hist} )
  cd \${ARC_ROOT}
  set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
  foreach smbbnum ( \${smbb_set} )
  #  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
    set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_region_transfer/${comp}/${var}/\${smbbnum}/${REGION}/
    mkdir -p \$SAVE_ROOT_smbb
    set inputname = \`ls \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc\`
    set fn = \`ls \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc | rev | cut -d '/' -f 1 | rev\`
    set outputname = \${SAVE_ROOT_smbb}/${REGION}_\${fn}
#    cdo -O -w select,name=${var} \${inputname} /proj/kimyy/tmp/test_lens2_fld_${var}.nc
    cdo -z zip_5 -O -w -selindexbox,${xw},${xe},${ys},${yn} \${inputname} \${outputname}
  end
end

foreach period ( \${period_set_ssp} )
  cd \${ARC_ROOT}
  set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
  foreach smbbnum ( \${smbb_set} )
    set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_region_transfer/${comp}/${var}/\${smbbnum}/${REGION}/
    mkdir -p \$SAVE_ROOT_smbb
    set inputname = \`ls \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc\`
    set fn = \`ls \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc | rev | cut -d '/' -f 1 | rev\`
    set outputname = \${SAVE_ROOT_smbb}/${REGION}_\${fn}
    cdo -O -w select,name=${var} \${inputname} /proj/kimyy/tmp/test_lens2_fld_${var}.nc
    cdo -z zip_5 -O -w -selindexbox,${xw},${xe},${ys},${yn} /proj/kimyy/tmp/test_lens2_fld_${var}.nc \${outputname}
  end
end

end

EOF

csh $tmp_scr > $tmp_log &

end


