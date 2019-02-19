source("utils.R", chdir = T)
require_package(tidyr)
require_package(dplyr)

title2position <- function(predictions)
{
  predictions %>% 
    separate(title, c("chr", "start", "end", "i")) %>% 
    mutate(start = as.int(start) + as.int(i) - 1) %>% 
    mutate(end = as.int(end) + as.int(i) - 1) %>% 
    mutate(i = NULL) %>% 
    mutate(position = (start + end) %/% 2) %>% 
    select(one_of(c("chr", "start", "end", 
                    "position", "value")), 
           everything())
}

df_get_region <- function(df, remove=F)
{
  df %>% 
    unite(region, c(start, end), sep="-", remove=remove) %>% 
    unite(region, c(chr, region), sep=":", remove=remove)
}

df_parse_region <- function(df)
{
  df %>% 
    mutate(region_ = region) %>% 
    separate(region_, c("chr", "region_"), sep=":") %>% 
    separate(region_, c("start", "end"), sep="-")
}

## region division from given vector
reg_vec <- function(vec, gap=0)
{
  regs <- c(1)
  for(i in seq(vec[-1])){
    ii <- vec[i]
    ij <- vec[i + 1]
    if(ij - ii > gap + 1){
      regs <- c(regs, i, i + 1)
    }
  }
  regs <- c(regs, len(vec))
  regs_start <- regs[seq(1, length(regs), 2)]
  regs_end <- regs[seq(2, length(regs), 2)]
  regs2 <- data.frame(i_start=regs_start, i_end=regs_end)
  regs2
}

## extreme point detection from given vector
ext_points <- function(vec, side=5, type="max")
{
  points <- c()
  for(i in 1:len(vec)){
    sta_i <- max(1, i - side)
    end_i <- min(len(vec), i + side)
    if(type == "max"){
      if(sum(vec[i] > vec[sta_i:i]) == i - sta_i && 
         sum(vec[i] > vec[i:end_i]) == end_i - i){
        points <- c(points, i)
      }
    }else if(type == "min"){
      if(sum(vec[i] < vec[sta_i:i]) == i - sta_i && 
         sum(vec[i] < vec[i:end_i]) == end_i - i){
        points <- c(points, i)
      }
    }
  }
  points
}

get_top_points <- function(values, minimun=NULL)
{
  tops <- ext_points(values, side = 10)
  if(! is.null(minimun)){
    tops <- tops[tops %in% which(values > minimun)]
  }
  tops
}

## counter for relations in expected trend in a vector
count_trend <- function(vec, point=1, direction=1, 
                        operator=">", tolerance=0, 
                        reset=F)
{
  point0 <- point
  point1 <- point
  count_total <- 0
  count_true <- 0
  score <- 0
  while(score <= tolerance){
    v0 <- vec[point]
    point <- point + direction
    if(point < 1){
      break
    }else if(point > length(vec)){
      break
    }
    count_total <- count_total + 1
    v1 <- vec[point]
    expr <- paste("v0", operator, "v1")
    if(! eval(parse(text = expr))){
      score <- score + 1
    }else{
      expr <- paste0("vec[point1]", operator, "v1")
      if(eval(parse(text = expr))){
        count_true <- count_true + 1
        point1 <- point
      }
      if(reset) score <- 0
    }
    if(vec[point1] == v1){
      point1 <- point
    }
  }
  count_total <- count_total - score
  count_total <- (point1 - point0) * direction
  point <- point - direction * max(score, 1)
  list(start_at = point0, 
       end_at = point1, 
       count = count_true, 
       total = count_total, 
       per = round(count_true / count_total, 2))
}
