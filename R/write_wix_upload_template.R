require(dplyr)
require(readr)

#' write_wix_upload_template
#' 
#' given a dataframe representing zotero data, gets the relevant fields and writes a wix upload template file to out
#'
#' @param df 
#' @param out 
#'
#' @return
#' @export
#'
#' @examples
#' ```
#' source(here::here("R/get_zotero_csv.R"))
#' source(here::here("R/write_wix_upload_template.R"))
#' t1 <- get_zotero_csv(pth = here::here("data/in/zotero/nanxiu_qian_library.csv")) %>% 
#'     write_wix_upload_template(out = here::here("data/temp", "test.csv"))
#' ```
write_wix_upload_template <- function(df, out){
    t1 <- df %>% 
        filter(
            nanxiu_tag != "Obituary"
        ) %>%
        mutate(
            cover_image_url = case_when(
                is.na(cover_image_url) ~ "https://static.wixstatic.com/shapes/b1c6b9_dbbec2c930a84ab0bfd718e22632ba05.svg"
                , TRUE ~ cover_image_url
            )
            , alt_text = "Preview"
        ) %>% 
        rename(
            `Title` = title
            , `Image` = cover_image_url
            , `Alt Text` = alt_text
            , `Type` = item_type_displayname
            , `Year` = publication_year
            , `Authors` = authors
            , `Publication` = publication_title
            , `URL` = url
            , `Citation` = abstract_note
            , `Category` = nanxiu_tag
            , `Notes` = notes
        ) %>% 
        select(
            `Title`
            , `Image`
            , `Alt Text`
            , `Type`
            , `Year`
            , `Authors`
            , `Publication`
            , `URL`
            , `Citation`
            , `Category`
            , `Notes`
        ) %>% 
        arrange(
            `Type`
            , `Year`
            , `Title`
        )
    t1 %>% readr::write_csv(file = out, na = "", quote = "all")
    return(t1)
}