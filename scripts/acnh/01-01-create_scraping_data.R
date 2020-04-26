library(jsonlite)

wiki_urls <- list(
  acnh_crafting = list(
    name = "acnh_crafting",
    url = "https://animalcrossing.fandom.com/wiki/Crafting_materials_(New_Horizons)",
    mode = "web",
    selector = ".article-table"
  ),
  acnh_diy_tools = list(
    name = "acnh_diy_tools",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(14)"
  ),
  acnh_diy_housewares = list(
    name = "acnh_diy_housewares",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(16)"
  ),
  acnh_diy_misc = list(
    name = "acnh_diy_misc",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(18)"
  ),
  acnh_diy_wallmount = list(
    name = "acnh_diy_wallmount",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(20)"
  ),
  acnh_diy_wallfloorrug = list(
    name = "acnh_diy_wallfloorrug",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(22)"
  ),
  acnh_diy_equipment = list(
    name = "acnh_diy_equipment",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(24)"
  ),
  acnh_diy_other = list(
    name = "acnh_diy_other",
    url = "https://animalcrossing.fandom.com/wiki/DIY_recipes",
    mode = "web",
    selector = "table.article-table:nth-child(26)"
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
    selector = "table.roundy:nth-child(1)"
  )
)

# write out the list into json file
jsonlite::write_json(wiki_urls,
                     here::here("data", "original", "urls.json"),
                     pretty = TRUE,
                     auto_unbox = TRUE)
