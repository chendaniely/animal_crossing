library(here)
library(readr)
library(dplyr)
library(stringr)
library(rvest)
library(purrr)
library(fs)

source(here::here("scripts", "acnh", "get_img_src.R"))
source(here::here("scripts", "acnh", "get_num_bells.R"))

clean_diy <- function(dat) {
    col_names <- names(dat)
    if ("materials_needed" %in% col_names & "materials_needed_clean" %in% col_names) {
        dat <- dplyr::select(dat, -materials_needed) %>%
            dplyr::rename(materials_needed = materials_needed_clean)
    }
    if ("size" %in% col_names & "size_clean" %in% col_names) {
        dat <- dplyr::select(dat, -size) %>%
            dplyr::rename(size = size_clean)
    }
    if ("x6" %in% col_names) {
        dat <- dplyr::select(dat, -x6)
    }
    if ("x7" %in% col_names) {
        dat <- dplyr::select(dat, -x7)
    }
    if ("image" %in% col_names) {
        dat <- dplyr::mutate(dat, image = purrr::map_chr(image, get_img_src))
    }
    if ("sell_price" %in% col_names) {
        dat <- dplyr::mutate(dat, sell_price = purrr::map_dbl(sell_price, get_number_bells))
    }


    return(dat)
}

diy_data_pths <- fs::dir_ls(here::here("data", "processed"), glob = "*diy*")

# the diy_villager is a special table that isn't like the other diy tables
diy_data_pths <- diy_data_pths[!stringr::str_detect(diy_data_pths, '_diy_villager')]

diy_dats <- purrr::map(diy_data_pths, readr::read_tsv)

cleaned_dfs <- purrr::map(diy_dats, clean_diy)


fs::dir_create(here::here("data", "final", "without_raw_html"))
diy_save_pths <- here::here("data", "final", "without_raw_html", fs::path_file(diy_data_pths))

purrr::walk2(cleaned_dfs, diy_save_pths, readr::write_tsv)
