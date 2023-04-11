require(dplyr)
require(jsonlite)
require(tibble)
require(tidyr)
require(janitor)

#' get_zotero_json
#' 
#' given path to csl json zotero export file, returns dataframe
#' DO NOT USE YET
#'
#' @param pth 
#'
#' @return
#' @export
#'
#' @examples
get_zotero_json <- function(pth){
    t1 <- jsonlite::read_json(pth) %>% 
        tibble::tibble(data = .) %>% 
        tidyr::unnest_wider(data) %>% 
        janitor::clean_names()
    # TODO uhoh, json missing attachment urls
    return(t1)
}