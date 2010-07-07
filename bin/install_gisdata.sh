#!/bin/sh
#################################################
# 
# Purpose: Install a sample of the Natural Earth Datasets
# Source:  http://www.naturalearthdata.com
#
#################################################
# Copyright (c) 2010 Open Source Geospatial Foundation (OSGeo)
# Copyright (c) 2009 LISAsoft
#
# Licensed under the GNU LGPL.
# 
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This program is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# the web page "http://www.fsf.org/licenses/lgpl.html".
##################################################

TMP="/tmp/build_gisdata"
DATA_FOLDER="/usr/local/share/data"
 
## Setup things... ##
if [ ! -d "$DATA_FOLDER" ] ; then
   mkdir -p "$DATA_FOLDER"
fi
 
# check required tools are installed
if [ ! -x "`which wget`" ] ; then
   echo "ERROR: wget is required, please install it and try again" 
   exit 1
fi

# create tmp folders
mkdir "$TMP"
cd "$TMP"



###############################
# Download natural earth datasets:

BASE_URL="http://www.naturalearthdata.com"
SCALE="110m"  # 1:100 million

# Simple Populated Places 1:110m
#    http://www.naturalearthdata.com/downloads/110m-cultural-vectors/
# Admin 0 - Countries 1:110m
# Populated Places (simple, less columns) 1:110m
# Land 1:110m
# Ocean 1:110m
# Lakes + Reservoirs 1:110m
# Rivers, Lake Ceterlines 1:110m
LAYERS="
cultural/$SCALE-populated-places-simple
cultural/$SCALE-admin-0-countries
cultural/$SCALE-populated-places-simple
physical/$SCALE-land
physical/$SCALE-ocean
physical/$SCALE-lakes
physical/$SCALE-rivers-lake-centerlines
"

for LAYER in $LAYERS ; do
   wget -nv  -O "`basename $LAYER`.zip" \
     "$BASE_URL/http//www.naturalearthdata.com/download/$SCALE/$LAYER.zip"
done

# Raster basemap -- Cross Blended Hypso with Shaded Relief and Water 1:50 million (40mb)
wget -c --progress=dot:mega \
   "$BASE_URL/http//www.naturalearthdata.com/download/50m/raster/HYP_50M_SR_W.zip"


# Unzip files into the gisdata directory
mkdir -p "$DATA_FOLDER/natural_earth"

for file in *.zip ; do
  unzip "$file" -d "$DATA_FOLDER/natural_earth"
done



###############################
# Link to Open Street Map data  (e.g. FOSS4G host city)
CITY="Barcelona"
if [ -e "/usr/local/share/osm/$CITY.osm.bz2" ] ; then
   ln -s "/usr/local/share/osm/$CITY.osm.bz2" "$DATA_FOLDER/feature_city.osm.bz2"
else
   echo "ERROR: $CITY.osm.bz2 not found. Run install_osm.sh first."
fi


