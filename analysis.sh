#!/bin/sh

# Notes for nanopore processing / 16S

# Concatenate reads into single fastq file.

cat fastq_runid_35c22e803de304c220e616b889d91fedca21b552_0.fastq fastq_runid_89c3e1b6928b961aac02b78841618ddce2bece70_0.fastq > feed_reads.fastq
gzip feed_reads.fastq

# QC with nanoQC

nanoQC feed_reads.fastq.gz

# Trim first 5 bases from file (based on nanoQC plots)
gunzip feed_reads.fastq.gz
python  ~/Dropbox/Code/FASTA_manip/fasta_trimmer.py feed_reads.fastq.gz


# Run through Kraken using Silva 16S database (on server). Use names flag for taxa ID
~/programs/kraken2-2.0.7-beta/kraken2/kraken2 --db ~/programs/kraken2-2.0.7-beta/16S_db/ cowshit.fastq --use-names > cowshit.txt

# In a rush at Eden so no QC. Rough overview. 

# Repeat for 'real' analysis.
# Loop through each file (still on server):
for i in `ls barcode*/*.fastq`
do
echo $i
~/programs/kraken2-2.0.7-beta/kraken2/kraken2 --db ~/programs/kraken2-2.0.7-beta/16S_db/ $i --use-names > ${i}.txt
done

# Stick all the txt output files together- per sample.
for i in barcode*/
do
  echo "$i"
  base=$(basename $i "")
  echo $base
  echo ${i}*.txt
cat ${i}*.txt > ./${base}_all_test.txt
done

# Exit server and copy files to local:
# So from local:
cd ~/Dropbox/CRISPR_Postdoc/Other_projects/Ferment/data/data/
mkdir batch2/
cd batch2/
scp sm758@rstudio04.cles.ex.ac.uk:~/CRISPR_Postdoc/ferment/batch2/barcode*_all_test.txt .

# Make OTU table in R.
