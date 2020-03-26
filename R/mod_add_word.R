# Module UI
  
#' @title   mod_add_word_ui and mod_add_word_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_add_word
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_add_word_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectizeInput(ns("in1"), "Add words", choices = NULL,
                multiple = TRUE)
  )
}
    
# Module Server
    
#' @rdname mod_add_word
#' @export
#' @keywords internal
    
mod_add_word_server <- function(input, output, session){
  ns <- session$ns

  updateSelectizeInput(session, 'in1', choices = row.names(wv_main), server = TRUE)
  
  return(
    reactive({
      input$in1
    })
  )
}
    
## To be copied in the UI
# mod_add_word_ui("add_word_ui_1")
    
## To be copied in the server
# callModule(mod_add_word_server, "add_word_ui_1")
 
