library(packageRank)
library(ggplot2)
library(dplyr)

# pkg_downloads <- cranDownloads(
#   packages = c("sp", "sf", "dplyr", "ggplot2"),
#   from = "2018-08-01",
#   to = "2023-07-31"
# )
#
# readr::write_csv(pkg_downloads$cranlogs.data, "files/pkg_downloads_data.csv")

pkg_downloads_data <- readr::read_csv("files/pkg_downloads_data.csv", show_col_types = FALSE)

pkg_plot_data <- pkg_downloads_data |>
  mutate(
    date = lubridate::date(date),
    month = lubridate::month(date),
    year = lubridate::year(date),
    date_month = lubridate::ymd(paste0(year, "-", stringr::str_pad(month, 2, pad = "0"), "-01"))
  ) |>
  summarise(
    count = mean(count),
    .by = c("package", "date_month")
  )

pkg_plot <- pkg_plot_data |>
    ggplot(aes(x = date_month, y = count, color = package)) +
    stat_smooth(
      geom = 'line', method = 'loess', span = 0.05, alpha = 0.75, linewidth = 1.75
    ) +
    scale_x_date() +
    scale_y_continuous(
      labels = scales::label_number()
    ) +
    pilot::scale_color_pilot() +
    labs(
      color = "Package name",
      x = "Date",
      y = "Average monthly downloads",
      caption = "Package downloads from CRAN (August 2018 - July 2023) via the {packageRank} package."
    ) +
    hrbrthemes::theme_ipsum_pub()

suppressMessages(suppressWarnings(pkg_plot))
