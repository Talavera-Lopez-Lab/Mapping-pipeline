#!/bin/bash

kb ref -i index_file_bustool/transcriptome.idx \
-g index_file_bustool/transcripts_to_genes.txt \
-f1 index_file_bustool/cdna.fa \
GRCh38.p14.genome.fa.gz \
merged_gtf_output_combined.gtf