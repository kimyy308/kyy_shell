#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH )
#set vars = ( NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX)
#set vars = ( IRON_FLUX )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf )
#set vars = ( dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
#set vars = ( diaz_loss_zint_100m )
#231102
set vars = ( TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 SALT PD DIC ALK )
#231120
set vars = ( DIC )

#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231124
set vars = ( Jint_100m_Fe tend_zint_100m_Fe  Jint_100m_NH4 tend_zint_100m_NH4 Jint_100m_PO4 tend_zint_100m_PO4 Jint_100m_SiO3 tend_zint_100m_SiO3 diaz_Nfix photoNO3_diat photoNO3_diaz photoNO3_sp photoNH4_diat photoNH4_diaz photoNH4_sp photoFe_diat photoFe_diaz photoFe_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake )

#20231214
set vars = ( DIC )
#20240219
set vars = ( DIC_ALT_CO2 DpCO2_ALT_CO2 ) 
#20240305
set vars = ( TEMP SALT )


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
#set siy = 1962
#set eiy = 1960
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/ocn/proc/tseries/month_1
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
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/ocn/proc/tseries/month_1
##          set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}/\${CASENAME} 
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}/\${CASENAME} 
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
                set inputname = \${ARC_ROOT}/b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}.pop.h.${var}.\${period_f}.nc
                set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${yloop}-\${mloop}.nc
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
