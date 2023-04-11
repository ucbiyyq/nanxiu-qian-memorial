require(dplyr)
require(tidyr)
require(janitor)
require(readr)
require(stringr)
require(urltools)

#' get_zotero_csv
#' 
#' given path to csv zotero export file, returns dataframe
#'
#' @param pth 
#'
#' @return
#' @export
#'
#' @examples
get_zotero_csv <- function(pth){
    # gets basic data
    basic <- readr::read_csv(pth) %>% 
        janitor::clean_names() %>% 
        mutate(
            publication_year = as.integer(publication_year)
            , item_type_displayname = case_when(
                item_type == "book" ~ "Book"
                , item_type == "journalArticle" ~ "Journal Article"
                , TRUE ~ item_type
            )
        )
    # gets authors
    authors <- basic %>%
        select(
            key
            , author
            , editor
        ) %>% 
        tidyr::pivot_longer(!key, names_to = "role", values_to = "name") %>% 
        tidyr::separate_rows(name, sep = ";") %>% 
        filter(!is.na(name)) %>% 
        mutate(
            name = stringr::str_trim(name)
        ) %>% 
        group_by(key) %>% 
        mutate(
            authors = stringr::str_c(role, name, sep = ": ", collapse = "; ")
            , rnk = row_number()
        ) %>% 
        ungroup() %>% 
        tidyr::nest(authors_df = c("role", "rnk", "name")) %>% 
        select(
            key
            , authors_df
            , authors
        )
    
    # gets attachments
    # TODO figure out file attachments later
    attachments <- basic %>% 
        select(
            key
            , link_attachments
            # , file_attachments
        ) %>% 
        tidyr::pivot_longer(!key, names_to = "attachment_type", values_to = "attachment_url") %>% 
        tidyr::separate_rows(attachment_url, sep = ";") %>% 
        filter(!is.na(attachment_url)) %>% 
        mutate(
            attachment_url = stringr::str_trim(attachment_url)
            , attachment_url_parsed = urltools::url_parse(attachment_url)
            , attachment_domain = attachment_url_parsed$domain
        ) %>% 
        tidyr::nest(attachments_df = !key)
    
    # assumes every key only has a single wix static image resource
    attachments_cover <- attachments %>% 
        tidyr::unnest(attachments_df) %>% 
        filter(attachment_type == "link_attachments" & attachment_domain == "static.wixstatic.com") %>% 
        arrange(key, attachment_url) %>% 
        group_by(key) %>% 
        slice(1) %>% 
        rename(cover_image_url = attachment_url) %>% 
        select(key, cover_image_url)
    
    # gets Nanxiu's tags for category of document
    nanxiu_tags <- basic %>% 
        select(key, manual_tags) %>% 
        tidyr::separate_rows(manual_tags, sep = ";") %>% 
        mutate(manual_tags = stringr::str_trim(manual_tags)) %>% 
        filter(stringr::str_detect(manual_tags, "Nanxiu -- ")) %>% 
        tidyr::separate(manual_tags, into = c("t1", "nanxiu_tag"), sep = " -- ") %>% 
        select(key, nanxiu_tag)
    
    # combo
    combo <- basic %>% 
        left_join(authors, by = "key") %>% 
        left_join(attachments, by = "key") %>% 
        left_join(attachments_cover, by = "key") %>% 
        left_join(nanxiu_tags, by = "key") %>% 
        select(
            key
            , item_type
            , publication_year
            , author
            , title
            , publication_title
            , isbn
            , issn
            , doi
            , url
            , abstract_note
            , date
            , date_added
            , date_modified
            , access_date
            , pages
            , num_pages
            , issue
            , volume
            , number_of_volumes
            , journal_abbreviation
            , short_title
            , series
            , series_number
            , series_text
            , series_title
            , publisher
            , place
            , language
            , rights
            , type
            , archive
            , archive_location
            , library_catalog
            , call_number
            , extra
            , notes
            , file_attachments
            , link_attachments
            , manual_tags
            , automatic_tags
            , editor
            , series_editor
            , translator
            , contributor
            , attorney_agent
            , book_author
            , cast_member
            , commenter
            , composer
            , cosponsor
            , counsel
            , interviewer
            , producer
            , recipient
            , reviewed_author
            , scriptwriter
            , words_by
            , guest
            , number
            , edition
            , running_time
            , scale
            , medium
            , artwork_size
            , filing_date
            , application_number
            , assignee
            , issuing_authority
            , country
            , meeting_name
            , conference_name
            , court
            , references
            , reporter
            , legal_status
            , priority_numbers
            , programming_language
            , version
            , system
            , code
            , code_number
            , section
            , session
            , committee
            , history
            , legislative_body
            , item_type_displayname
            , authors_df
            , authors
            , attachments_df
            , cover_image_url
            , nanxiu_tag
        ) %>% 
        arrange(key)
        
    return(combo)
}