#!/bin/bash

lats=(-85 -60 -30 0 30 60 85)

lon=-180
lonmax=180
lat=-85
lat1=-60

j=0
n=${#lats[@]}
n=$((n-1))
while [ $j -lt $n ]; do
    lat=${lats[$j]}
    lat1=${lats[$j+1]}
    while [ $lon -lt $lonmax ]; do
        lon1=$((lon + 30))
        FILE="topo_max_${lon}_${lon1}_${lat}_${lat1}.tiff"
        if [ ! -e $FILE ]; then
            echo "get $FILE"
            curl "https://www.gmrt.org/services/GridServer?minlongitude=${lon}&maxlongitude=${lon1}&minlatitude=${lat}&maxlatitude=${lat1}&format=geotiff&resolution=max&layer=topo" > $FILE
        fi
        echo $lon $lon1 $lat $lat1
        lon=$lon1
    done
    j=$((j+1))
done

SRS="EPSG:4326"
for z in topo_max_*.tiff; do
    echo "set srs to $SRS => $z"
    gdal_edit.py -a_srs $SRS $z
    gdal_edit.py -a_nodata nan $z
done
rm -f topo_max.vrt
gdalbuildvrt topo_max.vrt topo_max*.tiff f -r bilinear -a_srs WGS84
gdalinfo topo_max.vrt
