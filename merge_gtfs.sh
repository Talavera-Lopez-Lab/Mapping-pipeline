#!/bin/bash

# Define the paths to the required files and directories
# Replace these paths with the correct paths on your system
REFERENCE_GTF="/home/amaguza/data/human_reference_genome/gencode.v44.chr_patch_hapl_scaff.annotation.gtf"
INPUT_GTF_LIST="/home/amaguza/data/human_reference_genome/Combined_annotations/list_of_gtf_files.txt" # A text file that lists all the GTF files you want to merge
OUTPUT_PREFIX="merged_gtf_output"

# Run GffCompare with the provided options
# Here we are merging multiple GTF files (specified in INPUT_GTF_LIST) using a reference GTF
/home/amaguza/tools/gffcompare/gffcompare \
  -i $INPUT_GTF_LIST \
  -r $REFERENCE_GTF \
  -o $OUTPUT_PREFIX

# You can add more options as needed, for example:
# -s to specify path to genome sequences
# -M or -N to discard single-exon transfrags or reference transcripts
# etc.

echo "Merging completed. Check the outputs with prefix $OUTPUT_PREFIX"
