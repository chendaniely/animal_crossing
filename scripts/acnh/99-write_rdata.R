library(readr)
library(purrr)
library(fs)
library(here)
library(glue)

clean_dat <- fs::dir_ls(here::here("data", "final", "without_raw_html"))

dat_f <- fs::path_file(clean_dat) %>%
    fs::path_ext_remove()

dfs <- purrr::map(
    clean_dat,
    readr::read_tsv
)


rds_pth <- here::here("pkg", "R", "animalcrossing", "data", glue::glue("{dat_f}.RData"))

purrr::walk2(cleaned_dfs, rds_pth,
             function(x, y) {
                 var_name <- fs::path_ext_remove(fs::path_file(y))
                 assign(var_name, x)
                 save(list = var_name, file=y)
             })
