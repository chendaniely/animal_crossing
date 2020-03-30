library(xml2)
library(httr)
library(rvest)
library(glue)
library(purrr)
lirbary(here)
library(jsonlite)
library(readr)

extract_table <- function(url, selector, name) {
    ac_page <- list(
        name = name,
        url = url,
        selector = selector
    )

    response <- httr::GET(ac_page$url)

    stat_cde <- httr::status_code(response)
    if (stat_cde != 200) {
        stop(glue::glue("Expected status 200, got {stat_cde}"))
    }

    # TODO
    # convert from httr to rvest
    # this will reduce pinging the server twice
    # cont <- httr::content(response, "text")
    # wiki_page <- xml2::read_html(cont)

    tbl <- ac_page$url %>%
        xml2::read_html() %>%
        rvest::html_node(css = ac_page$selector) %>%
        rvest::html_table(fill = TRUE) # e.g., wall/floors/rugs have inconsistent num of columns in table

    print(ac_page$name)
    print(dim(tbl))
    head(tbl)
    return(tbl)
}

extract_table_mapper <- function(wiki_url_info) {
    return(
        extract_table(url = wiki_url_info$url, selector = wiki_url_info$selector, name = wiki_url_info$name)
    )
}



test_case <- wiki_urls$acnh_fish_n

ac_page <- list(
    name = test_case$name,
    url = test_case$url,
    selector = test_case$selector
)

response <- httr::GET(ac_page$url)

stat_cde <- httr::status_code(response)
stat_cde
# div.table-wrapper:nth-child(1) > div:nth-child(1) > table:nth-child(1)
# table.roundy:nth-child(2) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(1)
tbl <- ac_page$url %>%
    xml2::read_html() %>%
    rvest::html_node(css = "div.table-wrapper:nth-child(2) > div:nth-child(1) > table:nth-child(1)") %>%
    rvest::html_table(fill = TRUE)


extract_table(test_case$url, test_case$selector, test_case$name)

# extract the tables from each page
acnh_dfs <- purrr::map(wiki_urls, extract_table_mapper)

# get the names field that will be used as the file name
df_names <- purrr::map_chr(wiki_urls, ~ .$name)

# save the dataframes into individual tsv files
purrr::walk2(acnh_dfs,
             here::here("output", glue::glue("{df_names}.tsv")),
             readr::write_tsv)

# save the wiki_urls list as a json file
jsonlite::write_json(wiki_urls, here::here("output", "crafting.json"), pretty = TRUE), na = TRUE)



wiki_urls_critters <- list(

)

phantomjs_script = glue::glue("

",  .open = "<<", .close = ">>")

system("phantomjs ./scripts/scrape_critters.js")

df <- "critters.html" %>%
    rvest::html() %>%
    rvest::html_node(css = "div.tabbertab:nth-child(1) > div:nth-child(2) > div:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > div:nth-child(1) > div:nth-child(1) > table:nth-child(1)") %>%
    rvest::html_table(fill = TRUE)

head(df)