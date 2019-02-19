## uncomment to change repos
## r <- getOption("repos")
## r["CRAN"] <- "https://cran.rstudio.com/"
## options(repos = r)

## alias
as.df <- as.data.frame
as.vec <- as.vector
as.fac <- as.factor
as.char <- as.character
as.num <- as.numeric
as.int <- as.integer
len <- length

## "require" with auto-installation
require_package <- function(pkg, character.only = FALSE)
{
  if(! character.only){
    pkg <- as.character(substitute(pkg))
  }
  if(! pkg %in% installed.packages()[, "Package"]){
    install.packages(pkg)
  }
  require(pkg, character.only = TRUE)
}

## "require" with a package list
require_packages <- function(pkgs)
{
  for(p in pkgs){
    require_package(p, character.only = TRUE)
  }
}

source_here <- function(x, ...)
{
  dir <- "."
  if(sys.nframe() > 0){
    frame <- sys.frame(1)
    if (! is.null(frame$ofile)) {
      dir <- dirname(frame$ofile)
    }
  }
  source(file.path(dir, x), ...)
}

getScriptPath <- function()
{
  cmd.args <- commandArgs()
  m <- regexpr("(?<=^--file=).+", cmd.args, perl=TRUE)
  script.dir <- dirname(regmatches(cmd.args, m))
  if(length(script.dir) == 0) stop("can't determine script dir: please call the script with Rscript")
  if(length(script.dir) > 1) stop("can't determine script dir: more than one '--file' argument detected")
  return(script.dir)
}

src_path <- function(path)
{
  paste0(getScriptPath(), "/", path)
}
