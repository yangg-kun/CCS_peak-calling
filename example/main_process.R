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


## scanning
model_file <- "./trained_model_50bp.RData"
n_cores <- 8 ## number of cores used in parallel process
window_size <- 50
step_size <- 1
fa_file <- "./example.fa"
pred_file <- "./example.pred"
source(src_path("scanning.R"))

## create a table of predictions with position information
predictions <- "./example.pred"
saving <- "./example.ppred"
source(src_path("title2position.R"))

## peak-calling
predictions <- "./example.ppred"
mismatch <- 3 ## maximal of mismatches
consistency <- 0.8 ## proportion of consistency
peak_file <- "./example.peak"
source(src_path("peak_calling.R"))
