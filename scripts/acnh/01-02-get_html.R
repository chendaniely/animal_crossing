library(jsonlite)
library(purrr)
library(glue)
library(here)
library(httr)

get_response <- function(url) {
  response <- httr::GET(url)
  stat_cde <- httr::status_code(response)
  if (stat_cde != 200) {
    stop(glue::glue("Expected status 200, got {stat_cde}"))
  }

  return(response)
}

#' Generates the javascript code to be run by phantomjs
#' This will generate the html if it is dynamically generated using javascript
phantomjs_html <- function(url, name) {

    pth <- here::here("data", "processed", "html", glue::glue("{name}.html"))

    phantomjs_script <- glue::glue("
var webPage = require('webpage');
var page = webPage.create();

var fs = require('fs');
var path = '<<pth>>'

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
    response <- get_response(ur)

    temp <- tempfile()
    on.exit(unlink(temp))
    writeLines(phantomjs_html(url, name), con = temp)
    system(glue::glue("phantomjs {temp}"))
}

run_phantom_script_mapper <- function(url_info) {
    run_phantom_script(url_info$url, url_info$name)
}

# save the html files from the url using  phantomjs
purrr::walk(wiki_urls, run_phantom_script_mapper)
