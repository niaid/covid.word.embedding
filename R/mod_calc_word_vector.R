# Module UI

#' @title   mod_calc_word_vector_ui and mod_calc_word_vector_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_calc_word_vector
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_calc_word_vector_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("execute"), "Execute")
  )
}

# Module Server

#' @rdname mod_calc_word_vector
#' @export
#' @keywords internal

mod_calc_word_vector_server <- function(input, output, session, react_add, react_subtract){
  ns <- session$ns
  
  output$wv <- eventReactive(input$execute, {
    req(react_add())
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        wv <- rep(0, 50)
        
        for(i in react_add()){
          wv <- wv + wv_main[i,,drop = F]
        }
        
        for(i2 in react_subtract()){
          wv <- wv - wv_main[i2,,drop = F]
        }
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    return(wv)
  })
}

## To be copied in the UI
# mod_calc_word_vector_ui("calc_word_vector_ui_1")

## To be copied in the server
# callModule(mod_calc_word_vector_server, "calc_word_vector_ui_1")

