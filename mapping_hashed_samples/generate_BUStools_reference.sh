#!/bin/bash -x

### SET UP WORKING ENVIRONMENT

CPU=8
WF=standard
GTF=/Users/cartalop/github/Mapping-pipeline/data/gencode.vM33.annotation.gtf
FASTA=/Users/cartalop/github/Mapping-pipeline/data/GRCm39.genome.fa
GENOME=GRCm39

### GENERATE MAPPING INDEX FOR GRCm39

mkdir bustools_index

cd bustools_index

mkdir $GENOME

cd $GENOME

kb ref -i $GENOME\_idx \
   -g $GENOME\_t2g \
   -f1 $GENOME\_cDNA \
   -t $CPU \
   --workflow $WF \
   $FASTA \
   $GTF

cd ../..

