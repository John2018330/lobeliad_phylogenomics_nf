# Nextflow pipeline for lobeliad phylogenomics paper
Making a nextflow pipeline to generate a coalescent species tree of Lobeliad taxa using Hyb-Seq data. Using this data and software to learn nextflow and creating bioinformatics pipelines.

## Workflow
### Dependencies
Trimmomatic, FastQC, MultiQC, HybPiper, MAFFT, trimAl, IQTree, Astral?

### Requirements
#### Inputs
- Folder containing or individual raw read pairs '*_{1,2}.fastq' 
- Target file containing sequences used for target enrichment. For lobeliad data, `supercontig_baits.fasta` is used. For testing pipeline on luk data, `Angio_353.fasta` is used.
- 'TruSeq3-PE.fa': fasta file containing adapteres to look for when using trimmomatic

#### Outputs
- `multiqc_report.html`: Quality Control report on raw reads after being pushed through trimmomatic


### Pipeline
1. Raw Reads
- Paired-end raw reads are collected in a single folder ready as input for the pipeline.

2. Trimmomatic & Quality Control
- Each raw read file is trimmed/quality filtered using Trimmomatic. Trimmomatic takes as input a sample's paired end reads `R1, R2`, and for each paired read file produces one file for reads that have a pair found in the complmentary file `{R1, R2}_paired` and another for those that do not `{R1, R2}_unpaired`.  
- The two unpaired read files per sample are concatenated into one file: `unpaired`.
- FastQC is run on all of the paired/unpaired output files of Trimmomatic and outputs are stored in separate folder
- MultiQC collects all the FastQC outputs to generate a single report on all data files 


## To Do
- [ ] write multiqc process
- [ ] add astral to docker image
- [ ] add all params to nextflow file
- [ ] docker engine only, no docker desktop
- [x] add trimmomatic adapter file
- [x] connect docker to nextflow via config
- [x] find bait files
- [x] test docker image
- [x] write concat unpaired process
- [x] write trimmomatic process
- [x] add multiqc to docker image
- [x] write fastqc process
