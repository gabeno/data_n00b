#
# Fetch Data
#

library(jsonlite)
library(dplyr)

# the api returns data with a list and data frame
# the data we need is in the data frame
# the lost contains some meta data
# > loans.1 <- fromJSON('http://api.kivaws.org/v1/loans/search.json?page=1')
# > names(loans.1)
# [1] "paging" "loans"
# [1] "paging" "loans" 
# > loans.1$paging
# $page
# [1] 1
# $total
# [1] 1151728
# $page_size
# [1] 20
# $pages
# [1] 57587

# strategy is to write to disk already chunked data (by page)
# more efficient in terms of memory resource

# tags, themes, description.languages

fetch.data <- function(page) {
    url = 'http://api.kivaws.org/v1/loans/search.json?page=_'
    endpoint = sub('_', page, url)
    print(endpoint)
    loans <- fromJSON(endpoint, flatten = TRUE)
    loans
}

fetch.metadata <- function() {
    data <- fromJSON('http://api.kivaws.org/v1/loans/search.json?page=1')
    data$paging
}

metadata = fetch.metadata()
total.pages = metadata$pages

for (n in 1:total.pages) {
    # sprintf('%.2f%% done', (n/total.pages)*100) not executing ??
    if (n==1) {
        page_1 <- fetch.data(n)
        loans <- page_1$loans
    } else {
        new_df <- fetch.data(n)
    }
    loans <- merge(loans, new_df$loans, all=TRUE)
}

# transform fields as lists to character vectors

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

# problematic variables: tags, themes and description.languages
loans <- loans %>% mutate(tags=as.character(tags))
loans <- loans %>% mutate(themes=as.character(themes))
loans <- loans %>% mutate(description.languages=as.character(description.languages))

# write to file
write.csv(loans, "./dataset/loans.csv", row.names = FALSE, sep = '', fileEncoding = 'utf8')
