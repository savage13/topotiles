#!/bin/bash


DEM=topo_max_0_30_0_30.tiff
DEM=topo_max.vrt
COLORSCALE=colorscale.txt
OUTPUT=topodem.tiff
OUTPUT2=topodem2.tiff
HILLSHADE=topohill.tiff

# Color DEM
echo "Calculate Color DEM"
gdaldem color-relief $DEM $COLORSCALE $OUTPUT

# Hillshade
echo "Calculate Hillshade"
gdaldem hillshade -z 14 -s 111120 -multidirectional $DEM $HILLSHADE

rm -f gamma_hillshade.tif
rm -f colored_hillshade.tif

# Gamma Hillshade
# https://gis.stackexchange.com/a/255574

echo "Gamma correct Hillshade"
gdal_calc.py --quiet  -A $HILLSHADE --outfile=gamma_hillshade.tif \
  --calc="uint8(((A / 255.)**(1/0.5)) * 255)"

echo "Combine gamma corrected Hillshade and Color DEM"
# overlay
 gdal_calc.py --quiet  -A gamma_hillshade.tif -B $OUTPUT --allBands=B \
--calc="uint8( ( \
                 2 * (A/255.)*(B/255.)*(A<128) + \
                 ( 1 - 2 * (1-(A/255.))*(1-(B/255.)) ) * (A>=128) \
               ) * 255 )" --outfile=colored_hillshade.tif

echo "Create Map Tiles"
rm -rf tiles
mkdir tiles

gdal2tiles.py -e --zoom=1-7 \
              --s_srs EPSG:4326 \
              --processes=4 \
              colored_hillshade.tif tiles
