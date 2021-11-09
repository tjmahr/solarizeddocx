#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' Custom RMarkdown Docx Format
#' @export
document <- function(
  ...,
  reference_docx = "solarized",
  highlight = "solarized",
  pandoc_args = character(0)
) {
  if (reference_docx == "solarized") {
    reference_docx = pkg_resource("solarized-light.docx")
  }

  if (highlight == "solarized") {
    style_args <- c(
      "--highlight-style",
      pkg_resource("solarized_light.theme")
    )
  } else {
    style_args <- rmarkdown::pandoc_highlight_args(highlight)
  }


  # pandoc_args:
  #   - "--highlight-style=./inst/test.theme"
  # - "--syntax-definition=./inst/r.xml"
  # md_extensions: +fenced_code_attributes
  # reference_docx: "inst/custom-reference.docx"
  #

  # rmarkdown::pandoc("name", "value")
  # rmarkdown::pandoc_metadata_arg("name", "value")

  args <- c(
    "--syntax-definition", pkg_resource("r.xml"),
    style_args
  )


  rmarkdown::word_document(
    ...,
    reference_docx = reference_docx,
    pandoc_args = c(args, pandoc_args)
  )
}

demo <- function() {
  path_out <- tempfile(fileext = ".docx")
  rmarkdown::render(
    input = pkg_resource("syntax-test.Rmd"),
    output_file = path_out
  )

}

pkg_resource = function(...) {
  system.file(..., package = "solarizeddocx")
}
