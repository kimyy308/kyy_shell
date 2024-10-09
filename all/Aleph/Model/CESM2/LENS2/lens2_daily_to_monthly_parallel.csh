#!/bin/csh
####!/bin/csh -fx
# Updated  22-Jul-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#20240722
set vars = ( Z500 ) 
#20240723
set vars = ( U010 V010 ) 


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/d2m_${var}_lens2_ext_tmp.csh
set tmp_log =  ~/tmp_log/d2m_${var}_lens2_ext_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1960
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.lens2.en4.2_ba-10p1/ocn/proc/tseries/month_1


#echo \${IY_SET}
#set IY_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach scen ( \${scens} ) # scen loop
  set smbb_set = ( \`ls /proj/jedwards/archive/ | grep \${scen} | grep -v smbbext\` )
  foreach CASENAME_M ( \${smbb_set} )
#       set CASENAME_M = b.e21.\${scen}.\${RESOLN}.lens2.\${OBS}-\${FACTOR}p\${mbr}  #parent casename 
       set ARC_mon_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive/\${CASENAME_M}/atm/proc/tseries/month_1
       set ARC_day_TS_ROOT = /mnt/lustre/proj/jedwards/archive/\${CASENAME_M}/atm/proc/tseries/day_1
       set period_f = ( \`ls \${ARC_day_TS_ROOT}/*.${var}.* | cut -d '.' -f 15\` )
       set n_period_f = "\${#period_f}"
       echo \${period_f}
       mkdir -p \${ARC_mon_TS_ROOT}
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
         if (\${fy1} >= 1950 && \${fy1} <= 2025) then
           cdo -O -w -z zip_5 -monmean \${inputname} \${outputname} 
         endif
       end
  end
end
echo "postprocessing complete"

#set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
#set period_set_ssp = ( 201501-202412 202501-203412 )

EOF

#csh $tmp_scr &
csh -xv $tmp_scr > $tmp_log &
end



