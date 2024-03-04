#!/bin/bash
set +e

# Local directories
DOWNLOAD_DIR="/mnt/LaCIE/annaM/gut_project/raw_data/Fawkner-Corbett_2021/scRNA_seq_data"
FASTQ_DIR="$DOWNLOAD_DIR/fastq_files"
MAPPED_FILES_DIR="$DOWNLOAD_DIR/mapped_files"
SRA_LIST="$DOWNLOAD_DIR/sra_accessions.txt"

# Server directories
SERVER_DATA_DIR="/home/amaguza/data/mapping"

# Mapping variables
INDEX_FILE="$SERVER_DATA_DIR/index_file_bustool/transcriptome.idx"
T2G_FILE="$SERVER_DATA_DIR/index_file_bustool/transcripts_to_genes.txt" 

OUTPUT_FORMAT='h5ad'
LIBRARY_PREP_METHOD='10XV3'

# Ensure the mapped_files directory exists
mkdir -p "$MAPPED_FILES_DIR"

# Read SRA accessions and process
while IFS= read -r SRA_NAME
do
    FASTQ_FILE1="$FASTQ_DIR/${SRA_NAME}_1.fastq.gz"
    FASTQ_FILE2="$FASTQ_DIR/${SRA_NAME}_2.fastq.gz"
    SRA_OUTPUT_DIR="$MAPPED_FILES_DIR/$SRA_NAME"
    mkdir -p "$SRA_OUTPUT_DIR"

    if [ -f $FASTQ_FILE1 ] && [ -f $FASTQ_FILE2 ]; then
        echo "Preparing to process $SRA_NAME..."

        # Copy FASTQ files to the server
        scp $FASTQ_DIR/$FASTQ_FILE1 $FASTQ_DIR/$FASTQ_FILE2 $SERVER_DATA_DIR

         # Execute mapping on the server
        cd $SERVER_DATA_DIR && /home/amaguza/miniforge3/envs/bustool_env/bin/kb count -i $INDEX_FILE -g $T2G_FILE -x $LIBRARY_PREP_METHOD --$OUTPUT_FORMAT -t 32 -o $SRA_NAME $FASTQ_FILE1 $FASTQ_FILE2

        # Copy mapped files back to the local machine
        scp -r $SERVER_DATA_DIR/$SRA_NAME/* $MAPPED_FILES_DIR/$SRA_NAME/

        # Clean up server data for the current sample
        rm -r $SERVER_DATA_DIR/$SRA_NAME
        rm $SERVER_DATA_DIR/$FASTQ_FILE1 $SERVER_DATA_DIR/$FASTQ_FILE2

        echo "Processing of $SRA_NAME completed."
    else
        echo "FASTQ files for $SRA_NAME not found."
    fi
done < 'sra_accessions.txt'

echo "All mappings completed."
