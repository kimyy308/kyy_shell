#!/bin/csh

set homedir = /proj/kimyy/tmp

set siy = 1960
set eiy = 2025

set ly_s = 2
set ly_e = 4

#231102
#set var_set = ( VVEL NO3 )
#set var_set = ( WVEL NO3 )
set var_set = ( UVEL NO3 )


set yflag = 0 # if you want just multi-year mean, 0 skip the yearly calculation

set IY_SET = ( `seq ${siy} 1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set len_s = ( `seq 1 +1 "${#var_set}"` )

@ eiy_ml = ${eiy} - ${ly_e} + 1
set IY_SET_ml = ( `seq ${siy} 1 ${eiy_ml}` )

foreach ci ( ${len_s} )
  if ( ${ci} == 1 ) then
    set outvar = mul_${var_set[${ci}]}
  else
    set outvar = ${outvar}_${var_set[${ci}]}
  endif
end
foreach ci ( ${len_s} )
  if ( ${ci} == 1 ) then
    set expvar = "-expr,"${outvar}=${var_set[${ci}]}
  else
    set expvar = ${expvar}"*"${var_set[${ci}]}
  endif
end
set expvar = "${expvar}"
echo "${expvar}"

#HCST
set CASENAME_M = ens_all  #parent casename
set RESOLN = f09_g17

if ( ${yflag} == 1 ) then

foreach iyloop ( ${IY_SET} )
  set INITY = ${iyloop}
  @ fy_end = ${iyloop} + 4
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    foreach mon ( 01 02 03 04 05 06 07 08 09 10 11 12 )
      foreach ci ( ${len_s} )
        if ( ${ci} == 1 ) then
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M}/${CASENAME_M}_i${iyloop}
          set inputname = ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_${RESOLN}.hcst.ensmean_all_i${INITY}.pop.h.${fy}-${mon}.nc  
          set selvar = "-selname,"${var_set[${ci}]}" "${inputname}
        else
          set ARC_ROOT = ( $ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M}/${CASENAME_M}_i${iyloop} )
          set inputname = ( ${inputname} ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_${RESOLN}.hcst.ensmean_all_i${INITY}.pop.h.${fy}-${mon}.nc )
          set selvar = "${selvar}"" ""-selname,"${var_set[${ci}]}" "${inputname[${ci}]}
        endif
      end

      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${outvar}/${CASENAME_M}/${CASENAME_M}_i${iyloop}
      mkdir -p ${SAVE_ROOT}

      set outputname = ${SAVE_ROOT}/${outvar}_${RESOLN}.hcst.ensmean_all_i${INITY}.pop.h.${fy}-${mon}.nc
      cdo -O -w -z zip_5 -merge ${selvar} ${homedir}/merged_lens2_${outvar}.nc
      cdo -O -w -z zip_5 "${expvar}" ${homedir}/merged_lens2_${outvar}.nc ${outputname}
      echo ${outputname}
    end

    set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}/${CASENAME_M}_i${iyloop}
    mkdir -p ${SAVE_Y_ROOT}
    set outputname_y = ${SAVE_Y_ROOT}/${outvar}_${RESOLN}.hcst.ensmean_all_i${INITY}.pop.h.${fy}.nc
    cdo -O -w -z zip_5 ensmean ${SAVE_ROOT}/${outvar}_${RESOLN}.hcst.ensmean_all_i${INITY}.pop.h.${fy}-*.nc ${outputname_y}
    echo ${outputname_y}
  end
end
  
rm -f ${homedir}/merged_lens2_${outvar}.nc

endif #yflag


#HCST - multi-ly
foreach iyloop ( ${IY_SET_ml} )
  set INITY = ${iyloop}  
  set CASENAME = ${RESOLN}.hcst.ensmean_all_i${INITY}
  set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}/${CASENAME_M}_i${iyloop}
  set outputname_ly = ${SAVE_Y_ROOT}/${outvar}_${CASENAME}.pop.h.ly_${ly_s}_${ly_e}.nc
  @ fy_start = ${INITY} + ${ly_s} - 1
  @ fy_end = ${INITY} + ${ly_e} - 1
  set FY_SET = ( `seq ${fy_start} ${fy_end}` )
  set len_s_ml = ( `seq 1 +1 "${#FY_SET}"` )
  foreach ci ( ${len_s_ml} )
    if ( ${ci} == 1 ) then
      set inputname = ${SAVE_Y_ROOT}/${outvar}_${CASENAME}.pop.h.${FY_SET[${ci}]}.nc
    else
      set inputname = ( ${inputname} ${SAVE_Y_ROOT}/${outvar}_${CASENAME}.pop.h.${FY_SET[${ci}]}.nc  )
    endif
  end
  cdo -O -w -z zip_5 ensmean ${inputname} ${outputname_ly}
  echo ${outputname_ly} 
end


#ASSM
set CASENAME_M = ens_all  #parent casename

if ( ${yflag} == 1 ) then

foreach iyloop ( ${IY_SET} )
  set INITY = ${iyloop}
  set CASENAME = ${CASENAME_M}_i${INITY}

    foreach mon ( 01 02 03 04 05 06 07 08 09 10 11 12 )
      foreach ci ( ${len_s} )
        if ( ${ci} == 1 ) then
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M}
          set inputname = ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_ensmean_${INITY}-${mon}.nc  
          set selvar = "-selname,"${var_set[${ci}]}" "${inputname}
        else
          set ARC_ROOT = ( $ARC_ROOT /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M} )
          set inputname = ( ${inputname} ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_ensmean_${INITY}-${mon}.nc )
          set selvar = "${selvar}"" ""-selname,"${var_set[${ci}]}" "${inputname[${ci}]}
        endif
      end

      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${outvar}/${CASENAME_M}
      mkdir -p ${SAVE_ROOT}

      set outputname = ${SAVE_ROOT}/${outvar}_ensmean_${INITY}-${mon}.nc
      cdo -O -w -z zip_5 -merge ${selvar} ${homedir}/merged_lens2_${outvar}.nc
      cdo -O -w -z zip_5 "${expvar}" ${homedir}/merged_lens2_${outvar}.nc ${outputname}
      echo ${outputname}
    end

    set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}
    mkdir -p ${SAVE_Y_ROOT}
    set outputname_y = ${SAVE_Y_ROOT}/${outvar}_ensmean_${INITY}.nc
    cdo -O -w -z zip_5 ensmean ${SAVE_ROOT}/${outvar}_ensmean_${INITY}-*.nc ${outputname_y}
    echo ${outputname_y}
end
  
rm -f ${homedir}/merged_lens2_${outvar}.nc

endif #yflag

#ASSM - multi-ly
foreach iyloop ( ${IY_SET_ml} )
  set INITY = ${iyloop}  
  set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}
  set outputname_ly = ${SAVE_Y_ROOT}/${outvar}_ensmean_${INITY}_ly_${ly_s}_${ly_e}.nc
  @ fy_start = ${INITY} + ${ly_s} - 1
  @ fy_end = ${INITY} + ${ly_e} - 1
  set FY_SET = ( `seq ${fy_start} ${fy_end}` )
  set len_s_ml = ( `seq 1 +1 "${#FY_SET}"` )
  foreach ci ( ${len_s_ml} )
    if ( ${ci} == 1 ) then
      set inputname = ${SAVE_Y_ROOT}/${outvar}_ensmean_${FY_SET[${ci}]}.nc
    else
      set inputname = ( ${inputname} ${SAVE_Y_ROOT}/${outvar}_ensmean_${FY_SET[${ci}]}.nc  )
    endif
  end
  cdo -O -w -z zip_5 ensmean ${inputname} ${outputname_ly}
  echo ${outputname_ly} 
end




#LENS2
set CASENAME_M = ens_smbb  #parent casename

if ( ${yflag} == 1 ) then

foreach iyloop ( ${IY_SET} )
  set INITY = ${iyloop}
  set CASENAME = ${CASENAME_M}_i${INITY}

    foreach mon ( 01 02 03 04 05 06 07 08 09 10 11 12 )
      foreach ci ( ${len_s} )
        if ( ${ci} == 1 ) then
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M}
          set inputname = ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_ensmean_${INITY}-${mon}.nc  
          set selvar = "-selname,"${var_set[${ci}]}" "${inputname}
        else
          set ARC_ROOT = ( $ARC_ROOT /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var_set[${ci}]}/${CASENAME_M} )
          set inputname = ( ${inputname} ${ARC_ROOT[${ci}]}/${var_set[${ci}]}_ensmean_${INITY}-${mon}.nc )
          set selvar = "${selvar}"" ""-selname,"${var_set[${ci}]}" "${inputname[${ci}]}
        endif
      end

      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${outvar}/${CASENAME_M}
      mkdir -p ${SAVE_ROOT}

      set outputname = ${SAVE_ROOT}/${outvar}_ensmean_${INITY}-${mon}.nc
#      cdo -O -w -z zip_5 -merge -selname,${var_set[1]} ${inputname[1]} -selname,${var_set[2]} ${inputname[2]} -selname,${var_set[3]} ${inputname[3]} ${homedir}/merged_lens2_chl.nc
#      cdo -O -w -z zip_5 -expr,'sumChl=diatChl+diazChl+spChl;' ${homedir}/merged_lens2_chl.nc ${outputname}
      cdo -O -w -z zip_5 -merge ${selvar} ${homedir}/merged_lens2_${outvar}.nc
      cdo -O -w -z zip_5 "${expvar}" ${homedir}/merged_lens2_${outvar}.nc ${outputname}
      echo ${outputname}
    end

    set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}
    mkdir -p ${SAVE_Y_ROOT}
    set outputname_y = ${SAVE_Y_ROOT}/${outvar}_y_ensmean_${INITY}.nc
    cdo -O -w -z zip_5 ensmean ${SAVE_ROOT}/${outvar}_ensmean_${INITY}-*.nc ${outputname_y}
    echo ${outputname_y}
end
  
rm -f ${homedir}/merged_lens2_${outvar}.nc
endif #yflag

#LENS2 - multi-ly
foreach iyloop ( ${IY_SET_ml} )
  set INITY = ${iyloop}  
  set SAVE_Y_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_yearly_transfer/ocn/${outvar}/${CASENAME_M}
  set outputname_ly = ${SAVE_Y_ROOT}/${outvar}_y_ensmean_${INITY}_ly_${ly_s}_${ly_e}.nc
  @ fy_start = ${INITY} + ${ly_s} - 1
  @ fy_end = ${INITY} + ${ly_e} - 1
  set FY_SET = ( `seq ${fy_start} ${fy_end}` )
  set len_s_ml = ( `seq 1 +1 "${#FY_SET}"` )
  foreach ci ( ${len_s_ml} )
    if ( ${ci} == 1 ) then
      set inputname = ${SAVE_Y_ROOT}/${outvar}_y_ensmean_${FY_SET[${ci}]}.nc
    else
      set inputname = ( ${inputname} ${SAVE_Y_ROOT}/${outvar}_y_ensmean_${FY_SET[${ci}]}.nc  )
    endif
  end
  cdo -O -w -z zip_5 ensmean ${inputname} ${outputname_ly}
  echo ${outputname_ly} 
end


