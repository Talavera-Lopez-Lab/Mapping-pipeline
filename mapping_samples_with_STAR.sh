#!/bin/bash

# Declare an associative array with run accessions as keys and sample names as values
declare -A samples
samples=(
  ["ERR11403589"]="HCAHeart9508627"
  ["ERR11403590"]="HCAHeart9508628"
  ["ERR11403591"]="HCAHeart9508629"
  #... add other samples as needed
)

# Base URL
base_url="ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR114"

# File suffixes
suffixes=("S1_L001_I2_001.fastq.gz" "S1_L001_I1_001.fastq.gz" "S1_L001_R1_001.fastq.gz" "S1_L001_R2_001.fastq.gz")

# Base directory
BASE_DIR="/home/amaguza/data/test_heart_data/GEX"

# Mapping command
STAR_CMD="/home/amaguza/STAR-2.7.11a/source/STAR"

# Iterate over the associative array
for accession in "${!samples[@]}"; do
  sample=${samples[$accession]}
  
  # Create a directory for each sample inside the base directory
  mkdir -p "$BASE_DIR/$sample"
  
  # Change to the sample directory
  cd "$BASE_DIR/$sample"
  
  # Iterate over the suffixes and download files
  for suffix in "${suffixes[@]}"; do
    # Construct the file URL
    file_url="${base_url}/${accession}/${sample}_${suffix}"
    
    # Use axel to download the file with 40 connections
    axel -n 10 --output="${sample}_${suffix}" "$file_url"
    
    # Unzip the files
    gunzip "${sample}_${suffix}"
  done
  
  # Mapping the fastq files to the genome
  $STAR_CMD --runThreadN 40 \
            --genomeDir /home/amaguza/data/human_reference_genome/index_file_STAR \
            --readFilesIn "$sample_name_S1_L001_R1_001.fastq" "$sample_name_S1_L001_R2_001.fastq" \
            --runDirPerm All_RWX GZIP --soloBarcodeMate 1 --clip5pNbases 28 0 --soloType CB_UMI_Simple \
            --soloCBwhitelist /home/amaguza/data/10X_Genomics_whitelists/737K-arc-v1.txt \
            --soloCBstart 1 --soloCBlen 16 --soloUMIstart 17 --soloUMIlen 12 --soloStrand Forward \
            --soloUMIdedup 1MM_CR --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR \
            --soloCellFilter EmptyDrops_CR --outFilterScoreMin 30 \
            --soloFeatures Gene GeneFull Velocyto --soloOutFileNames output/ features.tsv barcodes.tsv matrix.mtx \
            --soloMultiMappers EM --outReadsUnmapped Fastx
  
  # Delete the initial fastq files
  rm "$sample_S1_L001_R1_001.fastq" "$sample_S1_L001_R2_001.fastq"
  
  # Change back to the parent directory
  cd "$BASE_DIR"
done

