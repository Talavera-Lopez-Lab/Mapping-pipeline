#!/bin/bash -x

 kb count --h5ad -i ../refseq/kb_index/GRCm39_idx -g ../refseq/kb_index/GRCm39_t2g -x 10xv3 --workflow kite -t 8 --gene-names *.fastq.gz
