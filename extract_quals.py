# Modified from code by Wouter Decoster


# This returns first ID of a fastq read i.e. before any whitespace
# Nanopore reads have 'start time' following a whitespace- so run this first if needed:
#sed 's/ //g' file_in.fq > file_out.fq

from math import log

def ave_qual(quals):
    """Calculate average basecall quality of a read.
    Receive the integer quality scores of a read and return the average quality for that read
    First convert Phred scores to probabilities,
    calculate average error probability
    convert average back to Phred scale
    """
    if quals:
        return -10 * log(sum([10**(q / -10) for q in quals]) / len(quals), 10)
    else:
        return None

import Bio
from Bio import SeqIO

import sys

inputfile = sys.argv[1]

for record in SeqIO.parse(inputfile, "fastq"):
	print("%s %s" % (record.id, ave_qual(record.letter_annotations["phred_quality"])))
