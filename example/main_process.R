## preparations
### set the directory of scripts
src_dir <- "../src/"
src_path <- function(path) paste0(src_dir, path)

### uncomment to change repos
## r <- getOption("repos")
## r["CRAN"] <- "https://cran.rstudio.com/"
## options(repos = r)

### loading dependencies
if(! "here" %in% installed.packages()) install.packages("here")
require(here)

## main processes
### scanning
model_file <- "./trained_model_50bp.RData"  # including model variable 'trained_model'
n_cores <- 8  # number of cores used in parallel process
window_size <- 50
step_size <- 1
fa_file <- "./example.fa"  # input fasta file
pred_file <- "./example.pred"  # path for saving predicted results
source(src_path("scanning.R"))

### creating a table of predictions with position information from scanning result
predictions <- "./example.pred"
saving <- "./example.ppred"
source(src_path("title2position.R"))

### peak-calling
predictions <- "./example.ppred"  # input file
mismatch <- 3  # maximal of mismatches
consistency <- 0.8  # proportion of consistency
peak_file <- "./example.peak"  # path for saving detected peaks
source(src_path("peak_calling.R"))
