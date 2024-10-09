#!/bin/csh
####!/bin/csh -fx
# Updated  06-Mar-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#20240306
set vars = ( TREFHT ) 
#20240722
set vars = ( Z500 ) 
#20240723
set vars = ( U010 V010 ) 


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/d2m_${var}_hcst_ext_tmp.csh
set tmp_log =  ~/tmp_log/d2m_${var}_hcst_ext_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1960
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/ocn/proc/tseries/month_1
#echo \${IY_SET}
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )
 set INITY = \${iyloop}
 foreach OBS ( \${OBS_SET} ) #OBS loop1
   foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
     foreach mbr ( \$mbr_set ) #mbr loop1
       set CASENAME_M = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}  #parent casename 
       set CASENAME = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}
       set ARC_mon_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\${CASENAME_M}/\${CASENAME}/atm/proc/tseries/month_1
       set ARC_day_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\${CASENAME_M}/\${CASENAME}/atm/proc/tseries/day_1
       set period_f = ( \`ls \${ARC_day_TS_ROOT}/*.${var}.* | cut -d '.' -f 16\` )
       #echo \${CASENAME} \${period_f}, \${iyloop}
       set inputname = ( \`ls \${ARC_day_TS_ROOT}/*.${var}.* \` )
       echo \${inputname}
       set fy1 = \`echo \${period_f} | cut -c 1-4\`
       set fy2 = \`echo \${period_f} | cut -c 10-13\`
       set outputname = \${ARC_mon_TS_ROOT}/\${CASENAME}.cam.h0.${var}.\${fy1}01-\${fy2}12.nc
       echo \${outputname}
       cdo -O -w -z zip_5 -monmean \${inputname} \${outputname} 
     end
   end
 end
end
echo "postprocessing complete"

EOF

#csh $tmp_scr &
csh $tmp_scr > $tmp_log &
end



