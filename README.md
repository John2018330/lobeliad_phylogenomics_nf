# Nextflow pipeline for lobeliad phylogenomics paper
!! Work in progress !!

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

3. HybPiper
- HybPiper is a pipeline that itself is split up into multiple steps. First is assembly
- Hybpiper assemble takes as input paired end raw reads (and the unpaired reads identified by trimmomatic) and distributes/maps them to targets provided in the target file. It then assembles the reads for each target into longer contigs and ultimately outputs a single representive sequence for each target. 




## To Do
- [ ] hybpiper retrieve sequences process
- [ ] hybpiper stats process
- [ ] look up when: and take: for process/workflow
- [ ] expand resource usage in nextflow config
- [ ] add publishDir mode option to processes
- [ ] skeleton pipeline step after trimmomatic
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
- [x] write simple multiqc process
- [x] expand trimmomatic params in nextflow config
