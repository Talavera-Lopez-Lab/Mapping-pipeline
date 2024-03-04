#!/bin/bash

# Define the paths to the required files and directories
REFERENCE_GTF="/mnt/LaCIE/annaM/human_reference_genome/files_from_genecode/gencode.v45.chr_patch_hapl_scaff.annotation.gtf"
INPUT_GTF_LIST="/mnt/LaCIE/annaM/human_reference_genome/Combined_annotations/list_of_gtf_files.txt" # A text file that lists all the GTF files you want to merge
OUTPUT_PREFIX="merged_gtf_output"

/home/amaguza/tools/gffcompare/gffcompare \
  -i $INPUT_GTF_LIST \
  -r $REFERENCE_GTF \
  -o $OUTPUT_PREFIX

echo "Merging completed. Check the outputs with prefix $OUTPUT_PREFIX"
