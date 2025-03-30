#!/bin/bash

#load cuda3.11 and python3.9.2
#export OMP_NUM_THREADS=$NCPUS

"Path to model directory "=$1
"Path to pod5_pass"=$2
Sample_name=$3



dorado basecaller --models-directory $1 $1/rna004_130bps_sup@v5.1.0  $2/pod5_pass  > $3.bam #for modification please add the flags --modified-bases m6A_DRACH --modified-bases inosine_m6A --modified-bases m5C --modified-bases PseuU

samtools fastq -T '*' $3.bam > $3.fastq

minimap2 -ax map-ont -y --secondary=no -t $N_CPUS -k 4 -w 10 MS2_RNA.fasta $3.bam >  $3.sam
 
samtools view -F 2324 -b $3.sam > $3_positive_strand.sam

samtools view -f 16 -b $3.sam > $3_negative_strand.sam

samtools sort $3_positive_strand.sam > $3_positive_strand_sorted.sam

samtools index $3_positive_strand_sorted.sam

samtools sort $3_negative_strand.sam > $3_negative_strand_sorted.sam

samtools index $3_negative_strand_sorted.sam