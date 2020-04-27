library(jsonlite)
library(purrr)
library(glue)
library(here)
library(httr)


## Functions -----


get_response <- function(url) {
  response <- httr::GET(url)
  stat_cde <- httr::status_code(response)
  if (stat_cde != 200) {
    stop(glue::glue("Expected status 200, got {stat_cde}"))
  }

  return(response)
}

web_html <- function(url, save_pth) {

  res <- get_response(url)

  html_page <- xml2::read_html(res)
  xml2::write_html(html_page, save_pth)
}

#' Generates the javascript code to be run by phantomjs
#' This will generate the html if it is dynamically generated using javascript
phantomjs_html <- function(url, save_pth) {

    phantomjs_script <- glue::glue("
var webPage = require('webpage');
var page = webPage.create();

var fs = require('fs');
var path = '<<save_pth>>'

page.open('<<url>>', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});
",  .open = "<<", .close = ">>",)

    return(phantomjs_script)
}

#' Creates a tempfile of the javascript code and calls phantomjs to run it
run_phantom_script <- function(url, name) {
    response <- get_response(url) ## using this for the status check side-effect

    temp <- tempfile()
    on.exit(unlink(temp))
    writeLines(phantomjs_html(url, name), con = temp)
    system(glue::glue("phantomjs {temp}"))
}

run_web_phantom <- function(url_info) {

  name <- url_info$name
  save_pth <- here::here("data", "original", "html", glue::glue("{name}.html"))

  if (fs::file_exists(save_pth)) { # if the file exists don't do anything
    return(NULL)
  } else {
    if (url_info$mode == "web") {
      web_html(url_info$url, save_pth)
    } else if (url_info$mode == "phantomjs") {
      run_phantom_script(url_info$url, save_pth)
    } else {
      stop("Unknown mode")
    }
  }
}


## Script -----


wiki_urls <- jsonlite::read_json(here::here("data", "original", "urls.json"))

# save the html files
purrr::walk(wiki_urls, run_web_phantom)
