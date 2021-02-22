library(sf)
library(tidyverse)
library(downloader)
library(fs)


read_zip <- function(path_to_file){
  
  df <- tempfile(); uf <- tempfile()
  download(path_to_file, df, mode = "wb")
  unzip(df, exdir = uf)
  mydata <- read_sf(uf)
  file_delete(df); dir_delete(uf)
  
  mydata
}

rivers <- read_zip("https://research.idwr.idaho.gov/gis/Spatial/Hydrography/streams_lakes/c_250k/hyd250.zip")
well <- read_zip("https://opendata.arcgis.com/datasets/1abb666937894ae4a87afe9655d2ff83_1.zip")
dam <- read_zip("https://opendata.arcgis.com/datasets/e163d7da3b84410ab94700a92b7735ce_0.zip")
us_shape <- read_zip("https://byuistats.github.io/M335/data/shp.zip")

snake <- rivers %>% 
  filter(FEAT_NAME %in% c("Snake River"))
henry <- rivers %>% 
  filter(FEAT_NAME == "Henrys Fork")
well_filt <- well  %>% 
  filter(Production >= 5000)
dam_filt <- dam  %>% 
  filter(SurfaceAre >= 50)
idaho_shape <- us_shape  %>% 
  filter(StateName == "Idaho")

my_proj <- "+proj=moll +lat_0=45 +lon_0=-115 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"




myplot <- ggplot()+
  geom_sf(data = idaho_shape, fill = NA)+
  geom_sf(data = snake, aes(color = "Snake River"), size = 1.5)+
  geom_sf(data = henry, aes(color = "Henry's Fork"), size = 1.5)+
  geom_sf(data = well_filt, aes(color = "Wells with Production > 5000 gallons"))+
  geom_sf(data = dam_filt, aes(color = "Dams with a surface area > 50 acres"), size = 1.1)+
  coord_sf(crs = st_crs(my_proj))+
  theme_bw()+
  labs(title = "Water Systems in Idaho", subtitle = "Rivers, Dams, and Wells", color = "Water System")+
  scale_color_manual(values = c("Henry's Fork" = "orange",
                                "Snake River" = "blue",
                                "Wells with Production > 5000 gallons" = "red",
                                "Dams with a surface area > 50 acres" = "springgreen3"))

myplot
ggsave("Water_in_Idaho.png", myplot)
