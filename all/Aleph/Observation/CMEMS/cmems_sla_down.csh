#!/bin/csh

#set year=2020
#set siy = 1993
set siy = 1999
#set siy = 2008
#set eiy = 2008
set eiy = 2024
set months = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set years = ( `seq ${siy} +1 ${eiy}` ) 

foreach year ( ${years} )
  set outdir = /mnt/lustre/proj/kimyy/Observation/CMEMS/sla/raw/${year}
  mkdir -p $outdir
  foreach mon ( $months )
      if ( -f ${outdir}/${year}-${mon}.nc ) then
        echo ${year}-${mon}".nc exist"
      else
#      motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id OCEANCOLOUR_GLO_BGC_L4_MY_009_104-TDS --product-id cmems_obs-oc_glo_bgc-plankton_my_l4-multi-4km_P1M --date-min "${year}-${mon}-01T00:00:00" --date-max "${year}-${mon}-28T23:59:59" --variable CHL --out-dir ${outdir} --out-name ${year}-${mon}.nc --user ykim7 --pwd Qp1al2zm3!
      endif
      copernicusmarine subset --dataset-id c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1M-m --variable sla --start-datetime ${year}-${mon}-01T00:00:00 --end-datetime ${year}-${mon}-01T00:00:00 --minimum-longitude -179.875 --maximum-longitude 179.875 --minimum-latitude -89.875 --maximum-latitude 89.875 --output-filename sla_${year}-${mon}.nc --output-directory ${outdir} --username ykim7 --password Qp1al2zm3!
  end
end




#  python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id OCEANCOLOUR_GLO_BGC_L4_MY_009_104-TDS --product-id cmems_obs-oc_glo_bgc-pp_my_l4-multi-4km_P1M --longitude-min -360 --longitude-max 360 --latitude-min -90 --latitude-max 90 --date-min "1998-01-01 00:00:00" --date-max "1998-12-01 23:59:59" --variable PP --variable PP_uncertainty --variable flags --out-dir <OUTPUT_DIRECTORY> --out-name <OUTPUT_FILENAME> --user <USERNAME> --pwd <PASSWORD>

#python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id OCEANCOLOUR_GLO_BGC_L4_MY_009_104-TDS --product-id cmems_obs-oc_glo_bgc-plankton_my_l4-gapfree-multi-4km_P1D --date-min "2023-10-10 00:00:00" --date-max "2023-10-10 23:59:59" --variable CHL --variable CHL_uncertainty --variable flags --out-dir <OUTPUT_DIRECTORY> --out-name <OUTPUT_FILENAME> --user <USERNAME> --pwd <PASSWORD>

