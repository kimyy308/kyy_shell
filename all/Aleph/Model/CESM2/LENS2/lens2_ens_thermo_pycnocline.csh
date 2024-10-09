#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set vars = ( NO3 PO4 SiO3 Fe PD SALT TEMP )
#set vars = ( PD TEMP NO3 )
set vars = ( TEMP NO3 )
#set vars = ( NO3 )

foreach rawvar ( ${vars} )

set var = ${rawvar}"CLINE"

set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${rawvar}/ens_smbb
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}/ens_smbb

set IY_SET = ( `seq ${siy} -1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )
  foreach mon ( ${M_SET} )
    set INITY = ${iyloop}
    mkdir -p $SAVE_ROOT
    set INPUT = ${ARC_ROOT}/${rawvar}_ensmean_${INITY}-${mon}.nc
    set OUTPUT = ${SAVE_ROOT}/${var}_ensmean_${INITY}-${mon}.nc
    
set TOD = `date`
set tmp_scr = ~/tmp_script/lens2_make_${var}.jnl
cat > $tmp_scr << EOF
 ! NOAA/PMEL TMAP
 ! FERRET v7.43 (optimized)
 ! Linux 3.10.0-862.el7.x86_64 64-bit - 11/30/18
 ! $TOD

 use "${INPUT}"
 let dtdz = ${rawvar}[z=@ddc]
 let dtdz_min = dtdz[z=@min]
 let zero_at_min = dtdz - dtdz_min
 let ${var} = zero_at_min[z=@loc:0]
 save/file="${OUTPUT}" ${var}
EOF
ferret -script $tmp_scr

  end
end

echo ${var}"_postprocessing complete"


end
