## uncomment to change repos
## r <- getOption("repos")
## r["CRAN"] <- "https://cran.rstudio.com/"
## options(repos = r)

if(! "here" %in% installed.packages()) install.packages("here")
require(here)

if(! "getopt" %in% installed.packages()) install.packages("getopt")
require(getopt)

spec = matrix(c(
  'input', 'i', 1, "character", "path of predictions",
  'mismatch', 'm', 2, "integer", "maximal of mismatches",
  'consistency', 'c', 2, "double", "proportion of consistency",
  'output', 'o', 1, "character", "path for saving selected peaks",
  'title2position', 't', 2, "character", "transforming predictions into required form",
  'help', 'h', 0, "logical", "help for peak-calling"
), byrow = T, ncol = 5)

opt = getopt(spec)
if(!is.null(opt$help)){
  cat(getopt(spec, usage=TRUE))
  q(status=1)
}

if(is.null(opt$input)){opt$input = "./example/example.pred"}
if(is.null(opt$mismatch)){opt$mismatch = 3}
if(is.null(opt$consistency)){opt$consistency = 0.8}
if(is.null(opt$output)){opt$output = "./example/example.peak"}
if(is.null(opt$title2position)){opt$title2position = ""}

predictions <- opt$input
mismatch <- opt$mismatch
consistency <- opt$consistency
peak_file <- opt$output

if(nchar(opt$title2position) > 0){
  saving <- opt$title2position
  source(here("title2position.R"))
  predictions <- saving
}

source(here("peak_calling.R"), chdir = T)
