peak-calling for Computatinal CRISPR Strategy
-------------------------------------------------------------------------------

# dependencies #

* here
* getopt
* randomForest
* foreach
* doParallel
* dplyr
* tidyr

_all these dependencies will be automatically installed when they are required but not in library_

# usage #

## use commands ##

There are 2 main functions in this work: scanning and peak-calling.  

scanning: getting CRISPR Z-socres from a fasta file with a trained model  
```
Rscript ./src/scanning.cmd.R -h
Rscript ./src/scanning.cmd.R -p 8
```

peak-calling: detecting peak regions from a table including Z-scores and position information  
```
Rscript ./src/peak_calling.cmd.R -h
Rscript ./src/peak_calling.cmd.R -t "./example/example.ppred"
```

## use a script ##

'main_process.R' in example directory can be a reference.


## notice ##

1. It's not recommended to input large size strings in R, so the length of reads in the fasta file should not be too long.

2. Peak-calling requires a table of predictions with at least 3 columns: 'chr | position | value'.

3. Script 'title2position.R' is provided to transform the output of scanning process into required form, which works only when headers in the fasta file are formed like '>chr22:16110586-16111635'.
