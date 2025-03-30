#!/bin/bash

#clair3

Sample_sorted_1.bam=$1 
Sample_sorted_1.pileup..vcf.gz=$2 

run_clair3.sh --bam_fn=$1 --ref_fnMS2_RNA.fasta  --platform="ont" --model_path=/r941_prom_sup_g5014 --include_all_ctgs --no_phasing_for_fa --threads=4   --output=$1"_folder"

#Sniffles2

sniffles2 -i $1 -v $1".vcf" --reference MS2_RNA.fasta

#bcftools 

bcftools view $2 