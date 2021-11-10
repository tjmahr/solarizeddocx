#' @keywords internal
"_PACKAGE"

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
#'   used by [demo_document()].
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


pkg_resource <- function(...) {
  system.file(..., package = "solarizeddocx")
}
