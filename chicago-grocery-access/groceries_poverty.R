# Load libraries
library(sf)
library(tidyverse)

# Set working directory
setwd() # Set as repository path

# Read shapefiles
chicago_nbh <- st_read("ComArea_ACS14_f.shp")
groceries <- st_read("groceries.shp")

# Mutate to add new column for child povertiy density, scaled by 100
chicago_nbh <- chicago_nbh %>%
  mutate(cpov_density = (ChldPov14 / shape_area) * 100)

# Get coordinate refernce system
groceries_crs <- st_crs(groceries)

# Transform and join
chicago_crs <- st_transform(chicago_nbh, groceries_crs)

# Plot
plot <- ggplot(chicago_crs) +
  geom_sf(aes(fill = cpov_density)) +
  scale_fill_gradient2(low = "white", high = "red",
                       space = "Lab",
                       breaks = c(min(chicago_crs$cpov_density, na.rm = TRUE),
                                  max(chicago_crs$cpov_density, na.rm = TRUE)),
                       labels = c("Low", "High")) +
  geom_sf(data = groceries, size = 1.25, 
          aes(shape = "Grocery Stores", colour = "Grocery Stores")) +
  scale_shape_manual(values = 2, name = "",
                     labels = c("Grocery Stores")) +
  scale_colour_manual(values = "blue", name = "",
                      labels = c("Grocery Stores")) +
  labs(fill = "Child Poverty Density",
       caption = paste("Density refers to the number of children living",
                       "in poverty, relative to the size of the district.")) +
  ggtitle("Access to Grocery Stores in Chicago's Poorest Neighbourhoods") +
  theme_bw()

# Save plot
ggsave("poverty_and_food.png", plot = plot, width = 10, height = 10, dpi = 1000)