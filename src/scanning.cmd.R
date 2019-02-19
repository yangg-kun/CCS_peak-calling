## uncomment to change repos
## r <- getOption("repos")
## r["CRAN"] <- "https://cran.rstudio.com/"
## options(repos = r)

if(! "here" %in% installed.packages()) install.packages("here")
require(here)

if(! "getopt" %in% installed.packages()) install.packages("getopt")
require(getopt)

spec = matrix(c(
  'model_file', 'm', 1, "character", "path of a .RData file including model variable 'trained_model'", 
  'n_cores', 'p', 2, "integer", "number of cores used in parallel process", 
  'window_size', 'w', 1, "integer", "window size for scanning(usually depending on the prediction model used)", 
  'step_size', 's', 1, "integer", "step size for scanning", 
  'fa_file', 'f', 1, "character", "path of the fasta file to be scanning", 
  'output', 'o', 1, "character", "path for saving predicted results", 
  'help', 'h', 0, "logical", "help for scanning"
), byrow = T, ncol = 5)

opt = getopt(spec)
if(!is.null(opt$help)){
  cat(getopt(spec, usage=TRUE))
  q(status=1)
}

if(is.null(opt$model_file)){opt$model_file = "./example/trained_model_50bp.RData"}
if(is.null(opt$n_cores)){opt$n_cores = 1}
if(is.null(opt$window_size)){opt$window_size = 50}
if(is.null(opt$step_size)){opt$step_size = 1}
if(is.null(opt$fa_file)){opt$fa_file = './example/example.fa'}
if(is.null(opt$output)){opt$output = './example/example.pred'}

model_file <- opt$model_file
n_cores <- opt$n_cores
window_size <- opt$window_size
step_size <- opt$step_size
fa_file <- opt$fa_file
output <- opt$output
pred_file <- output
source(here("scanning.R"))
