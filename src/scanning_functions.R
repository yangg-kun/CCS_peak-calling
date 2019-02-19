source("utils.R", chdir = T)

## loading fasta file as a data.frame
df_from_fasta <- function(fa_file)
{
  fa_reads <- readLines(fa_file)
  fa_df <- data.frame(heads=c(), seqs=c())
  head_i <- ""
  seq_i <- ""
  for(i in seq(fa_reads)){
    line_len <- nchar(fa_reads[i])
    if(substr(fa_reads[i], 1, 1) == ">"){
      fa_df <- rbind(fa_df, data.frame(heads=head_i, seqs=seq_i))
      head_i <- substr(fa_reads[i], 2, line_len)
      seq_i <- ""
    }else{
      seq_i <- paste0(seq_i, substr(fa_reads[i], 1, line_len))
    }
  }
  fa_df <- rbind(fa_df, data.frame(heads=head_i, seqs=seq_i))
  fa_df <- fa_df[-1,]
  rownames(fa_df) <- seq(nrow(fa_df))
  rm("fa_reads")
  fa_df
}

## generating a vector of k-mers
make_k_mer <- function(k, bases=c('A','T','C','G'))
{
  i_mer <- bases
  if(k < 2){
    return(bases)
  }
  for(i in 2:k){
    i_mer <- sapply(bases, 
                    function(char, char_vec){
                      paste0(char, char_vec)
                    }, 
                    i_mer)
    i_mer <- as.character(as.vector(i_mer))
  }
  i_mer
}

## require dependent packages
### packages will be installed automatically if they are not avaliable
require_packages(c("randomForest", 
                   "foreach", 
                   "doParallel"))
### an alternative way
# require_package(randomForest)
# require_package(foreach)
# require_package(doParallel)

pred.f <- function(sequence){
  # global vaules included: trained_model
  mat <- data.frame(k_mer=make_k_mer(6), n=0)
  for (j in 1:(nchar(sequence) - 5)){
    lo <- which(mat[, 1] == substr(sequence, j, (j + 5)))
    mat[lo, 2] <- as.numeric(mat[lo, 2]) + 1
  }
  mat <- mat[,2]/(nchar(sequence) - 5)
  as.numeric(predict(trained_model, mat))
}

## core function for parallel processing
core_func <- function(df_i){
  # global vaules included: window_size, step_size
  head_i <- as.character(unlist(df_i[1]))
  seq_i <- as.character(unlist(df_i[2]))
  
  for_i <- seq(1, nchar(seq_i) - window_size, step_size)
  for_func <- function(la_i){
    require(randomForest)
    sequence <- substr(seq_i, la_i, la_i + window_size - 1)
    if(length(grep("N", sequence, ignore.case = T))){
      return(data.frame(region = out, value = NA))
    }
    pred <- pred.f(sequence)
    out <- data.frame(title = paste0(head_i, "_", la_i), 
                      value = pred)
  }
  outs <- lapply(for_i, for_func)
  results <- data.frame(title = c(), value = c())
  for(out in outs){
    results <- rbind(results, out)
  }
  return(results)
}
