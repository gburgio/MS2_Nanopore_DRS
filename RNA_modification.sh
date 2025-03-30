#!/bin/bash

#export OMP_NUM_THREADS=$NCPUS

Sample_sorted_1.bam=$1 
Sample_sorted_2.bam=$2

#analysis for sample 1. Please perfomr the same analysis with sample 2

modkit pileup -t $NCPUS --motif C 0 --ref MS2_RNA.fasta --max-depth 2000000 --ignore h $1 $1_pileup.bed #m5C
modkit pileup -t $NCPUS --motif T 0 --ref MS2_RNA.fasta --max-depth 2000000 --ignore h $1 $1_pileup.bed #PseuU
modkit pileup -t $PNCPUS --motif DRACH 2 --ref MS2_RNA.fasta --max-depth 2000000 --ignore h $1 $1_pileup.bed #m6A

# install htslib

bgzip -k $1_pileup.bed
tablix -p $1_pileup.bed.gz

modkit dmr pair -a $1_pileup.bed.gz -b $2_pileup.bed.gz -o m5C_diff --ref MS2_RNA.fasta --base C -t 24  #m5C
modkit dmr pair -a $1_pileup.bed.gz -b $2_pileup.bed.gz -o m6A_diff --ref MS2_RNA.fasta --base A -t 24  #m6A
modkit dmr pair -a $1_pileup.bed.gz -b $2_pileup.bed.gz -o pseuU_diff --ref MS2_RNA.fasta --base T -t 24 #PseuU

