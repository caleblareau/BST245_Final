library(tidyverse)
library(BuenColors)

deng <- readRDS("data/deng.rds")
dim(deng)

#dengdf <- data.frame(deng)
#write.table(dengdf, row.names = FALSE, col.names = FALSE, sep = "\t", quote = FALSE,
#            file = "../../trajectoryCompare/dengetal.tsv")

time <- factor(
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

cl <- rev(c('#000033', '#0000A5', '#1E00FB', '#6F00FD', '#C628D6', '#FE629D', '#FF9B64', '#FFD52C', '#FFFF5F'))


barplot <- data.frame(time)
ggplot(barplot, aes(x = time)) + geom_bar(aes(fill = time)) + pretty_plot() + scale_fill_manual(values = rev(cl)) + theme(legend.position = "none")
ggsave("images/02colorBar.png", units = "in", width = 8, height = 6)

textpdf <- data.frame(
  levels = rev(c(
        "early2cell",
        "mid2cell",
        "late2cell",
        "4cell",
        "8cell",
        "16cell",
        "earlyblast",
        "midblast",
        "lateblast"
    )),
  y = 1:9,
  tp = paste0(as.character(9:1), "."), 
  color = rev(cl)
)

# ^ Easy to execute
#####################################
# Below can be more time consuming; procede with caution

#
# Make Plot summarizing the color codes / coordinates
#

ggplot(textpdf, aes(x=0, y=y, label=levels)) + geom_text(size = 10) +labs(x = NULL, y = NULL) + pretty_plot() +
    scale_x_continuous(limits=c(-9, 9)) + geom_point(inherit.aes = FALSE, data=textpdf, aes(x = 8, y = y, color = color), size = 18) +
    scale_color_manual(values  = cl) + scale_y_continuous(limits=c(0.5, 9.5)) + 
    geom_text(inherit.aes = FALSE, data=textpdf, aes(x = -8, y = y, label = tp), size = 10) +
    theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1), legend.position = "none") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) + 
    theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank()) +
    ggtitle("Cell state color key")
ggsave("images/01colorkey.png", units = "in", width = 8, height = 6)


#########
# EDA
#########
#
# Do linear regression for each gene
#

betas <- sapply(1:dim(deng)[1], function(i){
  coef(lm(log2(deng[i,]+1) ~ as.numeric(time)))[2] %>% unname
})
bdf <- data.frame(betas)
ggplot(bdf, aes(x=betas)) + geom_histogram(binwidth = 0.01) +labs(x = "Value of B1", y = "count") + pretty_plot() +
    scale_x_continuous(limits=c(-2, 2)) + 
    ggtitle("OLS Beta Coefficient with Time")
ggsave("images/05allBetas.png", units = "in", width = 8, height = 6)

#
# Permute
#

betasP <- sapply(1:dim(deng)[1], function(i){
  coef(lm(log2(deng[i,]+1) ~ sample(as.numeric(time))))[2] %>% unname
})

bdf <- data.frame(betasP)
ggplot(bdf, aes(x=betasP)) + geom_histogram(binwidth = 0.01) +labs(x = "Value of B1 from Permuted Regression", y = "count") +
  pretty_plot() + scale_x_continuous(limits=c(-2, 2)) + 
    ggtitle("OLS Beta Coefficient with Permuted Time")
ggsave("images/06allBetas.png", units = "in", width = 8, height = 6)


timeP <- factor(
    colnames(deng),
    levels = sample(levels(time))
)

betasP <- sapply(1:dim(deng)[1], function(i){
  coef(lm(log2(deng[i,]+1) ~ as.numeric(timeP)))[2] %>% unname
})

bdf <- data.frame(betasP)
ggplot(bdf, aes(x=betasP)) + geom_histogram(binwidth = 0.01) +labs(x = "Value of B1 from Permuted (Factor-level) Regression", y = "count") +
  pretty_plot() + scale_x_continuous(limits=c(-2, 2)) + 
    ggtitle("OLS Beta Coefficient with Permuted (Factor-level) Time")
ggsave("images/07allBetas.png", units = "in", width = 8, height = 6)



#
# Specific violin plots
#


makeViolinPlot = function(k){
  sdf <- data.frame(time, gene = log2(deng[k,] + 1))
  p <- ggplot(sdf, aes(x=time, y=gene)) + geom_violin(aes(fill=time), alpha = 8/10) + geom_jitter() +
    scale_fill_manual(values  = rev(cl)) + pretty_plot() + labs(x = NULL, y = "log2 Gene Expression") +
    theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1), legend.position = "none") + 
    ggtitle(rownames(deng)[k])
  ggsave(filename = paste0("images/violin.", as.character(k), ".png"), plot = p, units = "in", width = 8, height = 6)
}

#x <- lapply(which(abs(betas) > 1.5), makeViolinPlot)
#x <- lapply(which(abs(betas) < 0.0001), makeViolinPlot)


####
# PCA
####
pca <- prcomp(deng)
(pca$sdev^2)/(sum(pca$sdev^2)) %>% head()

plot(
    pca$rotation[,1],
    time,
    xlab="Principle component 1",
    ylab="True Ordering",
    col = rev(cl)[time],
    pch = 16
)


cor(pca$rotation[,1], as.numeric(time))^2

####
# Probablistic Approach
####
library(pseudogp)
ps = fitPseudotime(pca$rotation[,c(1,2)], smoothing_alpha = 30, smoothing_beta = 6, iter = 100, chains = 1)
posteriorCurvePlot(pca$rotation[,c(2,3)], ps)

pst <- extract(ps, pars = "t", permute = FALSE)
lambda <- extract(ps, pars = "lambda", permute = FALSE)
sigma <- extract(ps, pars = "sigma", permute = FALSE)
i <- 1
l <- lambda[, , (2 * i - 1):(2 * i), drop = FALSE]
s <- sigma[, , (2 * i - 1):(2 * i), drop = FALSE]

means <- sapply(1:dim(deng)[2], function(i){
  mean(pst[,1,i])
})

lb <- sapply(1:dim(deng)[2], function(i){
  quantile(pst[,1,i],0.02)
})

up <- sapply(1:dim(deng)[2], function(i){
  quantile(pst[,1,i],0.98)
})

ix <- sort.int(means, index.return = TRUE)$ix
plot(
    sort(means),
    1:length(means),
    xlab="GPLVM Ordering (Means w/ 95% Posterior Intervals)",
    ylab="Sorted Ordering",
    col = rev(cl)[as.numeric(time[ix])],
    pch = 16
)
segments(lb[ix],  1:length(means), up[ix],  1:length(means),col = rev(cl)[as.numeric(time[ix])], pch = 16)

cor(means, as.numeric(time))^2

plot(
    means,
    pca$rotation[,1],
    xlab="GPLVM Ordering",
    ylab="PC1 Ordering",
    col = rev(cl)[time],
    pch = 16
)

plot(
    means,
    time,
    xlab="GPLVM Ordering (Means w/ 95% Posterior Intervals)",
    ylab="Sorted Ordering",
    col = rev(cl)[time],
    pch = 16
)



# Define the top and bottom of the errorbars
limits <- aes(ymax = resp + se, ymin=resp - se)



#dm <- destiny::DiffusionMap(t(log2(1+deng)))
#plot(
#    dm@eigenvectors[,1],
#    time,
#    xlab="Diffusion component 1",
#    ylab="True Ordering",
#    col = colours[time],
#    pch = 16
#)

#cor(dm@eigenvectors[,1], as.numeric(time))^2


cordf <- data.frame(
  x = 1:20, 
  y = sapply(1:20, function(i){ cor(pca$rotation[,i], as.numeric(time))^2})
)

ggplot(data=cordf, aes(x=x, y=y)) + geom_bar(stat="identity") + theme(plot.subtitle = element_text(vjust = 1), 
    plot.caption = element_text(vjust = 1)) +labs(x = "Component", y = "R^2 with Time") +
   pretty_plot()
ggsave(filename = paste0("images/allPCs.png"), units = "in", width = 8, height = 6)

cor(runif(length(time)) %>% sort(), as.numeric(time) %>% sort())^2  

#
# Perfect Predictor
#
plot(
    runif(length(time)) %>% sort(),
    as.numeric(time) %>% sort(),
    xlab="Perfect Predictor",
    ylab="True Ordering",
    col = rev(cl)[as.numeric(time) %>% sort()],
    pch = 16
)

runif(length(time)) %>% sort() %>% cor(as.numeric(time) %>% sort())
