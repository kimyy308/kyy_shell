#!/bin/csh

set siy = 1998
set eiy = 2002
set months = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set days = ( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 )
set years = ( `seq ${siy} +1 ${eiy}` )

#Chl
foreach year ( ${years} )
  set outdir = /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/CHL/daily/${year}
  mkdir -p $outdir
  foreach mon ( $months )
    foreach day ( $days )
      
      # Skip impossible dates (basic check, not accounting leap year)
      if ( ( "$mon" == "02" && "$day" > 29 ) || ( "$mon" =~ "04" || "$mon" =~ "06" || "$mon" =~ "09" || "$mon" =~ "11" ) && "$day" > 30 ) continue

      set outfile = ${outdir}/GLob_Chl_${year}-${mon}-${day}.nc

      if ( -f $outfile ) then
        echo "${year}-${mon}-${day}.nc exists"
      else
        copernicusmarine subset --dataset-id cmems_obs-oc_glo_bgc-plankton_my_l4-gapfree-multi-4km_P1D --variable CHL --variable CHL_uncertainty --start-datetime ${year}-${mon}-${day}T00:00:00 --end-datetime ${year}-${mon}-${day}T00:00:00 --minimum-longitude -179.99722290039062 --maximum-longitude 179.9972381591797 --minimum-latitude -89.99722290039062 --maximum-latitude 89.99722290039062 --output-filename GLob_Chl_${year}-${mon}-${day}.nc --output-directory ${outdir} --username ykim7 --password Qp1al2zm3!
      endif

    end
  end
end
