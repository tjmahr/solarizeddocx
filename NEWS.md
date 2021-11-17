# solarizeddocx 0.0.1.9000

  - Added theme-building functions: `copy_base_pandoc_theme()`,
    `set_theme_text_style()`, `patch_theme_text_style()`,
    `write_pandoc_theme()`.

  - Added third parties to DESCRIPTION (solarized, pandoc, KDE syntax
    definition).
  
  - Added `file_code_block()` for a small syntax example.

  - Added `colors_solarized_light()` for the color names.

  - Changed reference docx file to add a `Source Code` paragraph style. This
    style is not part of the built-in reference docx but code blocks have this
    style in the docx files created by pandoc. Customized this style so that
    there is a small amount (2 pts) of padding around the code.
    
  - Fixed syntax definition highlighting so that `var_1` would not spuriously
    highlight the final 1.
    
  - Added a `NEWS.md` file to track changes to the package.
  
  - Added other usethis niceties.
  
# solarizeddocx 0.0.1

Initial release.
