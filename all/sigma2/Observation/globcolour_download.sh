#!/bin/bash

START_YEAR=1998
END_YEAR=2025

for year in $(seq $START_YEAR $END_YEAR); do
  for month in $(seq -w 1 12); do

    START_DATE="${year}-${month}-01T00:00:00"

    # 다음 달 계산
    if [ "$month" -eq 12 ]; then
      next_year=$((year + 1))
      next_month="01"
    else
      next_year=$year
      next_month=$(printf "%02d" $((10#$month + 1)))
    fi

    END_DATE="${next_year}-${next_month}-01T00:00:00"

    echo "Downloading ${year}-${month}"

    copernicusmarine subset \
      --dataset-id cmems_obs-oc_glo_bgc-pp_my_l4-multi-4km_P1M \
      --variable PP \
      --start-datetime ${START_DATE} \
      --end-datetime ${END_DATE} \
      --minimum-longitude -179.9791717529297 \
      --maximum-longitude 179.9791717529297 \
      --minimum-latitude -89.97917175292969 \
      --maximum-latitude 89.97916412353516 \
      --output-filename "/nird/datalake/NS11071K/users/yongyub/Observation/GlobColour/PP_${year}_${month}.nc"

  done
done
