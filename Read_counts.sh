#!/bin/bash

#require samtools

input.sorted.bam=$1


#to select short or long transcripts
samtools view -h  $1  -e 'qlen >= 3300 && qlen <= 10000' | samtools view -b -o  {basename $1}"_3000.bam"
samtools view -h  $1  -e 'qlen >= 100 && qlen <= 800' | samtools view -b -o {basename $1}"_800.bam"


#coverage

samtools depth $1 > $1"_coverage.txt"
bedtools genomecov -ibam $1 > $1"_bedtools_coverage.txt"


output_file="red_counts_ending_6bp_window.txt"
samtools view $1 | awk '{len=0; cigar=$6; while(match(cigar,/[0-9]+[MIDNX=]/)){op_len=substr(cigar,RSTART,RLENGTH-1); op_type=substr(cigar,RSTART+RLENGTH-1,1); if(op_type~/[MI=X]/){len+=op_len}; cigar=substr(cigar,RSTART+RLENGTH)}; end_pos=$4+len-1; window=1+int((end_pos-1)/5)*5; counts[window]++} END{for(w in counts) print w, w+4, counts[w]}'  | sort -k1,1n > $output_file

output_file="red_counts_starting_6bp_window.txt"
samtools view $1 | awk '{pos=1+int($4/5)*5; count[pos]++} END{for(p in count) print p, p+4, count[p]}' | sort -k1,1n > $output_file

output_file="red_counts_all_reads_6bp_window.txt"
samtools view $1 | awk '{s=$4; e=s+length($10)-1; for(i=1+int((s-1)/5)*5; i<=e; i+=5) count[i]++} END{for(p in count) print p, p+4, count[p]}' | sort -k1,1n > $output_file


