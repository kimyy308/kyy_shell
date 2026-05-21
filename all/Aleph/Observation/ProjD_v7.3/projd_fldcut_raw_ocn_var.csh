#!/bin/csh
####!/bin/csh -fx
# Updated  09-Feb-2026 by Yong-Yub Kim, e-mail: yongyub.kim@uib.no

set REGION = NWP
set xw = 133
set xe = 205
set ys = 221
set yn = 325

# =====================================================
# Time settings
# =====================================================
set IY_SET = (`seq 1955 2022`)
set M_SET  = ( 01 02 03 04 05 06 07 08 09 10 11 12 )

# =====================================================
# Paths
# =====================================================
set ARC_ROOT  = /mnt/lustre/proj/earth.system.predictability/OBS_DATA/POP2_g17_raw/ProjD_v7.3
set SAVE_ROOT = /proj/kimyy/tr_sysong/OBS/ProjD_v7.3/NWP
mkdir -p ${SAVE_ROOT}

# =====================================================
# Loop
# =====================================================
foreach iyloop ( ${IY_SET} )
    foreach mloop ( ${M_SET} )

        set inputname  = ${ARC_ROOT}/toso-proj7.${iyloop}-${mloop}.nc
        set outputname = ${SAVE_ROOT}/${REGION}_toso-proj7.${iyloop}-${mloop}.nc

        cdo -O -w -selindexbox,${xw},${xe},${ys},${yn} ${inputname} ${outputname}

        echo ${outputname}
        echo "toso_postprocessing complete "${iyloop}"-"${mloop} 

    end
end
