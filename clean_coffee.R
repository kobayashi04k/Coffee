library(tidyverse)
library(janitor)

clean_coffee <- read_csv("data/arabica_data_cleaned.csv") %>%
          clean_names()

(distinct(clean_coffee, country_of_origin))


#write_csv(clean_coffee,"data/cleaned_coffee.csv")
