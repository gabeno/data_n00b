library(ggplot2)
library(tidyr)


str(mtcars)
names(mtcars)
head(mtcars)
tail(mtcars)
dim(mtcars)

# plot 1
ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()

# cyl is a factor
mtcars$cyl <- factor(mtcars$cyl)
str(mtcars)

ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()

ggplot(mtcars, aes(x = wt, y = mpg)) +
    geom_point()

# color dependent on disp
ggplot(mtcars, aes(x = wt, y = mpg, col = disp)) + geom_point()

# size dependent on disp
ggplot(mtcars, aes(x = wt, y = mpg, size = disp)) + geom_point()


ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + geom_point()
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
    geom_point() + # Copy from Plot 1
    geom_smooth(method="lm", se=FALSE, linetype=2) # add a linear model for each cyl
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
    geom_point() + # Copy from Plot 1
    geom_smooth(method="lm", se=FALSE, linetype=2) +
    geom_smooth(aes(group=1)) # add a linear model for group

ggplot(mtcars, aes(x=wt, y=mpg, size=cyl)) + geom_point()
ggplot(mtcars, aes(x=wt, y=mpg, alpha=cyl)) + geom_point()
ggplot(mtcars, aes(x=wt, y=mpg, shape=cyl)) + geom_point()
ggplot(mtcars, aes(x=wt, y=mpg, label=cyl)) + geom_text()
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + geom_point(alpha=.5)
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + 
    geom_point(shape=24, color='yellow')
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + 
    geom_text(label='x', size=10, color='red')
ggplot(mtcars, aes(x=mpg, y=qsec, col=factor(cyl))) + geom_point()
ggplot(mtcars, aes(x=mpg, y=qsec, col=factor(cyl), shape=factor(am))) + 
    geom_point()
ggplot(mtcars, aes(x=mpg, y=qsec, col=factor(cyl), 
                   shape=factor(am), size=(hp/wt))) + 
    geom_point()

cyl.am <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(am)))
cyl.am + geom_bar() # default position="stack"
cyl.am + geom_bar(position = 'fill') # change position="fill"
cyl.am + geom_bar(position = 'dodge') # change position="dodge"
# Clean up the axes with scale_ functions
val = c("#E41A1C", "#377EB8")
lab = c("Manual", "Automatic")
cyl.am +
    geom_bar(position = "dodge") +
    scale_x_discrete('Cylinders') + 
    scale_y_continuous('Number') +
    scale_fill_manual('Transmission', values = val, labels = lab)

# setting a dummy aesthetic
mtcars$group <- rep(0, dim(mtcars)[1])
ggplot(mtcars, aes(x=mpg, y=group)) + geom_jitter()
ggplot(mtcars, aes(x=mpg, y=group)) +
    geom_jitter() +
    scale_x_continuous('MPG') +
    scale_y_continuous(limits=c(-2, 2))


# diamonds
diamonds

names(diamonds)
str(diamonds)
head(diamonds)
tail(diamonds)
dim(diamonds)

# scatter plot
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()

# scatter plot with a smoothing line
ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + geom_smooth()

# smoothing line only
ggplot(diamonds, aes(x = carat, y = price)) + geom_smooth()

# color smoothing line by clarity
ggplot(diamonds, aes(x = carat, y = price, color=clarity)) + geom_smooth()

# color by clarity and set alpha on scatter plot
ggplot(diamonds, aes(x = carat, y = price, color=clarity)) + geom_point(alpha=0.4)

# understanding the grammar - building plot in layers
dia_plot <- ggplot(diamonds, aes(x=carat, y=price))
dia_plot + geom_point()
dia_plot + geom_point(aes(color=clarity))
dia_plot <- dia_plot + geom_point(alpha=0.2)
# no error shading
dia_plot + geom_smooth(se=FALSE)
dia_plot + geom_smooth(se=FALSE, aes(col=clarity))


# Iris

# str(iris.tidy)
# 'data.frame':	600 obs. of  4 variables:
#     $ Species: Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ Part   : chr  "Sepal" "Sepal" "Sepal" "Sepal" ...
# $ Measure: chr  "Length" "Length" "Length" "Length" ...
# $ Value  : num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
# 
# 
# > iris %>% gather(key, Value, -Species)
# Species          key Value
# 1       setosa Sepal.Length   5.1
# 2       setosa Sepal.Length   4.9
# 3       setosa Sepal.Length   4.7
# 
# > g %>% separate(key, c("Part", "Measure"), "\\.")
# Species  Part Measure Value
# 1       setosa Sepal  Length   5.1
# 2       setosa Sepal  Length   4.9
# 3       setosa Sepal  Length   4.7
# 4       setosa Sepal  Length   4.6

iris.tidy <- iris %>%
    gather(key, Value, -Species) %>%
    separate(key, c("Part", "Measure"), "\\.")

# > head(iris.tidy)
# Species  Part Measure Value
# 1  setosa Sepal  Length   5.1
# 2  setosa Sepal  Length   4.9
# 3  setosa Sepal  Length   4.7
# 4  setosa Sepal  Length   4.6
# 5  setosa Sepal  Length   5.0
# 6  setosa Sepal  Length   5.4

ggplot(iris.tidy, aes(x = Species, y = Value, col = Part)) +
    geom_jitter() +
    facet_grid(. ~ Measure)



# > head(iris.wide)
# Species  Part Length Width
# 1  setosa Petal    1.4   0.2
# 2  setosa Petal    1.4   0.2
# 3  setosa Petal    1.3   0.2

iris$Flower <- 1:nrow(iris)
iris.wide <- iris %>%
    gather(key, value, -Flower, -Species) %>%
    separate(key, c("Part", "Measure"), "\\.") %>%
    spread(Measure, value)

ggplot(iris.wide, aes(x = Length, y = Width, col = Part)) +
    geom_jitter() +
    facet_grid(. ~ Species)


# overplotting

# [1] point shape and transparency
ggplot(mtcars, aes(x=wt, y=mpg, col=cyl)) + geom_point(size=4)
# Hollow circles - an improvement
ggplot(mtcars, aes(x=wt, y=mpg, col=cyl)) + geom_point(size=4, shape=1)
# Add transparency - very nice
ggplot(mtcars, aes(x=wt, y=mpg, col=cyl)) + geom_point(size=4, alpha=.6)

# [2] alpha with large datasets
# Scatter plot: carat (x), price (y), clarity (col)
ggplot(diamonds, aes(x=carat, y=price, col=clarity)) + geom_point()
# Adjust for overplotting
ggplot(diamonds, aes(x=carat, y=price, col=clarity)) + geom_point(alpha=.5)
# Scatter plot: clarity (x), carat (y), price (col)
ggplot(diamonds, aes(x=clarity, y=carat, col=price)) + geom_point(alpha=.5)
# Dot plot with jittering - avoid lineing up data on single axis
ggplot(diamonds, aes(x=clarity, y=carat, col=price)) + 
    geom_point(alpha=.5, position="jitter")


# scatter plots and jittering
ggplot(mtcars, aes(x=cyl, y=wt)) + geom_point()
# Use geom_jitter() instead of geom_point()
ggplot(mtcars, aes(x=cyl, y=wt)) + geom_jitter()
# Define the position object using position_jitter(): posn.j
posn.j <- position_jitter(width=.1)
# Use posn.j in geom_point()
ggplot(mtcars, aes(x=cyl, y=wt)) + geom_point(position=posn.j)

# overlapping bar plots
# Draw a bar plot of cyl, filled according to am
ggplot(mtcars, aes(x=cyl, fill=am)) + geom_bar()
# Change the position argument to "dodge"
ggplot(mtcars, aes(x=cyl, fill=am)) + geom_bar(position="dodge")
# Define posn_d with position_dodge()
posn_d = position_dodge(width=0.2)
# Change the position argument to posn_d
ggplot(mtcars, aes(x=cyl, fill=am)) + geom_bar(position=posn_d)
# Use posn_d as position and adjust alpha to 0.6
ggplot(mtcars, aes(x=cyl, fill=am)) + geom_bar(position=posn_d, alpha=.6)

# overlapping histograms
ggplot(mtcars, aes(mpg, col=cyl, fill=cyl)) + geom_histogram(binwidth = 1)
# Change position to identity 
ggplot(mtcars, aes(mpg, fill=cyl)) + 
    geom_histogram(binwidth = 1, position="identity")
# Change geom to freqpoly (position is identity by default) 
ggplot(mtcars, aes(mpg, col=cyl)) + 
    geom_freqpoly(binwidth = 1, position="identity")

# color ramp
# ggplot(Vocab, aes(x = education, fill = vocabulary)) +
#     geom_bar(position = "fill") +
#     scale_fill_brewer()
# # Definition of a set of blue colors
# blues <- brewer.pal(9, "Blues")
# # Make a color range using colorRampPalette() and the set of blues
# blue_range <- colorRampPalette(blues)
# # Use blue_range to adjust the color of the bars, use scale_fill_manual()
# ggplot(Vocab, aes(x = education, fill = vocabulary)) +
#     geom_bar(position = "fill") +
#     scale_fill_manual(values=blue_range(11))

# line plots
# Print out head of economics
head(economics)
# Plot unemploy as a function of date using a line plot
ggplot(economics, aes(x = date, y = unemploy)) + geom_line()
# Adjust plot to represent the fraction of total population that is unemployed
ggplot(economics, aes(x = date, y = (unemploy/pop))) + geom_line()
# recession periods
# > head(recess)
# begin        end
# 1 1969-12-01 1970-11-01
# 2 1973-11-01 1975-03-01
# 3 1980-01-01 1980-07-01
# 4 1981-07-01 1982-11-01
# 5 1990-07-01 1991-03-01
# 6 2001-03-01 2001-11-01
# > dim(recess)
# [1] 6 2
# Expand the following command with geom_rect() to draw the recess periods
ggplot(economics, aes(x = date, y = unemploy/pop)) + 
    geom_line() + 
    geom_rect(data=recess, inherit.aes=FALSE, 
              aes(xmin=begin, xmax=end, ymin=-Inf, ymax=Inf), 
              fill="red", alpha=0.2)

# multiple time series
# > fish.tidy <- gather(fish.species, Species, Capture, -Year)
# > head(fish.species)
# Year   Pink   Chum Sockeye  Coho Rainbow Chinook Atlantic
# 1 1950 100600 139300   64100 30500       0   23200    10800
# 2 1951 259000 155900   51200 40900     100   25500     9701
# 3 1952 132600 113800   58200 33600     100   24900     9800
# 4 1953 235900  99800   66100 32400     100   25300     8800
# 5 1954 123400 148700   83800 38300     100   24500     9600
# 6 1955 244400 143700   72000 45100     100   27700     7800
# > head(fish.tidy)
# Year Species Capture
# 1 1950    Pink  100600
# 2 1951    Pink  259000
# 3 1952    Pink  132600
# 4 1953    Pink  235900
# 5 1954    Pink  123400
# 6 1955    Pink  244400
# ggplot(fish.tidy, aes(x = Year, y = Capture, col=Species)) + geom_line()


# qplot
# The old way (shown)
plot(mpg ~ wt, data = mtcars)
# Using ggplot:
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
# Using qplot:
qplot(wt, mpg, data=mtcars)

# qplot() with x only
qplot(factor(cyl), data=mtcars)
# qplot() with x and y
qplot(factor(cyl), factor(vs), data=mtcars)
# qplot() with geom set to jitter manually
qplot(factor(cyl), factor(vs), data=mtcars, geom="jitter")

ggplot(mtcars, aes(cyl, wt, fill = factor(am))) + geom_dotplot(binaxis='y', stackdir='center')
# qplot with geom "dotplot", binaxis = "y" and stackdir = "center"
qplot(cyl, wt, data=mtcars, fill=factor(am), geom='dotplot', binaxis='y', stackdir='center')


# > head(ChickWeight)
# weight Time Chick Diet
# 1     42    0     1    1
# 2     51    2     1    1
# 3     59    4     1    1
# 4     64    6     1    1
# 5     76    8     1    1
# 6     93   10     1    1
# 
# # Check out the head of ChickWeight
# head(ChickWeight)
# # Use ggplot() for the second instruction
# ggplot(ChickWeight, aes(x=Time, y=weight)) + geom_line(aes(group=Chick))
# # Use ggplot() for the third instruction
# ggplot(ChickWeight, aes(x=Time, y=weight, col=Diet)) + geom_line(aes(group=Chick))
# # Use ggplot() for the last instruction
# ggplot(ChickWeight, aes(x=Time, y=weight, col=Diet)) + 
#     geom_line(aes(group=Chick), alpha=.3) + 
#     geom_smooth(lwd=2, se=FALSE)

# Check out the structure of titanic
# > str(titanic)
# 'data.frame':	714 obs. of  4 variables:
#     $ Survived: int  0 1 1 1 0 0 0 1 1 1 ...
# $ Pclass  : int  3 1 3 1 3 1 3 3 2 3 ...
# $ Sex     : chr  "male" "female" "female" "female" ...
# $ Age     : num  22 38 26 35 35 54 2 27 14 4 ...
# > head(titanic)
# Survived Pclass    Sex Age
# 1        0      3   male  22
# 2        1      1 female  38
# 3        1      3 female  26
# 4        1      1 female  35
# 5        0      3   male  35
# 6        0      1   male  54
# Use ggplot() for the first instruction
ggplot(titanic, aes(x=factor(Pclass), fill=factor(Sex))) + 
    geom_bar(position="dodge")
# Use ggplot() for the second instruction
ggplot(titanic, aes(x=factor(Pclass), fill=factor(Sex))) + 
    geom_bar(position="dodge") + 
    facet_grid(". ~ Survived")
# Position jitter (use below)
posn.j <- position_jitter(0.5, 0)
# Use ggplot() for the last instruction
ggplot(titanic, aes(x=factor(Pclass), y=Age, col=factor(Sex))) + 
    geom_jitter(position=posn.j, size=3, alpha=.5) + 
    facet_grid(". ~ Survived")

titanic <- read.csv('../ex_2_data_wrangling/titanic_clean.csv')
names(titanic)
head(titanic)
ggplot(titanic, aes(x=factor(pclass), fill=factor(sex))) + 
    geom_bar(position="dodge")
ggplot(titanic, aes(x=factor(pclass), fill=factor(sex))) + 
    geom_bar(position="dodge") + 
    facet_grid(". ~ survived")
posn.j <- position_jitter(0.5, 0)
ggplot(titanic, aes(x=factor(pclass), y=age, col=factor(sex))) + 
    geom_jitter(position=posn.j, size=3, alpha=.5) + 
    facet_grid(". ~ survived")
