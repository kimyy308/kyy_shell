#!/bin/bash

BASE_DIR="/nird/datalake/NS11071K/users/yongyub/Observation/ORAS5"

#YEAR_START=1998
#YEAR_END=2025
YEAR_START=1998
YEAR_END=2025

VARIABLES=(
  "sea_surface_temperature"
  "depth_of_20_c_isotherm"
)

for VAR in "${VARIABLES[@]}"; do

  OUTDIR="${BASE_DIR}/${VAR}"
  mkdir -p ${OUTDIR}

  for YEAR in $(seq $YEAR_START $YEAR_END); do
    for MONTH in $(seq -w 1 12); do

      OUTFILE="${OUTDIR}/${VAR}_${YEAR}_${MONTH}.nc"
      ZIPFILE="${OUTDIR}/${VAR}_${YEAR}_${MONTH}.zip"

      # 이미 nc 파일 있으면 skip
      if [ -f "$OUTFILE" ]; then
        echo "Skipping $OUTFILE"
        continue
      fi

      echo "Downloading ${VAR} ${YEAR}-${MONTH}"

      python <<EOF
import cdsapi

c = cdsapi.Client()

c.retrieve(
    "reanalysis-oras5",
    {
        "product_type": ["consolidated", "operational"],
        "vertical_resolution": "single_level",
        "variable": "$VAR",
        "year": "$YEAR",
        "month": "$MONTH",
    },
    "$ZIPFILE"
)
EOF

      # unzip 처리
      if [ -f "$ZIPFILE" ]; then
        echo "Unzipping $ZIPFILE"

        unzip -o "$ZIPFILE" -d "$OUTDIR"

        # unzip 후 생성된 nc 파일 이름 찾기
        UNZIPPED_FILE=$(find "$OUTDIR" -maxdepth 1 -name "*.nc" -type f -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

        # 파일 이름 통일
        if [ -f "$UNZIPPED_FILE" ]; then
          mv "$UNZIPPED_FILE" "$OUTFILE"
        fi

        # zip 삭제
        rm -f "$ZIPFILE"
      fi

    done
  done
done
