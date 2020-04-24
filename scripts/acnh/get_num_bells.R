get_number_bells <- function(string) {
    if (is.na(string)) {return(NA)}

    return(
        string %>%
        stringr::str_replace(",", "") %>%
        stringr::str_replace("[Bb]ells", "") %>%
        stringr::str_replace("<.*>", "") %>%
        stringr::str_trim() %>%
        as.numeric()
    )
}
