#!/bin/csh

#set year=2020
set siy = 1993
#set siy = 2008
#set eiy = 2008
set eiy = 2022
set months = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set years = ( `seq ${siy} +1 ${eiy}` ) 

#Chl
foreach year ( ${years} )
  set outdir = /mnt/lustre/proj/kimyy/Observation/CMEMS/GLOBCURRENT/${year}
  mkdir -p $outdir
  foreach mon ( $months )
      if ( -f ${outdir}/${year}-${mon}.nc ) then
        echo ${year}-${mon}".nc exist"
      else
      endif
      copernicusmarine subset --dataset-id cmems_obs-mob_glo_phy-cur_my_0.25deg_P1M-m --variable ugos --variable vgos --variable uo --variable vo --variable err_ugos --variable err_vgos --variable err_uo --variable err_vo --start-datetime ${year}-${mon}-01T00:00:00 --end-datetime ${year}-${mon}-01T00:00:00 --minimum-longitude -179.875 --maximum-longitude 179.875 --minimum-latitude -89.875 --maximum-latitude 89.875 --output-filename GLob_Vel_${year}-${mon}.nc --output-directory ${outdir} --username ykim7 --password Qp1al2zm3!
  end
end





