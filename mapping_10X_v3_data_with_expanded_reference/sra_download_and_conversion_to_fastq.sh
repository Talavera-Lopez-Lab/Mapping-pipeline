#!/bin/bash

# Variables

#SRA variables
SRA_BIOPROJECT="PRJNA666217" # SRA bioproject name
SRA_LIST="$DOWNLOAD_DIR/sra_accessions.txt" # list with the SRA  Accession Numbers (will be automaticly created in the Part 1)

# Working directories
DOWNLOAD_DIR="/mnt/LaCIE/annaM/gut_project/raw_data/Fawkner-Corbett_2021/scRNA_seq_data" # Directory where SRA files will be downloaded
FASTQ_DIR="$DOWNLOAD_DIR/fastq_files" # Directory where fastq files will be placed
WORKSPACE_DIR="$DOWNLOAD_DIR/sra_workspace" # Directory for cache files created during sra to fastq transformation
MAPPED_FILES_DIR="$DOWNLOAD_DIR/mapped_files" # Directory for mapping output

# Part 1: Fetch SRA Accession Numbers
#esearch -db sra -query $SRA_BIOPROJECT | efetch -format runinfo | cut -d ',' -f 1 > sra_accessions.txt

# Part 2: Download SRA Files
while IFS= read -r line
do
    if [ "$line" != "Run" ]; then
        prefetch "$line" --output-directory "$DOWNLOAD_DIR"
    fi
done < "sra_accessions.txt"

echo "Downloads completed."

# Part 3: Convert SRA to FASTQ and Delete SRA Files
mkdir -p "$FASTQ_DIR"

mkdir -p "$WORKSPACE_DIR"

export VDB_CONFIG="$WORKSPACE_DIR"

while IFS= read -r SRA_NAME
do
    SRA_FILE_PATH="$DOWNLOAD_DIR/$SRA_NAME/$SRA_NAME.sra"

    echo "Converting $SRA_NAME to FASTQ format"

    if fastq-dump --split-files --gzip --outdir "$FASTQ_DIR" "$SRA_FILE_PATH"; then
        echo "$SRA_NAME conversion complete. Deleting SRA file"
        rm "$SRA_FILE_PATH"
        echo "$SRA_NAME SRA file deleted."
    else
        echo "Error converting $SRA_NAME. SRA file not deleted."
    fi
done < "sra_accessions.txt"

echo "All conversions and deletions completed."