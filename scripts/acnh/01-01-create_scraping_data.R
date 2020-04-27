library(jsonlite)
library(here)

wiki_urls <- list(
  acnh_crafting_yearly = list(
    name = "acnh_crafting_yearly",
    url = "https://animalcrossing.fandom.com/wiki/Crafting_materials_(New_Horizons)",
    mode = "web",
    selector = "",
    xpath = "/html/body/div[2]/section/div[2]/article/div/div[1]/div[2]/table[2]",
    image = list(
      selector = ".article-table:nth-child(10) td:nth-child(2)"
    )
  ),
  acnh_crafting_seasonal = list(
    name = "acnh_crafting_seasonal",
    url = "https://animalcrossing.fandom.com/wiki/Crafting_materials_(New_Horizons)",
    mode = "web",
    selector = "",
    xpath = "/html/body/div[2]/section/div[2]/article/div/div[1]/div[2]/table[3]",
    image = list(
      selector = ".article-table:nth-child(12) td:nth-child(2)"
    )
  ),
  acnh_diy_tools = list(
    name = "acnh_diy_tools",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Tools",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_housewares = list(
    name = "acnh_diy_housewares",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Housewares",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_misc = list(
    name = "acnh_diy_misc",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Miscellaneous",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_wallmount = list(
    name = "acnh_diy_wallmount",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Wall-mounted",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_wallfloorrug = list(
    name = "acnh_diy_wallfloorrug",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Wallpaper,_rugs_and_flooring",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_equipment = list(
    name = "acnh_diy_equipment",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Equipment",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_other = list(
    name = "acnh_diy_other",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes/Other",
    mode = "web",
    selector = ".article-table",
    image = list(
      selector = "td:nth-child(2)"
    ),
    size = list(
      selector = "td:nth-child(4)"
    )
  ),
  acnh_diy_unconfirmed = list(
    name = "acnh_diy_unconfirmed",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "",
    xpath = "/html/body/div[2]/section/div[2]/article/div/div[1]/div[2]/table[1]",
    image = list(
      selector = ".sortable td:nth-child(2)"
    ),
    size = list(
      selector = ".sortable td:nth-child(4)"
    )
  ),
  acnh_diy_villager = list(
    name = "acnh_diy_villager",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "",
    xpath = "/html/body/div[2]/section/div[2]/article/div/div[1]/div[2]/table[2]"
  ),
  acnh_fish_n = list(
    name = "acnh_fish_n",
    url = "https://animalcrossing.fandom.com/wiki/Fish_(New_Horizons)#Northern%20Hemisphere",
    mode = "phantomjs",
    selector = "div.tabbertab:nth-child(1) > div:nth-child(2) > div:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > div:nth-child(1) > div:nth-child(1) > table:nth-child(1)"
  ),
  acnh_fish_s = list(
    name = "acnh_fish_s",
    url = "https://animalcrossing.fandom.com/wiki/Fish_(New_Horizons)#Southern%20Hemisphere",
    mode = "phantomjs",
    selector = "div.tabbertab:nth-child(1) > div:nth-child(2) > div:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > div:nth-child(1) > div:nth-child(1) > table:nth-child(1)"
  ),
  acnh_bugs_n = list(
    name = "acnh_bugs_n",
    url = "https://animalcrossing.fandom.com/wiki/Bugs_(New_Horizons)#Northern%20Hemisphere",
    mode = "phantomjs",
    selector = "div.tabbertab:nth-child(1) > table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(1) > table:nth-child(1)"
  ),
  acnh_bugs_s = list(
    name = "acnh_bugs_s",
    url = "https://animalcrossing.fandom.com/wiki/Bugs_(New_Horizons)#Southern%20Hemisphere",
    mode = "phantomjs",
    selector = "div.tabbertab:nth-child(1) > table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(1) > table:nth-child(1)"
  ),
  acnh_villagers = list(
    name = "acnh_villagers",
    url = "https://animalcrossing.fandom.com/wiki/Villager_list_(New_Horizons)",
    mode = "web",
    selector = "table.roundy:nth-child(1)",
    image = list(
      selector = ".sortable td:nth-child(2)"
    )
  )
)

# write out the list into json file
jsonlite::write_json(wiki_urls,
                     here::here("data", "original", "urls.json"),
                     pretty = TRUE,
                     auto_unbox = TRUE)
