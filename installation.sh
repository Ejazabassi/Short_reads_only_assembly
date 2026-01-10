
echo "Creating conda environments for short read quality control and multiqc"
# initialize conda for this script
eval "$(conda shell.bash hook)"

# remove any existing environments 
conda env remove -n 01_short_read_qc -y
conda env remove -n 02_multiqc -y
# 01 fastqc and fastp installation
conda create -n 01_short_read_qc -y
conda activate 01_short_read_qc 

echo "Installing fastqc and fastp"
# for quality check
conda install bioconda::fastqc -y
# for quality check and trimming
conda install bioconda::fastp -y

echo "fastqc and fastp installation completed"
# 02
#multiqc
conda create -n 02_multiqc -y
conda activate 02_multiqc
conda install bioconda::multiqc -y




