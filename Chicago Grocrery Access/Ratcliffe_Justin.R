#### DPSS Homework Week 5
#### R. Justin Ratcliffe
#### 12284830
#### Due: September 6th, 2020

### Load libraries
library(sf)
library(tmap)
library(tidyverse)


## Question 5
# Load Chicago neighbourhood data, plot basic geometry of Chicago

chicago_nbh <- st_read("ComArea_ACS14_f.shp")

plot(chicago_nbh["ComAreaID"])


## Question 6
# Create new variable: Child poverty density by neighbourhood.

chicago_nbh <- chicago_nbh %>% mutate(cpov_density = ChldPov14/shape_area) 


## Question 7
# Plot child poverty density

plot(chicago_nbh["cpov_density"])
  
ggplot(chicago_nbh) +
  geom_sf(aes(fill = cpov_density))

tm_shape(chicago_nbh) + 
  tm_polygons("cpov_density")


### Load grocery data for Question 8

groceries <- st_read("groceries.shp")
groceries_crs <- st_crs(groceries)


## Question 8a
# Modify the coordinate reference system in the Chicago data to match the grocery data

chicago_crs <- st_transform(chicago_nbh, groceries_crs)


## Question 8b
# Plot grocery location on top of the child poverty data

ggplot(chicago_crs) +
  geom_sf(aes(fill = cpov_density)) +
  scale_fill_gradient2("reverse") +
  geom_sf(data = groceries, size = 0.5, aes(colour = "orange"))



