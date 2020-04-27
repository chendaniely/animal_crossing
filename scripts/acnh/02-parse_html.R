library(jsonlite)
library(here)
library(rvest)
library(tibble)
library(purrr)
library(readr)


## funtions -----
get_html_pth <- function(name) {
 return(here::here("data", "original", "html", glue::glue("{name}.html")))
}

extract_table_node <- function(ac_page_info) {
    ac_html <- ac_page_info$name %>%
        get_html_pth() %>%
        xml2::read_html()

    if (ac_page_info$selector != "") {
        tbl <- rvest::html_node(ac_html, css = ac_page_info$selector)
    } else if (ac_page_info$selector == "" & ac_page_info$xpath != "") {
        tbl <- rvest::html_node(ac_html, xpath = ac_page_info$xpath)
    } else {
        stop("Unknown css selector or xpath")
    }
    return(tbl)
}

extract_table <- function(ac_page_info) {

    tbl <- extract_table_node(ac_page_info)

    df <- rvest::html_table(tbl, fill = TRUE) # e.g., wall/floors/rugs have inconsistent num of columns in table

    print(ac_page_info$name)
    print(dim(df))
    head(df)

    return(df)
}


## script -----
## extract html tables -----

url_data <- jsonlite::read_json(here::here("data", "original", "urls.json"))

acnh_data <- purrr::map(url_data, purrr::safely(extract_table))
transposed <- purrr::transpose(acnh_data)

# check to make sure there were no errors
stopifnot(length(acnh_data) == 16)
errs <- transposed$error
stopifnot(all(purrr::map_lgl(errs, is.null)))


## add image and size html -----

add_image_size_html <- function(data, url_data) {

    if (is.null(url_data$image) & is.null(url_data$size)) {return(data)}

    data_html <- get_html_pth(url_data$name) %>%
        xml2::read_html()

    if (!is.null(url_data$image)) {
        image_html <- data_html %>%
            rvest::html_nodes(css = url_data$image$selector) %>%
            rvest::html_node(css = "a") %>%
            rvest::html_attr("href")

        data$Image <- image_html
    }

    if (!is.null(url_data$size)) {
        size_html <- data_html %>%
            rvest::html_nodes(css = url_data$size$selector) %>%
            rvest::html_node(css = "a") %>%
            rvest::html_attr("href")
        data$Size <- size_html
    }

    return(data)
}

parsed_dfs <- purrr::map2(transposed$result, url_data, add_image_size_html)

## Save data to tsv -----
df_names <- purrr::map_chr(url_data, ~ .$name)

purrr::walk2(parsed_dfs,
             here::here("data", "processed", "from_html", glue::glue("{df_names}.tsv")),
             readr::write_tsv)

# Wrting to RData done in separate script
# purrr::walk2(purrr::transpose(acnh_data)$result,
#              here::here("pkg", "R", "animalcrossing", "data",
#                         glue::glue("{df_names}.RData")),
#              function(x, y) {
#                  var_name <- fs::path_ext_remove(fs::path_file(y))
#                  assign(var_name, x)
#                  save(list = var_name, file=y)
#              })
