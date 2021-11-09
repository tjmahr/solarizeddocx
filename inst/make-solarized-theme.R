# https://pandoc.org/MANUAL.html#syntax-highlighting:
#
# > If you are not satisfied with the predefined styles, you can use
# > --print-highlight-style to generate a JSON .theme file which can be modified
# > and used as the argument to --highlight-style. To get a JSON version of the
# > pygments style, for example:
# >
# >     pandoc --print-highlight-style pygments > my.theme
# >
# > Then edit my.theme and use it like this:
# >
# >     pandoc --highlight-style my.theme

# via https://github.com/altercation/solarized#the-values
p <- list(
  base03  = "#002b36",
  base02  = "#073642",
  base01  = "#586e75",
  base00  = "#657b83",
  base0   = "#839496",
  base1   = "#93a1a1",
  base2   = "#eee8d5",
  base3   = "#fdf6e3",
  yellow  = "#b58900",
  orange  = "#cb4b16",
  red     = "#dc322f",
  magenta = "#d33682",
  violet  = "#6c71c4",
  blue    = "#268bd2",
  cyan    = "#2aa198",
  green   = "#859900"
)

save_base_theme <- function(path) {
  system2(
    command = rmarkdown::pandoc_exec(),
    "--print-highlight-style pygments",
    # stdout = path
  )
  invisible(path)
}

# Make a pipeable interface for modify parts of the style definition
set_text_style <- function(data, name, ...) {
  # clean up the dots to match the style's data naming scheme
  dots <- rlang::dots_list(...)
  style_names <- c(
    "text" = "text-color",
    "background" = "background-color",
    "bold" = "bold",
    "italic" = "italic",
    "underline" = "underline",
    "line" = "line-number-color",
    "line" = "line-number-background-color"
  )
  dots <- setNames(dots, style_names[names(dots)])

  if (name != "global") {
    data[["text-styles"]][[name]][names(dots)] <- dots
  } else {
    data[names(dots)] <- dots
  }

  data
}


j <- save_base_theme("inst/base.theme") %>%
  jsonlite::read_json()

# there is definitely a smart more data oriented way but I wanted to hit
# the ground running with something pipeable and interactive.

new <- j %>%
  set_text_style("Comment", text = p$base01, italic = TRUE) %>%
  set_text_style("CommentVar", ) %>%
  set_text_style("Constant", text = p$cyan) %>%
  set_text_style("Other", ) %>%
  set_text_style("Attribute", ) %>%
  set_text_style("SpecialString", ) %>%
  set_text_style("Annotation", ) %>%
  set_text_style("Function", ) %>%
  set_text_style("String", ) %>%
  set_text_style("ControlFlow", ) %>%
  set_text_style("Operator", ) %>%
  set_text_style("Error", ) %>%
  set_text_style("BaseN", ) %>%
  set_text_style("Alert", ) %>%
  set_text_style("Variable", ) %>%
  set_text_style("BuiltIn", ) %>%
  set_text_style("Extension", ) %>%
  set_text_style("Preprocessor", ) %>%
  set_text_style("Information", ) %>%
  set_text_style("VerbatimString", ) %>%
  set_text_style("Warning", ) %>%
  set_text_style("Documentation", ) %>%
  set_text_style("Import", ) %>%
  set_text_style("Char", ) %>%
  set_text_style("DataType", ) %>%
  set_text_style("Float", ) %>%
  set_text_style("SpecialChar", ) %>%
  set_text_style("DecVal", ) %>%
  set_text_style("Keyword", )

jsonlite::write_json(
  new,
  "inst/test.theme",
  null = "null",
  auto_unbox = TRUE
)
