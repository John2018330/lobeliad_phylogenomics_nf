# Test nextflow pipeline for lobeliad phylogenomics paper
Making a nextflow pipeline to generate a coalescent species tree of Lobeliad taxa using Hyb-Seq data

## Workflow
### Dependencies
Trimmomatic, FastQC, MultiQC??, HybPiper, MAFFT, trimAl, IQTree, Astral?

### Requirements
'samples_list.txt': a list of all taxa or sample identifiers
Raw read pairs '*_{1,2}.fastq': raw reads 
'Angio353.fasta': fasta file containing Angiosperms 353 target sequences for target enrichment. Use for luk test data 
'supercontig_baits.fasta': fasta file containing modified campanula baits used for assembly. Use for lobeliad data



## To Do
- [ ] connect docker to nextflow via config
- [ ] add astral to docker image
- [ ] add params to nextflow file
- [ ] docker engine only, no docker desktop
- [x] find bait files
- [x] test docker image
