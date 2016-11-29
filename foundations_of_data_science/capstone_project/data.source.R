#
# Fetch Data
#

library(jsonlite)
library(dplyr)

# the api returns data with a list and data frame
# the data we need is in the data frame

# strategy is to write to disk already chunked data (by page)
# more efficient in terms of memory resource

setwd("~/projects/data_science_projects/data_n00b/foundations_of_data_science/capstone_project")
combine <- function(u, v) { paste(u, v, sep=', ') }

fetch.data <- function(page) {
    url = 'http://api.kivaws.org/v1/loans/search.json?page=_'
    endpoint = sub('_', page, url)
    print(paste('fetching data for =>', endpoint))
    loans <- fromJSON(endpoint, flatten = TRUE)
    # unpack tags from list
    loans$loans$tags <- unlist(
        lapply(loans$loans$tags, function(data) {
            ifelse(is.null(data[['name']]),
                   NA,
                   Reduce(comb, c(data[['name']]))) }))
    # unpack themes from list
    loans$loans$themes <- unlist(
        lapply(loans$loans$themes, function(data) {
            ifelse(is.null(data), NA, Reduce(comb, data)) }))
    # unpack languages from list
    loans$loans$description.languages <- unlist(
        lapply(loans.1$loans$description.languages, function(data) {
            ifelse(is.null(data), NA, Reduce(comb, data)) }))
    loans
}

save.data <- function(obj, page) {
    path = sub('_', page, './dataset/loans._.csv')
    write.csv(obj, path, row.names = FALSE, sep = '', fileEncoding = 'utf8')
    print(paste('Data saved ... ', path))
}

pages <- function(page=1) {
    metadata <- fetch.data(page)
    metadata$paging$pages
}

total_pages <- pages()
get.data <- function(pages) {
    for (page in 1:pages) {
        loans <- fetch.data(page)
        save.data(loans$loans, page)
    }
}

get.data(total_pages)







# ------------------------------------ PLAY ------------------------------------

loans.40 <- fetch.data(40)
tbl_df(loans.1$loans)

# tags, themes, description.languages - fields with list

# > glimpse(loans)
# Observations: 42
# Variables: 26
# $ id                       (int) 1176441, 1176449, 1176528, 1177062, 1177477, 1177609, 1177629, 1177715, 1177775, 1177776, 1177777, 1177...
# $ name                     (chr) "Mehrikhon", "Zilola", "Ryskan", "El Cordero Group", "Pinky", "Maribel", "Senghong", "Mona", "Amina", "...
# $ status                   (chr) "fundraising", "fundraising", "fundraising", "fundraising", "fundraising", "fundraising", "fundraising"...
# $ funded_amount            (int) 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 0, 0, 0, 0, 0, 0, 0, 15...
# $ basket_amount            (int) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
# $ activity                 (chr) "Food Production/Sales", "Sewing", "Dairy", "Grocery Store", "Fish Selling", "Tailoring", "Higher educa...
# $ sector                   (chr) "Food", "Services", "Agriculture", "Food", "Food", "Services", "Education", "Services", "Housing", "Hou...
# $ use                      (chr) "to buy more dried apricot fruit for her retail business.", "to buy high-quality fabrics and make parti...
# $ partner_id               (int) 100, 63, 171, 328, 125, 145, 9, 77, 462, 462, 156, 386, 462, 156, 462, 156, 156, 156, 156, 185, 156, 46...
# $ posted_date              (chr) "2016-11-08T21:50:02Z", "2016-11-08T21:40:02Z", "2016-11-08T21:30:03Z", "2016-11-08T19:50:04Z", "2016-1...
# $ planned_expiration_date  (chr) "2016-12-08T21:50:02Z", "2016-12-08T21:40:02Z", "2016-12-08T21:30:03Z", "2016-12-08T19:50:04Z", "2016-1...
# $ loan_amount              (int) 1525, 275, 2200, 725, 125, 225, 2450, 1500, 1500, 1500, 400, 500, 850, 400, 1500, 200, 300, 200, 100, 1...
# $ borrower_count           (int) 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 12, 1, 1, 13, 1, 1, 4, 9,...
# $ lender_count             (int) 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 4, 0...
# $ bonus_credit_eligibility (lgl) TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FAL...
# $ tags                     (list) NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ...
# $ themes                   (list) NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ...
# $ description.languages    (list) en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en, en...
# $ image.id                 (int) 2347964, 2347981, 2347564, 2349015, 2344940, 2349677, 2349698, 2349824, 2349867, 2349868, 2349870, 2349...
# $ image.template_id        (int) 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
# $ location.country_code    (chr) "TJ", "TJ", "KG", "NI", "PH", "PH", "KH", "LB", "PS", "PS", "KE", "KE", "PS", "KE", "PS", "KE", "KE", "...
# $ location.country         (chr) "Tajikistan", "Tajikistan", "Kyrgyzstan", "Nicaragua", "Philippines", "Philippines", "Cambodia", "Leban...
# $ location.town            (chr) NA, "Tursun-zoda", "Kara-Suu village, Talas region", "Bilwi", "Sara, Iloilo", "Taytay, Palawan", "Kampo...
# $ location.geo.level       (chr) "country", "town", "town", "town", "town", "town", "town", "town", "town", "town", "town", "town", "tow...
# $ location.geo.pairs       (chr) "39 71", "39 71", "41 75", "13 -85", "13 122", "13 122", "12 104.5", "33.833333 35.833333", "31.92157 3...
# $ location.geo.type        (chr) "point", "point", "point", "point", "point", "point", "point", "point", "point", "point", "point", "poi...

# tags
# ----
# "tags":[{"name":"#Woman Owned Biz"},{"name":"#Animals"},{"name":"#Parent"},{"name":"#Single Parent"}]}
# > tags
# [[1]]
# name
# 1     #First Loan
# 2 #Sustainable Ag
# 3   #Eco-friendly
# 4          #Vegan
# 5         #Parent
# 6      #Schooling
# 7     #Technology
# 
# [[2]]
# data frame with 0 columns and 0 rows
# 
# [[3]]
# name
# 1 #Fabrics
# 
# [[4]]
# name
# 1 #Woman Owned Biz
# 2         #Animals
# 3          #Parent
# 4   #Single Parent
# 
# [[5]]
# name
# 1 user_favorite
# 2    #Schooling
# 
# [[6]]
# name
# 1 #Repeat Borrower
# 
# [[7]]
# data frame with 0 columns and 0 rows
# 
# [[8]]
# name
# 1 #Job Creator
# 
# [[9]]
# name
# 1          user_favorite
# 2          #Eco-friendly
# 3 #Health and Sanitation
# 4            #Technology
# 
# [[10]]
# name
# 1 #Woman Owned Biz
# 2          #Parent
# 3 #Repeat Borrower
# 
# [[11]]
# name
# 1 #Woman Owned Biz
# 
# [[12]]
# name
# 1       #Animals
# 2        #Parent
# 3 #Single Parent
# 4     #Schooling
# 
# [[13]]
# name
# 1 user_favorite
# 2    #Schooling
# 
# [[14]]
# data frame with 0 columns and 0 rows
# 
# [[15]]
# name
# 1 user_favorite
# 2   #First Loan
# 3 #Eco-friendly
# 4       #Parent
# 5   #Technology
# 
# [[16]]
# name
# 1          user_favorite
# 2          #Eco-friendly
# 3 #Health and Sanitation
# 4            #Technology
# 
# [[17]]
# name
# 1          user_favorite
# 2          #Eco-friendly
# 3 #Health and Sanitation
# 4            #Technology
# 
# [[18]]
# name
# 1 user_favorite
# 2    #Schooling
# 
# [[19]]
# data frame with 0 columns and 0 rows
# 
# [[20]]
# name
# 1 user_favorite

loans.1$loans$tags <- unlist(
    lapply(
        loans.1$loans$tags,
        function(data) {
            ifelse(is.null(data[['name']]), NA, Reduce(comb, c(data[['name']]))) # treat dataframe
        }))
# > unlist(lapply(loans.1$loans$tags, function(data) { ifelse(is.null(data[['name']]), NA, Reduce(comb, c(data[['name']]))) }))
# [1] "#First Loan, #Sustainable Ag, #Eco-friendly, #Vegan, #Parent, #Schooling, #Technology"
# [2] NA                                                                                     
# [3] "#Fabrics"                                                                             
# [4] "#Woman Owned Biz, #Animals, #Parent, #Single Parent"                                  
# [5] "user_favorite, #Schooling"                                                            
# [6] "#Repeat Borrower"                                                                     
# [7] NA                                                                                     
# [8] "#Job Creator"                                                                         
# [9] "user_favorite, #Eco-friendly, #Health and Sanitation, #Technology"                    
# [10] "#Woman Owned Biz, #Parent, #Repeat Borrower"                                          
# [11] "#Woman Owned Biz"                                                                     
# [12] "#Animals, #Parent, #Single Parent, #Schooling"                                        
# [13] "user_favorite, #Schooling"                                                            
# [14] NA                                                                                     
# [15] "user_favorite, #First Loan, #Eco-friendly, #Parent, #Technology"                      
# [16] "user_favorite, #Eco-friendly, #Health and Sanitation, #Technology"                    
# [17] "user_favorite, #Eco-friendly, #Health and Sanitation, #Technology"                    
# [18] "user_favorite, #Schooling"                                                            
# [19] NA                                                                                     
# [20] "user_favorite"


# themes
# ------
# raw sample: "themes":["Fair Trade","Green"]
# > loans.1$loans$themes
# [[1]]
# [1] "Green"           "Rural Exclusion"
# 
# [[2]]
# NULL
# 
# [[3]]
# [1] "Underfunded Areas"
# 
# [[4]]
# [1] "Vulnerable Groups" "Underfunded Areas"
# 
# [[5]]
# [1] "Higher Education"
# 
# [[6]]
# NULL
# 
# [[7]]
# [1] "Fair Trade" "Green"     
# 
# [[8]]
# [1] "Conflict Zones"    "Underfunded Areas" "Rural Exclusion"  
# 
# [[9]]
# [1] "Water and Sanitation"
# 
# [[10]]
# NULL
# 
# [[11]]
# NULL
# 
# [[12]]
# [1] "Vulnerable Groups" "Underfunded Areas"
# 
# [[13]]
# [1] "Higher Education"
# 
# [[14]]
# NULL
# 
# [[15]]
# [1] "Green"
# 
# [[16]]
# [1] "Water and Sanitation"
# 
# [[17]]
# [1] "Water and Sanitation"
# 
# [[18]]
# [1] "Higher Education"
# 
# [[19]]
# [1] "Vulnerable Groups" "Conflict Zones"   
# 
# [[20]]
# NULL

unlist(
    lapply(
        loans.1$loans$themes,
        function(data) {
            ifelse(is.null(data), NA, Reduce(comb, data)) # treat vector
        }))
# > unlist(lapply(loans.1$loans$themes, function(data) { ifelse(is.null(data), NA, Reduce(comb, data)) }))
# [1] "Green, Rural Exclusion"                             NA                                                  
# [3] "Underfunded Areas"                                  "Vulnerable Groups, Underfunded Areas"              
# [5] "Higher Education"                                   NA                                                  
# [7] "Fair Trade, Green"                                  "Conflict Zones, Underfunded Areas, Rural Exclusion"
# [9] "Water and Sanitation"                               NA                                                  
# [11] NA                                                   "Vulnerable Groups, Underfunded Areas"              
# [13] "Higher Education"                                   NA                                                  
# [15] "Green"                                              "Water and Sanitation"                              
# [17] "Water and Sanitation"                               "Higher Education"                                  
# [19] "Vulnerable Groups, Conflict Zones"                  NA


# description.languages
# ---------------------
# raw sample: "description":{"languages":["es","en"]}
# > loans.1$loans$description.languages
# [[1]]
# [1] "en"
# 
# [[2]]
# [1] "en"
# 
# [[3]]
# [1] "en"
# 
# [[4]]
# [1] "es" "en"
# 
# [[5]]
# [1] "en"
# 
# [[6]]
# [1] "en"
# 
# [[7]]
# [1] "es" "en"
# 
# [[8]]
# [1] "en"
# 
# [[9]]
# [1] "en"
# 
# [[10]]
# [1] "en"
# 
# [[11]]
# [1] "es" "en"
# 
# [[12]]
# [1] "es" "en"
# 
# [[13]]
# [1] "en"
# 
# [[14]]
# [1] "es" "en"
# 
# [[15]]
# [1] "en"
# 
# [[16]]
# [1] "en"
# 
# [[17]]
# [1] "en"
# 
# [[18]]
# [1] "en"
# 
# [[19]]
# [1] "es" "en"
# 
# [[20]]
# [1] "en"

unlist(
    lapply(
        loans.1$loans$description.languages,
        function(data) {
            ifelse(is.null(data), NA, Reduce(comb, data)) # treat vector
        }))
# > unlist(lapply(loans.1$loans$description.languages, function(data) { ifelse(is.null(data), NA, Reduce(comb, data)) }))
# [1] "en"     "en"     "en"     "es, en" "en"     "en"     "es, en" "en"     "en"     "en"     "es, en" "es, en"
# [13] "en"     "es, en" "en"     "en"     "en"     "en"     "es, en" "en"

# description.langauges and themes
# 