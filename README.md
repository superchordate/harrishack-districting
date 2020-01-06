# harrishack-districting

## National Prototype
This repo currently has a national level prototype of what type of work we could present. To get the app working on your computer you'll need to download this repo as well as downloading the data and place it in the currently empty data folder in 'harrishack-district'. They should look like the following: harrishack-districting/data/congress/congress.gpkg and ../data/senate/senate.gpkg The data can be found
[here](https://drive.google.com/drive/u/1/folders/1OiQtuwcMqpiJ2-ren72Hgsv3KXAYpqv1). Make sure to install any missing R packages. If you have any questions or complications feel free to message Daniel on slack.

## Notes from [meeting](https://docs.google.com/document/d1PBrhhpL8MkmPmdMxncdV99OdHcZky8WWsGp5ttvisY4/edit)

Focus: Illinois (ignore US Senate and House of Representives, ignoring Chicago alderman districts) NOT ignoring State Senate,

Political entity: State: bi-camerate system (house and senate, nebraska is uni-camerate).

Illinois senate (upper): The Illinois Senate is made up of 59 senators elected from individual legislative districts determined by population; redistricted every 10 years, based on the 2010 U.S. census each senator represents approximately 217,468 people

Illinois house of representative (lower): each senate district is split into 2 house districts.

### Tools

Spatial: sf (R package for manipulating shapefiles).
tigris : census shapefile API
Ggparliament

Cgp grey: gerrymandering youtube video

