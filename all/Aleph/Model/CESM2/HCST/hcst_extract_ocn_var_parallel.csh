#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = (NO3 SiO3 PO4)
#set vars = ( UVEL VVEL PD )
#set vars = ( UE_PO4 VN_PO4 WT_PO4 )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
#set vars = ( WVEL2 )
#set vars = ( diatC diazC spC )

#set vars = ( diatC diazC spC diatChl diazChl spChl NO3 PO4 SiO3 Fe WVEL )
#set vars = ( TEMP UVEL VVEL PD DIC ALK UE_PO4 VN_PO4 WT_PO4 WVEL2 )
#set vars = ( PAR_avg )
#set vars = ( HMXL )
#set vars = ( diatChl diazChl spChl NO3 PO4 SiO3 Fe PAR_avg ALK diatC diazC DIC PD SALT spC TEMP UVEL VVEL WVEL WVEL2 O2 ) #zooC later? 
#set vars = ( O2 zooC ) 
#set vars = ( diatChl diazChl spChl ) 
#set vars = ( zooC O2 ) 
#set vars = ( DOP NH4 ) 
#set vars = ( diat_Qp sp_Qp diaz_Qp ) 
set vars = ( photoC_TOT ) 
#20230823
set vars = ( TEMP SALT UVEL VVEL PD DIC ALK WVEL diatChl diazChl spChl Fe NO3 NH4 SiO3 PO4 DOP PAR_avg zooC photoC_TOT )
#20231026
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231101
set vars = ( pH_3D )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/${var}_hcst_tmp.log

#reversed order
set siy = 2021
set eiy = 1960

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = $siy
set eiy = $eiy
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/ocn/proc/tseries/month_1
#echo \${IY_SET}
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )
 set INITY = \${iyloop}
#  foreach scen ( \${scens} )
#    if (\${iyloop} <= 2014) then
#      set scen = BHISTsmbb
#    else if (\${iyloop} >= 2015) then
#      set scen = BSSP370smbb
#    endif
    foreach OBS ( \${OBS_SET} ) #OBS loop1
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
          set CASENAME_M = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}  #parent casename 
          set CASENAME = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive/\${CASENAME_M}/\${CASENAME}/ocn/hist/
          set ARC_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\${CASENAME_M}/\${CASENAME}/ocn/proc/tseries/month_1
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/\${CASENAME_M}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
          set period_SET = ( \`ls \${ARC_TS_ROOT}/*.${var}.* | cut -d '.' -f 16\` )
          @ fy_end = \${INITY} + 4
          set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
          foreach fy ( \${FY_SET} )
            ###if ( \${period_SET} == "" ) then
            if ( \${#period_SET} == 0 ) then
              foreach mloop ( \${M_SET} )
                set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.pop.h.\${fy}-\${mloop}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                cdo -O -L -w -select,name=${var} \${inputname} \$outputname
#                cdo -O -L -w -select,name=${var} \${inputname} ${homedir}/hcst_test2_${var}.nc
#                cdo -O -L -w -z zip_5 -sellevel,500/15000 ${homedir}/hcst_test2_${var}.nc \$outputname 
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
                    set inputname = \${ARC_TS_ROOT}/\${CASENAME}.pop.h.${var}.\${period_f}.nc
                    set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                    #ls \$input_head
                     cdo -O -L -w -seltimestep,\$tind2 \$inputname ${homedir}/hcst_test_${var}.nc
                     cdo -O -L -w -select,name=${var} ${homedir}/hcst_test_${var}.nc \$outputname
#                     cdo -O -L -w -select,name=${var} ${homedir}/hcst_test_${var}.nc ${homedir}/hcst_test2_${var}.nc
#                     cdo -O -L -w -z zip_5 -sellevel,500/15000 ${homedir}/hcst_test2_${var}.nc \$outputname 
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
rm -f ${homedir}/hcst_test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
