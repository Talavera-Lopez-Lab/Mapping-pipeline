#!/bin/bash -x

### SET UP WORKING ENVIRONMENT

CPU=8
GTF=
FASTA=

### GENERATE MAPPING INDEX FOR GRCm39

kb ref -i GRCm39_idx \
   -g GRCm39_t2g \
   -f1 GRCm39_cDNA \
   -t 8 \
   --workflow standard \
   $FASTA \
   $GTF
