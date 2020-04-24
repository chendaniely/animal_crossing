library(here)
library(readr)
library(dplyr)
library(stringr)
library(rvest)
library(purrr)
library(fs)
library(janitor)

source(here::here("scripts", "acnh", "get_img_src.R"))
source(here::here("scripts", "acnh", "get_num_bells.R"))

bugs_n <- readr::read_tsv(here::here("data", "original", "acnh_bugs_n.tsv"))
bugs_n_cleaned <- bugs_n %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src))


bugs_s <- readr::read_tsv(here::here("data", "original", "acnh_bugs_s.tsv"))
bugs_s_cleaned <- bugs_s %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src))


crafting <- readr::read_tsv(here::here("data", "original", "acnh_crafting.tsv"))
crafting_cleaned <- crafting %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src)) %>%
    dplyr::mutate(item_sell_price = purrr::map_dbl(item_sell_price, get_number_bells))


fish_n <- readr::read_tsv(here::here("data", "original", "acnh_fish_n.tsv"))
fish_n_cleaned <-  fish_n %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src))


fish_s <- readr::read_tsv(here::here("data", "original", "acnh_fish_s.tsv"))
fish_s_cleaned <-  fish_s %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src))


villagers <- readr::read_tsv(here::here("data", "original", "acnh_villagers.tsv"))
villagers_cleaned <-  villagers %>%
    janitor::clean_names() %>%
    dplyr::mutate(image = purrr::map_chr(image, get_img_src)) %>%
    dplyr::mutate(catchphrase = stringr::str_replace_all(catchphrase, "\\\"", ""))

gender_personality <- stringr::str_split_fixed(villagers_cleaned$personality, " ", 2)

villagers_cleaned <- villagers_cleaned %>%
    dplyr::mutate(
        gender = gender_personality[, 1],
        personality = gender_personality[, 2]
    )

readr::write_tsv(bugs_n_cleaned, here::here("data", "final", "without_raw_html", "acnh_bugs_n.tsv"))
readr::write_tsv(bugs_s_cleaned, here::here("data", "final", "without_raw_html", "acnh_bugs_s.tsv"))
readr::write_tsv(crafting_cleaned, here::here("data", "final", "without_raw_html", "acnh_crafting.tsv"))
readr::write_tsv(fish_n_cleaned, here::here("data", "final", "without_raw_html", "acnh_fish_n.tsv"))
readr::write_tsv(fish_s_cleaned, here::here("data", "final", "without_raw_html", "acnh_fish_s.tsv"))
readr::write_tsv(villagers_cleaned, here::here("data", "final", "without_raw_html", "acnh_villagers.tsv"))
