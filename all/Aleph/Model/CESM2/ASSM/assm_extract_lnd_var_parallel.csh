#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#20230830
#set vars = ( GPP NPP TOTVEGC TWS )
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ SNOW_PERSISTENCE RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT ) #SNOW_PERSISTENCE -> removed
#20230907
set vars = ( SOILWATER_10CM )
#20230910
set vars = ( FAREA_BURNED NFIRE )
#20230913
set vars = ( Q2M RH2M TLAI )
set vars = ( SNOW )
#20231006
set vars = ( Q2M RH2M TLAI SNOW )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1960
#set siy = 1990
#set eiy = 1960
#set siy = 2020
#set eiy = 1991
#set siy = 2020
#set eiy = 2020
set scens = (BHISTsmbb BSSP370smbb)
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
#  foreach scen ( \${scens} )
    if (\${yloop} <= 2014) then
      set scen = BHISTsmbb
    else if (\${yloop} >= 2015) then
      set scen = BSSP370smbb
    endif
    foreach OBS ( \${OBS_SET} ) #OBS loop1
#      set OBS = \${OBS_SET[\$obsloop]}
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
          set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
          set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/lnd/proc/tseries/month_1
#          set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/lnd/${var}/\${CASENAME} 
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/lnd/${var}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT

          if ( \$yloop == 2020 && \${OBS} == "projdv7.3_ba" ) then
            set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_fixed/archive/\${CASENAME_M}/lnd/hist
            foreach mloop ( \${M_SET} )
              set inputname = \${ARC_ROOT}/\${CASENAME_M}.clm2.h0.\${yloop}-\${mloop}.nc
              set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${yloop}-\${mloop}.nc
              cdo -O -w -select,name=${var} \$inputname \$outputname
              echo "from fixed run, " \${outputname} 
            end
          else
             set period_SET = ( \`ls \${ARC_ROOT}/*.${var}.* | cut -d '.' -f 19\` )
             foreach period ( \${period_SET} )
               set Y_1 = (\`echo \$period | cut -c 1-4\`)
               set Y_2= (\`echo \$period | cut -c 8-11\`)
               if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
                 set period_f=\${period}
                 echo \${period_f}, \${yloop}
                 @ tind = \`expr \( \${yloop} - \${Y_1} \) \* 12\`
                 #echo \${vind}
                 foreach mloop ( \${M_SET} )
                   @ tind2 = \$tind + \$mloop
                   #echo \$tind2
                   set inputname = \${ARC_ROOT}/b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}.clm2.h0.${var}.\${period_f}.nc
                   set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${yloop}-\${mloop}.nc
                   #ls \$input_head
                    cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/test_${var}.nc
                    cdo -O -w -select,name=${var} ${homedir}/test_${var}.nc \$outputname
#                    cdo -O -w -select,name=${var} ${homedir}/test_${var}.nc ${homedir}/test2_${var}.nc
#                    cdo -O -w -sellevel,992.556095123291 ${homedir}/test2_${var}.nc \$outputname 
#                   cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/test_${var}.nc
#                   cdo -O -w -select,name=${var} -sellevel,992.556095123291 ${homedir}/test_${var}.nc \$outputname
                   echo \${outputname}
                 end
               endif
             end 
          endif
        end
      end
    end
#  end
end
rm -f ${homedir}/test_${var}.nc
rm -f ${homedir}/test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
