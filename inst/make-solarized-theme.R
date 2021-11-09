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
library(magrittr)
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
    "line_background" = "line-number-background-color"
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

# These are the creator's styles for Vim
# https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L534

new <- j %>%
  set_text_style(
    "global",
    text = p$base00, background = p$base3,
    # I'm having trouble testing these
    line = p$base1, line_background = p$base2
  ) %>%
  set_text_style("Comment", text = p$base1, italic = TRUE) %>%
  # not sure what this is
  # ## comments
  set_text_style("Documentation", text = p$base1,  italic = TRUE,  bold = FALSE) %>%
  set_text_style("CommentVar", text = p$base1, italic = TRUE) %>%
  # #> comments
  set_text_style("Information",   text = p$base00, italic = FALSE, bold = FALSE) %>%
  set_text_style("Keyword",  text = p$green) %>%
  set_text_style("Variable", text = p$violet) %>%
  set_text_style("Constant", text = p$orange) %>%
  set_text_style("Float",    text = p$magenta) %>%
  set_text_style("BaseN",    text = p$magenta) %>%
  set_text_style("DecVal",   text = p$magenta) %>%
  set_text_style("Operator", text = p$yellow) %>%
  set_text_style("Function", text = p$blue) %>%
  set_text_style("ControlFlow", text = p$green, bold = FALSE) %>%
  set_text_style("Char",           text = p$cyan) %>%
  set_text_style("SpecialChar",    text = p$blue) %>%
  set_text_style("String",         text = p$cyan) %>%
  set_text_style("VerbatimString", text = p$violet) %>%
  set_text_style("SpecialString",  text = p$cyan) %>%
  set_text_style("BuiltIn",  ) %>%
  set_text_style("Extension", ) %>%
  set_text_style("Preprocessor", ) %>%
  set_text_style("Attribute", ) %>%
  set_text_style("Annotation", ) %>%
  set_text_style("Other", text = p$violet) %>%
  set_text_style("Import", ) %>%
  set_text_style("DataType", ) %>%
  set_text_style("Error", text = p$orange) %>%
  set_text_style("Alert", text = p$orange) %>%
  set_text_style("Warning", text = p$orange) %>%
  { }

jsonlite::write_json(
  new,
  "inst/solarized_light.theme",
  null = "null",
  auto_unbox = TRUE
)

file.remove("syntax-test.docx")
rmarkdown::render("syntax-test.Rmd")
system2("open", "syntax-test.docx")
# ?rmarkdown::word_document


# Definitions of the things
# https://docs.kde.org/stable5/en/kate/katepart/highlight.html
#
# General default styles:
#
# dsNormal, when no special highlighting is required.
#
# dsKeyword, built-in language keywords.
#
# dsFunction, function calls and definitions.
#
# dsVariable, if applicable: variable names (e.g. $someVar in PHP/Perl).
#
# dsControlFlow, control flow keywords like if, else, switch, break, return,
# yield, ...
#
# dsOperator, operators like + - * / :: < >
#
# dsBuiltIn, built-in functions, classes, and objects.
#
# dsExtension, common extensions, such as Qt™ classes and functions/macros in
# C++ and Python.
#
# dsPreprocessor, preprocessor statements or macro definitions.
#
# dsAttribute, annotations such as @override and __declspec(...). String-related
# default styles:
#
# dsChar, single characters, such as 'x'.
#
# dsSpecialChar, chars with special meaning in strings such as escapes,
# substitutions, or regex operators.
#
# dsString, strings like "hello world".
#
# dsVerbatimString, verbatim or raw strings like 'raw \backlash' in Perl,
# CoffeeScript, and shells, as well as r'\raw' in Python.
#
# dsSpecialString, SQL, regexes, HERE docs, LATEX math mode, ...
#
# dsImport, import, include, require of modules. Number-related default styles:
#
# dsDataType, built-in data types like int, void, u64.
#
# dsDecVal, decimal values.
#
# dsBaseN, values with a base other than 10.
#
# dsFloat, floating point values.
#
# dsConstant, built-in and user defined constants like PI.
#
# Comment and
# documentation-related default styles:
#
# dsComment, comments.
#
# dsDocumentation, /** Documentation comments */ or """docstrings""".
#
# dsAnnotation, documentation commands like @param, @brief.
#
# dsCommentVar, the variable names used in above commands, like "foobar" in
# @param foobar.
#
# dsRegionMarker, region markers like //BEGIN, //END in comments. Other default
# styles:
#
# dsInformation, notes and tips like @note in doxygen.
#
# dsWarning, warnings like @warning in doxygen.
#
# dsAlert, special words like TODO, FIXME, XXXX.
#
# dsError, error highlighting and wrong syntax.
#
# dsOthers, when nothing else fits.
