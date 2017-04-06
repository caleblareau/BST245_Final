library(tidyverse)

deng <- readRDS("deng.rds")
dim(deng)

dengdf <- data.frame(deng)
write.table(dengdf, row.names = FALSE, col.names = FALSE, sep = "\t", quote = FALSE,
            file = "../../trajectoryCompare/dengetal.tsv")


tmp <- factor(
    colnames(deng),
    levels = c(
        "early2cell",
        "mid2cell",
        "late2cell",
        "4cell",
        "8cell",
        "16cell",
        "earlyblast",
        "midblast",
        "lateblast"
    )
)

colours <- rainbow(n = 9)

dm <- destiny::DiffusionMap(t(log2(1+deng)))
plot(
    dm@eigenvectors[,1],
    tmp,
    xlab="Diffusion component 1",
    ylab="True Ordering",
    col = colours[tmp],
    pch = 16
)


pca <- prcomp(deng)
(pca$sdev^2)/(sum(pca$sdev^2)) %>% head()

plot(
    pca$rotation[,1],
    tmp,
    xlab="Principle component 1",
    ylab="True Ordering",
    col = colours[tmp],
    pch = 16
)

plot(
    pca$rotation[,2],
    tmp,
    xlab="Principle component 2",
    ylab="True Ordering",
    col = colours[tmp],
    pch = 16
)

plot(
    pca$rotation[,3],
    tmp,
    xlab="Principle component 3",
    ylab="True Ordering",
    col = colours[tmp],
    pch = 16
)


plot(
    pca$rotation[,6],
    tmp,
    xlab="Principle component 5",
    ylab="True Ordering",
    col = colours[tmp],
    pch = 16
)

cor(pca$rotation[,1], as.numeric(tmp))^2
cor(dm@eigenvectors[,1], as.numeric(tmp))^2


cordf <- data.frame(
  x = 1:20, 
  y = sapply(1:20, function(i){ cor(pca$rotation[,i], as.numeric(tmp))^2})
)

ggplot(cordf, aes(x = x, y = y)) + geom_point() + geom_line()

cor(runif(length(tmp)) %>% sort(), as.numeric(tmp) %>% sort())^2  

plot(
    runif(length(tmp)) %>% sort(),
    as.numeric(tmp) %>% sort(),
    xlab="Perfect Predictor",
    ylab="True Ordering",
    col = colours[as.numeric(tmp) %>% sort()],
    pch = 16
)

