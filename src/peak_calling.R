## parameters:
### predictions | path of predictions
### mismatch | maximal of mismatches
### consistency | proportion of consistency
### peak_file | path for saving selected peaks

require(here)
source(here("peak_calling_functions.R"), chdir = T)

read.table(predictions, head = T) %>% 
  df_get_peaks(mismatch = mismatch) %>% 
  filter(percent > consistency) %>% 
  write.table(file = peak_file, 
              quote = F, sep = "\t", 
              col.names = T, 
              row.names = F)
