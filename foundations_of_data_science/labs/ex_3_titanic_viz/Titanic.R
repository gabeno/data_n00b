# titanic is avaliable in your workspace
titanic <- read.csv('../ex_2_data_wrangling/titanic_clean.csv')

names(titanic)
head(titanic)
str(titanic)

titanic$Sex <- titanic$sex
titanic$Age <- titanic$age
titanic$Pclass <- titanic$pclass
titanic$Survived <- titanic$survived

names(titanic)

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