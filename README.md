# topotiles
Convert Topopgraphy Raster to Tiles with Hillshade

![Example color-relief hillshaded output](topo.png?raw=true "Example color-relief hillshaded output")

## Steps
1. `./get_gmrt.sh` - Downloads topography data from https://www.gmrt.org in tiles of approximately 30 degres
    -  These files are about 200 MB a piece 
2. `./fix_180.sh` - Shift tiles into -180/180 longitude *if necessary* 
3. `./make_tiles.sh` - Create hillshaded topography and create tiles for a leaflet tilelayer / slippy map
4. `./png2webp.sh` - Convert and shrink all png files to webp using [cwebp](https://developers.google.com/speed/webp/download)

## Notes
- Any raster topography can be used for this process
- Processing is done using https://gdal.org/
- Rasters with longitude values outside of -180/180 appear to be lost in the procedure in `gdal2tiles.py`
- Hillshaded topography is accomplished by creating 
  - a color-relief using [gdal2dem](https://gdal.org/programs/gdaldem.html)
  - a hillshade using [gdal2dem](https://gdal.org/programs/gdaldem.html) with a multidirectional shading 
    - scale values `-s` and `-z` can be changed depending on the data units and desired output
  - a gamma correction is applied to the hillshade using [gdal_calc.py](https://gdal.org/programs/gdal_calc.html)
  - the gamma corrected hillshade and color-relief are combined using an [overlay function](https://en.wikipedia.org/wiki/Blend_modes#Overlay)
  - Reference: https://gis.stackexchange.com/a/255574
- Creating of the tiles can take a long time
- The output tiles directory should have `leaflet.html` and other various html files to easily view the output
- Any artifacts in the color-relief image will propagate into the resulting tiles.
- Colormap is taken from [GeoMapApp](http://www.geomapapp.org/) and the default [GMRT](https://www.gmrt.org) colorscale
  - The land and ocean scales were merged 
  - Colored at shallow water depths were changed from a dark green to very light/almost white 

## License
BSD 2-Clause Simplified License
