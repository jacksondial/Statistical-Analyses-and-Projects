library(sf)
ID_counties <- USAboundaries::us_counties(states = "ID")
st_crs(ID_counties)

#change coordinate reference system

my_proj <- "+proj=robin +datum=WGS84"
ID_tr <- ID_counties %>% st_transform(crs = my_proj)

st_crs(ID_tr)

#Compare the following two plots, same data but different CRS's

ggplot() + geom_sf(data = ID_counties) + theme_bw()
ggplot() + geom_sf(data = ID_tr) + theme_bw()

#Now change projection on the fly instead of changing the actual dataset

ggplot() + geom_sf(data = ID_counties) +
  theme_bw()+
  coord_sf(crs = st_crs(my_proj))

#Doing a similar thing but using a predefined EPSG number
ggplot() + geom_sf(data = ID_counties) +
  theme_bw()+
  coord_sf(crs = st_crs(5041)) #5041 is an EPSG number

4215

ggplot() + geom_sf(data = ID_counties) +
  theme_bw()+
  coord_sf(crs = st_crs(21500)) #5041 is an EPSG number


my_proj <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
ggplot() + geom_sf(data = ID_counties) +
  theme_bw()+
  coord_sf(crs = st_crs(my_proj))

my_proj <- "+proj=moll +lat_0=45 +lon_0=-115 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

states_tr <- states %>% st_transform( crs = my_proj)
idaho_tr <- idaho %>% st_transform( crs = my_proj)

ggplot() +
  geom_sf(data = states_tr, inherit.aes = FALSE) +
  geom_sf(data = idaho_tr, inherit.aes = FALSE)




pacman::p_load(downloader, sf, fs, tidyverse)

river_path <- "https://research.idwr.idaho.gov/gis/Spatial/Hydrography/streams_lakes/c_250k/hyd250.zip"


read_zip <- function(path_to_file){

  df <- tempfile(); uf <- tempfile()
  download(path_to_file, df, mode = "wb")
  unzip(df, exdir = uf)
  mydata <- read_sf(uf)
  file_delete(df); dir_delete(uf)

mydata
}

rivers <- read_zip("https://research.idwr.idaho.gov/gis/Spatial/Hydrography/streams_lakes/c_250k/hyd250.zip") %>% 
  filter(FEAT_NAME %in% c("Snake River", "Henry's Fork"))

well <- read_zip("https://opendata.arcgis.com/datasets/1abb666937894ae4a87afe9655d2ff83_1.zip?outSR=%7B%22latestWkid%22%3A102605%2C%22wkid%22%3A102605%7D") %>% 
  filter(Production > 5000)

dam <- read_zip("https://opendata.arcgis.com/datasets/e163d7da3b84410ab94700a92b7735ce_0.zip?outSR=%7B%22latestWkid%22%3A102605%2C%22wkid%22%3A102605%7D") %>% 
  filter(SurfaceAre > 50)

idaho_shape <- read_zip("https://byuistats.github.io/M335/data/shp.zip") %>% 
  filter(StateName == "Idaho")

my_proj <- "+proj=moll +lat_0=45 +lon_0=-115 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"


ggplot()+
  geom_sf(data = idaho_shape)+
  geom_sf(data = rivers, color = "blue")+
  geom_sf(data = well, color = rgb(.1,.1,.1,.05), size = 10)+
  geom_sf(data = dam, color = rgb(.1,.1,.1,.05))+
  coord_sf(crs = st_crs(my_proj),xlim = c(-117, -110))


