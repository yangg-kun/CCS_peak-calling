## parameters:
### predictions | table of predicted values with titles
### saving | path for saving transformed table

require(here)
source(here("utils.R"), chdir = T)

require_package(tidyr)
require_package(dplyr)

predictions %>% read.table(head = T) %>% 
  separate(title, c("chr", "start", "end", "i")) %>% 
  mutate(start = as.int(start) + as.int(i) - 1) %>% 
  mutate(end = as.int(end) + as.int(i) - 1) %>% 
  mutate(i = NULL) %>% 
  mutate(position = (start + end) %/% 2) %>% 
  select(one_of(c("chr", "start", "end", 
                  "position", "value")), 
         everything()) %>% 
  write.table(saving, quote = F, sep = "\t",
              col.names = T, row.names = F)
