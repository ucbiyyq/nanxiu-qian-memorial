library(dplyr)

# try out citr? ----
require(citr)

# ... ok we have some install problems ...

# or maybe just read the library as json? ----
# library has to be exported as CSL JSON
require(jsonlite)
t1 <- get_zotero_json(pth = here::here("data/in/zotero/My Library.json"))

# or maybe read library as csv? ----
source(here::here("R/get_zotero_csv.R"))
source(here::here("R/write_wix_upload_template.R"))
t1 <- get_zotero_csv(pth = here::here("data/in/zotero/nanxiu_qian_publications.csv")) %>% 
    write_wix_upload_template(out = here::here("data/temp", "wix_uploads.csv"))

# converts text to placeholder ??? ----
source(here::here("R/write_placeholder_ris.R"))
t1 <- write_placeholder_ris(
    pth = here::here("data/temp/input_journal_articles_misc.txt")
    , ty = "JOUR"
    , kw = "Nanxiu -- Journal Articles, Book Chapters, and Review Essays"
    , out = here::here("data/temp/placeholder_journal_articles_misc.ris")
)
t1 <- write_placeholder_ris(
    ty = "JOUR"
    , pth = here::here("data/temp/input_book_reviews.txt")
    , kw = "Nanxiu -- Book Reviews"
    , out = here::here("data/temp/placeholder_book_reviews.ris")
)
t1 <- write_placeholder_ris(
    ty = "ENCYC"
    , pth = here::here("data/temp/input_encyclopedia_entries.txt")
    , kw = "Nanxiu -- Encyclopedia Entries"
    , out = here::here("data/temp/placeholder_encyclopedia_entries.ris")
)
t1 <- write_placeholder_ris(
    ty = "JOUR"
    , pth = here::here("data/temp/input_translations_from_en_to_zh.txt")
    , kw = "Nanxiu -- Translations from English to Chinese"
    , out = here::here("data/temp/placeholder_translations_from_en_to_zh.ris")
)
t1 <- write_placeholder_ris(
    ty = "JOUR"
    , pth = here::here("data/temp/input_translations_from_zh_to_en.txt")
    , kw = "Nanxiu -- Translations from Chinese to English"
    , out = here::here("data/temp/placeholder_translations_from_zh_to_en.ris")
)
t1 <- write_placeholder_ris(
    ty = "JOUR"
    , pth = here::here("data/temp/input_creative_writing.txt")
    , kw = "Nanxiu -- Creative Writing"
    , out = here::here("data/temp/placeholder_creative_writing.ris")
)
t1 <- write_placeholder_ris(
    ty = "CONF"
    , pth = here::here("data/temp/input_conference_papers.txt")
    , kw = "Nanxiu -- Conference Papers"
    , out = here::here("data/temp/placeholder_conference_papers.ris")
)
