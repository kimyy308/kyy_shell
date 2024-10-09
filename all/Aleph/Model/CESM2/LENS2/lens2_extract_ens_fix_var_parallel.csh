#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

set var = $1

#!/bin/csh
set RESOLN = f09_g17
set yloop = $2
set mloop = $3
set comp = $4

if ( ${comp} == ocn ) then
  set modn = 'pop.h'
else if ( ${comp} == atm ) then
  set modn = 'cam.h0'
endif


  if (${yloop} <= 2014) then
    set scen = BHIST
  else if (${yloop} >= 2015) then
    set scen = BSSP370
  endif
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries
  cd ${ARC_ROOT}
  #set ENS_ALL = ( `ls -d *HIST*/  | grep -v ext | rev | cut -c 2-9 | rev` )
  #set ENS_ALL = ( `ls -d *HISTsmbb*/  | grep -v ext | rev | cut -c 2-9 | rev` )
  #set ENS_ALL = ( 1231.012 )
  #foreach ENS ( ${ENS_ALL} )
    cd ${ARC_ROOT}
    set ENS = ens_smbb
    #set CASENAME_M = LE2-${ENS}     
    #set CASENAME = ( `ls  | grep ${ENS} | grep ${scen} | grep -v ext | grep -v .nc | grep -v allfiles ` )
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/${comp}/${var}/${ENS}
    mkdir -p $SAVE_ROOT
    set FILE_ROOT = ${ARC_ROOT}/${comp}/${var}/${ENS}
    echo ${FILE_ROOT}
    set period_SET = ( `ls ${FILE_ROOT}/${var}*ensmean*  | cut -d '.' -f 3 | rev | cut -c 1-13 | rev` )
    foreach period ( ${period_SET} )
      set Y_1 = (`echo $period | cut -c 1-4`)
      set Y_2= (`echo $period | cut -c 8-11`)
      if ($Y_1 <= ${yloop} && ${yloop} <= $Y_2) then
        set period_f=${period}
        echo ${period_f}, ${yloop}
        @ tind = `expr \( ${yloop} - ${Y_1} \) \* 12`
        #echo ${vind}
          @ tind2 = $tind + $mloop
          ### ensmean
          #echo $tind2i
          set inputname = ${FILE_ROOT}/${var}_ensmean_${period_f}.nc
          set outputname = ${SAVE_ROOT}/${var}_ensmean_${yloop}-${mloop}.nc
          #ls $input_head
           cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/lens2_test_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc $outputname
          #echo ${inputname}
          #echo ${outputname}
          
          ### ensmax
          set inputname = ${FILE_ROOT}/${var}_ensmax_${period_f}.nc
          set outputname = ${SAVE_ROOT}/${var}_ensmax_${yloop}-${mloop}.nc
          cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc $outputname
          ### ensmin
          set inputname = ${FILE_ROOT}/${var}_ensmin_${period_f}.nc
          set outputname = ${SAVE_ROOT}/${var}_ensmin_${yloop}-${mloop}.nc
          cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc $outputname
          ### ensstd
          set inputname = ${FILE_ROOT}/${var}_ensstd_${period_f}.nc
          set outputname = ${SAVE_ROOT}/${var}_ensstd_${yloop}-${mloop}.nc
          cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc $outputname
      endif
    end
  #end 

