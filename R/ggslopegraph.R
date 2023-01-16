#' Slope graph for ggplot2
#'
#' Creates a slope graph ideal to use when computing changes in one or more
#' indicators between waves of a survey or other time series data with
#' a low number of periods.
#'
#' @param data Data frame containing the data in a long form. Required input.
#' @param x The variable on the x axis, usually time, survey wave, etc. Required
#' input.
#' @param y The variable on the y axis, usually an indicator such as poverty and
#' inequality measures. Required input.
#' @param group Grouping variable showing various levels of the indicator.
#' @param DataLabel Data label
#' @param title Plot title
#' @param subtitle Plot subtitle
#' @param caption Plot caption
#' @param LineThickness Line width
#' @param LineColor Line color
#' @param DataTextSize Text size of the data point value.
#' @param DataTextColor Text color of the data point value.
#' @param DataLabelPadding Text padding of the label of each level.
#' @param DataLabelLineSize Text label line size.
#' @param DataLabelFillColor Text label fill color.
#' @param WiderLabels Set wider labels? False by default.
#' @param ReverseYAxis Revert Y axis? False by default.
#' @param ReverseXAxis Revert X axis? False by default.
#' @param RemoveMissing Remove missing values? True by default.
#'
#' @source Adapted and updated from
#' [this great package](https://github.com/leeper/slopegraph).
#' @return A pretty slope graph.
#' @export
#'
#' @examples
#' HohgantR::indicators_long |>
#' dplyr::filter(indicator == "Indicator") |>
#' ggslope(year, value, DisaggregationLevel)
#'

ggslope <- function(data,
                    x,
                    y,
                    group,
                    DataLabel = NULL,
                    title = "No title given",
                    subtitle = "No subtitle given",
                    caption = "No caption given",
                    LineThickness = 1,
                    LineColor = "ByGroup",
                    DataTextSize = 2.5,
                    DataTextColor = "black",
                    DataLabelPadding = 0.05,
                    DataLabelLineSize = 0,
                    DataLabelFillColor = "#f5f5f2",
                    WiderLabels = FALSE,
                    ReverseYAxis = FALSE,
                    ReverseXAxis = FALSE,
                    RemoveMissing = TRUE) {

  # ---------------- input checking ----------------------------

  # Init .data to avoid note
  .data <- NULL

  # error checking and setup
    if (length(match.call()) <= 4) {
      stop("Not enough arguments passed requires a data, plus at least three variables")
    }
    argList <- as.list(match.call()[-1])
    if (!methods::hasArg(data)) {
      stop("You didn't specify a data to use", call. = FALSE)
    }

    Nx <- deparse(substitute(x)) # name of x variable
    Ny <- deparse(substitute(y)) # name of y variable
    Ngroup <- deparse(substitute(group)) # name of group variable

    if (is.null(argList$DataLabel)) {
      NDataLabel <- deparse(substitute(y))
      DataLabel <- argList$y
    } else {
      NDataLabel <- deparse(substitute(DataLabel))
    }

  Ndata <- argList$data # name of data
  if (!methods::is(data, "data.frame")) {
    stop(paste0("'", Ndata, "' does not appear to be a |> frame"))
  }
  if (!Nx %in% names(data)) {
    stop(paste0("'", Nx, "' is not the name of a variable in the data"),
         call. = FALSE)
  }
  if (anyNA(data[[Nx]])) {
    stop(paste0("'", Nx, "' can not have missing data please remove those rows!"),
         call. = FALSE)
  }
  if (!Ny %in% names(data)) {
    stop(paste0("'", Ny, "' is not the name of a variable in the data"),
         call. = FALSE)
  }
  if (!Ngroup %in% names(data)) {
    stop(paste0("'", Ngroup, "' is not the name of a variable in the data"),
         call. = FALSE)
  }
  if (!NDataLabel %in% names(data)) {
    stop(paste0("'", NDataLabel, "' is not the name of a variable in the data"),
         call. = FALSE)
  }
  if (anyNA(data[[Ngroup]])) {
    stop(paste0(
      "'",
      Ngroup,
      "' can not have missing data please remove those rows!"
    ),
    call. = FALSE)
  }
  if (!class(data[[Ny]]) %in% c("integer", "numeric")) {
    stop(paste0("Sorry I need the measured variable '", Ny, "' to be a number"),
         call. = FALSE)
  }
  if (!"ordered" %in% class(data[[Nx]])) {
    # keep checking
    if (!"character" %in% class(data[[Nx]])) {
      # keep checking
      if ("factor" %in% class(data[[Nx]])) {
        # impose order
        message(paste0("\nConverting '", Nx, "' to an ordered factor\n"))
        data[[Nx]] <- factor(data[[Nx]], ordered = TRUE)
      } else {
        stop(
          paste0(
            "Sorry I need the variable '",
            Nx,
            "' to be of class character, factor or ordered"
          ),
          call. = FALSE
        )
      }
    }
  }

  x <- dplyr::enquo(x)
  y <- dplyr::enquo(y)
  group <- dplyr::enquo(group)
  DataLabel <- dplyr::enquo(DataLabel)

  # Handle edge cases

  if (ReverseXAxis) {
    data[[Nx]] <- forcats::fct_rev(data[[Nx]])
  }

  NumbOfLevels <- nlevels(factor(data[[Nx]]))
  if (WiderLabels) {
    CustomTheme <-
      c(CustomTheme, ggplot2::expand_limits(x = c(0, NumbOfLevels + 5)))
  }

  if (ReverseYAxis) {
    CustomTheme <- c(CustomTheme, ggplot2::scale_y_reverse())
  }

  if (length(LineColor) > 1) {
    if (length(LineColor) < length(unique(data[[Ngroup]]))) {
      message(
        paste0(
          "\nYou gave me ",
          length(LineColor),
          " colors I'm recycling colors because you have ",
          length(unique(data[[Ngroup]])),
          " ",
          Ngroup,
          "s\n"
        )
      )
      LineColor <-
        rep(LineColor, length.out = length(unique(data[[Ngroup]])))
    }
    LineGeom <-
      list(ggplot2::geom_line(ggplot2::aes(color = .data[[group]]), size = LineThickness),
           ggplot2::scale_color_manual(values = data[[LineColor]]))
  } else {
    if (LineColor == "ByGroup") {
      LineGeom <-
        list(ggplot2::geom_line(ggplot2::aes(color = .data[[group]], alpha = 1), size = LineThickness))
    } else {
      LineGeom <-
        list(ggplot2::geom_line(ggplot2::aes(), size = LineThickness, color = LineColor))
    }
  }

  # logic to sort out missing values if any
  if (anyNA(data[[Ny]])) {
    # are there any missing
    if (RemoveMissing) {
      # which way should we handle them
      data <- data |>
        dplyr::group_by(!!group) |>
        dplyr::filter(!anyNA(!!y)) |>
        droplevels()
    } else {
      data <- data |>
        dplyr::filter(!is.na(!!y))
    }
  }

  # The actual graph
  data |>
    ggplot2::ggplot(ggplot2::aes(group = .data[[group]], y = .data[[y]], x = .data[[x]])) +
    LineGeom +
    # left side y axis labels
    ggrepel::geom_text_repel(
      data = dplyr::slice_max(data, eval(x), n = 1),
      ggplot2::aes(label = .data[[group]]),
      hjust = "left",
      box.padding = 0.10,
      point.padding = 0.10,
      segment.color = "gray",
      segment.alpha = 0.6,
      fontface = "bold",
      size = 3,
      nudge_x = -1.95,
      direction = "y",
      force = 1.5,
      max.iter = 3000
    ) +
    # right side y axis labels
    ggrepel::geom_text_repel(
      data = dplyr::slice_min(data, eval(x), n = 1),
      ggplot2::aes(label = .data[[group]]),
      hjust = "right",
      box.padding = 0.10,
      point.padding = 0.10,
      segment.color = "gray",
      segment.alpha = 0.6,
      fontface = "bold",
      size = 3,
      nudge_x = 1.95,
      direction = "y",
      force = 1.5,
      max.iter = 3000
    ) +
    # data point labels
    ggplot2::geom_label(ggplot2::aes(label = .data[[NDataLabel]]),
               size = DataTextSize,
               label.padding = ggplot2::unit(DataLabelPadding, "lines"),
               label.size = DataLabelLineSize,
               color = DataTextColor,
               fill = DataLabelFillColor
    ) +
    ggplot2::scale_x_discrete(position = "top") +
    CustomTheme() +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      caption = caption
    )
}

# ggslope theme

CustomTheme <- function(){
  ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "none",
      axis.text.x = ggplot2::element_text(size = 12, vjust = 1.5),
      axis.text.y = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
      panel.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
      panel.border = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(size = 16, hjust = 0.5, color = "#4e4d47"),
      plot.subtitle = ggplot2::element_text(
        size = 14,
        hjust = 0.5,
        color = "#4e4d47",
        margin = ggplot2::margin(
          b = -0.1,
          t = -0.1,
          l = 2,
          unit = "cm"
        ),
        debug = F
      ),
      plot.margin = ggplot2::unit(c(.5, .5, .2, .5), "cm"),
      panel.spacing = ggplot2::unit(c(-.1, 0.2, .2, 0.2), "cm"),
      plot.caption = ggplot2::element_text(
        size = 9,
        hjust = 0.92,
        margin = ggplot2::margin(t = 0.2,
                                 b = 0,
                                 unit = "cm"),
        color = "#939184"
      )
    )
}
