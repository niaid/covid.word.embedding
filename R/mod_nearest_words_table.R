# Module UI
  
#' @title   mod_nearest_words_table_ui and mod_nearest_words_table_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_nearest_words_table
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_nearest_words_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("contents"))
  )
}
    
# Module Server
    
#' @rdname mod_nearest_words_table
#' @export
#' @keywords internal
    
mod_nearest_words_table_server <- function(input, output, session, react_wv){
  ns <- session$ns
  
  output$contents <- DT::renderDataTable({
    req(react_wv())
    
    DT::datatable(text2vec::sim2(x = wv_main, y = react_wv(), method = "cosine", norm = "l2") %>%
                    data.frame(row.names = row.names(wv_main)) %>% tibble::rownames_to_column(),
                  caption = "Table 1. Cosine similarity of words to calculated word vector.")
  })
}
    
## To be copied in the UI
# mod_nearest_words_table_ui("nearest_words_table_ui_1")
    
## To be copied in the server
# callModule(mod_nearest_words_table_server, "nearest_words_table_ui_1")
 
