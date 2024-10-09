#!/bin/csh
####!/bin/csh -fx
# Updated  06-Jun-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

set exp_abb = xWDS
set FLUX_casename = EXP_FLUX_${exp_abb}

set vars = (UVEL VVEL WVEL photoC_TOT diatChl diazChl spChl TEMP SALT WVEL2 NO3 SiO3 PO4 Fe PAR_avg NH4 DOP SSH IRON_FLUX HBLT diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_surf diaz_light_lim_Cweight_avg_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf photoC_diat_zint_100m photoC_diaz_zint_100m photoC_sp_zint_100m photoC_TOT_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf TAUX TAUY ATM_COARSE_DUST_FLUX_CPL ATM_FINE_DUST_FLUX_CPL SHF_QSW QSW_BIN_01 QSW_BIN_06 )
#set vars = ( TEMP )
#set vars = (UVEL VVEL WVEL photoC_TOT diatChl diazChl spChl TEMP WVEL2 NO3 SiO3 PO4 Fe PAR_avg NH4 DOP )
#set vars_2d = ( SSH IRON_FLUX HBLT diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_surf diaz_light_lim_Cweight_avg_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf photoC_diat_zint_100m photoC_diaz_zint_100m photoC_sp_zint_100m photoC_TOT_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf TAUX TAUY ATM_COARSE_DUST_FLUX_CPL ATM_FINE_DUST_FLUX_CPL SHF_QSW QSW_BIN_01 QSW_BIN_06 )


if ( ${exp_abb} == REF1 ) then
  set exp_abb_f = ref1
else
  set exp_abb_f = ${exp_abb}
endif

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_${FLUX_casename}_merge.csh
set tmp_log =  ~/tmp_log/${var}_${FLUX_casename}_merge.log

#set sy = 1998
#set ey = 2007

#### caution
#### fixed term -> 1998 ~ 2007


cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set outfreq = mon
#set scens = ( BHISTsmbb BSSP370smbb )
set scens = ( BHISTsmbb )
foreach scen ( \${scens} ) 
  set CASENAME_M = b.e21.\${scen}.\${RESOLN}.atm_flux.${exp_abb_f}  #parent casename
  set CASENAME = ${FLUX_casename}  #parent casename
#  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/archive/\${CASENAME_M}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME}/merged 
  mkdir -p \$SAVE_ROOT

#  set input_head = \${ARC_ROOT}/ocn/hist/\${CASENAME_M}.pop.h.????-??.nc
#  set input_set=(\`ls \${input_head}*\`)
#  foreach inputname ( \${input_set} ) 
    
    cdo -O -w -mergetime \${ARC_ROOT}/b*19*.nc \${ARC_ROOT}/b*200[0-7]*.nc \${SAVE_ROOT}/merged_${var}_\${outfreq}.nc 
    cdo remapcon,/proj/shared_data/ensemble_simulations/script/ocean_remap/cdo/outgrid.r360x180.txt -setgrid,/proj/shared_data/ensemble_simulations/script/ocean_remap/cdo/POP.grid_gx1v7.nc \${SAVE_ROOT}/merged_${var}_\${outfreq}.nc \${SAVE_ROOT}/merged_remap_${var}_\${outfreq}.nc 
    cdo -O -w -timselmean,12,0,0  \${SAVE_ROOT}/merged_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/yearly_merged_remap_${var}_\${outfreq}.nc 
    
    cdo -O -w -ymonmean \${SAVE_ROOT}/merged_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/clim_mean_remap_${var}_\${outfreq}.nc
    cdo -O -w -ymonsub \${SAVE_ROOT}/merged_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/clim_mean_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/clim_ano_remap_${var}_\${outfreq}.nc

#    set outputnc=(\`echo \${inputname} | cut -d '/' -f 12\`)
#    set outputnc_new=(\`echo \${outputnc} | sed "s/\${scen}.\${RESOLN}/${var}_\${outfreq}_\${RESOLN}/g"\`)
#    set outputname = \${SAVE_ROOT}/\${outputnc_new}
#    echo "cdo -O select,name="${var}" "\$inputname" "\$outputname
#    cdo -O -w -z zip_5 select,name=${var} \$inputname ${homedir}/test_\${CASENAME}_atm_assm_extract_ocn_${var}.nc
#    cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/test_\${CASENAME}_atm_assm_extract_ocn_${var}.nc  \$outputname 
#  end
end
#rm -f ${homedir}/test_\${CASENAME}_atm_assm_extract_ocn_${var}.nc
#rm -f ${homedir}/test2_${var}.nc
echo "postprocessing complete"

EOF

csh $tmp_scr > $tmp_log &
end

