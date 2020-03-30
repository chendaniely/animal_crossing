library(jsonlite)
library(here)
library(rvest)
library(tibble)
library(purrr)
library(readr)

get_html_pth <- function(name) {
 return(here::here("data", "processed", "html", glue::glue("{name}.html")))
}

extract_table <- function(ac_page_info) {
    df <- ac_page_info$name %>%
        get_html_pth() %>%
        xml2::read_html() %>%
        rvest::html_node(css = ac_page_info$selector) %>%
        rvest::html_table(fill = TRUE) # e.g., wall/floors/rugs have inconsistent num of columns in table

    print(ac_page_info$name)
    print(dim(df))
    head(df)

    return(df)
}

url_data <- jsonlite::read_json(here::here("data", "original", "urls.json"))

#ac_page_info <- url_data[[1]]

acnh_data <- purrr::map(url_data, purrr::safely(extract_table))

purrr::transpose(acnh_data)

df_names <- purrr::map_chr(url_data, ~ .$name)

purrr::walk2(purrr::transpose(acnh_data)$result,
             here::here("data", "original", glue::glue("{df_names}.tsv")),
             readr::write_tsv)

purrr::walk(acnh_data, head, n = 1)