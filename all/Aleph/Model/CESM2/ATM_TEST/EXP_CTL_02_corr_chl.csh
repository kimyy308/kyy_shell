#!/bin/csh
####!/bin/csh -fx
# Updated  28-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

set sy = 1998
set ey = 2020
#set var = photoC_TOT_zint


#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set MEM_SET = ("1231.012")  #
set RESOLN = f09_g17
set siy = ${sy}
set eiy = ${ey}
set outfreq = mon
set Y_SET = ( `seq ${siy} +1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach year ( ${Y_SET} )
  foreach month ( ${M_SET} )
    foreach MEM ( ${MEM_SET} ) #OBS loop1
#      set CASENAME_M = b.e21.${scen}.${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}  #parent casename
      set CASENAME = LE2-${MEM} #parent casename
      #diatChl
      set ARC_ROOT_diat = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/diatChl/${CASENAME}
      set SAVE_ROOT_diat = ${ARC_ROOT_diat} 
      mkdir -p ${SAVE_ROOT_diat}/link
      mkdir -p $SAVE_ROOT_diat
      mkdir -p ${SAVE_ROOT_diat}/merged
      ln -sf ${ARC_ROOT_diat}/diatChl_${CASENAME}.pop.h.${year}-${month}.nc ${SAVE_ROOT_diat}/link/
      
      #diazChl
      set ARC_ROOT_diaz = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/diazChl/${CASENAME}
      set SAVE_ROOT_diaz = ${ARC_ROOT_diaz} 
      mkdir -p ${SAVE_ROOT_diaz}/link
      mkdir -p $SAVE_ROOT_diaz
      mkdir -p ${SAVE_ROOT_diaz}/merged
      ln -sf ${ARC_ROOT_diaz}/diazChl_${CASENAME}.pop.h.${year}-${month}.nc ${SAVE_ROOT_diaz}/link/
      
      #spChl
      set ARC_ROOT_sp = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/spChl/${CASENAME}
      set SAVE_ROOT_sp = ${ARC_ROOT_sp} 
      mkdir -p ${SAVE_ROOT_sp}/link
      mkdir -p $SAVE_ROOT_sp
      mkdir -p ${SAVE_ROOT_sp}/merged
      ln -sf ${ARC_ROOT_sp}/spChl_${CASENAME}.pop.h.${year}-${month}.nc ${SAVE_ROOT_sp}/link/

      #sumChl
      set ARC_ROOT_sum = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/sumChl/${CASENAME}
      set SAVE_ROOT_sum = ${ARC_ROOT_sum} 
      mkdir -p ${SAVE_ROOT_sum}/link
      mkdir -p $SAVE_ROOT_sum
      mkdir -p ${SAVE_ROOT_sum}/merged
#      cdo -O -w -z zip_5 -merge -selname,diatChl ${ARC_ROOT_diat}/diatChl_${CASENAME}.pop.h.${year}-${month}.nc -selname,diazChl ${ARC_ROOT_diaz}/diazChl_${CASENAME}.pop.h.${year}-${month}.nc ${ARC_ROOT_sp}/spChl_${CASENAME}.pop.h.${year}-${month}.nc ${homedir}/merged_chl.nc
#      cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_chl.nc ${ARC_ROOT_sum}/sumChl_${CASENAME}.pop.h.${year}-${month}.nc 
      ln -sf ${ARC_ROOT_sum}/sumChl_${CASENAME}.pop.h.${year}-${month}.nc ${SAVE_ROOT_sum}/link/

      #Obs
      set OBS_ROOT = /mnt/lustre/proj/kimyy/Observation/OC_CCI/monthly_reg_cam 
      mkdir -p ${OBS_ROOT}/link
      ln -sf ${OBS_ROOT}/OC_CCI_reg_cesm2.${year}${month}.nc ${OBS_ROOT}/link/

    end
  end
end
rm -f ${homedir}/merged_chl.nc
mkdir -p ${SAVE_ROOT_diat}/corr
mkdir -p ${SAVE_ROOT_diaz}/corr
mkdir -p ${SAVE_ROOT_sp}/corr
mkdir -p ${SAVE_ROOT_sum}/corr

#mergetime, select surface (500cm)
cdo -O -w -z zip_5 -sellevel,500 -mergetime ${SAVE_ROOT_diat}/link/diat* ${SAVE_ROOT_diat}/merged/merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -sellevel,500 -mergetime ${SAVE_ROOT_diaz}/link/diaz* ${SAVE_ROOT_diaz}/merged/merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -sellevel,500 -mergetime ${SAVE_ROOT_sp}/link/sp* ${SAVE_ROOT_sp}/merged/merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -sellevel,500 -mergetime ${SAVE_ROOT_sum}/link/sum* ${SAVE_ROOT_sum}/merged/merged_sumChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 mergetime ${OBS_ROOT}/link/OC_CCI* ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc

#mergetime, vertical average
cdo -O -w -z zip_5 -mergetime ${SAVE_ROOT_diat}/link/diat* ${homedir}/merged_diat_chl.nc 
cdo -O -w -z zip_5 -mergetime ${SAVE_ROOT_diaz}/link/diaz* ${homedir}/merged_diaz_chl.nc 
cdo -O -w -z zip_5 -mergetime ${SAVE_ROOT_sp}/link/sp* ${homedir}/merged_sp_chl.nc
cdo -O -w -z zip_5 -mergetime ${SAVE_ROOT_sum}/link/sum* ${homedir}/merged_sum_chl.nc

cdo -O -w -z zip_5 -vertmean ${homedir}/merged_diat_chl.nc ${SAVE_ROOT_diat}/merged/vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -vertmean ${homedir}/merged_diaz_chl.nc ${SAVE_ROOT_diaz}/merged/vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -vertmean ${homedir}/merged_sp_chl.nc ${SAVE_ROOT_sp}/merged/vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -w -z zip_5 -vertmean ${homedir}/merged_sum_chl.nc ${SAVE_ROOT_sum}/merged/vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc

#yearlymean and data availability
cdo -O -yearmean ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc
cdo -O -expr,'chlor_a=chlor_a/chlor_a' ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc

#masking
cdo -O -mul ${SAVE_ROOT_diat}/merged/merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/merged/OC_CCI_masked_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_diaz}/merged/merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_sp}/merged/merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/merged/OC_CCI_masked_merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_sum}/merged/merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/merged/OC_CCI_masked_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc

#masking (vertmean)
cdo -O -mul ${SAVE_ROOT_diat}/merged/vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/merged/OC_CCI_masked_vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_diaz}/merged/vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_sp}/merged/vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/merged/OC_CCI_masked_vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -mul ${SAVE_ROOT_sum}/merged/vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${OBS_ROOT}/merged/mask_merged_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/merged/OC_CCI_masked_vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc

#yearly mean (models)
cdo -O -yearmean ${SAVE_ROOT_diat}/merged/OC_CCI_masked_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/merged/OC_CCI_masked_yearly_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_yearly_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_sp}/merged/OC_CCI_masked_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/merged/OC_CCI_masked_yearly_merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_sum}/merged/OC_CCI_masked_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/merged/OC_CCI_masked_yearly_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc

#yearly mean (models, vertmean)
cdo -O -yearmean ${SAVE_ROOT_diat}/merged/OC_CCI_masked_vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/merged/OC_CCI_masked_yearly_vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_yearly_vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_sp}/merged/OC_CCI_masked_vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/merged/OC_CCI_masked_yearly_vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -yearmean ${SAVE_ROOT_sum}/merged/OC_CCI_masked_vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/merged/OC_CCI_masked_yearly_vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc

#timcorr_monthly
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,diatChl ${SAVE_ROOT_diat}/merged/OC_CCI_masked_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/corr/OC_CCI_masked_corr_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,diazChl ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/corr/OC_CCI_masked_corr_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,spChl ${SAVE_ROOT_sp}/merged/OC_CCI_masked_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/corr/OC_CCI_masked_corr_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,sumChl ${SAVE_ROOT_sum}/merged/OC_CCI_masked_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/corr/OC_CCI_masked_corr_sumChl_${CASENAME}_${siy}_${eiy}.nc

#timcorr_monthly (vertmean)
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,diatChl ${SAVE_ROOT_diat}/merged/OC_CCI_masked_vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/corr/OC_CCI_masked_vm_corr_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,diazChl ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/corr/OC_CCI_masked_vm_corr_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,spChl ${SAVE_ROOT_sp}/merged/OC_CCI_masked_vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/corr/OC_CCI_masked_vm_corr_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/merged_${siy}_${eiy}.nc -selname,sumChl ${SAVE_ROOT_sum}/merged/OC_CCI_masked_vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/corr/OC_CCI_masked_vm_corr_sumChl_${CASENAME}_${siy}_${eiy}.nc

#timcorr_yearly
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,diatChl ${SAVE_ROOT_diat}/merged/OC_CCI_masked_yearly_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/corr/OC_CCI_masked_yearly_corr_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,diazChl ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_yearly_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/corr/OC_CCI_masked_yearly_corr_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,spChl ${SAVE_ROOT_sp}/merged/OC_CCI_masked_yearly_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/corr/OC_CCI_masked_yearly_corr_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,sumChl ${SAVE_ROOT_sum}/merged/OC_CCI_masked_yearly_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/corr/OC_CCI_masked_yearly_corr_sumChl_${CASENAME}_${siy}_${eiy}.nc

#timcorr_yearly
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,diatChl ${SAVE_ROOT_diat}/merged/OC_CCI_masked_yearly_vm_merged_diatChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diat}/corr/OC_CCI_masked_yearly_vm_corr_diatChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,diazChl ${SAVE_ROOT_diaz}/merged/OC_CCI_masked_yearly_vm_merged_diazChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_diaz}/corr/OC_CCI_masked_yearly_vm_corr_diazChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,spChl ${SAVE_ROOT_sp}/merged/OC_CCI_masked_yearly_vm_merged_spChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sp}/corr/OC_CCI_masked_yearly_vm_corr_spChl_${CASENAME}_${siy}_${eiy}.nc
cdo -O -L -timcor -selname,chlor_a ${OBS_ROOT}/merged/yearly_merged_${siy}_${eiy}.nc -selname,sumChl ${SAVE_ROOT_sum}/merged/OC_CCI_masked_yearly_vm_merged_sumChl_${CASENAME}_${siy}_${eiy}.nc ${SAVE_ROOT_sum}/corr/OC_CCI_masked_yearly_vm_corr_sumChl_${CASENAME}_${siy}_${eiy}.nc

rm -rf ${SAVE_ROOT_diat}/link/*
rm -rf ${SAVE_ROOT_diaz}/link/*
rm -rf ${SAVE_ROOT_sp}/link/*
rm -rf ${SAVE_ROOT_sum}/link/*
echo "postprocessing complete"

