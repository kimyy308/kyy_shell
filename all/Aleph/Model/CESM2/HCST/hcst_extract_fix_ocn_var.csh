#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set var = spChl  
#dim -> 2 or 3 
set dim = 3

#reversed order
set iy = 1971
set fy = 1972
set fm = 10
# en4.2_ba projdv7.3_ba
set OBS = en4.2_ba
#set OBS = projdv7.3_ba
set FACTOR = 10
set mbr = 1

set RESOLN = f09_g17
set CASENAME_M = ${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}  #parent casename 
set CASENAME = ${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}_i${iy}
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive/${CASENAME_M}/${CASENAME}/ocn/hist/
set ARC_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/${CASENAME_M}/${CASENAME}/ocn/proc/tseries/month_1
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/${CASENAME_M}/${CASENAME} 
mkdir -p $SAVE_ROOT
set period_SET = ( `ls ${ARC_TS_ROOT}/*.${var}.* | cut -d '.' -f 16` )
  if ( ${#period_SET} == 0 ) then
      set inputname = ${ARC_ROOT}/${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}_i${iy}.pop.h.${fy}-${fm}.nc
      set outputname = ${SAVE_ROOT}/${var}_${CASENAME}.pop.h.${fy}-${fm}.nc
      if ( ${dim} == 3 ) then
        cdo -O -w -select,name=${var} ${inputname} ${homedir}/hcst_test2_${var}.nc
        cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/hcst_test2_${var}.nc $outputname
      else
        cdo -O -w -select,name=${var} ${inputname} ${outputname}
      endif
      echo ${outputname} "from raw"
  else
    foreach period ( ${period_SET} )
      set Y_1 = (`echo $period | cut -c 1-4`)
      set Y_2= (`echo $period | cut -c 8-11`)
      if ($Y_1 <= ${fy} && ${fy} <= $Y_2) then
        set period_f=${period}
        echo ${period_f}, ${iy}
        @ tind = `expr \( ${iy} - ${Y_1} \) \* 12`
        #echo ${vind}
          @ tind2 = $tind + $fm
          #echo $tind2
          set inputname = ${ARC_TS_ROOT}/${CASENAME}.pop.h.${var}.${period_f}.nc
          set outputname = ${SAVE_ROOT}/${var}_${CASENAME}.pop.h.${fy}-${fm}.nc
          #ls $input_head
          if ( ${dim} == 3 ) then
           cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/hcst_test_${var}.nc
           cdo -O -w -select,name=${var} ${homedir}/hcst_test_${var}.nc ${homedir}/hcst_test2_${var}.nc
           cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/hcst_test2_${var}.nc $outputname 
          else
           cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/hcst_test_${var}.nc
           cdo -O -w -select,name=${var} ${homedir}/hcst_test_${var}.nc $outputname
          endif
          echo ${outputname} "from ts"
      endif
    end
  endif
