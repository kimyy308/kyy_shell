#!/bin/csh
####!/bin/csh -fx
# Updated  18-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( BSF )
#set vars = ( HBLT diat_agg_zint_100m )
#set vars = ( diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m )
#set vars = ( diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_Cweight_avg_100m  )
#set vars = ( diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf )
#set vars = ( diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m )
#set vars = ( diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m )
#set vars = ( diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m )
#set vars = ( diaz_P_lim_surf dustToSed graze_diat_zint_100m  )
#set vars = ( graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m  )
#set vars = ( graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F )
#set vars = ( O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m )
#set vars = ( photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m   )
#set vars = ( sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m   )
#set vars = ( sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m     )
#set vars = ( sp_N_lim_surf sp_P_lim_Cweight_avg_100m   )
#set vars = ( sp_P_lim_surf zoo_loss_zint_100m zoo_loss_zint_100m  )


set vars = ( BSF HBLT diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m  graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m zoo_loss_zint_100m  )

#reversed order
set siy = 2021
set eiy = 2021
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 

foreach iyloop ( ${IY_SET} )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_hcst_tmp_${iyloop}.csh
set tmp_log =  ~/tmp_log/${var}_hcst_tmp_${iyloop}.log


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
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
 set INITY = ${iyloop}
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
          set FY_SET = ( \`seq ${iyloop} \${fy_end}\` )
          foreach fy ( \${FY_SET} )
            ###if ( \${period_SET} == "" ) then
            if ( \${#period_SET} == 0 ) then
              foreach mloop ( \${M_SET} )
                set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.pop.h.\${fy}-\${mloop}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                cdo -O -w -select,name=${var} \${inputname} ${homedir}/hcst_test2_${var}_${iyloop}.nc
                cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/hcst_test2_${var}_${iyloop}.nc \$outputname 
                echo \${outputname} "from raw"
              end
            else
              foreach period ( \${period_SET} )
                set Y_1 = (\`echo \$period | cut -c 1-4\`)
                set Y_2= (\`echo \$period | cut -c 8-11\`)
                if (\$Y_1 <= \${fy} && \${fy} <= \$Y_2) then
                  set period_f=\${period}
                  echo \${period_f}, ${iyloop}
                  @ tind = \`expr \( ${iyloop} - \${Y_1} \) \* 12\`
                  #echo \${vind}
                  foreach mloop ( \${M_SET} )
                    @ tind2 = \$tind + \$mloop
                    #echo \$tind2
                    set inputname = \${ARC_TS_ROOT}/\${CASENAME}.pop.h.${var}.\${period_f}.nc
                    set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                    #ls \$input_head
                     cdo -O -seltimestep,\$tind2 \$inputname ${homedir}/hcst_test_${var}_${iyloop}.nc
                     cdo -O -z zip_5 -select,name=${var} ${homedir}/hcst_test_${var}_${iyloop}.nc \$outputname
                    echo \${outputname}
                  end
                endif
              end
            endif
          end 
        end
      end
    end
#  end
rm -f ${homedir}/hcst_test_${var}_${iyloop}.nc
echo "postprocessing complete"

EOF

csh $tmp_scr > $tmp_log &
end
end

foreach iyloop ( ${IY_SET} )
foreach var ( ${vars} )
set tmp_scr =  ~/tmp_script/${var}_hcst_tmp_${iyloop}.csh
set tmp_log =  ~/tmp_log/${var}_hcst_tmp_${iyloop}.log
  set stat = pre
  while ( ${stat} != postprocessing )
    sleep 10s
    set stat = ( `grep post $tmp_log | cut -d ' ' -f 1` )
  end
end
end
