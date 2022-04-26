## usethis namespace: start
## usethis namespace: end
NULL

#' Solarized Syntax Highlighting in Microsoft Word
#'
#' @param ... Arguments passed to [rmarkdown::word_document()].
#' @param reference_docx Reference docx file to use. By default, this value is
#'   set to use `"solarized"` to use this package's file. Alternatively, one
#'   could `"default"` for pandoc's default file or a path to a custom docx
#'   file.
#' @param highlight Syntax highlighting style to use. By default, this value is
#'   set to `"solarized"` to use this package's syntax definition. See
#'   alternatives in [rmarkdown::word_document()].
#' @param syntax_definition Syntax definition to use for syntax highlighting.
#'   Defaults to `"solarized"` to use this package's language definition. This
#'   option is not one available to  [rmarkdown::word_document()], but setting
#'   this argument to `NULL` or `"default"` will use the default behavior.
#' @param pandoc_args Additional command line options to pass to pandoc. (This
#'   should be a character vector of options.)
#' @return An RMarkdown output format for Word documents.
#' @export
#' @examples
#' \dontrun{
#' rmarkdown::render("test.Rmd", output_format = solarizeddocx::document())
#' }
document <- function(
  ...,
  reference_docx = "solarized",
  highlight = "solarized",
  syntax_definition = "solarized",
  pandoc_args = character(0)
) {

  if (reference_docx == "solarized") {
    reference_docx = file_reference_docx()
  }

  style_args <- if (highlight == "solarized") {
    c("--highlight-style", file_solarized_light_theme())
  } else {
    rmarkdown::pandoc_highlight_args(highlight)
  }

  syntax_args <- if (syntax_definition == "solarized") {
    c("--syntax-definition", file_syntax_definition())
  } else if (syntax_definition == "default") {
    character(0)
  } else if (is.null(syntax_definition)) {
    character(0)
  } else {
    c("--syntax-definition", syntax_definition)
  }

  args <- c(style_args, syntax_args)

  rmarkdown::word_document(
    ...,
    reference_docx = reference_docx,
    pandoc_args = c(args, pandoc_args)
  )
}


#' Render and open the demo RMarkdown file
#' @export
#' @return This function renders the built-in RMarkdown file and opens it. It
#'   returns the path to the rendered file invisibly.
demo_document <- function() {
  path_out <- tempfile(fileext = ".docx")

  rmarkdown::render(
    file_syntax_test(),
    output_file = path_out
  )
  system2("open", path_out)
  invisible(path_out)
}


#' Retrieve file paths to package resources
#' @name fileresources
#' @rdname fileresources
#' @return `file_reference_docx()` returns the path to the reference docx file
#'   used by this package. `file_syntax_definition()` returns the path to the
#'   XML file specifying how pandoc should highlight the code in the document.
#'   `file_solarized_light_theme()` returns the path to the .theme file used by
#'   this package. `file_syntax_test()` returns the path to the RMarkdown file
#'   used by [demo_document()]. `file_code_block()` returns a minimal .Rmd file
#'   with a single code block for small illustrations.
#' @references the reference docx is a modified version of the own built into
#'   pandoc by John MacFarlane. The syntax definition is a modified version of
#'   the one by the KDE developers. I used the code here:
#'   <https://github.com/KDE/syntax-highlighting/blob/master/data/syntax/r.xml>
NULL

#' @rdname fileresources
#' @export
file_reference_docx <- function() {
  pkg_resource("solarized-light.docx")

}

#' @rdname fileresources
#' @export
file_syntax_definition <- function() {
  pkg_resource("r.xml")
}

#' @rdname fileresources
#' @export
file_solarized_light_theme <- function() {
  pkg_resource("solarized_light.theme")
}


#' @rdname fileresources
#' @export
file_syntax_test <- function() {
  pkg_resource("syntax-test.Rmd")
}

#' @rdname fileresources
#' @export
file_code_block <- function() {
  pkg_resource("syntax-block.Rmd")
}


pkg_resource <- function(...) {
  system.file(..., package = "solarizeddocx")
}


#' Syntax highlighting theme building tools
#' @rdname themebuilding
#' @return `copy_base_pandoc_theme(path)` saves the pandoc syntax highlighting
#'   theme's JSON data to `path` and returns the `path` invisibly.
#'   `set_theme_text_style()` and `patch_theme_text_style`() return a modified
#'   syntax highlighting theme. `write_pandoc_theme()` writes out the pandoc
#'   syntax highlighting theme to a JSON file and invisibly returns the original
#'   data. `colors_solarized_light()` returns a list with the solarized light
#'   colors.
#' @references  Solarized Light Theme colors via
#'   <https://github.com/altercation/solarized#the-values>
#' @examples
#'
#' d <- tempfile("solarizeddocx-ex")
#' dir.create(d)
#' s <- tempfile(tmpdir = d)
#'
#' copy_base_pandoc_theme(s)
#' data_theme <- jsonlite::read_json(s)
#' str(data_theme, max.level = 2)
#' str(data_theme$`text-styles`$Comment)
#'
#' # Interactive (pipe-able) interface
#'
#' # bold pink roman comments
#' my_theme <- set_theme_text_style(
#'     data_theme,
#'     "Comment",
#'     text = "#ff748c",
#'     bold = TRUE,
#'     italic = FALSE
#' )
#' str(my_theme$`text-styles`$Comment)
#'
#' # Patching interface
#'
#' # Stub for a Fairy Floss theme https://github.com/sailorhg/fairyfloss
#' data_theme_patches <- list(
#'   global = list(text = "#F8F8F2", background = "#5A5475"),
#'   Function = list(text = "#C2FFDF"),
#'   Operator = list(text = "#FFB8D1"),
#'   Float = list(text = "#C5A3FF")
#' )
#' my_theme2 <- patch_theme_text_style(data_theme, data_theme_patches)
#' str(my_theme2$`text-styles`$Function)
#' str(my_theme2$`text-styles`$Float)
#' @export
colors_solarized_light <- function() {
  list(
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
}

#' @param path Path where to save pandoc's built-in syntax highlighting theme.
#' @rdname themebuilding
#' @export
copy_base_pandoc_theme <- function(path) {
  # https://pandoc.org/MANUAL.html#syntax-highlighting:
  #
  # > If you are not satisfied with the predefined styles, you can use
  # > --print-highlight-style to generate a JSON .theme file which can
  # > be modified and used as the argument to --highlight-style. To get
  # > a JSON version of the pygments style, for example:
  # >
  # >     pandoc --print-highlight-style pygments > my.theme
  # >
  # > Then edit my.theme and use it like this:
  # >
  # >     pandoc --highlight-style my.theme
  system2(
    command = rmarkdown::pandoc_exec(),
    "--print-highlight-style pygments",
    stdout = path
  )
  invisible(path)
}


#' @param data List containing data from a syntax highlighting theme's JSON
#'   file.
#' @param name String name of the text styles to modify (e.g., `"Function"`).
#'   The theme is a list with global style settings and a sub-list `text-styles`
#'   with each of the specific token styles. (See examples.) Use `"global"` to
#'   modify the top-level theme elements or a name in `data[["text-styles"]]` to
#'   modify those styles.
#' @param ... Key-value pairs setting the style appearance. The keys can be one
#'   of the color setters: `text` (text-color), `background` (background-color),
#'   `line` (line-number-color), `line_background`
#'   (line-number-background-color). These fields take a hex color value. The
#'   keys can also be one of the font style setters: `bold`, `underline`,
#'   `italic`. These fields take `TRUE` or `FALSE`.
#' @rdname themebuilding
#' @export
set_theme_text_style <- function(data, name, ...) {
  # clean up the dots to match the style's data naming scheme
  dots <- rlang::dots_list(...)
  style_names <- c(
    "text" = "text-color",
    "background" = "background-color",
    "bold" = "bold",
    "italic" = "italic",
    "underline" = "underline",
    "line" = "line-number-color",
    "line_background" = "line-number-background-color"
  )
  dots <- stats::setNames(dots, style_names[names(dots)])

  if (name != "global") {
    data[["text-styles"]][[name]][names(dots)] <- dots
  } else {
    data[names(dots)] <- dots
  }

  data
}

#' @param data_patches Alternatively, we can provide provide a list of patches
#'   and use those to call `set_theme_text_style()`. For example, `list(global =
#'   list(text = "#657b83"), Comment = list(color = "#93a1a1"))` would apply the
#'   approach changes to the global and comment styles.
#' @rdname themebuilding
#' @export
patch_theme_text_style <- function(data, data_patches) {
  for (patch_name in names(data_patches)) {
    this_patch <- c(
      data = list(data),
      name = patch_name,
      data_patches[[patch_name]]
    )
    data <- do.call(set_theme_text_style, this_patch)
  }
  data
}


#' @param output_path Path where to write out a pandoc syntax highlighting theme
#'   JSON file.
#' @rdname themebuilding
#' @export
write_pandoc_theme <- function(data, output_path) {
  jsonlite::write_json(
    data,
    output_path,
    null = "null",
    auto_unbox = TRUE,
    pretty = TRUE
  )
  invisible(data)
}
