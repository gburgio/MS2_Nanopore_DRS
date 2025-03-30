#!/bin/bash


Sample_sorted_1.bam=$1 
Sample_sorted_1.fasta=$2

#convert to fasta

samtools fasta -T '*' $1 > $2

#blast search 

mkblastdb -in MS2_RNA.fasta -out MS2_RNA.fasta.db -parse_seqids -dbtype nucl

blastn -query $2 -db MS2_RNA.fasta.db -outfmt "10 qseqid sseqid stitle pident length mismatch gapopen qstart qend sstart send evalue bitscore" > $2"_blast_output"

#search for hybrids RNA

awk -F',' '{queries[$1]=1; hits[$1,++count[$1]]=$0; qstarts[$1,count[$1]]=$8; qends[$1,count[$1]]=$9;} END{for(q in queries){if(count[q]>1){print "Query: "q" has "count[q]" hits"; found=0; for(i=1;i<=count[q];i++){for(j=1;j<=count[q];j++){if(i!=j && (qends[q,i]==qstarts[q,j]-1 || qstarts[q,i]==qends[q,j]+1)){print "  Hit "i": "hits[q,i]; print "  Hit "j": "hits[q,j]; print "  Adjacent: "((qends[q,i]==qstarts[q,j]-1)?"Hit "i" end -> Hit "j" start":"Hit "i" start -> Hit "j" end"); print ""; found=1;}}} if(!found) print "  No adjacent hits\n";}}}' $2"_blast_output" > $2"_blast_output_hybrids"

