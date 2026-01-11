#!/bin/bash
# initialize conda for this script
eval "$(conda shell.bash hook)"
# Set working directory
WORKDIR="/home/ejaz/03_WGS_assembly/short_reads_only_asselmbly"
SOURCE_DIR="/home/ejaz/03_WGS_assembly/hybrid_genome_assembly_guide_bkc/short_reads"

cd "$WORKDIR" || exit 1

# Create directories
mkdir -p 00_raw_reads
mkdir -p 01_qc_before_processing
mkdir -p 02_process_reads
mkdir -p 03_qc_after_processing

# Copy short reads files
cp "$SOURCE_DIR"/*.fastq.gz 00_raw_reads/

# Rename the files
cd 00_raw_reads || exit 1
for file in *_1.fastq.gz; do
    mv "$file" "codanics_1.fastq.gz"
done

for file in *_2.fastq.gz; do
    mv "$file" "codanics_2.fastq.gz"
done
cd - 

echo "Directory structure created:"
ls -d */

echo ""
echo "Files copied to 00_raw_reads:"
ls 00_raw_reads/

# change to qc_before_processing directory
cd 01_qc_before_processing || exit 1
# run fastqc on raw reads
conda activate 01_short_read_qc
fastqc ../00_raw_reads/*.fastq.gz -o .
#e xpert use case of fastqc
mkdir fastqc_reports
fastqc -o fastqc_reports --nogroup --threads 8 ../00_raw_reads/*.fastq.gz
# to generate svg format reports
fastqc -o fastqc_reports --extract --svg --threads 8 ../00_raw_reads/*.fastq.gz

# expert use case of multiqc
conda activate 02_multiqc
multiqc -p -o ./multiqc/fastqc_multiqc ./

# run fastp for read trimming and quallity control
cd ../02_process_reads
conda activate 01_short_read_qc
fastp -i ../00_raw_reads/codanics_1.fastq.gz -I ../00_raw_reads/codanics_2.fastq.gz -o ../02_process_reads/codanics_1.trimmed.fastq.gz -O ../02_process_reads/codanics_2.trimmed 
.fastq.gz \ 03_qc_after_processing/-h fastp_report.html -j fastp_report.json -w 8 \
-q 25 

# fastqc and multiqc run on processed reads
cd ../03_qc_after_processing || exit 1
conda activate 01_short_read_qc
mkdir fastqc_reports_processed
fastqc -o fastqc_reports_processed --nogroup --threads 8 ../02_process_reads/*.trimmed.fastq.gz
# to generate svg format reports
fastqc -o fastqc_reports_processed --extract --svg --threads 8 ../02_process_reads/*.trimmed.fastq.gz       
fastqc ../02_process_reads/*.trimmed.fastq.gz -o 
# run multiqc on on fastqc files of processed reads
conda activate 02_multiqc
multiqc -p -o ./multiqc/fastqc_multiqc_processed ./
echo "Analysis complete."






# previous commands for reference
# change to qc_before_processing directory
#cd 01_qc_before_processing || exit 1
# run fastqc on raw reads
#fastqc ../00_raw_reads/*.fastq.gz -o .
# expert use case of fastqc
#mkdir fastqc_reports



















# to generate reports in a separate directory
#fastqc -o fastqc_reports --nogroup --threads 8 ../00_raw_reads/*.fastq.gz
# to generate svg format reports in a separate directory
#fastqc -o fastqc_reports --svg --nogroup --threads 8 ../00_raw_reads/*.fastq.gz
# change to process_reads directory
#cd ../02_process_reads || exit 1

#mkdir reports
#fastqc -o reports --svg -t 8 * .fq 



#basic use case
#multiqc .




#expert use case of multiqc
#multiqc -p -o /home/ejaz/00_bioinformatocs_basics/01_grab_seq/01_short_read_qc/multiqc/fastqc_multiqc ./


# to unzip any .fq file

#gunzip filename

# to zip

#gzip filename