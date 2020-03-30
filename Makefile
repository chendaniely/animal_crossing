.PHONY: data_raw
data_raw:
	Rscript scripts/acnh/01-get_data.R
	Rscript scripts/acnh/02-parse_html.R

.PHONY: data_clean
data_clean:
	Rscript scripts/acnh/03-clean_data.R
