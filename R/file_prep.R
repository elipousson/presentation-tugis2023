md_counties <- tigris::counties("MD")
md_counties <- sf::st_transform(md_counties, crs = 3857)

sf::write_sf(md_counties, here::here("files/md_counties.gpkg"))

inspire_plans <- mapbaltimore::inspire_plans
inspire_plans <- sf::st_transform(inspire_plans, crs = 3857)

sf::write_sf(inspire_plans, here::here("files/md_counties.gpkg"))

balt_center <- sf::st_centroid(md_counties[3, ])
balt_area <- sf::st_buffer(balt_center, dist = units::as_units(25, "mi"))


balt_area_schools <- balt_area |>
  sf::st_transform(4326) |>
  sf::st_bbox() |>
  osmdata::opq() |>
  osmdata::add_osm_features(
    features = c("amenity" = "university",
                 "amenity" = "college")
  )

balt_area_schools <- osmdata::osmdata_sf(balt_area_schools)

readr::write_rds(balt_area_schools, here::here("files/balt_area_schools.rds"))
