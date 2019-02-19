## parameters:
### model_file | path of a .RData file including model variable 'trained_model'
### n_cores | number of cores used in parallel process
### window_size | window size for scanning(usually depending on the prediction model used)
### step_size | step size for scanning
### fa_file | path of the fasta file to be scanning
### output | path for saving predicted results

require(here)
source(here("scanning_functions.R"), chdir = T)

## loading a trained model from a .RData file
load(model_file)

## load fasta file as a data.frame
fa_df <- df_from_fasta(fa_file)

## prediction
t0 <- Sys.time()
cl <- makeCluster(n_cores)
registerDoParallel(cl)
results <- 
  foreach(df_i=iter(fa_df, by="row"), 
          .combine=rbind) %dopar% 
  core_func(df_i)
stopImplicitCluster()
dtime <- Sys.time() - t0
cat("time for scanning:\n ")
print(dtime)
write.table(results, file = pred_file, 
            quote = F, sep = "\t", 
            row.names = F)
cat("results saved in '", pred_file, "'\n", sep="")
