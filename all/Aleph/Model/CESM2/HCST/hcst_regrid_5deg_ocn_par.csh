#!/bin/csh
####!/bin/csh -fx
# Updated  06-Jan-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#20240106
set vars = ( SSH TEMP SALT UVEL VVEL PD DIC ALK WVEL diatChl diazChl spChl diatC diazC spC Fe NO3 NH4 SiO3 PO4 DOP PAR_avg zooC photoC_TOT pH_3D FG_CO2 DpCO2)

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_hcst_ext_tmp.csh
set tmp_log =  ~/tmp_log/${var}_hcst_ext_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2021
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
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive/\${CASENAME_M}/\${CASENAME}/ocn/hist/
          set ARC_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\${CASENAME_M}/\${CASENAME}/ocn/proc/tseries/month_1
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_5deg/archive/\${CASENAME_M}/\${CASENAME}/ocn/proc/tseries/month_1
          mkdir -p \$SAVE_ROOT
          set period_SET = ( \`ls \${ARC_TS_ROOT}/*.${var}.* | cut -d '.' -f 16\` )
          @ fy_end = \${INITY} + 4
          set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
          
          if ( \$iyloop == 2021 && \${OBS} == "projdv7.3_ba" ) then
            foreach fy ( \${FY_SET} )
              set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_fixed/archive/\${CASENAME_M}/\${CASENAME}/ocn/hist/
              foreach mloop ( \${M_SET} )
                set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.pop.h.\${fy}-\${mloop}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.r72x36.pop.h.\${fy}-\${mloop}.nc
                cdo -O -w -z zip_5 -remapbil,r72x36 -select,name=${var} \${inputname} \$outputname
                echo \${outputname} "from raw"
              end
            end
          else
            foreach period ( \${period_SET} )
              set inputname = \${ARC_TS_ROOT}/\${CASENAME}.pop.h.${var}.\${period}.nc
              set outputname = \${SAVE_ROOT}/\${CASENAME}.r72x36.pop.h.${var}.\${period}.nc
#               cdo -O -w -z zip_5 -remapbil,r72x36 -select,name=${var} \${inputname} \${outputname}
               cdo -O -w -select,name=${var} \${inputname} ${homedir}/hcst_test_5deg_${var}.nc
               cdo -O -w -z zip_5 -remapbil,r72x36  ${homedir}/hcst_test_5deg_${var}.nc \${outputname}
#               cdo -O -w -z zip_5 -remapbil,r72x36 \${inputname} ${homedir}/hcst_test_5deg_${var}.nc
#               cdo -O -select,name=${var} ${homedir}/hcst_test_5deg_${var}.nc \${outputname} 
#                cdo -O -w -z zip_5 -select,name=${var} \${inputname} \$outputname
              echo \${outputname} "from ts"
            end
          endif 
        end
      end
    end
#  end
end
rm -f ${homedir}/hcst_test_${var}.nc
echo "postprocessing complete"

EOF

csh $tmp_scr > $tmp_log &
end



#foreach var ( ${vars} )
#set tmp_scr =  ~/tmp_script/${var}_hcst_ext_tmp.csh
#set tmp_log =  ~/tmp_log/${var}_hcst_ext_tmp.log
#  set stat = pre
#  while ( ${stat} != postprocessing )
#    sleep 10s
#    set stat = ( `grep post $tmp_log | cut -d ' ' -f 1` )
#  end
#end
