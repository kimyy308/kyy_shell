#!/bin/csh
####!/bin/csh -fx
# Updated  03-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set vars = ( aice sithick )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/ASSM
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1960
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/ice/proc/tseries/month_1
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
  foreach scen ( \${scens} )
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
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/ice/proc/tseries/month_1
##          set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ice/${var}/\${CASENAME} 
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ice/${var}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
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
                set inputname = \${ARC_ROOT}/b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}.cice.h.${var}.\${period_f}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cice.h.\${yloop}-\${mloop}.nc
                #ls \$input_head
                 cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/assm_test_${var}.nc
                 cdo -O -w -z zip_5 -select,name=${var} ${homedir}/assm_test_${var}.nc \$outputname
                echo \${outputname}
              end
            endif
          end 
        end
      end
    end
  end
end
rm -f ${homedir}/assm_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
