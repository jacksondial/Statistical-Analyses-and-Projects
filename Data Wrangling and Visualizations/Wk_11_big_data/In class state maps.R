library(sf)
library(USAboundaries)

devtools::install_github("ropensci/USAboundaries")
devtools::install_github("ropensci/USAboundariesData")


idaho <- us_states(states = "Idaho")
idaho
View(idaho)
View(us_states())

plot(idaho$geometry)

ggplot() + geom_sf(data = idaho, fill = NA)+
  theme_bw()

#To plot all of the US
allus <- us_states()
ggplot()+
  geom_sf(data = allus)

us_counties()
idaho_cities <- us_cities(state = "Idaho")

ggplot() + geom_sf(data = idaho)+
  geom_sf(data = idaho_cities)

#create a cloropleth
#according to land ares
idaho_counties <- us_counties(states = "Idaho")
ggplot(data = idaho_counties) +
  geom_sf(aes(fill = awater))

us_states %>% filter(!state_name %in% c("Alaska", "Puerto Rico"))



