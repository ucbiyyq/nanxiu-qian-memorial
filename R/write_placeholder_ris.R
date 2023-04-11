require(dplyr)
require(readr)
require(tidyr)

#' write_placeholder_ris
#' 
#' given path to a delimited input file, writes a placeholder ris file to out path
#' useful for uploading bulk entries into zotero
#'
#' @param pth 
#' @param ty 
#' @param kw 
#' @param out 
#'
#' @return
#' @export
#'
#' @examples
#' ```
#' t1 <- write_placeholder_ris(
#'     pth = here::here("data/temp/input_journal_articles_misc.txt")
#'     , ty = "JOUR"
#'     , kw = "Nanxiu -- Journal Articles, Book Chapters, and Review Essays"
#'     , out = here::here("data/temp/placeholder_journal_articles_misc.ris")
#' )
#' ```
write_placeholder_ris <- function(pth, ty, kw, out) {
    # try to convert to placeholder RIS
    t1 <- readr::read_delim(file = pth, delim = "\n", quote = "", col_names = "AB") %>% 
        mutate(
            TY = ty
            , KW = kw
            , ER = NA_character_
        ) %>% 
        select(TY, AB, KW, ER) %>% 
        tidyr::pivot_longer(cols = c("TY", "AB", "KW", "ER"), names_to = "field", values_to = "value") %>% 
        mutate(
            output = glue::glue("{field}  - {value}", .na = "")
        ) %>% 
        select(output)
    t1 %>% readr::write_delim(file = out, col_names = FALSE, quote = "none")
    return(t1)
}