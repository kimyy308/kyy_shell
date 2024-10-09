#!/bin/csh

set year=2020
set months = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set outdir = /Volumes/kyy_raid/Data/Observation/CMEMS/${year}
foreach mon ( $months )
  python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id SEALEVEL_GLO_PHY_L4_MY_008_047-TDS --product-id cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs-0.25deg_P1D --date-min "${year}-${mon}-01 00:00:00" --date-max "${year}-${mon}-31 23:59:59" --variable err_ugosa --variable err_vgosa --variable ugosa --variable vgosa --out-dir ${outdir} --out-name ${year}-${mon}.nc --user ykim7 --pwd Qp1al2zm3!
end


