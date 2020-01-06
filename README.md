# harrishack-districting

## National Prototype

This repo currently has a national level prototype of what type of work we could present. To get the app working on your computer you'll need to download this repo as well as downloading the data and place it in the currently empty data folder in `harrishack-district`. They should look like the following: `harrishack-districting/data/congress/congress.gpkg` and `harrishack-district/data/senate/senate.gpkg` The data can be found
[here](https://drive.google.com/open?id=1PBM6Byz1QJWTwcls8ejldxlAsmAjRY-k). Make sure to install any missing R packages. If you have any questions or complications feel free to message Daniel on slack.

## Notes from [meeting](https://docs.google.com/document/d1PBrhhpL8MkmPmdMxncdV99OdHcZky8WWsGp5ttvisY4/edit)

Focus: Illinois State politics (the General Assembly is defined by a house and senate -- Note that this is different from the US house and senate but has similar structure). We can also look into a Chicago level analysis, other State and/or National level question if we have the time.
[Illinois State Politics](https://en.wikipedia.org/wiki/Illinois_General_Assembly)

Political entity: State: bi-camerate system (house and senate, nebraska is uni-camerate).

Illinois senate (upper): The Illinois Senate is made up of 59 senators elected from individual legislative districts determined by population; redistricted every 10 years, based on the 2010 U.S. census each senator represents approximately 217,468 people
[Illinois House](https://en.wikipedia.org/wiki/Illinois_House_of_Representatives)

Illinois house of representative (lower): each senate district is split into 2 house districts.
[Illinois Senate](https://en.wikipedia.org/wiki/Illinois_Senate)

### Tools

Spatial: sf (R package for manipulating shapefiles).
tigris : census shapefile API
Ggparliament
tidycensus : census demigraphic data API (you'll need a census API key, get one [here](https://api.census.gov/data/key_signup.html))

Cgp grey: [gerrymandering youtube video](https://www.youtube.com/watch?v=Mky11UJb9AY)

### Question
What are the representation rates for certain interesting demographics in each chamber? e.g. How is race distributed in the senate vs each district and throughout IL.

Potential interesting demographics: Race, Gender, Income, need to explore what data tidycensus has.

