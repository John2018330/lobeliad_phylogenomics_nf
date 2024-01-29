# Test nextflow pipeline for lobeliad phylogenomics paper
Making a nextflow pipeline to generate a coalescent species tree of Lobeliad taxa using Hyb-Seq data

## Workflow
### Dependencies
Trimmomatic, FastQC, MultiQC??, HybPiper, MAFFT, trimAl, IQTree, Astral?

### Requirements
'samples_list.txt': a list of all taxa or sample identifiers
Raw read pairs '*_{1,2}.fastq': raw reads 
'baits.fasta': file in fasta format containing target sequences for target enrichment 


## To Do
- add astral to docker image
- test docker image
- start nextflow pipe
- docker engine only, no docker desktop
