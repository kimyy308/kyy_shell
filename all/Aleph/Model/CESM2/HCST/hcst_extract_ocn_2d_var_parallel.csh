#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr (2021 -> read HCST fixed)

set homedir = /proj/kimyy/tmp
#set vars = ( diatC diazC spC )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 photoC_TOT_zint_100m IRON_FLUX )
#set vars = ( SSH )
#set vars = ( HMXL )
#set vars = ( photoC_TOT_zint )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 photoC_TOT_zint_100m IRON_FLUX SSH HMXL photoC_TOT_zint )
#set vars = ( BSF )
#set vars = ( BSF HBLT diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m  graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m  )
#set vars = ( sp_P_lim_Cweight_avg_100m )
#set vars = ( IRON_FLUX )
#set vars = ( diat_N_lim_Cweight_avg_100m )
set vars = ( HBLT diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_surf diat_N_lim_Cweight_avg_100m diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m  graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )

#20230823
set vars = ( HMXL HBLT SSH IRON_FLUX photoC_TOT_zint_100m photoC_TOT_zint ATM_CO2 CaCO3_FLUX_100m DpCO2 pCO2SURF )

#20231106
set vars = ( CO3 DIC_ALT_CO2 pH_3D POC_FLUX_IN POC_PROD )
#20231114
set vars = ( DOC )
#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231124
set vars = ( Jint_100m_Fe tend_zint_100m_Fe  Jint_100m_NH4 tend_zint_100m_NH4 Jint_100m_PO4 tend_zint_100m_PO4 Jint_100m_SiO3 tend_zint_100m_SiO3 diaz_Nfix photoNO3_diat photoNO3_diaz photoNO3_sp photoNH4_diat photoNH4_diaz photoNH4_sp photoFe_diat photoFe_diaz photoFe_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake )

#20231212
set vars = ( photoFe_sp )
#20240219
set vars = ( DIC_ALT_CO2 DpCO2_ALT_CO2 ) 


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
#set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (10)
#set mbr_set = (1)
set RESOLN = f09_g17
set siy = 2021
set eiy = 1960
#set siy = 2010
#set eiy = 2010
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
            if ( \$iyloop == 2021 && \${OBS} == "projdv7.3_ba" ) then
              set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_fixed/archive/\${CASENAME_M}/\${CASENAME}/ocn/hist/
              foreach mloop ( \${M_SET} )
                set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.pop.h.\${fy}-\${mloop}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                cdo -O -w -z zip_5 -select,name=${var} \${inputname} \$outputname
                echo \${outputname} "from raw"
              end
            else
              ###if ( \${period_SET} == "" ) then
              if ( \${#period_SET} == 0 ) then
                foreach mloop ( \${M_SET} )
                  set inputname = \${ARC_ROOT}/\${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}.pop.h.\${fy}-\${mloop}.nc
                  set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
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
#                    @ tind = \`expr \( \${iyloop} - \${Y_1} \) \* 12\`
                    @ tind = \`expr \( \${fy} - \${Y_1} \) \* 12\`
                    #echo \${vind}
                    foreach mloop ( \${M_SET} )
                      @ tind2 = \$tind + \$mloop
                      #echo \$tind2
                      set inputname = \${ARC_TS_ROOT}/\${CASENAME}.pop.h.${var}.\${period_f}.nc
                      set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-\${mloop}.nc
                      #ls \$input_head
                       cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/hcst_test_${var}.nc
                       cdo -O -w -z zip_5 -select,name=${var} ${homedir}/hcst_test_${var}.nc \${outputname} 
                      echo \${outputname} "from ts"
                    end
                  endif
                end
              endif
            endif
          end 
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
