#' Bernie's theme for ggplot 2 blog graphs. Inspired by the excellent
#' `{hrbrthemes}` package.
#'
#' @return Theme for ggplot graphs in accordance with Bernie's blog colors.
#' @export
#'
#' @examples
#' \donttest{
#'  library(ggplot2)
#'  # Prepare data
#'  cty_mpg <- aggregate(mpg$cty, by=list(mpg$manufacturer), FUN=mean)  # aggregate
#'  colnames(cty_mpg) <- c("make", "mileage")  # change column names
#'  cty_mpg <- cty_mpg[order(cty_mpg$mileage), ]  # sort
#'  cty_mpg$make <- factor(cty_mpg$make, levels = cty_mpg$make)
#'  # Plot
#'  ggplot(cty_mpg, aes(x=make, y=mileage)) +
#'    geom_segment(aes(x=make,
#'                     xend=make,
#'                     y=0,
#'                     yend=mileage), color = "white") +
#'    geom_point(size=3, color = "orange") +
#'    labs(title="Lollipop Chart",
#'         subtitle="Make Vs Avg. Mileage",
#'         caption="source: mpg") +
#'    HohgantR::themebernie() +
#'    theme(axis.text.x = element_text(angle=65, vjust=0.6))
#'  }

themebernie <- function(){
  hrbrthemes::theme_modern_rc() +
    ggplot2::theme(panel.background = ggplot2::element_rect(fill = "#222831",
                                                            color = NA),
                   plot.background = ggplot2::element_rect(fill = "#222831",
                                                           color = NA))
}


#' Mineral theme for ggplot 2 graphs
#'
#' @return Theme for ggplot graphs inspired by coal paper and the excellent
#' `{hrbrthemes}` package.
#' @export
#'
#' @examples
#' \donttest{
#'  library(ggplot2)
#'  # Prepare data
#'  cty_mpg <- aggregate(mpg$cty, by=list(mpg$manufacturer), FUN=mean)  # aggregate
#'  colnames(cty_mpg) <- c("make", "mileage")  # change column names
#'  cty_mpg <- cty_mpg[order(cty_mpg$mileage), ]  # sort
#'  cty_mpg$make <- factor(cty_mpg$make, levels = cty_mpg$make)
#'  # Plot
#'  ggplot(cty_mpg, aes(x=make, y=mileage)) +
#'    geom_segment(aes(x=make,
#'                     xend=make,
#'                     y=0,
#'                     yend=mileage), color = "#C3CED6") +
#'    geom_point(size=3, color = "#C3CED6") +
#'    labs(title="Lollipop Chart",
#'         subtitle="Make Vs Avg. Mileage",
#'         caption="source: mpg") +
#'    HohgantR::thememineral() +
#'    theme(axis.text.x = element_text(angle=65, vjust=0.6))
#'  }

thememineral <- function(){
  hrbrthemes::theme_modern_rc() +
    ggplot2::theme(panel.background = ggplot2::element_rect(fill = "#36454f",
                                                            color = NA),
                   plot.background = ggplot2::element_rect(fill = "#36454f",
                                                           color = NA),
                   panel.grid = ggplot2::element_line(colour = "#718C9E"))
}
