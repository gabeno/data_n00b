#
# Fetch Data
#

library(jsonlite)
library(dplyr)
library(foreach)
library(doParallel)

# the api returns data with a list and data frame
# the data we need is in the data frame

# strategy is to write to disk already chunked data (by page)
# more efficient in terms of memory resource

fn.combine <- function(u, v) { paste(u, v, sep=', ') }

fetch.data <- function(page) {
    url = 'http://api.kivaws.org/v1/loans/search.json?page='
    endpoint = paste0(url, page)
    print(paste0('fetching data for => ', endpoint))
    loans <- fromJSON(endpoint, flatten = TRUE)
    loans
}

metadata <- function(d){
    md <- data.frame(total_pages=d$paging$pages,
                     total_records=d$paging$total,
                     page_size=d$paging$page_size,
                     num_cols=dim(d$loans)[2])
    md
}

page.1 <- fetch.data(1)
metadata <- metadata(page.1)
total_pages <- metadata$total_pages

#
# parallelize
#
no_cores <- detectCores() - 1 # => 3
cl<-makeCluster(no_cores)
registerDoParallel(cl)
t.start <- Sys.time()
loans <- foreach(page=1:total_pages , .combine=bind_rows, .packages=c('jsonlite')) %dopar% {
    if (page %% 4 == 0) Sys.sleep(1)
    page_df <- fetch.data(page)
    page_df <- page_df$loans
    # unpack tags from list
    page_df$tags <- unlist(
        lapply(page_df$tags, function(data) {
            ifelse(is.null(data[['name']]),
                   NA,
                   Reduce(fn.combine, c(data[['name']]))) }))
    # unpack themes from list
    page_df$themes <- unlist(
        lapply(page_df$themes, function(data) {
            ifelse(is.null(data), NA, Reduce(fn.combine, data)) }))
    # unpack languages from list
    page_df$description.languages <- unlist(
        lapply(page_df$description.languages, function(data) {
            ifelse(is.null(data), NA, Reduce(fn.combine, data)) }))
    page_df
}
t.end <- Sys.time()
stopImplicitCluster()
print(t.end - t.start)

save(loans, file='loans.RData')