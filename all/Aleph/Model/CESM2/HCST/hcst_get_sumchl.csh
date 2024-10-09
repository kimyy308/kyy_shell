#!/bin/csh

set homedir = /proj/kimyy/tmp

set siy = 1960
set eiy = 2021

set RESOLN = f09_g17
set IY_SET = ( `seq ${siy} 1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set Chl_set = ( diatChl diazChl spChl )
foreach iyloop ( ${IY_SET} )
  set INITY = ${iyloop}
  set CASENAME_M = ens_all  #parent casename
  set CASENAME = ${CASENAME_M}_i${INITY}
  set CASENAME_F = ensmean_all_i${INITY}
  foreach ci ( 1 2 3 )
    if ( ${ci} == 1 ) then
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${Chl_set[${ci}]}/${CASENAME_M}/${CASENAME}
    else
      set ARC_ROOT = ( $ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${Chl_set[${ci}]}/${CASENAME_M}/${CASENAME} )
    endif
  end
  #echo ${ARC_ROOT[${ci}]}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/sumChl/${CASENAME_M}/${CASENAME}
  mkdir -p ${SAVE_ROOT}
  @ fy_end = ${INITY} + 4
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    foreach mon ( 01 02 03 04 05 06 07 08 09 10 11 12 )
      foreach ci ( 1 2 3 )
        if ( ${ci} == 1 ) then
          set inputname = ${ARC_ROOT[${ci}]}/${Chl_set[${ci}]}_${RESOLN}.hcst.${CASENAME_F}.pop.h.${fy}-${mon}.nc  
        else
          set inputname = ( ${inputname} ${ARC_ROOT[${ci}]}/${Chl_set[${ci}]}_${RESOLN}.hcst.${CASENAME_F}.pop.h.${fy}-${mon}.nc )
        endif
      end
      set outputname = ${SAVE_ROOT}/sumChl_${RESOLN}.hcst.${CASENAME_F}.pop.h.${fy}-${mon}.nc
      cdo -O -w -z zip_5 -merge -selname,${Chl_set[1]} ${inputname[1]} -selname,${Chl_set[2]} ${inputname[2]} -selname,${Chl_set[3]} ${inputname[3]} ${homedir}/merged_hcst_chl.nc
      cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_hcst_chl.nc ${outputname}
#      cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_hcst_chl.nc ${homedir}/merged_hcst_vm_chl.nc
#      cdo -O -w -z zip_5 -vertmean ${homedir}/merged_hcst_vm_chl.nc ${outputname}

    end
  end
end
  
#    set SAVE_ROOT
