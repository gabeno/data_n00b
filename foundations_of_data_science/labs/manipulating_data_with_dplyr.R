# http://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/
# http://rpubs.com/justmarkham/dplyr-tutorial

library(dplyr)
library(hflights)

data("hflights")
head(hflights)

# local data frame
flights <- tbl_df(hflights)
flights # defaults to 10 rows
print(flights, n=20)

# regular data.frame
data.frame(head(flights))

#Q difference: tbl_df vs data.frame

# filter
filter(flights, Month==1, DayofMonth==1) # comma implies and
filter(flights, Month==1 & DayofMonth==1)
filter(flights, UniqueCarrier=='AA' | UniqueCarrier=='UA')
filter(flights, UniqueCarrier %in% c('AA', 'UA'))

# select
select(flights, DepTime, ArrTime, FlightNum)
# `starts_with`, `ends_with`, and `matches`
select(flights, Year:DayofMonth, contains('Taxi'), contains('Delay'))

#chaining
# nesting parens
filter(select(flights, UniqueCarrier, DepDelay), DepDelay > 60)
# chaining with pipe operator %>%
flights %>%
    select(UniqueCarrier, DepDelay) %>%
    filter(DepDelay > 60)

# arrange
flights %>% select(UniqueCarrier, DepDelay) %>% arrange(DepDelay)
flights %>% select(UniqueCarrier, DepDelay) %>% arrange(desc(DepDelay))

# mutate - add rows
flights %>% select(Distance, AirTime) %>% mutate(Speed = Distance/AirTime*60)

# summarise - group by
# single col
flights %>% 
    group_by(Dest) %>% 
    summarise(avg_delay = mean(ArrDelay, na.rm=TRUE))
# multiple col
flights %>% 
    group_by(UniqueCarrier) %>% 
    summarise_each(funs(mean), Cancelled, Diverted)
# multiple funcs on multiple cols
flights %>% 
    group_by(UniqueCarrier) %>% 
    summarise_each(funs(min(., na.rm=TRUE), max(., na.rm=TRUE)), matches('Delay'))
# group by and count
flights %>%
    group_by(Month, DayofMonth) %>%
    summarise(flight_count = n()) %>%
    arrange(desc(flight_count))
# group by and count - use tally (count and sort)
flights %>%
    group_by(Month, DayofMonth) %>%
    tally(sort = TRUE)
# group by and count distinct
flights %>%
    group_by(Dest) %>%
    summarise(flight_count = n(), plane_count = n_distinct(TailNum))
# grouping w/o summarising
flights %>%
    group_by(Dest) %>%
    select(Cancelled) %>%
    table() %>%
    head()

# window functions
# Q:
# for each carrier, calculate which two days of the year they had their longest departure delays
# note: smallest (not largest) value is ranked as 1, so you have to use `desc` to rank by largest value
flights %>%
    group_by(UniqueCarrier) %>%
    select(Month, DayofMonth, DepDelay) %>%
    filter(min_rank(desc(DepDelay)) <= 2) %>%
    arrange(UniqueCarrier, desc(DepDelay))
# rewrite with top_n
flights %>%
    group_by(UniqueCarrier) %>%
    select(Month, DayofMonth, DepDelay) %>%
    top_n(2) %>%
    arrange(UniqueCarrier, desc(DepDelay)) %>% 
    print(n=30)
# Q:
# for each month, calculate the number of flights and the change from the previous month
flights %>%
    group_by(Month) %>%
    summarise(flight_count = n()) %>%
    mutate(change = flight_count - lag(flight_count))
# rewrite using tally
flights %>%
    group_by(Month) %>%
    tally() %>%
    mutate(change = n - lag(n))

# convenience functions
# randomly sample a fixed number of rows, without replacement
flights %>% sample_n(5)
# randomly sample a fraction of rows, with replacement
flights %>% sample_frac(0.25, replace=TRUE)
# base R approach to view the structure of an object
str(flights)
# dplyr approach: better formatting, and adapts to your screen width
glimpse(flights)
