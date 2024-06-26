## Extract results of interest, write TAF output tables

## Before:
## After:

library(TAF)
library(dplyr)

mkdir("output")

# process landing ratio with survey index

load(file = "model/Chr_advice_2024.Rdata")
index_Q34 <- read.taf("data/GAM_MURQ34_indices1991-2023_tw.csv") 
catch_mur.27.3a47d <- read.csv(file = "data/Catch_summary.csv")

output_summary <- index_Q34 %>% rename(index_up = up, index_lo = lo, index_CV = CV, year = Year) %>%
  mutate(index = index/1000, index_up = index_up/1000, index_lo = index_lo/1000, age = NULL)
  
output_summary <- full_join(output_summary, catch_mur.27.3a47d)  
output_summary$advice[output_summary$advice == 0] <- NA

output_summary <- left_join(output_summary, lc@summary[, c("year", "Lc")]) %>% rename(Lc_year = Lc)
output_summary <- left_join(output_summary, lmean@summary)
output_summary$Linf <- lref@Linf
output_summary$LFeM <- lref@value

output_summary <- left_join(output_summary, fi@indicator[,c("year", "indicator")])
output_summary$inv_indicator <- 1/output_summary$indicator
output_summary <- left_join(output_summary, hr@data[,c("year", "harvest_rate")])
output_summary$Fmsy_proxy <- Fp@value
output_summary$Iloss <- bi@Iloss
output_summary$Itarget <- bi@Itrigger

write.taf(output_summary, "output/output_summary.csv")

output_summary_ref <- index_Q34 %>% rename(index_up = up, index_lo = lo, index_CV = CV, year = Year) %>%
  mutate(index = index/1000, index_up = index_up/1000, index_lo = index_lo/1000, age = NULL)

output_summary_ref <- full_join(output_summary_ref, catch_mur.27.3a47d)  
output_summary_ref$advice[output_summary_ref$advice == 0] <- NA

output_summary_ref <- left_join(output_summary_ref, lc_ref@summary[, c("year", "Lc")]) %>% rename(Lc_year = Lc)
output_summary_ref <- left_join(output_summary_ref, lmean_ref@summary)
output_summary_ref$Linf <- lref_ref@Linf
output_summary_ref$LFeM <- lref_ref@value

output_summary_ref <- left_join(output_summary_ref, fi_ref@indicator[,c("year", "indicator")])
output_summary_ref$inv_indicator <- 1/output_summary_ref$indicator
output_summary_ref <- left_join(output_summary_ref, hr@data[,c("year", "harvest_rate")])
output_summary_ref$Fmsy_proxy <- Fp_ref@value # be careful if last year of data indicator above 1 use Fp_ref
output_summary_ref$Iloss <- bi_ref@Iloss
output_summary_ref$Itarget <- bi_ref@Itrigger

write.taf(output_summary_ref, "output/output_summary_ref.csv")

output_summary_ref2 <- index_Q34 %>% rename(index_up = up, index_lo = lo, index_CV = CV, year = Year) %>%
  mutate(index = index/1000, index_up = index_up/1000, index_lo = index_lo/1000, age = NULL)

output_summary_ref2 <- full_join(output_summary_ref2, catch_mur.27.3a47d)  
output_summary_ref2$advice[output_summary_ref2$advice == 0] <- NA

output_summary_ref2 <- left_join(output_summary_ref2, lc@summary[, c("year", "Lc")]) %>% rename(Lc_year = Lc)
output_summary_ref2 <- left_join(output_summary_ref2, lmean_ref2@summary)
output_summary_ref2$Linf <- lref_ref@Linf
output_summary_ref2$LFeM <- lref_ref@value

output_summary_ref2 <- left_join(output_summary_ref2, fi_ref2@indicator[,c("year", "indicator")])
output_summary_ref2$inv_indicator <- 1/output_summary_ref2$indicator
output_summary_ref2 <- left_join(output_summary_ref2, hr@data[,c("year", "harvest_rate")])
output_summary_ref2$Fmsy_proxy <- Fp_ref2@value # be careful if last year of data indicator above 1 use Fp_ref
output_summary_ref2$Iloss <- bi_ref@Iloss
output_summary_ref2$Itarget <- bi_ref@Itrigger

write.taf(output_summary_ref2, "output/output_summary_ref2.csv") 

# LBI table
write.taf(Ind, "output/LBI.csv")
