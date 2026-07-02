%%bash

SRC="/content/drive/MyDrive/MSWEP_V316_test/Past/Hourly"
DST="/content/drive/MyDrive/MSWEP_17_18Juni2016/Hourly"

mkdir -p "$DST"

find "$SRC" -maxdepth 1 \
    \( -name "2016166.*.nc" -o -name "2016178.*.nc" \) \
    -print0 | while IFS= read -r -d '' file
do
    rsync -ah --progress "$file" "$DST/"
done
