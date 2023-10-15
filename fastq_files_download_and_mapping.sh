#!/bin/bash

### Set up working environment

CPU=16
STAR_INDEX=/home/amaguza/data/human_reference_genome/index_file_STAR
base_url="ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR114"
BASE_DIR="/home/amaguza/data/test_heart_data/GEX"
STAR_CMD="/home/amaguza/STAR-2.7.11a/source/STAR"
WL=/home/amaguza/data/10X_Genomics_whitelists/737K-arc-v1.txt

# File suffixes
suffixes=("S1_L001_R1_001.fastq.gz" "S1_L001_R2_001.fastq.gz")


# Read sample and accession from the file
awk '{print $1,$2}' sample_accessions.txt | while read -r sample accession; do
  
  # Create a directory for each sample inside the base directory
  mkdir -p "$BASE_DIR/$sample"
  
  # Change to the sample directory
  cd "$BASE_DIR/$sample"
  
  # Iterate over the suffixes and download files
  for suffix in "${suffixes[@]}"; do
    # Construct the file URL
    file_url="${base_url}/${accession}/${sample}_${suffix}"
    
    # Use axel to download the file 
    axel -n $CPU --output="${sample}_${suffix}" "$file_url"

        # Unzip the files
    #gunzip "${sample}_${suffix}"

  done
  
  # Mapping the fastq files to the genome
  $STAR_CMD --runThreadN 40 \
            --genomeDir $STAR_INDEX \
            --readFilesIn <(gunzip -c "${sample}_S1_L001_R1_001.fastq.gz") <(gunzip -c "${sample}_S1_L001_R2_001.fastq.gz") \
            --runDirPerm All_RWX GZIP --soloBarcodeMate 1 --clip5pNbases 28 0 --soloType CB_UMI_Simple \
            --soloCBwhitelist $WL \
            --soloCBstart 1 --soloCBlen 16 --soloUMIstart 17 --soloUMIlen 12 --soloStrand Forward \
            --soloUMIdedup 1MM_CR --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR \
            --soloCellFilter EmptyDrops_CR --outFilterScoreMin 30 \
            --soloFeatures Gene GeneFull Velocyto --soloOutFileNames output/ features.tsv barcodes.tsv matrix.mtx \
            --soloMultiMappers EM --outReadsUnmapped Fastx
  
  # Delete the initial fastq files
  rm *.fastq *.fastq.gz
  
  # Change back to the parent directory
  cd "$BASE_DIR"
done

