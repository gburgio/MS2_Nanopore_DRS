This repository contains the codes used for the publication titled "Nanopore direct RNA sequencing (DRS) of MS2 bacteriophages in E.coli throughout its life cycle reveals a complex transcriptional activity to control and maintain its growth."

E.coli bacteria (F+) were infected with MS2 bacteriophage and samples were collected at 0 hours, 3 hours and 6 hours time point post innoculation. RNA was extracted, poly-A tailed and sequenced on a Nanopore Promethion platform. 

The repository was divided in multiple bash scripts and one R script. The scripts were run on a high performinc computer on 104 cpu nodes and 500 Gb of RAM. The scripts are compatible with nodes with lower cpu and RAM usage. GPU acceletation was performed with NVIDIA Tesla V100 under cuda3.11 and python 3.9.

Mapping_script.sh is the script that has served for base-calling and mapping. 

Gene_expression.sh is the gene expreesion script. Its acompaigning script deseq_analysis.r contains the deseq analysis.

Read_counts.sh script quantify the read coverages; overall coverage, coverages within 6 bp window (start, end and overall coverage).

Snv_analysis.sh script include code for SNV and indels detection.

Hybrid_RNA.sh script described the detection of RNA hybrids.

RNA_modifications.sh is the script used for the detection of RNA modification. 

