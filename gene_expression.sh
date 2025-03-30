#!/bin/bash

#export OMP_NUM_THREADS=$NCPUS

Sample_name=$3

"PATH to salmon output"=$4

minimap2 -ax map-ont -y --secondary=no -t $NCPUS -k 4 -w 10 MS2_ref_transcripts.fasta $3.bam >  $3.sam

samtools view -bS $3.sam > $3.bam

samtools sort $3.bam > $3_sorted.bam

samtools index $3_sorted.bam

salmon quant --ont -p $NCPUS -t MS2_ref_transcripts.fasta -l U -a $3.bam -o $4 

