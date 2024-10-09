#!/bin/csh
####!/bin/csh -fx
# Updated  22-Jul-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#20240722
set vars = ( Z500 U010 V010 ) 
#20240731
set vars = ( Z500 ) 


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/d2m_${var}_assm_ext_tmp.csh
set tmp_log =  ~/tmp_log/d2m_${var}_assm_ext_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#set siy = 2020
set siy = 2014
set eiy = 1960
#set scens = (BHISTsmbb BSSP370smbb)
set scens = (BHISTsmbb)
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach scen ( \${scens} ) # scen loop
 foreach OBS ( \${OBS_SET} ) #OBS loop1
   foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
     foreach mbr ( \$mbr_set ) #mbr loop1
       set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename 
       set ARC_mon_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/atm/proc/tseries/month_1
       set ARC_day_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/atm/proc/tseries/day_1
       set period_f = ( \`ls \${ARC_day_TS_ROOT}/*.${var}.* | cut -d '.' -f 19\` )
       set n_period_f = "\${#period_f}"
       echo \${period_f}
        foreach ni ( \`seq 1 \${n_period_f}\` )
         set period_f2 = \${period_f[\${ni}]}
         echo \${period_f2}
#         set inputname = ( \`ls \${ARC_day_TS_ROOT}/*.${var}.* \` )
         set fy1 = \`echo \${period_f2} | cut -c 1-4\`
         set fy2 = \`echo \${period_f2} | cut -c 10-13\`
         set inputname = \${ARC_day_TS_ROOT}/\${CASENAME_M}.cam.h1.${var}.\${fy1}0101-\${fy2}1231.nc
         echo \${inputname}
         set outputname = \${ARC_mon_TS_ROOT}/\${CASENAME_M}.cam.h0.${var}.\${fy1}01-\${fy2}12.nc
         echo \${outputname}
#         sleep 1000s
         cdo -O -w -z zip_5 -monmean \${inputname} \${outputname} 
       end
     end
   end
 end
end
echo "postprocessing complete"

EOF

#csh $tmp_scr &
csh $tmp_scr > $tmp_log &
end



