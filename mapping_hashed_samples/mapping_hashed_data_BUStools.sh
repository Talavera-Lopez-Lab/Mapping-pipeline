#!/bin/bash -x

###SET UP WORKING ENVIRONMENT

WF=kite
CPU=8
INDEX=/Users/cartalop/github/Mapping-pipeline/mapping_hashed_samples/bustools_index/GRCm39
CHEM=10xv3
READS=/Volumes/XF-11/hh/

for i in $(cat samples.tsv)

do
    mkdir $i

    cd $i
    
    kb count --h5ad --gene-names \
       -i $INDEX/GRCm39_idx \
       -g $INDEX/GRCm39_t2g \
       -x $CHEM \
       --workflow $WF \
       -t $CPU \
       $READS/$i/*.fastq.gz

    cd ..

done

    
