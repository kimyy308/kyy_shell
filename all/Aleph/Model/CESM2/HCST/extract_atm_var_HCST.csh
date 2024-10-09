#!/bin/csh
####!/bin/csh -fx
# Updated  27-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#set siy = 2020
#set eiy = 1989
set siy = 2021
set eiy = 2021
set var = SST

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  foreach obsloop ( `seq 1 ${#OBS_SET}` ) #OBS loop1
    set OBS = ${OBS_SET[$obsloop]}
    foreach FACTOR ( $FACTOR_SET ) #FACTOR loop1
      foreach mbr ( $mbr_set ) #mbr loop1
        setenv CASENAME_M ${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}  #parent casename
        setenv CASENAME ${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}_i${INITY}
        setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive/${CASENAME_M}/${CASENAME}
        setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/atm/${var}/${CASENAME_M}/${CASENAME}
        
        mkdir -p $SAVE_ROOT
        
        #set inputname = ${ARC_ROOT}/atm/hist/f09_g17.hcst.${OBS}-${FACTOR}p${mbr}_i${INITY}.cam.h0.1989-01.nc
        set input_head = ${ARC_ROOT}/atm/hist/${RESOLN}.hcst.${OBS}-${FACTOR}p${mbr}_i${INITY}.cam.h0.
        set input_set=(`ls ${input_head}*`)
        foreach inputname ( ${input_set} )
          set outputnc=(`echo ${inputname} | cut -d '/' -f 12`)
          set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
          set outputname=${SAVE_ROOT}/${outputnc_new}
#          echo ${outputnc}
#          echo $inputname
#          echo $outputname
          cdo -O select,name=${var} $inputname $outputname
        end
      end
    end
  end
end


