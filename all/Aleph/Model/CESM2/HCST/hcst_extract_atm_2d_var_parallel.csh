#!/bin/csh
####!/bin/csh -fx
# Updated  16-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( diatC diazC spC )
#set vars = ( PS PSL  )
#set vars = ( PRECT U10 AODDUST )
#set vars = ( SST )
#set vars = ( TS )
#set vars = ( PS PSL PRECT U10 AODDUST SST TS )
set vars = ( TS SST PSL PRECT AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )
#20230913
set vars = ( Q RELHUM ) 

#20231008
set vars = ( CLOUD OMEGA U V AEROD_v FSDS FSNS U10 TAUX TAUY Z3 CLDTOT LHFLX SHFLX ) 

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_hcst_extract_tmp.csh
set tmp_log =  ~/tmp_log/${var}_hcst_extract_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2021
set eiy = 1960
#set eiy = 1970
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/atm/proc/tseries/month_1
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
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive/\${CASENAME_M}/\${CASENAME}/atm/hist/
          set ARC_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\${CASENAME_M}/\${CASENAME}/atm/proc/tseries/month_1
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/${var}/\${CASENAME_M}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
          set period_SET = ( \`ls \${ARC_TS_ROOT}/*.${var}.* | cut -d '.' -f 16\` )
          @ fy_end = \${INITY} + 4
          set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
          foreach fy ( \${FY_SET} )
            ###if ( \${period_SET} == "" ) then
            if ( \${#period_SET} == 0 ) then
              foreach mloop ( \${M_SET} )
                set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.cam.h0.\${fy}-\${mloop}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${fy}-\${mloop}.nc
                cdo -O -w -z zip_5 -select,name=${var} \${inputname} \$outputname
                echo \${outputname} "from raw"
              end
            else
              foreach period ( \${period_SET} )
                set Y_1 = (\`echo \$period | cut -c 1-4\`)
                set Y_2= (\`echo \$period | cut -c 8-11\`)
                if (\$Y_1 <= \${fy} && \${fy} <= \$Y_2) then
                  set period_f=\${period}
                  echo \${period_f}, \${iyloop}
#                  @ tind = \`expr \( \${iyloop} - \${Y_1} \) \* 12\`
                  @ tind = \`expr \( \${fy} - \${Y_1} \) \* 12\`
                  #echo \${vind}
                  foreach mloop ( \${M_SET} )
                    @ tind2 = \$tind + \$mloop
                    #echo \$tind2
                    set inputname = \${ARC_TS_ROOT}/\${CASENAME}.cam.h0.${var}.\${period_f}.nc
                    set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${fy}-\${mloop}.nc
                    #ls \$input_head
                     cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/hcst_test_${var}.nc
                     cdo -O -w -z zip_5 -select,name=${var} ${homedir}/hcst_test_${var}.nc \${outputname} 
                    echo \${outputname} "from ts"
                  end
                endif
              end
            endif
          end 
        end
      end
    end
#  end
end
rm -f ${homedir}/hcst_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
