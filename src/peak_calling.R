## parameters:
### predictions | path of predictions
### mismatch | maximal of mismatches
### consistency | proportion of consistency
### peak_file | path for saving selected peaks

require(here)
source(here("peak_calling_functions.R"), chdir = T)

get_peaks <- function(values, top_min = 3, peak_min = 2, 
                      tolerance = 3, reset = T)
{
  peaks <- data.frame()
  tops <- get_top_points(values, minimun = top_min)
  ind <- which(values < peak_min)
  for(ti in tops){
    sta_ti <- max(ind[ind < ti]) + 1
    end_ti <- min(ind[ind > ti]) - 1
    if(is.na(sta_ti) | sta_ti > ti){sta_ti <- 1}
    if(is.na(end_ti) | end_ti < ti){end_ti <- len(values)}
    val_ti <- values[sta_ti:end_ti]
    ii <- ti - sta_ti + 1
    peaks <- rbind(peaks, 
                   count_trend(val_ti, ii, 
                               direction = -1, 
                               tolerance = tolerance, 
                               reset = reset) %>% 
                     as.df() %>% cbind(top_p=ti, .), 
                   count_trend(val_ti, ii, 
                               direction = 1, 
                               tolerance = tolerance, 
                               reset = reset) %>% 
                     as.df() %>% cbind(top_p=ti, .))
  }
  peaks %>% 
    mutate(end_p = top_p - start_at + end_at) %>% 
    select(top_p, count, total, end_p) %>% 
    group_by(top_p) %>% 
    summarise(count = sum(count), 
              total = sum(total), 
              start = min(end_p), 
              end = max(end_p)) %>% 
    ungroup %>% 
    rename(top = top_p) %>% 
    mutate(percent = count / total)
}

## peaks from a data.frame of several discontinuous regions
df_get_peaks <- function(df, mismatch=0)
{
  regs <- df %>% arrange(chr, position) %>%
    select(position) %>% unlist() %>% reg_vec()
  peaks <- data.frame()
  for(ri in 1:(nrow(regs))){
    df_ri <- df %>% 
      slice(regs$i_start[ri]:regs$i_end[ri]) %>% 
      df_get_region()
    p_ri <- df_ri$value %>% 
      get_peaks(tolerance = mismatch)
    if(nrow(p_ri) == 0) next
    p_ri <- p_ri %>% 
      mutate(chr = df_ri$chr[top]) %>% 
      mutate(start = df_ri$position[start]) %>% 
      mutate(end = df_ri$position[end]) %>% 
      mutate(top = df_ri$position[top]) %>% 
      df_get_region(remove = T) %>% 
      select(region, everything()) %>% 
      rename(peak = region)
    peaks <- peaks %>% 
      rbind(p_ri %>% cbind(region=ri, .))
  }
  peaks
}


read.table(predictions, head = T) %>% 
  df_get_peaks(mismatch = mismatch) %>% 
  filter(percent > consistency) %>% 
  write.table(file = peak_file, 
              quote = F, sep = "\t", 
              col.names = T, 
              row.names = F)
