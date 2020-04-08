library(here)
library(fs)
library(readr)
library(stringr)
library(testthat)
library(tibble)
library(janitor)
library(dplyr)
library(purrr)

#' extracts the dimensions of the object from the img html tag
#' Example img tag code:
#' <img src="https://vignette.wikia.nocookie.net/animalcrossing/images/d/d7/NH1.0x1.0sq.jpg/revision/latest?cb=20200324214412" alt="NH1.0x1.0sq" class="" data-image-key="NH1.0x1.0sq.jpg" data-image-name="NH1.0x1.0sq.jpg" width="31" height="31" >
parse_size <- function(size_html_string) {
    # extract the dimensions from the text between "NH" and "sq.jpeg"
    return(
        stringr::str_match(string = size_html_string,
                           pattern = "NH(.*?)sq\\.jpg"
        )[, 2]
    )
}

testthat::expect_equal(
    parse_size('<img src="https://vignette.wikia.nocookie.net/animalcrossing/images/d/d7/NH1.0x1.0sq.jpg/revision/latest?cb=20200324214412" alt="NH1.0x1.0sq" class="" data-image-key="NH1.0x1.0sq.jpg" data-image-name="NH1.0x1.0sq.jpg" width="31" height="31" >'),
    '1.0x1.0'
)

#' Example text and code for materials:
#' 8x <img src="https://vignette.wikia.nocookie.net/animalcrossing/images/f/f2/NH-softwood-icon.png/revision/latest/scale-to-width-down/18?cb=20200328195710" alt="NH-softwood-icon" class="" data-image-key="NH-softwood-icon.png" data-image-name="NH-softwood-icon.png" width="18" height="18" >softwood 3x <img src="https://vignette.wikia.nocookie.net/animalcrossing/images/f/fa/NH-iron_nugget-icon.png/revision/latest/scale-to-width-down/18?cb=20200328195115" alt="NH-iron nugget-icon" class="" data-image-key="NH-iron_nugget-icon.png" data-image-name="NH-iron nugget-icon.png" width="18" height="18" >iron nugget
parse_materials <- function(materials_string) {
    rm_img <- stringr::str_remove_all(string = materials_string,
                                      pattern = "<img.*?>")
    comma_delimit <- stringr::str_replace_all(string = rm_img,
                                              pattern = "\\s+(?=\\d+x)", # look for the space before a numberx, e.g., 3x
                                              replacement = ", ")
    return(comma_delimit)
}

testthat::expect_equal(
    parse_materials('8x <img src="https://vignette.wikia.nocookie.net/animalcrossing/images/f/f2/NH-softwood-icon.png/revision/latest/scale-to-width-down/18?cb=20200328195710" alt="NH-softwood-icon" class="" data-image-key="NH-softwood-icon.png" data-image-name="NH-softwood-icon.png" width="18" height="18" >softwood 3x <img src="https://vignette.wikia.nocookie.net/animalcrossing/images/f/fa/NH-iron_nugget-icon.png/revision/latest/scale-to-width-down/18?cb=20200328195115" alt="NH-iron nugget-icon" class="" data-image-key="NH-iron_nugget-icon.png" data-image-name="NH-iron nugget-icon.png" width="18" height="18" >iron nugget'),
        '8x softwood, 3x iron nugget'
)

clean_df <- function(input_pth, clean_fxn) {
    print(input_pth)
    df <- readr::read_tsv(input_pth) %>%
        janitor::clean_names()

    # process materials
    if (stringr::str_detect(clean_fxn, "m")) {
        if (!"materials_needed" %in% names(df)) {print(names(df)); stop("cannot find 'materials_needed' column")}
        df <- df %>%
            dplyr::mutate(materials_needed_clean = purrr::map_chr(materials_needed, parse_materials))
    }

    # process size
    if (stringr::str_detect(clean_fxn, "s")) {
        if (!"size" %in% names(df)) {print(names(df)); stop("cannot find 'size' column")}
        df <- df %>%
            dplyr::mutate(size_clean = purrr::map_chr(size, parse_size))
    }
    return(df)
}

# script -----

diy_data_pths <- fs::dir_ls(here::here("data", "original"), glob = "*diy*")

params <- tibble::tibble(input_file_pth = diy_data_pths) %>%
    dplyr::mutate(
        output_file_pth = stringr::str_replace(diy_data_pths, "original", "final"),
        clean_fxn = dplyr::case_when(
            stringr::str_detect(output_file_pth, "acnh_diy_wallfloorrug") ~ "m",
            TRUE ~ "m+s"),
        rds_pth = here::here("pkg", "R", "animalcrossing", "data",
            glue::glue("{fs::path_ext_remove(fs::path_file(diy_data_pths))}.RData"))
    )
params

cleaned_dfs <- purrr::map2(params$input_file_pth, params$clean_fxn, clean_df)

purrr::walk2(cleaned_dfs, params$output_file_pth, readr::write_tsv)
purrr::walk2(cleaned_dfs, params$rds_pth,
             function(x, y) {
                 var_name <- fs::path_ext_remove(fs::path_file(y))
                 assign(var_name, x)
                 save(list = var_name, file=y)
             })
