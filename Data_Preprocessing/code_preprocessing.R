#loading formatted source data
step1_lipids_553x360 <- read.csv("Lipidomics_all_samples_Source_formatted.csv", header=T, row.names =1, sep = "\t", strip.white = F)

#transpose data frame
step2_lipids_360x553 <- as.data.frame(t(step1_lipids_553x360))


#replace all zeros "0" with NA
step2_lipids_360x553[step2_lipids_360x553 == 0] <- NA
write.table(step2_lipids_360x553, "step2_lipids_360x553NA_op.txt", row.names=T, col.names=NA, sep="\t", quote=F)


#find > 50% missing values
nacounts_lipids <- colSums(is.na(step2_lipids_360x553))
write.table(nacounts_lipids, "nacounts_lipids.txt", row.names=T, col.names=NA, sep="\t", quote=F)

#impute half minimums
library(tidyverse)
step3_lipids_360x553_hmins <- step2_lipids_360x553 %>%
  mutate_if(is.numeric, function(x) ifelse(is.na(x), min(x/2, na.rm = T), x))
write.table(step3_lipids_360x553_hmins, "step3_lipids_360x553_hmins_op.txt", row.names=T, col.names=NA, sep="\t", quote=F)

#log2 transformation
step4_lipids_360x553_hmins_logged <- log2(step3_lipids_360x553_hmins)
write.table(step4_lipids_360x553_hmins_logged, "step4_lipids_360x553_hmins_logged_op.txt", row.names=T, col.names=NA, sep="\t", quote=F)


#Auto-scaling
step5_lipids_360x553_hmins_logged_scaled <- as.data.frame(scale(step4_lipids_360x553_hmins_logged))
write.table(step5_lipids_360x553_hmins_logged_scaled, "step5_lipids_360x553_hmins_loggedscaled_op.txt", row.names=T, col.names=NA, sep="\t", quote=F)