#!/bin/csh

set homedir = /proj/kimyy/tmp

set siy = 1960
set eiy = 2020

set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set IY_SET = ( `seq ${siy} 1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set Chl_set = ( diatChl diazChl spChl )
foreach iyloop ( ${IY_SET} )
  foreach OBS ( ${OBS_SET} ) #OBS loop1
    foreach FACTOR ( $FACTOR_SET ) #FACTOR loop1
    foreach mbr ( $mbr_set ) #mbr loop1
      set INITY = ${iyloop}
#      set CASENAME_M = b.e21.${scen}.${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}
#      set CASENAME_M = ens_all  #parent casename
      set CASENAME_M = ${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}
      foreach ci ( 1 2 3 )
        if ( ${ci} == 1 ) then
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${Chl_set[${ci}]}/${CASENAME_M}
        else
          set ARC_ROOT = ( $ARC_ROOT /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${Chl_set[${ci}]}/${CASENAME_M} )
        endif
      end
      #echo ${ARC_ROOT[${ci}]}
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/sumChl/${CASENAME_M}
      set SAVE_ROOT_surface = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/sumChl/surface/${CASENAME_M}
      mkdir -p ${SAVE_ROOT}
      mkdir -p ${SAVE_ROOT_surface}
      foreach mon ( 01 02 03 04 05 06 07 08 09 10 11 12 )
        foreach ci ( 1 2 3 )
          if ( ${ci} == 1 ) then
            set inputname = ${ARC_ROOT[${ci}]}/${Chl_set[${ci}]}_${CASENAME_M}.pop.h.${INITY}-${mon}.nc  
          else
            set inputname = ( ${inputname} ${ARC_ROOT[${ci}]}/${Chl_set[${ci}]}_${CASENAME_M}.pop.h.${INITY}-${mon}.nc )
          endif
        end
        set outputname = ${SAVE_ROOT}/sumChl_${CASENAME_M}_${INITY}-${mon}.nc
        set outputname_surface = ${SAVE_ROOT_surface}/surface_sumChl_${CASENAME_M}_${INITY}-${mon}.nc
        cdo -O -w -z zip_5 -merge -selname,${Chl_set[1]} ${inputname[1]} -selname,${Chl_set[2]} ${inputname[2]} -selname,${Chl_set[3]} ${inputname[3]} ${homedir}/merged_assm_chl.nc
        cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_assm_chl.nc ${outputname}
        cdo -O -w -z zip_5 -sellevel,10/1000 ${outputname} ${outputname_surface} 
#      cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_assm_chl.nc ${homedir}/merged_assm_vm_chl.nc
#      cdo -O -w -z zip_5 -vertmean ${homedir}/merged_assm_vm_chl.nc ${outputname}
       end # month loop
    end #mbr loop
    end  #FACTOR loop
  end # OBS loop
end # year loop
 
rm -f ${homedir}/merged_assm_chl.nc 
rm -f ${homedir}/merged_assm_vm_chl.nc 
