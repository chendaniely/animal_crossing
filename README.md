# Animal Crossing

This data is all pulled form the Animal Crossing wiki: https://animalcrossing.fandom.com/wiki/Animal_Crossing_Wiki

The datasets can be found in the `data/original` folder. So far only the tables for New Horizons were pulled.
The data in the `data/original` folder are the raw tables from the website.
More processing can be done to get information like "size of furniture" and "materials for diy builds".
This information all lies within the raw html part of the respetive columns, I just have not parsed them yet.

**If you don't want to process the html strings for the materials and size columns, I've cleaned them for you in the `data/final/without_raw_html` folder**

For the `acnh_bugs_*` and `acnh_fish_*` datasets the `n` and `s` suffix denotes the norther and southern hemisphere, respectively.

## How to download

If you don't know your way around git, click the green "Clone or download" button above, and download the zip snapshot from there.

## Teaching

This could be a decent teaching dataset for cleaning data ... or it just helps us pay off our debts to Tom Nook, who knows.

## Packages

This repository contains the repo for the R package as a Git submodule.

- Link to the github repository: https://github.com/chendaniely/animalcrossing
- The submodule is found under `pkg/R`
