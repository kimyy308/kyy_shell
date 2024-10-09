#!/bin/csh
####!/bin/csh -fx
# Updated  16-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2022
set eiy = 1980
set var = SMsurf #surface_soil_moisture
#set var = SMroot #rootzone_soil_moisture
#precip
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv GRID_ROOT /mnt/lustre/proj/kimyy/Observation/GPCC
  setenv GLEAM_ROOT /mnt/lustre/proj/kimyy/Observation/GLEAM/raw
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/GLEAM/${var}/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${GRID_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${GLEAM_ROOT}/${var}_1980-2022_GLEAM_v3.8a_MO.nc
    set output = ${SAVE_ROOT}/GLEAM_reg_cesm2.v5.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_GLEAM.nc
    ncatted -O -a units,lon,c,c,"degrees_east" -a units,lat,c,c,"degrees_north" /proj/kimyy/tmp/test_GLEAM.nc /proj/kimyy/tmp/test_GLEAM2.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_GLEAM2.nc ${output}
#    cdo -O remapcon,${gridfile} /proj/kimyy/tmp/test_GLEAM.nc ${output}
#    cdo -O remapnn,${gridfile} ${input} ${output}
  end
end
rm -f /proj/kimyy/tmp/test_GLEAM.nc /proj/kimyy/tmp/test_GLEAM2.nc

