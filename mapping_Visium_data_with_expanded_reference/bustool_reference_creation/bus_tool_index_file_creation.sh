#!/bin/bash

kb ref -i transcriptome.idx \
-g transcripts_to_genes.txt \
-f1 cdna.fa \
/mnt/LaCIE/annaM/human_reference_genome/files_from_genecode/GRCh38.p14.genome.fa.gz \
/mnt/LaCIE/annaM/human_reference_genome/Combined_annotations/expanded_gtf_annotation.gtf