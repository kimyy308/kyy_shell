#!/bin/csh
####!/bin/csh -fx
# Updated  03-May-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp


set var = SST
set comp = atm


#set REGION = GLO
#set xw = -180
#set xe = 180
#set ys = -90
#set yn = 90
#set REGION = GLO2
#set xw = -180
#set xe = 180
#set ys = -60
#set yn = 60
#set REGION = NINO34
#set xw = -170
#set xe = -120
#set ys = -5
#set yn = 5
set REGION = AMO
set xw = -80
set xe = 0
set ys = 0
set yn = 60

set OBS_SET = ("en4.2_ba" "projdv7.3_ba")
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
#set OBS_SET = ("projdv7.3_ba")
#set FACTOR_SET = (20)
#set mbr_set = (5)
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set RESOLN = f09_g17
set scens = (BHISTsmbb BSSP370smbb)

set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/${comp}/${var}/ens_all
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/${comp}/${var}/ens_all/${REGION}

mkdir -p ${SAVE_ROOT}

#set siy = 2020
#set eiy = 2019
#set IY_SET = ( `seq ${siy} -1 ${eiy}` )
set IY_SET = ( 2014 2019 2020 )

foreach iyloop ( ${IY_SET} )
    if (${iyloop} <= 2014) then
      set scen = BHISTsmbb
    else if (${iyloop} >= 2015) then
      set scen = BSSP370smbb
    endif
    foreach OBS ( ${OBS_SET} )  # OBS loop
    foreach FACTOR ( ${FACTOR_SET} ) #FACTOR loop
    foreach mbr ( ${mbr_set} ) #mbr loop
    set CASENAME_M = b.e21.${scen}.${RESOLN}.assm.${OBS}-${FACTOR}p${mbr}  #mother CASENAME
    set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/${CASENAME_M}/atm/proc/tseries/month_1
    set SAVE_ROOT = /mnt/lustre/proj/kimyy/tr_sysong/fldmean/ASSM_EXP/archive/${CASENAME_M}/atm
    mkdir -p ${SAVE_ROOT}
    if ( $iyloop == 2020 && ${OBS} == "projdv7.3_ba" ) then  #fixed decision
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_fixed/archive/${CASENAME_M}/atm/hist
      foreach mloop ( ${M_SET} ) # month loop
        set inputname = ${ARC_ROOT}/${CASENAME_M}.cam.h0.${iyloop}-${mloop}.nc
        set outputname = ${SAVE_ROOT}/m_${REGION}_${var}_${CASENAME_M}.cam.h0.${iyloop}-${mloop}.nc
        cdo -O -w -select,name=${var} ${inputname} /proj/kimyy/tmp/test.nc
        cdo -z zip_5 -O -w -fldmean -sellonlatbox,${xw},${xe},${ys},${yn} /proj/kimyy/tmp/test.nc ${outputname}
        echo "from fixed run, " ${outputname} 
      end        
    else
      set period_SET = ( `ls ${ARC_ROOT}/*.${var}.* | cut -d '.' -f 19` )
        foreach period ( ${period_SET} )
#          echo ${period_SET}
          set Y_1 = (`echo $period | cut -c 1-4`)
#          set Y_2= (\`echo \$period | cut -c 8-11\`)
#          if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
#            set period_f=\${period}
#            echo \${period_f}, \${yloop}
 #           @ tind = \`expr \( \${yloop} - \${Y_1} \) \* 12\`
#            foreach mloop ( \${M_SET} )
#              @ tind2 = \$tind + \$mloop
           if ( ${Y_1} <= ${iyloop} ) then # period decision
              set inputname = ${ARC_ROOT}/${CASENAME_M}.cam.h0.${var}.${period}.nc
              set outputname = ${SAVE_ROOT}/m_${REGION}_${CASENAME_M}.cam.h0.${var}.${period}.nc
#               cdo -O -w -seltimestep,$tind2 $inputname ${homedir}/test_${var}.nc
               cdo -O -w -sellonlatbox,${xw},${xe},${ys},${yn} ${inputname} /proj/kimyy/tmp/test.nc
               cdo -O -w -fldmean /proj/kimyy/tmp/test.nc ${outputname}
              echo ${outputname}
           endif # period decision
#            end
#          endif
        end            
    endif #fixed decision
    rm -f /proj/kimyy/tmp/test.nc

#    mkdir -p $SAVE_ROOT

#    set inputname = ${ARC_ROOT}/${var}_ensmean_${INITY}-${mon}.nc
#    set outputname1=${SAVE_ROOT}/${REGION}_${var}_ensmean_${iyloop}-${mon}.nc
#    set outputname2=${SAVE_ROOT}/M_${REGION}_${var}_ensmean_${iyloop}-${mon}.nc
#    if ( ${var} == TS & ${INITY} < 2022 ) then
#      setenv HadCRUT5_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam
#      set HadCRUT5name=${HadCRUT5_ROOT}/HadCRUT5_reg_cesm2.${INITY}${mon}.nc
#      cdo -O -expr,'tas_mean=tas_mean/tas_mean' ${HadCRUT5name} ${homedir}/TS_mask.nc
#      cdo -O -L -merge -selname,tas_mean ${homedir}/TS_mask.nc -selname,TS ${inputname} ${homedir}/TS_merge.nc
#      cdo -O -expr,'TS=tas_mean*TS' ${homedir}/TS_merge.nc ${homedir}/TS_masked.nc
#      cdo -O -sellonlatbox,${xw},${xe},${ys},${yn} ${homedir}/TS_merge.nc ~/test.nc
#      cdo -O setmissval,0 ~/test.nc ${outputname1}
#      cdo -O fldmean ${outputname1} ${outputname2}
#    else
#      cdo -O -sellonlatbox,${xw},${xe},${ys},${yn} ${inputname} ~/test.nc
#      cdo -O setmissval,0 ~/test.nc ${outputname1}
#      cdo -O fldmean ${outputname1} ${outputname2}
#    endif

    echo ${var}"_postprocessing complete"

end #mbr loop
end #FACTOR loop
end #OBS loop

end

