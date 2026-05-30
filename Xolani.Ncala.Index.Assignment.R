## ----setup, include=FALSE-------------------------
knitr::opts_chunk$set(echo = FALSE)


## ----echo=FALSE-----------------------------------
library(dplyr)
iiag.data <- read.csv("2024 IIAG_Processed Data.csv",
                 header = TRUE,
                 na.strings = c("", ".", "NA"))

library(stargazer)
index.variables <- data.frame(iiag.data$Country,iiag.data$Year, iiag.data$Political.Context, iiag.data$Media.Impartiality, iiag.data$Legal.Framework, iiag.data$Absence.of.Media.Censorship, iiag.data$Internet.Users..Privacy.Protection, iiag.data$Absence.of.Online.Censorship)

clean.index.variables <- na.omit(index.variables[, c("iiag.data.Country", "iiag.data.Year", "iiag.data.Political.Context", "iiag.data.Media.Impartiality", "iiag.data.Legal.Framework", "iiag.data.Absence.of.Media.Censorship", "iiag.data.Internet.Users..Privacy.Protection", "iiag.data.Absence.of.Online.Censorship")])

index.variables.22 <- subset(clean.index.variables, iiag.data.Year == 2022 )


stargazer(index.variables.22, type = "text")

num.index.variables.22 <- index.variables.22[, sapply(index.variables.22, is.numeric)]

cnum.index.variables.22 <- num.index.variables.22[,apply(num.index.variables.22,2, function(x) var(x, na.rm = TRUE) != 0)]

stargazer(cor(cnum.index.variables.22, use="complete.obs"), type = "text")





## -------------------------------------------------

# Min-Max Normalization Formula:
# Normalized Score = (X - Min) / (Max - Min)

# Botswana's score
botswana_score <- 55.63

# Min-max normalization
normalized_botswana <- (botswana_score - min(index.variables.22$iiag.data.Political.Context)) / 
                       (max(index.variables.22$iiag.data.Political.Context) - min(index.variables.22$iiag.data.Political.Context))




## ----echo=FALSE-----------------------------------
# Are the distributions of any component measures highly skewed, so that they should be transformed even before putting them onto a common scale (such as the log transformation of GNI per capita in the HDI)?

#Political Context Meausure 2022
hist((cnum.index.variables.22$iiag.data.Political.Context), 
     main = "Histogram of Political Context 2022", 
     xlab = "Political Context", 
     col = "lightblue", 
     border = "black",
     freq = FALSE)
lines(density(cnum.index.variables.22$iiag.data.Political.Context),
      col = "red")

#Media Impartiality Measure 2022
hist((cnum.index.variables.22$iiag.data.Media.Impartiality),
     main = "Histogram of Media Impartiality 2022",
     xlab = "Media Impartiality",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density(cnum.index.variables.22$iiag.data.Media.Impartiality),
      col = "red")

#Legal Framework Meausre 2022
hist((cnum.index.variables.22$iiag.data.Legal.Framework),
     main = "Histogram Of Legal Framework 2022",
     xlab = "Legal Framework",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density(cnum.index.variables.22$iiag.data.Legal.Framework),
      col = "red")

#Absence of Media Censorship
hist((cnum.index.variables.22$iiag.data.Absence.of.Media.Censorship),
     main = "Histogram of Absence of Media Censorship 2022",
     xlab = "Absence of Media Censorship",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density(cnum.index.variables.22$iiag.data.Absence.of.Media.Censorship), 
      col = "red")
#Internet Users Privacy Protection
hist((cnum.index.variables.22$iiag.data.Internet.Users..Privacy.Protection),
     main = "Histogram of Internet Users Privacy Protection 2022",
     xlab = "Internet Users Privacy Protection",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density(cnum.index.variables.22$iiag.data.Internet.Users..Privacy.Protection),
      col = "red")

#Absence of online Censorship
hist((cnum.index.variables.22$iiag.data.Absence.of.Online.Censorship),
     main = "Histogram of Absense of Online Censorship 2022",
     xlab = "Absence of Online Censorship",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density((num.index.variables.22$iiag.data.Absence.of.Online.Censorship)),
      col = "red")



## -------------------------------------------------
Validity.index.variables <- (iiag.data[, c("Country","Year", "Political.Context", "Media.Impartiality", "Legal.Framework", "Absence.of.Media.Censorship", "Internet.Users..Privacy.Protection", "Absence.of.Online.Censorship",
                                           "Freedom.to.Express.Personal.Opinion", "Reporting.of.Election.Monitoring.Agencies", "Equal.Party.Access.to.State.Owned.Media")])
Validity.index.variables.22 <- subset(Validity.index.variables, Year == 2022 )

num.validity.index.variable.22 <- Validity.index.variables.22[, sapply(Validity.index.variables.22, is.numeric)]

cnum.validity.index.variable.22 <- num.validity.index.variable.22[, apply(num.validity.index.variable.22,2, function(x) var(x, na.rm = TRUE)!=0)]

correlation <- stargazer(cor(cnum.validity.index.variable.22, use="complete.obs"), type = "text")





## -------------------------------------------------
# Constructing the Index 

# Assuming the dataset is called index.variables.22 and already loaded

# I will specify the component columns 
components <- c(
  "iiag.data.Political.Context", 
  "iiag.data.Media.Impartiality", 
  "iiag.data.Legal.Framework", 
  "iiag.data.Absence.of.Media.Censorship", 
  "iiag.data.Internet.Users..Privacy.Protection", 
  "iiag.data.Absence.of.Online.Censorship"
)

# Here I will normalise each component (x-min)/(max -min)

for (comp in components) {
  norm_col <- paste0("Norm_", comp)
  min_val <- min(index.variables.22[[comp]], na.rm = TRUE)
  max_val <- max(index.variables.22[[comp]], na.rm = TRUE)
  index.variables.22[[norm_col]] <- (index.variables.22[[comp]] - min_val) / (max_val - min_val)
}

# Create MDFI score column: mean of normalized components × 100
norm_cols <- paste0("Norm_", components)
index.variables.22$MDFI_Score <- rowMeans(index.variables.22[, norm_cols], na.rm = TRUE) * 100

# View the updated dataset
MDFI_score <- index.variables.22[,c(
  "iiag.data.Political.Context", 
  "iiag.data.Media.Impartiality", 
  "iiag.data.Legal.Framework", 
  "iiag.data.Absence.of.Media.Censorship", 
  "iiag.data.Internet.Users..Privacy.Protection", 
  "iiag.data.Absence.of.Online.Censorship",
  "MDFI_Score")]
library(knitr)

library(kableExtra)

# Create a clean table with custom formatting
MDFI_score_table <- index.variables.22[, c(
  "iiag.data.Country",  # optional: add country for reference
  "iiag.data.Political.Context", 
  "iiag.data.Media.Impartiality", 
  "iiag.data.Legal.Framework", 
  "iiag.data.Absence.of.Media.Censorship", 
  "iiag.data.Internet.Users..Privacy.Protection", 
  "iiag.data.Absence.of.Online.Censorship",
  "MDFI_Score")]
rownames(MDFI_score_table) <- 1:nrow (MDFI_score_table) 
MDFI_score_table.clean <- MDFI_score_table[, !names(MDFI_score_table) %in% "Row_Number"]
# Generate the table
kable(MDFI_score_table.clean, 
      caption = "Media and Digital Freedom Index (MDFI) Scores for 2022",
      digits = 2, 
      align = "c") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), 
                full_width = FALSE,
                font_size = 12)


## -------------------------------------------------
summary(MDFI_score_table.clean$MDFI_Score)


## -------------------------------------------------
hist((MDFI_score_table.clean$MDFI_Score),
     main = "Histogram of Media and Digital Index Scores",
     xlab = "MDFI score",
     col = "lightblue",
     border = "black",
     freq = FALSE)
lines(density(MDFI_score_table.clean$MDFI_Score),
      col = "red")

