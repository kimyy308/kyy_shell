#!/bin/csh
####!/bin/csh -fx
# Updated  03-May-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp


#set var = TEMP
set comp = ocn

set REGION = NWP
set xw = 133
set xe = 205
set ys = 221
set yn = 325

#set vars = ( TEMP SSH SALT DIC DIC_ALT_CO2 FG_CO2 )
#set vars = ( TEMP SSH SALT DIC DIC_ALT_CO2 FG_CO2 UVEL VVEL WVEL )
#set vars = ( UVEL VVEL WVEL )
set vars = ( TAUX TAUY )

foreach var ( ${vars} )
mkdir ~/tmp_script
mkdir ~/tmp_log

set tmp_scr =  ~/tmp_script/fldcut_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/fldcut_${var}_assm_tmp.log

cat > $tmp_scr << EOF

set OBS_SET = (en4.2_ba projdv7.3_ba)
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

mkdir -p \${SAVE_ROOT}

set IY_SET = ( 2014 2019 2020 )

foreach iyloop ( \${IY_SET} )
    if (\${iyloop} <= 2014) then
      set scen = BHISTsmbb
    else if (\${iyloop} >= 2015) then
      set scen = BSSP370smbb
    endif
foreach OBS ( \${OBS_SET} )  # OBS loop
foreach FACTOR ( \${FACTOR_SET} ) #FACTOR loop
foreach mbr ( \${mbr_set} ) #mbr loop
    set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #mother CASENAME
    set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/\${CASENAME_M}/ocn/proc/tseries/month_1
    set SAVE_ROOT = /mnt/lustre/proj/kimyy/tr_sysong/fld/ASSM_EXP/archive/\${CASENAME_M}/ocn
    mkdir -p \${SAVE_ROOT}
    if ( \$iyloop == 2020 && \${OBS} == "projdv7.3_ba" ) then  #fixed decision
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_fixed/archive/\${CASENAME_M}/ocn/hist
      foreach mloop ( \${M_SET} ) # month loop
        set inputname = \${ARC_ROOT}/\${CASENAME_M}.pop.h.\${iyloop}-\${mloop}.nc
        set outputname = \${SAVE_ROOT}/${REGION}_${var}_\${CASENAME_M}.pop.h.\${iyloop}-\${mloop}.nc
        cdo -O -w -select,name=${var} \${inputname} /proj/kimyy/tmp/test_fld_${var}.nc
        cdo -z zip_5 -O -w -selindexbox,${xw},${xe},${ys},${yn} /proj/kimyy/tmp/test_fld_${var}.nc \${outputname}
        echo "from fixed run, " \${outputname} 
      end        
    else
      set period_SET = ( \`ls \${ARC_ROOT}/*.${var}.* | cut -d '.' -f 19\` )
        foreach period ( \${period_SET} )
          set Y_1 = (\`echo \$period | cut -c 1-4\`)
           if ( \${Y_1} <= \${iyloop} ) then # period decision
              set inputname = \${ARC_ROOT}/\${CASENAME_M}.pop.h.${var}.\${period}.nc
              set outputname = \${SAVE_ROOT}/${REGION}_\${CASENAME_M}.pop.h.${var}.\${period}.nc
               cdo -O -w -selindexbox,${xw},${xe},${ys},${yn} \${inputname} \${outputname}
              echo \${outputname}
           endif # period decision
        end            
    endif #fixed decision

    echo ${var}"_postprocessing complete"

end #mbr loop
end #FACTOR loop
end #OBS loop

end

rm -f /proj/kimyy/tmp/test_fld_${var}.nc

EOF

csh $tmp_scr > $tmp_log &

end


