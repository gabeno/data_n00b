# http://www.dataschool.io/dplyr-tutorial-part-2/
# http://rpubs.com/justmarkham/dplyr-tutorial-part-2

library(dplyr)
library(nycflights13)

flights
glimpse(flights)

####################################
# Choosing columns: select, rename #
####################################

# choose columns
flights %>% select(carrier, flight)
# hide columns
flights %>% select(-month, -day)
# hide a range of columns
flights %>% select(-(dep_time:arr_delay))
# hide any column with a matching name
flights %>% select(-contains("time"))
# pick columns using a character vector of column names
cols <- c("carrier", "flight", "tailnum")
flights %>% select(one_of(cols)) %>% print(n=5)
# select() can be used to rename columns, though all columns not mentioned are dropped
flights %>% select(tail = tailnum)
# rename() does the same thing, except all columns not mentioned are kept
flights %>% rename(tail = tailnum)


####################################################################
# Choosing rows: filter, between, slice, sample_n, top_n, distinct #
####################################################################

# filter

# filter() supports the use of multiple conditions
flights %>% filter(dep_time >= 600, dep_time <= 605)

# between() is a concise alternative for determing if numeric values fall in a range
flights %>% filter(between(dep_time, 600, 605))

# side note: is.na() can also be useful when filtering
# remove values with na
flights %>% filter(!is.na(dep_time))

# slice() filters rows by position
flights %>% slice(1000:1005)

# keep the first three rows within each group
flights %>% group_by(month, day) %>% slice(1:3)

# sample three rows from each group
flights %>% group_by(month, day) %>% sample_n(3)

# keep three rows from each group with the top dep_delay
flights %>% group_by(month, day) %>% top_n(3, dep_delay)

# also sort by dep_delay within each group
flights %>% group_by(month, day) %>% top_n(3, dep_delay) %>% arrange(desc(dep_delay))

# unique rows can be identified using unique() from base R
flights %>% select(origin, dest) %>% unique()

# dplyr provides an alternative that is more "efficient"
flights %>% select(origin, dest) %>% distinct()

# side note: when chaining, you don't have to include the parentheses if 
# there are no arguments
flights %>% select(origin, dest) %>% distinct


#########################################################
# Adding new variables: mutate, transmute, add_rownames #
#########################################################

# mutate() creates a new variable (and keeps all existing variables)
flights %>% mutate(speed = distance/air_time*60)

# transmute() only keeps the new variables
flights %>% transmute(speed = distance/air_time*60)

# example data frame with row names
mtcars %>% head()

# add_rownames() turns row names into an explicit variable
mtcars %>% add_rownames("model") %>% head()

# side note: dplyr no longer prints row names (ever) for local data frames
mtcars %>% tbl_df()


#################################################################################
# Grouping and counting: summarise, tally, count, group_size, n_groups, ungroup #
#################################################################################

# summarise() can be used to count the number of rows in each group
flights %>% group_by(month) %>% summarise(cnt = n())

# tally() and count() can do this more concisely
flights %>% group_by(month) %>% tally()
flights %>% count(month)

# you can sort by the count
flights %>% group_by(month) %>% summarise(cnt = n()) %>% arrange(desc(cnt))

# tally() and count() have a sort parameter for this purpose
flights %>% group_by(month) %>% tally(sort=TRUE)
flights %>% count(month, sort=TRUE)

# you can sum over a specific variable instead of simply counting rows
flights %>% group_by(month) %>% summarise(dist = sum(distance))

# tally() and count() have a wt parameter for this purpose
flights %>% group_by(month) %>% tally(wt = distance)
flights %>% count(month, wt = distance)

# group_size() returns the counts as a vector
flights %>% group_by(month) %>% group_size()

# n_groups() simply reports the number of groups
flights %>% group_by(month) %>% n_groups()

# group by two variables, summarise, arrange (output is possibly confusing)
# summarises only on months (sorts per month)
flights %>% 
    group_by(month, day) %>% 
    summarise(cnt = n()) %>% 
    arrange(desc(cnt)) %>% 
    print(n = 40)

# ungroup() before arranging to arrange across all groups
# summarises on months and days (sorts per month per day)
flights %>% 
    group_by(month, day) %>% 
    summarise(cnt = n()) %>% 
    ungroup() %>% 
    arrange(desc(cnt))


####################################
# Creating data frames: data_frame #
####################################

# data_frame() example
data_frame(a = 1:6, b = a*2, c = 'string', 'd+e' = 1) %>% glimpse()

# data.frame() example
data.frame(a = 1:6, c = 'string', 'd+e' = 1) %>% glimpse()


################################################################
# Joining (merging) tables: left_join, right_join, inner_join, #
# full_join, semi_join, anti_join                              #
################################################################

# create two simple data frames
(a <- data_frame(color = c("green","yellow","red"), num = 1:3))
(b <- data_frame(color = c("green","yellow","pink"), size = c("S","M","L")))

# only include observations found in both "a" and "b" (automatically joins on 
# variables that appear in both tables)
inner_join(a, b)

# include observations found in either "a" or "b"
full_join(a, b)

# include all observations found in "a"
left_join(a, b)

# include all observations found in "b"
right_join(a, b)

# right_join(a, b) is identical to left_join(b, a) except for column ordering
left_join(b, a)

# filter "a" to only show observations that match "b"
semi_join(a, b)

# filter "a" to only show observations that don't match "b"
anti_join(a, b)

# sometimes matching variables don't have identical names
b <- b %>% rename(col = color)

# specify that the join should occur by matching "color" in "a" with "col" in "b"
inner_join(a, b, by=c("color" = "col"))


####################################
# Viewing more output: print, View #
####################################

# specify that you want to see more rows
flights %>% print(n = 15)

# specify that you want to see ALL rows (don't run this!)
flights %>% print(n = Inf)

# specify that you want to see all columns
flights %>% print(width = Inf)

# show up to 1000 rows and all columns
flights %>% View()

# set option to see all columns and fewer rows
options(dplyr.width = Inf, dplyr.print_min = 6)

# reset options (or just close R)
options(dplyr.width = NULL, dplyr.print_min = 10)