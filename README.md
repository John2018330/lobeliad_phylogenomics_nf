# Nextflow pipeline for lobeliad phylogenomics paper
Making a nextflow pipeline to generate a coalescent species tree of Lobeliad taxa using Hyb-Seq data

## Workflow
### Dependencies
Trimmomatic, FastQC, MultiQC??, HybPiper, MAFFT, trimAl, IQTree, Astral?

### Requirements
- 'samples_list.txt': a list of all taxa or sample identifiers
- Raw read pairs '*_{1,2}.fastq': raw reads 
- 'Angio353.fasta': fasta file containing Angiosperms 353 target sequences for target enrichment. Use for luk test data 
- 'supercontig_baits.fasta': fasta file containing modified campanula baits used for assembly. Use for lobeliad data
- 'TruSeq3-PE.fa': fasta file containing adapteres to look for when using trimmomatic


### Pipeline
1. Raw Reads
- Paired-end raw reads are collected in a single folder ready as input for the pipeline

2. Trimmomatic & Quality Control
- Each raw read file is trimmed/quality filtered using Trimmomatic, producing one file for reads that have a pair and another for those that are left unpaired
- The two unpaired read files per sample are concatenated into one file 
- FastQC is run on all of the paired/unpaired output files of Trimmomatic and outputs are stored in separate folder
- MAYBE: MultiQC is run on all fastqc outputs to generate a single report on all data files 


## To Do
- [ ] write fastqc process
- [ ] write multiqc process
- [ ] add multiqc to docker image
- [ ] add astral to docker image
- [ ] add all params to nextflow file
- [ ] docker engine only, no docker desktop
- [x] add trimmomatic adapter file
- [x] connect docker to nextflow via config
- [x] find bait files
- [x] test docker image
- [x] write concat unpaired process
- [x] write trimmomatic process
