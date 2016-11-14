library(ggplot2)

#
# 1 - Statistics
#
# smooothing
# Explore the mtcars data frame with str()
str(mtcars)
# A scatter plot with LOESS smooth:
ggplot(mtcars, aes(x = wt, y = mpg)) + 
    geom_point() + 
    geom_smooth(method="loess")
# A scatter plot with an ordinary Least Squares linear model: by default y ~ x
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point() + geom_smooth(method="lm")
# The previous plot, without 95% CI ribbon:
ggplot(mtcars, aes(x = wt, y = mpg)) + 
    geom_point() + 
    geom_smooth(method="lm", se=FALSE)
# The previous plot, without points:
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_smooth(method="lm", se=FALSE)


# grouping variables
# Define cyl as a factor variable
# Note: In this ggplot command our smooth is calculated for each subgroup 
# because there is an invisible aesthetic, group which inherits from col
ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) + 
    geom_point() + stat_smooth(method = "lm", se = F)
# Add another stat_smooth() layer with exactly the same attributes (method set to "lm", se to FALSE).
# Add a group aesthetic inside the aes() of this new stat_smooth(), set it to a summary variable, 1
ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) + 
    geom_point() + 
    stat_smooth(method = "lm", se = F) + 
    stat_smooth(method = "lm", se = F, aes(group=1))


# modifying stat_smooth
# Plot 1: Recall that LOESS smoothing is a non-parametric form of regression 
# that uses a weighted, sliding-window, average to calculate a line of best fit. 
# We can control the size of this window with the span argument.
# Add span, set it to 0.7
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point() +
    # Add span below 
    geom_smooth(se = F, span=.7)
# Plot 2: In this plot, we set a linear model for the entire dataset as well 
# as each subgroup, defined by cyl. In the second stat_smooth(),
# Set method to "loess"
# Add span, set it to 0.7
ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
    geom_point() +
    stat_smooth(method = "lm", se = F) +
    # Change method and add span below
    stat_smooth(method = "loess", aes(group = 1), 
                se = F, col = "black", span=.7)
# Plot 3: Plot 2 presents a problem because there is a black line on our plot 
# that is not included in the legend. To get this, we need to map something to 
# col as an aesthetic, not just set col as an attribute.
# Add col to the aes() function in the second stat_smooth(), set it to "All". 
# This will name the line properly.
# Remove the col attribute in the second stat_smooth(). Otherwise, 
# it will overwrite the col aesthetic.
ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
    geom_point() +
    stat_smooth(method = "lm", se = F) +
    stat_smooth(method = "loess",
                # Add col inside aes()
                aes(group = 1, col="All"), 
                # Remove the col argument below
                se = F, span = 0.7)
# Plot 4: Now we should see our "All" model in the legend, but it's not black 
# anymore.
# Add a scale layer: scale_color_manual() with the first argument set to 
# "Cylinders" and values set to the predfined myColors variable
myColors <- c(brewer.pal(3, "Dark2"), "black")
ggplot(mtcars, aes(x = wt, y = mpg, col = factor(cyl))) +
    geom_point() +
    stat_smooth(method = "lm", se = F, span = 0.75) +
    stat_smooth(method = "loess", 
                aes(group = 1, col="All"), 
                se = F, span = 0.7) +
    # Add correct arguments to scale_color_manual
    scale_color_manual("Cylinders", values=myColors)


# modifying stat_smooth (2)
# Plot 1: Jittered scatter plot, add a linear model (lm) smooth:
# Plot 1: The code on the right builds a jittered plot of vocabulary against 
# education of the Vocab data frame.
# Add a stat_smooth() layer with method set to "lm". Make sure no CI ribbons 
# are shown by setting se to FALSE.
ggplot(Vocab, aes(x = education, y = vocabulary)) +
    geom_jitter(alpha = 0.2) + stat_smooth(se=FALSE, method="lm")
# Plot 2: Only lm, colored by year
# Plot 2: We'll just focus on the linear models from now on.
# Copy the previous command, remove the geom_jitter() layer.
# Add the col aesthetic to the ggplot() command. Set it to factor(year).
ggplot(Vocab, aes(x = education, y = vocabulary, col=factor(year))) + 
    stat_smooth(se=FALSE, method="lm")
# Plot 3: Set a color brewer palette
# Plot 3: The default colors are pretty unintuitive. Since this can be considered 
# an ordinal scale, it would be nice to use a sequential color palette.
# Copy the previous command, add scale_color_brewer() to use a default ColorBrewer. 
# This should result in an error, since the default palette, "Blues", 
# only has 9 colors, but we have 16 years here.
ggplot(Vocab, aes(x = education, y = vocabulary, col=factor(year))) + stat_smooth(se=FALSE, method="lm") + scale_color_brewer()

# Plot 4: Add the group, specify alpha and size
# Plot 4: Overcome the error by using year as a numeric vector. You'll have to 
# specify the invisible group aesthetic which will be factor(year). You are given 
# a scale layer which will fix your coloring, but you'll need to make the 
# following changes:
#     Add group inside aes(), set it to factor(year).
#     Inside stat_smooth(), set alpha equal to 0.6 and size equal to 2.
ggplot(Vocab, aes(x = education, y = vocabulary, col = year, group=factor(year))) +
    stat_smooth(method = "lm", se = F, alpha=.6, size=2) +
    scale_color_gradientn(colors = brewer.pal(9,"YlOrRd"))

# Quantiles
# Use stat_quantile instead of stat_smooth:
# The code from the previous exercise, with the linear model and a suitable color 
# palette, is already included. Change the stat function from stat_smooth() to 
# stat_quantile(). Consider the arguments that were used with stat_smooth(). 
# You only have to keep alpha and size, throw the other arguments out!
ggplot(Vocab, aes(x = education, y = vocabulary, col = year, group = factor(year))) +
    stat_quantile(alpha = 0.6, size = 2) +
    scale_color_gradientn(colors = brewer.pal(9,"YlOrRd"))
# Set quantile to 0.5:
# The resulting plot will be a mess, because there are three quartiles drawn by 
# default. Copy the code for the previous instruction and set the quantiles 
# argument to 0.5 so that only the median is shown.
ggplot(Vocab, aes(x = education, y = vocabulary, col = year, group = factor(year))) +
    stat_quantile(quantiles=.5, alpha = 0.6, size = 2) +
    scale_color_gradientn(colors = brewer.pal(9,"YlOrRd"))

# sum
# Plot with linear and loess model
# ggplot2 is already loaded. A plot showing a linear model and LOESS regression is
# already provided and stored as p. Add stat_sum() to this plotting object p. This
# will map the overall count of each dot onto size. You don't have to set any 
# arguments, the aesthetics will be inherited from the base plot!
p <- ggplot(Vocab, aes(x = education, y = vocabulary)) +
    stat_smooth(method = "loess", aes(col = "red"), se = F) +
    stat_smooth(method = "lm", aes(col = "blue"), se = F) +
    scale_color_discrete("Model", labels = c("red" = "LOESS", "blue" = "lm"))
# Add stat_sum
p + stat_sum()
# Add stat_sum and set size range
# In addition, add the size scale with the generic scale_size() function. Use the 
# range argument to set the minimum and maximum dot sizes as c(1,10).
p + stat_sum() + scale_size(range=c(1, 10))

# prep for stat_summary
# Use str() to explore the structure of the mtcars dataset.
# In mtcars, cyl and am are classified as continuous, but they are actually 
# categorical. Previously we just used factor(), but here we'll modify the actual 
# dataset. Change cyl and am to be categorical in the mtcars data frame using as.factor.
# Next we'll set three position objects with convenient names. This allows us to 
# use the exact positions on multiple layers. Create:
#     posn.d, using position_dodge() with a width of 0.1,
#     posn.jd, using position_jitterdodge() with a jitter.width of 0.1 and a dodge.width of 0.2
#     posn.j, using position_jitter() with a width of 0.2.
# Finally, we'll make our base layers and store it in the object wt.cyl.am. Make 
# the base call for ggplot mapping cyl to the x, wt to y, am to both col and fill. 
# Also set group = am inside aes(). The reason for these redundancies will become 
# clear later on.
# Display structure of mtcars
str(mtcars)
# Convert cyl and am to factors:
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am)
# Define positions:
posn.d <- position_dodge(width=.1)
posn.jd <- position_jitterdodge(jitter.width=.1, dodge.width=.2)
posn.j <- position_jitter(width=.2)
# base layers:
wt.cyl.am <- ggplot(mtcars, aes(x=cyl, y=wt, col=am, fill=am, group=am))

# plotting variations
# Plot 1: Jittered, dodged scatter plot with transparent points
wt.cyl.am + geom_point(position = posn.jd, alpha = 0.6)
# Plot 2: Mean and SD - the easy way
# Plot 2: Add a stat_summary() layer to wt.cyl.am and calculate the mean and 
# standard deviation as we did in the video: set fun.data to mean_sdl and specify 
# fun.args to be list(mult = 1). Set the position argument to posn.d.
wt.cyl.am + geom_point(alpha = 0.6) + 
    stat_summary(position = posn.d, fun.data=mean_sdl, fun.args=list(mult=1))
# Plot 3: Mean and 95% CI - the easy way
# Plot 3: Repeat the previous plot, but use the 95% confidence interval instead of
# the standard deviation. You can use mean_cl_normal instead of mean_sdl this time.
# There's no need to specify fun.args in this case. Again, set position to posn.d.
wt.cyl.am + geom_point(alpha = 0.6) + 
    stat_summary(position = posn.d, fun.data=mean_cl_normal)
# Plot 4: Mean and SD - with T-tipped error bars - fill in ___
# The above plots were simple because they implicitly used a default geom, which 
# is geom_pointrange(). For Plot 4, fill in the blanks to calculate the mean and 
# standard deviation separately with two stat_summary() functions:
#     For the mean, use geom = "point" and set fun.y = mean. This time you should 
#     use fun.y because the point geom uses the y aesthetic behind the scenes.
#     Add error bars with another stat_summary() function. Set geom = "errorbar" 
#     to get the real "T" tips. Set fun.data = mean_sdl.
wt.cyl.am + 
    stat_summary(geom = "point", fun.y = mean, position = posn.d) +
    stat_summary(geom = "errorbar", fun.data = mean_sdl, position = posn.d, 
                 fun.args = list(mult = 1), width = 0.1)

# custom functions
xx <- seq(1, 100)
# > xx
# [1]   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18
# [19]  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36
# [37]  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54
# [55]  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72
# [73]  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90
# [91]  91  92  93  94  95  96  97  98  99 100
# > mean_sdl(xx, mult = 1)
# y     ymin     ymax
# 1 50.5 21.48851 79.51149
#
# First, change the arguments ymin and ymax inside the data.frame() call of gg_range().
# ymin should be the minimum of x
# ymax should be the maximum of x
# Use min() and max(). Watch out, naming is important here. gg_range(xx) should 
# now generate the required output.
# Function to save range for use in ggplot 
gg_range <- function(x) {
    # Change x below to return the instructed values
    data.frame(ymin = min(x), # Min
               ymax = max(x)) # Max
}
gg_range(xx)
# Next, change the arguments y, ymin and ymax inside the data.frame() call of med_IQR().
# y should be the median of x
# ymin should be the first quartile
# ymax should be the 3rd quartile.
# You should use median() and quantile(). For example, quantile() can be used as 
# follows to give the first quartile: quantile(x)[2]. med_IQR(xx) should now 
# generate the required output.
med_IQR <- function(x) {
    # Change x below to return the instructed values
    data.frame(y = median(x), # Median
               ymin = quantile(x)[2], # 1st quartile
               ymax = quantile(x)[4])  # 3rd quartile
}
med_IQR(xx)

wt.cyl.am <- ggplot(mtcars, aes(x = cyl,y = wt, col = am, fill = am, group = am))
# Add three stat_summary calls to wt.cyl.am
# The first stat_summary() layer should have geom set to "linerange". fun.data 
# argument should be set to med_IQR, the function you used in the previous exercise.
# The second stat_summary() uses the "linerange" geom. This time fun.data should 
# be gg_range, the other function you created. Also set alpha to 0.4.
# For the last stat_summary(), use geom = "point". The points should have 
# col "black" and shape "X".
wt.cyl.am + 
    stat_summary(geom = "linerange", fun.data = med_IQR, position = posn.d, 
                 size = 3) +
    stat_summary(geom = "linerange", fun.data = gg_range, position = posn.d, 
                 size = 3, alpha = .4) +
    stat_summary(geom = "point", fun.y = median, position = posn.d, size = 3, 
                 col = "black", shape = "X")


#
# 2 - Coordinates and Facets
#
# zooming in
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am)
# Basic ggplot() command, coded for you
p <- ggplot(mtcars, aes(x = wt, y = hp, col = am)) + geom_point() + geom_smooth()
# Add scale_x_continuous
# Extend p with a scale_x_continuous() with limits = c(3, 6) and expand = c(0, 0). 
# What do you see?
p + scale_x_continuous(limits=c(3, 6), expand=c(0, 0))
# The proper way to zoom in:
# Try again, this time with coord_cartesian(): Set the xlim argument equal 
# to c(3, 6). Compare the two plots.
p + coord_cartesian(xlim=c(3, 6))

# aspect ratio
# We can set the aspect ratio of a plot with coord_fixed() or coord_equal(). 
# Both use aspect = 1 as a default. A 1:1 aspect ratio is most appropriate when 
# two continuous variables are on the same scale, as with the iris dataset.
# Complete basic scatter plot function
# Complete the basic scatter plot function using the iris data frame to plot 
# Sepal.Width onto the y aesthetic, Sepal.Length onto the x and Species onto col. 
# You should understand all the other functions used in this plotting call by now. 
# This is saved in an object called base.plot.
base.plot <- ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, col=Species)) +
    geom_jitter() +
    geom_smooth(method = "lm", se = F)
# Plot base.plot: default aspect ratio
base.plot
# Fix aspect ratio (1:1) of base.plot
# Add a coord_equal() layer to force a 1:1 aspect ratio.
base.plot + coord_equal()

# pie charts
# Create stacked bar plot: thin.bar
# Create a basic stacked bar plot. Since we have univariate data and stat_bin() 
# requires an x aesthetic, we'll have to use a dummy variable. Set x to 1 and map 
# cyl onto fill. Assign the bar plot to thin.bar.
thin.bar <- ggplot(mtcars, aes(x=1, fill=cyl)) + geom_bar()
# Convert thin.bar to pie chart
# Add a coord_polar() layer to thin.bar. Set the argument theta to "y". This 
# specified the axis which would be transformed to polar coordinates. There's a 
# ring structure instead of a pie!
thin.bar + coord_polar(theta='y')
# Create stacked bar plot: wide.bar
# Repeat the code for the stacked bar plot, but this time set the width argument 
# inside the geom_bar() function to 1 and assign this plot to wide.bar. This fills 
# up the plot so that there is no empty space on our x scale.
wide.bar <- ggplot(mtcars, aes(x=1, fill=cyl)) + geom_bar(width=1)
# Convert wide.bar to pie chart
wide.bar + coord_polar(theta='y')

# facets - basics
# Starting from the basic scatter plot, use facet_grid() and the formula 
# notation to facet the plot in three different ways:
#     Rows by am.
#     Columns by cyl.
#     Rows and columns by am and cyl.
# Basic scatter plot:
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
# Separate rows according to transmission type, am
p + facet_grid(am ~ .)
# Separate columns according to cylinders, cyl
p + facet_grid(. ~ cyl)
# Separate by both columns and rows 
p + facet_grid(am ~ cyl)

# faceting on many variables
#     Beginning with the basic scatter plot, add a color scale for cyl_am including a 
# scale_color_manual() layer using the vector myCol as the values.
#     Copy your scatter plot code from the previous instruction and add a facet_grid() 
# layer facetting the plot according to gear on rows and vs on columns 
# (0 is a V-engine and 1 is a straight engine). Now we have 6 variables in total 
# (4 categorical variables and 2 continuous variables). The plot is still readable, 
# but it's starting to get difficult.
#     We can try and add one more variable, using size. Map disp, the displacement 
# volume from each cylinder, onto size. We haven't used alpha, but for a more dense
# dataset, that would also be necessary. It would also make it more difficult to 
# read cyl which is mapped onto lightness.
mtcars$cyl_am <- paste(mtcars$cyl, mtcars$am, sep = "_")
myCol <- rbind(brewer.pal(9, "Blues")[c(3,6,8)],
               brewer.pal(9, "Reds")[c(3,6,8)])
# Basic scatter plot, add color scale:
ggplot(mtcars, aes(x = wt, y = mpg, col=cyl_am)) + 
    geom_point() + scale_color_manual(values=myCol)
# Facet according on rows and columns.
ggplot(mtcars, aes(x = wt, y = mpg, col=cyl_am)) + geom_point() + 
    scale_color_manual(values=myCol) + facet_grid(gear ~ vs)
# Add more variables
ggplot(mtcars, aes(x = wt, y = mpg, col=cyl_am, size=disp)) + 
    geom_point() + scale_color_manual(values=myCol) + facet_grid(gear ~ vs)

# dropping levels
# When you have a categorical variable with many levels which are not all present 
# in sub-groups of another variable, it may be desirable to drop the unused levels. 
# As an example let's return to the mammalian sleep dataset, mamsleep. 
# It is available in your workspace.
# The variables of interest here are name, which contains the full popular name of
# each animal, and vore, the eating behavior. Each animal can only be classified 
# under one eating habit, so if we facet according to vore, we don't need to 
# repeat the full list in each sub-plot.
#
# Create a basic scatter plot using mamsleep, with time mapped to x, name to y and
# sleep to col.
# Extend the code for the previous instruction: facet rows according to vore. 
# If you look at the resulting plot, you'll notice that there are a lot of lines 
# where no data is available.
# Extend facet_grid with scale = "free_y" and space = "free_y" to leave out rows 
# for which there's no data.
#
# > str(mamsleep) # make from msleep?
# 'data.frame':	112 obs. of  4 variables:
#     $ vore : chr  "omni" "herbi" "omni" "herbi" ...
# $ name : chr  "Owl monkey" "Mountain beaver" "Greater short-tailed shrew" "Cow" ...
# $ sleep: Factor w/ 2 levels "total","rem": 1 1 1 1 1 1 1 1 1 1 ...
# $ time : num  17 14.4 14.9 4 14.4 8.7 10.1 5.3 9.4 10 ...
#
# Basic scatter plot
ggplot(mamsleep, aes(x=time, y=name, col=sleep)) + geom_point()
# Facet rows accoding to vore
ggplot(mamsleep, aes(x=time, y=name, col=sleep)) + 
    geom_point() + facet_grid(vore ~ .)
# Specify scale and space arguments to free up rows
ggplot(mamsleep, aes(x=time, y=name, col=sleep)) + 
    geom_point() + facet_grid(vore ~ ., scale="free_y", space="free_y")


#
# 3 - Themes
#
#
# Rectangles
z + theme(plot.background=element_rect(fill=myPink))
# Plot 2: adjust the border to be a black line of size 3
z + theme(plot.background=element_rect(fill=myPink, color="black", size=3))
# Plot 3: set panel.background, legend.key, legend.background and 
# strip.background to element_blank()
uniform_panels <- theme(panel.background = element_blank(), 
                        legend.key = element_blank(), 
                        legend.background=element_blank(), 
                        strip.background = element_blank())
z + theme(plot.background=element_rect(fill=myPink, color="black", size=3)) + 
    uniform_panels

# lines
z + 
    theme(panel.grid = element_blank(), 
          axis.line=element_line(color="black"), 
          axis.ticks=element_line(color="black"))

# text
z + theme(
    strip.text=element_text(size=16, color=myRed),
    axis.title.y=element_text(color=myRed, hjust=0, face="italic"),
    axis.title.x=element_text(color=myRed, hjust=0, face="italic"),
    axis.text=element_text(color="black")
)

# legends
# Move legend by position
z + theme(legend.position=c(0.85, 0.85))
# Change direction
z + theme(legend.direction="horizontal")
# Change location by name
z + theme(legend.position="bottom")
# Remove legend entirely
z + theme(legend.position="none")

# positions
library(grid)
z + theme(panel.margin.x=unit(2, "cm"))
# Add code to remove any excess plot margin space
z + theme(panel.margin.x=unit(2, "cm"), plot.margin=unit(c(0,0,0,0), "cm"))

# themes
# Theme layer saved as an object, theme_pink
theme_pink <- theme(panel.background = element_blank(),
                    legend.key = element_blank(),
                    legend.background = element_blank(),
                    strip.background = element_blank(),
                    plot.background = element_rect(fill = myPink, color = "black", size = 3),
                    panel.grid = element_blank(),
                    axis.line = element_line(color = "black"),
                    axis.ticks = element_line(color = "black"),
                    strip.text = element_text(size = 16, color = myRed),
                    axis.title.y = element_text(color = myRed, hjust = 0, face = "italic"),
                    axis.title.x = element_text(color = myRed, hjust = 0, face = "italic"),
                    axis.text = element_text(color = "black"),
                    legend.position = "none")
# Apply theme_pink to z2
z2 + theme_pink
# Change code so that old theme is saved as old
old <- theme_update(panel.background = element_blank(),
                    legend.key = element_blank(),
                    legend.background = element_blank(),
                    strip.background = element_blank(),
                    plot.background = element_rect(fill = myPink, 
                                                   color = "black", size = 3),
                    panel.grid = element_blank(),
                    axis.line = element_line(color = "black"),
                    axis.ticks = element_line(color = "black"),
                    strip.text = element_text(size = 16, color = myRed),
                    axis.title.y = element_text(color = myRed, hjust = 0, 
                                                face = "italic"),
                    axis.title.x = element_text(color = myRed, hjust = 0, 
                                                face = "italic"),
                    axis.text = element_text(color = "black"),
                    legend.position = "none")
# Display the plot z2
z2
# Restore the old plot
theme_set(old)

# exploring ggthemes
# Load ggthemes package
library(ggthemes)
# apply these themes to all following plots, with theme_set():
#     theme_set(theme_bw())
# But you can also apply them on a particular plot, with:
#     ... + theme_bw()
# Apply theme_tufte
z2 + theme_tufte()
# Apply theme_tufte, modified:
z2 + theme_tufte() + theme(
    legend.position=c(0.9, 0.9),
    legend.title=element_text(face="italic", size=12),
    axis.title=element_text(face="bold", size=14))


#
# 4 - Best Practices
#
# Bar plots (1)
# Base layers
m <- ggplot(mtcars, aes(x = cyl, y = wt))
# Draw dynamite plot
m +
    stat_summary(fun.y = mean, geom = "bar", fill = "skyblue") +
    stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), 
                 geom = "errorbar", width = 0.1)
# Bar plots (2)
# Base layers
m <- ggplot(mtcars, aes(x = cyl,y = wt, col = am, fill = am))
# Plot 1: Draw dynamite plot
m +
    stat_summary(fun.y = mean, geom = "bar") +
    stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), 
                 geom = "errorbar", width = 0.1)
# Plot 2: Set position dodge in each stat function
m +
    stat_summary(fun.y = mean, geom = "bar", position = "dodge") +
    stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), 
                 geom = "errorbar", width = 0.1, position = "dodge")
# Set your dodge posn manually
posn.d <- position_dodge(0.9)
# Plot 3:  Redraw dynamite plot
m +
    stat_summary(fun.y = mean, geom = "bar", position = posn.d) +
    stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), 
                 geom = "errorbar", width = 0.1, position = posn.d)
# Bar plots (3)
# > mtcars.cyl
# cyl   wt.avg        sd  n    prop
# 1   4 2.285727 0.5695637 11 0.34375
# 2   6 3.117143 0.3563455  7 0.21875
# 3   8 3.999214 0.7594047 14 0.43750
# Base layers
m <- ggplot(mtcars.cyl, aes(x = cyl, y = wt.avg))
# Plot 1: Draw bar plot
m + geom_bar(stat="identity", fill="skyblue")
# Plot 2: Add width aesthetic
m + geom_bar(stat="identity", fill="skyblue", aes(width=prop))
# Plot 3: Add error bars
m + geom_bar(stat="identity", fill="skyblue", aes(width=prop)) + 
    geom_errorbar(aes(ymin=wt.avg - sd, ymax=wt.avg+sd), width=0.1)

# pie charts (1)
ggplot(mtcars, aes(x = cyl, fill = am)) + geom_bar(position = "fill") + facet_grid(. ~ cyl)
ggplot(mtcars, aes(x = factor(1), fill = am)) + geom_bar(position = "fill") + 
    facet_grid(. ~ cyl)
ggplot(mtcars, aes(x = factor(1), fill = am)) + geom_bar(position = "fill") + 
    facet_grid(. ~ cyl) + coord_polar(theta="y")
ggplot(mtcars, aes(x = factor(1), fill = am)) + 
    geom_bar(position = "fill", width=1) + 
    facet_grid(. ~ cyl) + coord_polar(theta="y")

# heatmaps
library(lattice)
names(barley)

# heatmaps - perception of color changes depending on the nighboring colors
# not suitable for individual seeing results
# for trends? not good
# plotting continuous data on a common scale is better
# timescale - change over time

# Define the data and the aesthetics layer. Using the barley dataset, 
# map year onto x, variety onto y and fill according to yield
# Add a geom_tile() to build the heat maps.
# So far the entire dataset it plotted on one heat map. Add a facet_wrap() 
# function to get a facetted plot. Use the formula ~ site (without the dot!) 
# and set ncol = 1. By default, the names of the farms will be above the panels, 
# not to the side.
# brewer.pal() from the RColorBrewer package has been used to create a "Reds" 
# color palette. The hexadecimal color codes are stored in the myColors object. 
# Add the scale_fill_gradientn() function and specify the colors argument 
# correctly to give the heat maps a reddish look.
# Create color palette
myColors <- brewer.pal(9, "Reds")
# Build the heat map from scratch
ggplot(barley, aes(x=year, y=variety, fill=yield)) + 
    geom_tile() + 
    facet_wrap(~ site, ncol=1) + 
    scale_fill_gradientn(colors=myColors)

# The line plot might be a good alternative:
#     Base layer: same dataset, map year onto x, yield onto y and variety onto col
# as well as onto group!
#     Add the appropriate geom for this line plot; no additional arguments are needed.
# Add facetting with the same formula as in the heat map plot, instead of ncol, set nrow to 1.
myColors <- brewer.pal(9, "Reds")
ggplot(barley, aes(x = year, y = variety, fill = yield)) + geom_tile() + 
    facet_wrap( ~ site, ncol = 1) + scale_fill_gradientn(colors = myColors)
# Line plots
ggplot(barley, aes(x = year, y = yield, col = variety, group=variety)) + 
    geom_line() + facet_wrap( ~ site, nrow = 1)

# In the videos we saw two methods for depicting overlapping measurements of 
# spread. You can use dodged error bars or you can use overlapping transparent ribbons
# Base layer: use the barley dataset. Try to come up with the correct mappings 
# for x, y, col, group and fill.
# Add a stat_summary() function for the mean. Specify fun.y to be mean and set 
# geom to "line".
# Add a stat_summary() function for the ribbons. Set fun.data = mean_sdl and 
# fun.args = list(mult = 1) to have a ribbon that spans over one standard 
# deviation in both directions. Use the "ribbon" geom. Set col = NA and alpha = 0.1.
ggplot(barley, aes(x=year, y=yield, fill=site, group=site, col=site)) + 
    stat_summary(fun.y=mean, geom="line") + 
    stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), 
                 geom="ribbon", col=NA, alpha=.1)