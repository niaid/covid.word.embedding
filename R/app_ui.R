#' @import shiny
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          mod_add_word_ui("add_word_ui_1"),
          mod_subtract_word_ui("subtract_word_ui_1"),
          mod_calc_word_vector_ui("calc_word_vector_ui_1")
        ),
        mainPanel(
          mod_nearest_words_table_ui("nearest_words_table_ui_1")
        )
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'covid.word.embedding')
  )
  
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
