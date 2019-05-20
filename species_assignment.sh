#!/bin/sh


# QC with nanoQC

nanoQC feed_reads.fastq.gz

# Trim first 5 bases from file (based on nanoQC plots)
gunzip feed_reads.fastq.gz
python  ~/Code/FASTA_manip/fasta_trimmer.py feed_reads.fastq.gz


# In a rush at Eden so no QC. Rough overview. 

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
scp server_IP:~/ferment/batch2/barcode*_all_test.txt .

# Make OTU table in R.
