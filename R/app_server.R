#' @import shiny
app_server <- function(input, output,session) {
  add <- callModule(mod_add_word_server, "add_word_ui_1")
  subtract <- callModule(mod_subtract_word_server, "subtract_word_ui_1")
  wv <- callModule(mod_calc_word_vector_server, "calc_word_vector_ui_1", react_add = add, react_subtract = subtract)
  callModule(mod_nearest_words_table_server, "nearest_words_table_ui_1", react_wv = wv)
}
