# Plan:
# - Get the JSON version of the default theme
# - modify it with R
# - save a new JSON file

library(magrittr)
library(solarizeddocx)

p <- colors_solarized_light()

j <- copy_base_pandoc_theme("inst/base.theme") %>%
  jsonlite::read_json()

# (There is definitely a smart more data oriented way but I wanted to hit
# the ground running with something pipeable and interactive.)
new <- j %>%
  set_theme_text_style(
    "global",
    text = p$base00,
    background = p$base3,
    # I'm having trouble testing these
    line = p$base1,
    line_background = p$base2
  ) %>%
  # # comments
  set_theme_text_style("Comment", text = p$base1, italic = TRUE) %>%
  # ## comments
  set_theme_text_style("Documentation", text = p$base1,  italic = TRUE,  bold = FALSE) %>%
  # #> comments
  set_theme_text_style("Information",   text = p$base00, italic = FALSE, bold = FALSE) %>%
  # set_theme_text_style("CommentVar", text = p$base1, italic = TRUE) %>%
  set_theme_text_style("Keyword",  text = p$green) %>%
  set_theme_text_style("Variable", text = p$violet) %>%
  set_theme_text_style("Constant", text = p$orange) %>%
  set_theme_text_style("Float",    text = p$magenta) %>%
  set_theme_text_style("BaseN",    text = p$magenta) %>%
  set_theme_text_style("DecVal",   text = p$magenta) %>%
  set_theme_text_style("Operator", text = p$yellow) %>%
  set_theme_text_style("Function", text = p$blue) %>%
  set_theme_text_style("ControlFlow", text = p$green, bold = FALSE) %>%
  set_theme_text_style("Char",           text = p$cyan) %>%
  set_theme_text_style("SpecialChar",    text = p$blue) %>%
  set_theme_text_style("String",         text = p$cyan) %>%
  set_theme_text_style("VerbatimString", text = p$violet) %>%
  set_theme_text_style("SpecialString",  text = p$cyan) %>%
  set_theme_text_style("BuiltIn",  ) %>%
  set_theme_text_style("Extension", ) %>%
  set_theme_text_style("Preprocessor", ) %>%
  set_theme_text_style("Attribute",  text = p$base00) %>%
  set_theme_text_style("Annotation", ) %>%
  set_theme_text_style("Other", text = p$violet) %>%
  set_theme_text_style("Import", text = p$green, italic = TRUE) %>%
  set_theme_text_style("DataType", ) %>%
  set_theme_text_style("Error", text = p$orange) %>%
  set_theme_text_style("Alert", text = p$orange) %>%
  set_theme_text_style("Warning", text = p$orange) %>%
  { }

write_pandoc_theme(new, "inst/solarized_light.theme")

# test out a patching version
patches <- tibble::lst(
  global = list(
    text = p$base00,
    background = p$base3,
    # I'm having trouble testing these
    line = p$base1,
    line_background = p$base2
  ),
  Comment = list(text = p$base1, italic = TRUE,  bold = FALSE),
  Documentation = Comment,
  Information = list(text = p$base00, italic = FALSE, bold = FALSE),
  Keyword = list(text = p$green),
  ControlFlow = list(text = p$green, bold = FALSE),
  Operator = list(text = p$yellow),
  Function = list(text = p$blue),
  Variable = list(text = p$violet),
  VerbatimString = Variable,
  Other = Variable,
  Constant = list(text = p$orange),
  Error = list(text = p$orange),
  Alert = Error,
  Warning = Error,
  Float = list(text = p$magenta),
  DecVal = Float,
  BaseN = Float,
  SpecialChar = list(text = p$blue),
  String = list(text = p$cyan),
  Char = String,
  SpecialString = String,
  Attribute = list(text = p$base00),
  Import = list(text = p$green, italic = TRUE)
)

j2 <- patch_theme_text_style(j, patches)
waldo::compare(new, j2)

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
