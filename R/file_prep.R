md_counties <- tigris::counties("MD")
md_counties <- sf::st_transform(md_counties, crs = 3857)

sf::write_sf(md_counties, here::here("files/md_counties.gpkg"))


inspire_plans <- mapbaltimore::inspire_plans
inspire_plans <- sf::st_transform(inspire_plans, crs = 3857)

sf::write_sf(inspire_plans, here::here("files/md_counties.gpkg"))
