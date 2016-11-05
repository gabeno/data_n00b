# Challenge:
# ---------
# In this exercise, you'll work with a toy data set showing product purchases
# from an electronics store. While the data set is small and simple, it still
# illustrates many of the challenges you have to address in real-world data
# wrangling!
# The data set and exercise are inspired by this blog post.
#
# Getting started
# The data is in an Excel file here called refine.xlsx. Right away, you'll
# notice that the data set has a few issues:
#   - There are four brands: Philips, Akzo, Van Houten and Unilever. However,
#     there are many different spellings and capitalizations of those names!
#   - The product code and number are combined in one column, separated by a
#     hyphen.
#
# Exercise
# Using R, clean this data set to make it easier to visualize and analyze.
# Specifically, these are the tasks you need to do:
#     
# 0: Load the data in RStudio
#   Save the data set as a CSV file called refine_original.csv and load it in
#   RStudio into a data frame.
# 1: Clean up brand names
#   Clean up the 'company' column, so all of the misspellings of the brand
#   names are standardized. For example, you can transform the values in the
#   column to be: philips, akzo, van houten and unilever (all lowercase).
# 2: Separate product code and number
#   Separate the product code and product number into separate columns i.e.
#   add two new columns called product_code and product_number, containing
#   the product code and number respectively
# 3: Add product categories
#   You learn that the product codes actually represent the following 
#   product categories:
#       p = Smartphone
#       v = TV
#       x = Laptop
#       q = Tablet
#   In order to make the data more readable, add a column with the product
#   category for each record.
# 4: Add full address for geocoding
#   You'd like to view the customer information on a map. In order to do 
#   that, the addresses need to be in a form that can be easily geocoded.
#   Create a new column full_address that concatenates the three address
#   fields (address, city, country), separated by commas.
# 5: Create dummy variables for company and product category
#   Both the company name and product category are categorical variables
#   i.e. they take only a fixed set of values. In order to use them in
#   further analysis you need to create dummy variables. Create dummy 
#   binary variables for each of them with the prefix company_ and product_ i.e.
#   Add four binary (1 or 0) columns for company: company_philips,
#   company_akzo, company_van_houten and company_unilever
#   Add four binary (1 or 0) columns for product category: product_smartphone,
#   product_tv, product_laptop and product_tablet
# 6: Submit the project on Github
#   Include your code, the original data as a CSV file refine_original.csv,
#   and the cleaned up data as a CSV file called refine_clean.csv.
#


############
# solution #
############

library(dplyr)

purchases <- read.csv('./refine_original.csv', header=TRUE, sep=",", as.is = TRUE)
dim(purchases)
head(purchases)

# fix brand names
purchases$company <- unlist(lapply(purchases$company, function(c){tolower(c)}))
purchases$company <- unlist(lapply(purchases$company, function(c){ sub('0', 'o', c) }))
purchases$company <- unlist(lapply(purchases$company, function(c){ sub('ak ', 'ak', c) }))
purchases$company <- unlist(lapply(purchases$company, function(c){ sub('^[pf]h?i?ll?i?ps$', 'philips', c) }))
purchases$company <- unlist(lapply(purchases$company, function(c){ sub('^unile?ver$', 'unilever', c) }))

# fix product code and number
purchases$product_code <- unlist(lapply(purchases$Product.code...number, function(c){ unlist(strsplit(c, '-'))[1] }))
purchases$product_number <- unlist(lapply(purchases$Product.code...number, function(c){ unlist(strsplit(c, '-'))[2] }))

# add category
add.cat <- function(p_code) {
    if (p_code == 'p') {
        'Smartphone'
    } else if (p_code == 'v') {
        'TV'
    } else if (p_code == 'x') {
        'Laptop'
    } else if (p_code == 'q') {
        'Tablet'
    }
}
purchases$category <- unlist(lapply(purchases$product_code, function(c){ add.cat(c) }))

# add full_address
purchases$full_address <- paste(purchases$address, purchases$city, purchases$country, sep=',')

# add company dummy variables
dummy.var <- function(col, name) {
    lapply(col==name, as.numeric)
}

purchases$company_philips <- dummy.var(purchases$company, 'philips')
purchases$company_akzo <- dummy.var(purchases$company, 'akzo')
purchases$company_van_houten <- dummy.var(purchases$company, 'van houten')
purchases$company_unilever <- dummy.var(purchases$company, 'unilever')

# add product dummy variables
purchases$product_smartphone <- dummy.var(purchases$category, 'Smartphone')
purchases$product_tv <- dummy.var(purchases$category, 'TV')
purchases$product_laptop <- dummy.var(purchases$category, 'Laptop')
purchases$product_tablet <- dummy.var(purchases$category, 'Tablet')