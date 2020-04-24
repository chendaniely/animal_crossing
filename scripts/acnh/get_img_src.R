get_img_src <- function(image_html_text) {
    # using rvest and xml2 becuase i don't want to deal with regex
    if (is.na(image_html_text)){return(NA)}

    # 50px acnh_diy_wallfloorrug
    # Unknown bugs
    if (image_html_text %in% c('50px', 'Unknown')) {return(NA)}

    return(
        image_html_text %>%
        xml2::read_html() %>%
        rvest::html_node("img") %>%
        rvest::html_attr("src")
    )
}
